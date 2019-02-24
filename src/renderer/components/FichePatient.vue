<template>
  <div class="content">
    <router-link :to="{ name: 'liste-patient' }">Retour</router-link>
    <h2>
      ID Patient: {{ $route.query.infos.id }}
      {{ getPatientData }}
      <button class="btn" id="show-modal" @click="showModal = true">Observation</button>
      <!-- use the modal component, pass in the prop -->
      <Modal v-if="showModal" @close="showModal = false">
        <!--
          you can use custom content here to overwrite
          default content
        -->
          <div>
            <!-- Illustration des dents -->
            <Machoire class="modal-container" />
          </div>
        <h3 slot="header">Hello Test</h3>
      </Modal>
    </h2>
    <form>
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

      <button v-on:click="editPatient" class="btn">{{ title }}</button>
    </form>
    <br>
    <fieldset>
      <legend>Consultations Patient</legend>
      {{ getConsultations }}
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
        <router-link :to="{ name: 'add-consultation', query: { infos: { 'idPatient': this.$data.form.id } } }">New Consultation</router-link>
      </button>
    </fieldset>
  </div>
</template>

<script>
  import required from 'vuelidate/lib/validators/required'
  import email from 'vuelidate/lib/validators/email'
  import numeric from 'vuelidate/lib/validators/numeric'

  import ConsultationRow from './ConsultationRow'
  import Modal from './Modal.vue'

  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    components: {
      ConsultationRow,
      Modal
    },
    data () {
      return {
        infos: {

        },
        form: {
          id: Number(this.$route.query.infos.id),
          firstName: '', // this.$route.query.infos.nom,
          lastName: '', // this.$route.query.infos.prenom,
          telephone: '', // this.$route.query.infos.tel,
          emailValue: '' // this.$route.query.infos.mail
        },
        title: 'Enregistrer Modifications',
        consultations: [],
        dataIsHere: false,
        showModal: false
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
      }
    },
    validations: {
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
    width: 330px;
    margin: 0px auto;
    padding: 20px 30px;
    background-color: #fff;
    border-radius: 2px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, .33);
    transition: all .3s ease;
    font-family: Helvetica, Arial, sans-serif;
  }

  .modal-header h3 {
    margin-top: 410px;
    color: #42b983;
  }

  .modal-body {
    margin: 100px 0;
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
