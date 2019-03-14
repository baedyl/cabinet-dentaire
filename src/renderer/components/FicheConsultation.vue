<template>
  <div class="content">
    <router-link :to="{ name: 'fiche-patient', query: { infos: { 'id': form.idPatient }}}">
      <img class="icon left-arrow" src="../assets/back.png"/>
    </router-link>
    <br>
    <br>
    <br>
    <h2>ID Consultation: {{ idConsultation }}</h2>
    {{ getConsultationData }}
    <form>
      <div class="form-group" :class="{ 'form-group--error': $v.form.dateConsultation.$error }">
        <label class="form__label">Date Consultation</label>
        <input class="form__input" v-model.trim="$v.form.dateConsultation.$model" type="date"/>
      </div>
      <div class="error" v-if="!$v.form.dateConsultation.required">Le champ date est obligatoire!</div>
      <!--
      <input type="date" :value="myDate && myDate.toISOString().split('T')[0]" @input="myDate = $event.target.valueAsDate">
      -->
      <div class="form-group" :class="{ 'form-group--error': $v.form.fraisConsultation.$error }">
        <label class="form__label">Frais Consultation</label>
        <input class="form__input" v-model.trim="$v.form.fraisConsultation.$model"/>
      </div>
      <div class="error" v-if="!$v.form.fraisConsultation.numeric">Valeur de frais de consultation incorrecte!</div>

      <div class="form-group">
        <label class="form__label">Medecin traitant</label>
        <select v-model="$data.form.nomDocteur" @change="onChange">
          {{ getIdDocteurs }}
          <option v-for="doc in docteurs" :value="doc.nomComplet">
            {{ doc.nomComplet }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label class="form__label">Notes Consultation</label>
        <input class="form__input" v-model="$data.form.note"/>
      </div>

      <h2><button v-on:click="editConsultation" class="btn">{{ title }}</button></h2>
    </form>
    <br>
    <fieldset>
      <legend>Actes</legend>
      {{ getActes }}
      <table>
        <tr>
          <th>#ID</th>
          <th>Libelle</th>
          <th>Note Acte</th>
          <th>Consultation_idConsultation</th>
          <th>Dent Acte</th>
          <th>Etat Acte</th>
          <th>Action</th>
        </tr>
        <ActeRow v-for="acte in actes"
        :key="acte.idActe"
        :acte="acte"
        />
      </table>
      <br>
      <button class="btn">
      <h2><router-link class="btn" :to="{ name: 'add-acte', params: { id: this.$data.idConsultation } }">New Acte</router-link></h2>
      </button>
      <!--<router-link :to="{ name: 'add-acte', query: { id: { 'idConsultation': this.$data.idConsultation } } }">New Acte</router-link>-->
    </fieldset>
    <fieldset v-if="addOrdonnance">
      <legend>Ordonnance</legend>
      <label class="form__label">Note Ordonnance</label>
      <input class="form__input" v-model="$data.form.noteOrdonnance"/>

      <div class="form-group">
        <label class="switch" for="hasExtra">Another One?
          <input type="checkbox" id="hasExtra" v-model="hasExtra">
          <span class="slider round"></span>
        </label>
        <!--<div class="toggle">
          <input id="hasExtra" type="checkbox" v-model="hasExtra"/>
          <label for="hasExtra">
            <div class="toggle__switch"></div>
          </label>
        </div>-->
      </div>
      <div class="form-group" v-if="hasExtra">
        <label class="form__label">Extra</label>
        <textarea class="form__input" v-model="extra"/>
      </div>
      <br>
      <h2><button class="btn" v-on:click="newOrdonnance">Ajouter</button></h2>
    </fieldset>
  </div>
</template>

<script>
  import numeric from 'vuelidate/lib/validators/numeric'
  import required from 'vuelidate/lib/validators/required'
  import JsPDF from 'jspdf'

  import ActeRow from './ActeRow'

  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    components: {
      ActeRow
    },
    data () {
      return {
        infos: {
        },
        docteurs: [],
        hasExtra: false,
        addOrdonnance: false,
        extra: '',
        form: {
          dateConsultation: '', // this.$route.query.infos.dateConsultation,
          fraisConsultation: '', // this.$route.query.infos.fraisConsultation,
          nomDocteur: '', // this.$route.query.infos.nomDocteur,
          note: '', // this.$route.query.infos.note,
          medecin: '',
          idPatient: '', // this.$route.query.infos.idPatient
          noteOrdonnance: ''
        },
        idConsultation: Number(this.$route.query.id.idConsultation),
        myDate: new Date(),
        actes: [],
        title: 'Modifier Consultation',
        dataIsHere: false
      }
    },
    computed: {
      getConsultationData: function () {
        console.log(this.$data.dataIsHere)
        if (this.$data.dataIsHere === false) {
          console.log('Reading the Database...')
          conn.query('SELECT * FROM Consultation WHERE idConsultation = ?', [this.$data.idConsultation], (err, results, fields) => {
            if (err) throw err
            console.log('Data Consultation SQL : ', results)
            for (var c of results) {
              console.log('Infos : ', c)
              // this.consultations.push(c)
              this.$data.form.dateConsultation = new Date(c.dateConsultation).toISOString().split('T')[0]
              this.$data.form.fraisConsultation = c.fraisConsultation
              this.$data.form.idPatient = c.Patient_idPatient
              this.$data.form.nomDocteur = c.nomDocteur
              this.$data.form.note = c.note
            }
            this.$data.dataIsHere = true
          })
        }
      },
      getActes: function () {
        console.log('infos: ' + this.$route.query.infos)
        if (this.actes.length === 0) {
          console.log('Reading the Database...')
          conn.query('SELECT * FROM Acte WHERE Consultation_idConsultation = ?', [this.$data.idConsultation], (err, results, fields) => {
            if (err) throw err
            console.log('Actes SQL : ', results)
            for (var a of results) {
              console.log('Acte : ', a)
              this.actes.push(a)
            }
          })
        }
      },
      getIdDocteurs: function () {
        conn.query('SELECT idDocteur, Personnel_idPersonnel FROM Docteur',
          (err, results, fields) => {
            if (err) throw err
            for (var id of results) {
              console.log('ID Docteur : ', id.idDocteur)
              // var idDoc = id.idDocteur
              var idPers = id.Personnel_idPersonnel
              // this.$data.docteurs.push(pers)
              conn.query('SELECT * FROM Personnel WHERE idPersonnel = ?', [idPers],
                (err, results, fields) => {
                  if (err) throw err
                  // console.log(results)
                  var docteur = {
                    'nom': results[0].nom,
                    'prenom': results[0].prenom,
                    'mail': results[0].mail,
                    'nomComplet': results[0].nom + ' ' + results[0].prenom,
                    'tel': results[0].telephone
                  }
                  this.$data.docteurs.push(docteur)
                })
            }
            console.log(this.$data.docteurs)
          })
      }
    },
    methods: {
      editConsultation: function () {
        conn.query('UPDATE Consultation SET dateConsultation = ?, fraisConsultation = ?, nomDocteur = ?, note = ? WHERE idConsultation = ?',
          [this.$data.form.dateConsultation, this.$data.form.fraisConsultation, this.$data.form.nomDocteur, this.$data.form.note, this.$data.idConsultation],
          (err, results, fields) => {
            if (err) throw err
            console.log('Consultation Updated ', results)
          })
      },
      onChange: function (event) {
        console.log(event.target.value)
        this.$data.addOrdonnance = true
      },
      newOrdonnance: function () {
        let noteFinale = this.$data.form.noteOrdonnance + ';' + this.$data.extra
        conn.query('INSERT INTO Ordonnance(idPatient, note) VALUES(?, ?)', [this.$data.form.idPatient, noteFinale],
          (err, results, fields) => {
            if (err) throw err
            console.log('New Ordonnance: ', results)
            // Default export is a4 paper, portrait, using milimeters for units
            var doc = new JsPDF()

            doc.text(this.$data.form.nomDocteur, 20, 20)
            doc.text(this.$data.form.dateConsultation, 120, 20)
            doc.text(80, 30, 'Ordonnance')
            doc.text(40, 60, this.$data.form.noteOrdonnance)
            doc.text(40, 70, this.$data.extra)
            doc.text(120, 120, 'Signature')
            doc.save('a4.pdf')
          })
      }
    },
    props: [
      'consultation'
    ],
    validations: {
      form: {
        dateConsultation: {
          required
        },
        fraisConsultation: {
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
</style>
