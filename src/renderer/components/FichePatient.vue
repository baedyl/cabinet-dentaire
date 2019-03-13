<template>
  <div class="content">
    <router-link :to="{ name: 'liste-patient' }">
      <img class="icon left-arrow" src="../assets/back.png"/>
    </router-link>
    <br>
    <br>
    <br>
    <h2>
      ID Patient: {{ $route.query.infos.id }}
      {{ getPatientData }}
      {{ getConsultations }}
      {{ getActesPatient }}
      {{ initTeethGraphics }}
      {{ getAntecedantsPatient }}
      <button class="btn" id="show-modal" @click="showModal = true">Observation</button>
      <button class="btn" id="new-antecedant" @click="ajoutAntecedant = (ajoutAntecedant === false)? true : false">Ajouter Antecedant</button>
      <!-- use the modal component, pass in the prop -->
      <Modal v-if="showModal" @close="showModal = false">
        <!--
          you can use custom content here to overwrite
          default content
        -->

        <hr>
        <h6 slot="header">

          Historique Actes
          <li v-for="acte in actes" :value="acte.idActe">
            {{ acte.libelle }} {{ acte.dentActe }} {{ acte.etatActe }}
          </li>
          <!-- Illustration des dents -->
          <div class="" v-on:click="showCoords($event)">
            <svg class="dots" width="300" height="420">
               <circle v-for="acte in actes" class="colorCircle" v-bind:cx="acte.valX" v-bind:cy="acte.valY" r="10" v-bind:stroke="acte.color" stroke-width="4" v-bind:fill="acte.color" />
            </svg>
            <img src="../assets/dents.png"/>
          </div>
        </h6>

      </Modal>
      <!--
      <Modal v-if="hasOrdonnance" @close="hasOrdonnance = false">
        <h3 slot="header">
          <label class="form__label">Note Ordonnance</label>
          <input class="form__input" v-model="$data.note"/>
          <button class="btn" v-on:click="newOrdonnance">Ajouter</button>
        </h3>
      </Modal>
    -->
    </h2>
    <div class="form-container">
      <form class="edit-form">
        <div class="form-group" :class="{ 'form-group--error': $v.form.firstName.$error }">
          <label class="form__label">Nom Patient</label>
          <input class="form__input" v-model.trim="$v.form.firstName.$model"/>
        </div>
        <div class="error" v-if="!$v.form.firstName.required">Le champ nom est obligatoire!</div>

        <div class="form-group" :class="{ 'form-group--error': $v.form.lastName.$error }">
          <label class="form__label">Prenom Patient</label>
          <input class="form__input" v-model.trim="$v.form.lastName.$model"/>
        </div>
        <div class="error" v-if="!$v.form.lastName.required">Le champ prenom est obligatoire!</div>

        <div class="form-group" :class="{ 'form-group--error': $v.form.telephone.$error }">
          <label class="form__label">Telephone Patient</label>
          <input class="form__input" v-model.trim="$v.form.telephone.$model"/>
        </div>
        <div class="error" v-if="!$v.form.telephone.numeric">Numero de Telephone non valide!</div>

        <div class="form-group" :class="{ 'form-group--error': $v.form.emailValue.$error }">
          <label class="form__label">Email Patient</label>
          <input class="form__input" v-model.trim="$v.form.emailValue.$model"/>
        </div>
        <div class="error" v-if="!$v.form.emailValue.required">Le champ Email est obligatoire!</div>
        <div class="error" v-if="!$v.form.emailValue.email">Email non valide!</div>
        <br>

        <h2><button v-on:click="editPatient" class="btn">{{ title }}</button></h2>
      </form>

      <div class="antecedant">
        <fieldset>
          <legend>Antecedants</legend>
          <table>
            <tr>
              <th>#ID</th>
              <th>description</th>
              <th>note</th>
              <th>Action</th>
            </tr>
            <AntecedantRow v-for="ante in antecedants"
            :key="ante.idAntecedant"
            :ante="ante"
            />
          </table>
          <br>
          <hr>
          <br>
          <form v-if="ajoutAntecedant">
            <div class="form-group" :class="{ 'form-group--error': $v.descAntecedant.$error }">
              <label class="form__label">Description Antecedant</label>
              <input class="form__input" v-model.trim="$v.descAntecedant.$model"/>
            </div>
            <div class="error" v-if="!$v.descAntecedant.required">Le champ description est obligatoire!</div>
            <label class="form__label">Note Antecedant</label>
            <input class="form__input" v-model="noteAntecedant"/>
            <button class="btn" @click="newAntecedant">Ajouter</button>
            <button class="btn" @click="ajoutAntecedant = false">Annuler</button>
          </form>
        </fieldset>
      </div>
    </div>

    <br>
    <fieldset>
      <legend>Consultations Patient</legend>
      <table>
        <tr>
          <th>#ID</th>
          <th>Date Consultation</th>
          <th>Frais Consultation</th>
          <th>#ID Patient</th>
          <th>Nom Medecin</th>
          <th>Action</th>
        </tr>
        <ConsultationRow v-for="consultation in consultations"
        :key="consultation.idConsultation"
        :consultation="consultation"
        />
      </table>
      <br>
      <button class="btn">
        <h2>
          <router-link :to="{ name: 'add-consultation', query: { infos: { 'idPatient': this.$data.form.id } } }">New Consultation</router-link>
        </h2>
      </button>
    </fieldset>
  </div>
</template>

<script>
  import required from 'vuelidate/lib/validators/required'
  import email from 'vuelidate/lib/validators/email'
  import numeric from 'vuelidate/lib/validators/numeric'

  import ConsultationRow from './ConsultationRow'
  import AntecedantRow from './AntecedantRow'
  import Modal from './Modal.vue'
  // import Machoire from './Machoire'

  const db = require('../database.js')
  const conn = db.getPool()
/*
  const createCanvas = require('canvas')
  const canvas = createCanvas(200, 200)
  const ctx = canvas.getContext('2d')
*/

  export default {
    components: {
      ConsultationRow,
      Modal,
      AntecedantRow
      // , Machoire
    },
    data () {
      return {
        infos: {

        },
        teethGraphics: new Map(),
        valX: 0,
        valY: 0,
        drawCircle: false,
        form: {
          note: '',
          id: Number(this.$route.query.infos.id),
          firstName: '', // this.$route.query.infos.nom,
          lastName: '', // this.$route.query.infos.prenom,
          telephone: '', // this.$route.query.infos.tel,
          emailValue: '' // this.$route.query.infos.mail
        },
        title: 'Enregistrer Modifications',
        consultations: [],
        antecedants: [],
        actes: [],
        dataIsHere: false,
        showModal: false,
        hasOrdonnance: false,
        antecedantIsHere: false,
        descAntecedant: '',
        noteAntecedant: '',
        ajoutAntecedant: false
      }
    },
    props: [
      'patient'
    ],
    computed: {
      getConsultations: function () {
        if (this.consultations.length === 0) {
          console.log('Reading the Database...')
          conn.query('SELECT * FROM Consultation WHERE Patient_idPatient = ?', [this.$data.form.id], (err, results, fields) => {
            if (err) throw err
            console.log('Consultations Patient SQL : ', results)
            for (var c of results) {
              console.log('Consultation : ', c)
              this.consultations.push(c)
            }
          })
        }
      },
      getPatientData: function () {
        console.log(this.$data.dataIsHere)
        if (this.$data.dataIsHere === false) {
          console.log('Reading the Database...')
          conn.query('SELECT * FROM Patient WHERE idPatient = ?', [this.$data.form.id], (err, results, fields) => {
            if (err) throw err
            console.log('Data Patient SQL : ', results)
            for (var c of results) {
              console.log('Infos : ', c)
              // this.consultations.push(c)
              this.$data.form.firstName = c.nomPatient
              this.$data.form.lastName = c.prenomPatient
              this.$data.form.telephone = c.telephonePatient
              this.$data.form.emailValue = c.mailPatient
            }
            this.$data.dataIsHere = true
          })
        }
      },
      getActesPatient: function () {
        if (this.$data.actes.length === 0) { // In case there are no acts, test with a boolean var to execute this prop only once
          for (let consultation of this.$data.consultations) {
            console.log('Id Consultation : ', consultation.idConsultation)

            conn.query('SELECT * FROM Acte WHERE Consultation_idConsultation = ?', [consultation.idConsultation],
              (err, results, fields) => {
                if (err) throw err
                console.log(results)
                if (results.length > 0) {
                  for (let acte of results) {
                    /* let acte = {
                      'libelle': results[0].libelle,
                      'note': results[0].noteActe,
                      'dent': results[0].dentActe,
                      'etat': results[0].etatActe
                    }
                    */
                    let obj = this.$data.teethGraphics.get(String(acte.dentActe))
                    let valX = 0
                    let valY = 0
                    let i = 0
                    for (let val in obj) {
                      if (i === 0) valX = obj[val]
                      else valY = obj[val]
                      i += 1
                    }
                    if (acte.etatActe === 'Done') acte.color = 'green'
                    else if (acte.etatActe === 'Pending') acte.color = 'yellow'
                    else acte.color = 'red'

                    acte.valX = valX
                    acte.valY = valY
                    this.$data.actes.push(acte)
                  }
                }
              })
          }
        }
        console.log(this.$data.actes)
      },
      initTeethGraphics: function () {
        // Set up the positions to draw the teeth on the image
        // En haut
        this.$data.teethGraphics.set('11', { 'x': 142, 'y': 65 })
        this.$data.teethGraphics.set('21', { 'x': 163, 'y': 65 })
        this.$data.teethGraphics.set('12', { 'x': 124, 'y': 74 })
        this.$data.teethGraphics.set('22', { 'x': 184, 'y': 74 })
        this.$data.teethGraphics.set('13', { 'x': 108, 'y': 85 })
        this.$data.teethGraphics.set('23', { 'x': 199, 'y': 85 })
        this.$data.teethGraphics.set('14', { 'x': 98, 'y': 104 })
        this.$data.teethGraphics.set('24', { 'x': 209, 'y': 104 })
        this.$data.teethGraphics.set('15', { 'x': 90, 'y': 125 })
        this.$data.teethGraphics.set('25', { 'x': 215, 'y': 125 })
        this.$data.teethGraphics.set('16', { 'x': 83, 'y': 146 })
        this.$data.teethGraphics.set('26', { 'x': 224, 'y': 146 })
        this.$data.teethGraphics.set('17', { 'x': 77, 'y': 176 })
        this.$data.teethGraphics.set('27', { 'x': 226, 'y': 176 })
        this.$data.teethGraphics.set('18', { 'x': 77, 'y': 202 })
        this.$data.teethGraphics.set('28', { 'x': 228, 'y': 202 })

        // En bas
        /* this.$data.teethGraphics.set('11', { 'x': 136, 'y': 65 })
        this.$data.teethGraphics.set('21', { 'x': 157, 'y': 65 })
        this.$data.teethGraphics.set('12', { 'x': 116, 'y': 74 })
        this.$data.teethGraphics.set('22', { 'x': 178, 'y': 74 })
        this.$data.teethGraphics.set('13', { 'x': 100, 'y': 85 })
        this.$data.teethGraphics.set('23', { 'x': 192, 'y': 85 })
        this.$data.teethGraphics.set('14', { 'x': 89, 'y': 104 })
        this.$data.teethGraphics.set('24', { 'x': 201, 'y': 104 })
        this.$data.teethGraphics.set('15', { 'x': 83, 'y': 125 })
        this.$data.teethGraphics.set('25', { 'x': 210, 'y': 125 })
        this.$data.teethGraphics.set('16', { 'x': 76, 'y': 146 })
        this.$data.teethGraphics.set('26', { 'x': 217, 'y': 146 })
        this.$data.teethGraphics.set('17', { 'x': 73, 'y': 176 })
        this.$data.teethGraphics.set('27', { 'x': 219, 'y': 176 })
        this.$data.teethGraphics.set('18', { 'x': 70, 'y': 202 })
        this.$data.teethGraphics.set('28', { 'x': 220, 'y': 202 }) */
      },
      getAntecedantsPatient: function () {
        // console.log(this.$data.dataIsHere)
        if (this.$data.antecedantIsHere === false) {
          console.log('Reading the Database...')
          conn.query('SELECT * FROM Antecedant WHERE Patient_idPatient = ?', [this.$data.form.id], (err, results, fields) => {
            if (err) throw err
            console.log('Atecedant Patient SQL : ', results)
            for (var c of results) {
              console.log('Infos : ', c)
              this.$data.antecedants.push(c)
            }
            this.$data.antecedantIsHere = true
          })
        }
      }
    },
    methods: {
      editPatient: function () {
        conn.query('UPDATE Patient SET nomPatient = ?, prenomPatient = ?, telephonePatient = ?, mailPatient = ? WHERE idPatient = ?',
          [this.$data.form.firstName, this.$data.form.lastName, this.$data.form.telephone, this.$data.form.emailValue, this.$data.form.id],
          (err, results, fields) => {
            if (err) throw err
            console.log('Patient Updated ', results)
          })
      },
      newOrdonnance: function () {
        conn.query('INSERT INTO Ordonnance(idPatient, note) VALUES(?, ?)', [this.$data.form.id, this.$data.form.note],
          (err, results, fields) => {
            if (err) throw err
            console.log('New Ordonnance: ', results)
          })
      },
      showCoords: function (event) {
        var x = event.offsetX
        var y = event.offsetY
        console.log('Before: ' + x + ', ' + y)

        // Change the values acknowlegding the css
        this.$data.valX = x
        this.$data.valY = y
        this.$data.drawCircle = true
        console.log('Map: ' + this.$data.teethGraphics)
      },
      newAntecedant: function () {
        conn.query('INSERT INTO Antecedant(description, note, Patient_idPatient) VALUES(?, ?, ?)', [this.$data.descAntecedant, this.$data.noteAntecedant, this.$data.form.id],
          (err, results, fields) => {
            if (err) throw err
            console.log('New Antecedant: ', results)
          })
        this.$data.antecedantIsHere = false
        this.$data.antecedants = []
        this.$data.ajoutAntecedant = false
      }
    },
    validations: {
      descAntecedant: {
        required
      },
      form: {
        emailValue: {
          required,
          email
        },
        firstName: {
          required
        },
        lastName: {
          required
        },
        telephone: {
          numeric
        }
      }
    }
  }
</script>

<style>
  /* Style the content */
  .content {
  margin-left: 200px;
  padding-left: 20px;
  }

  img{
    /* position: absolute; */
    height: 400px;
    top: 50px;
    margin: 20px;
    /* border: 3px solid #73AD21; */
  }

  fieldset
  {
    background-color:#CCC;
    padding:16px;
  }
  legend
  {
    margin-bottom:0px;
    margin-left:16px;
  }

  .icon {
    height: 50px;
    margin: 10px;
  }
  .left-arrow {
    top: 0px;
  }
  .refresh {
    top: 0px;
    left: 300px;
  }

  .container {
    position: relative;
  }

  .form-container {
    display: flex;
    width: 1250px;
    justify-content: space-between;
    margin: 20px;
  }

  .edit-form {
    width: 600px;
  }

  .antecedant {
    /* border: 1px solid #000; */
    justify-content: flex-end;
    width: 600px;
  }

  .dots {
    float: left;
    position: absolute;
    left: 450px;
    top: 50px;
    z-index: 1000;
    opacity: 0.5;
     /*
     background-color: #92AD40;
     padding: 5px;
     color: #FFFFFF;
     font-weight: bold; */
  }

  .modal-mask {
    position: fixed;
    z-index: 9998;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, .5);
    display: table;
    transition: opacity .3s ease;
  }

  .modal-wrapper {
    display: table-cell;
    vertical-align: middle;
  }

  .modal-container {
    width: 390px;
    margin: 0px auto;
    padding: 20px 30px;
    background-color: #fff;
    border-radius: 2px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, .33);
    transition: all .3s ease;
    font-family: Helvetica, Arial, sans-serif;
    /*  */
  }

  .modal-header h6 {
    margin-top: 450px;
    padding: 20px;
    color: #42b983;
  }

  .modal-body {
    margin: 35px 0;
  }

  .modal-default-button {
    float: right;
  }

  /*
   * The following styles are auto-applied to elements with
   * transition="modal" when their visibility is toggled
   * by Vue.js.
   *
   * You can easily play with the modal transition by editing
   * these styles.
   */

  .modal-enter {
    opacity: 0;
  }

  .modal-leave-active {
    opacity: 0;
  }

  .modal-enter .modal-container,
  .modal-leave-active .modal-container {
    -webkit-transform: scale(1.1);
    transform: scale(1.1);
  }

</style>
