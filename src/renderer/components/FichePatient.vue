<template>
  <div class="content">
    <router-link :to="{ name: 'liste-patient' }">Retour</router-link>
    <h2>
      ID Patient: {{ $route.query.infos.id }}
      {{ getPatientData }}
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

      <button v-on:click="editPatient" class="btn">{{ title }}</button>
    </form>
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
      <router-link :to="{ name: 'add-consultation', query: { infos: { 'idPatient': this.$data.form.id } } }">New Consultation</router-link>
    </fieldset>
  </div>
</template>

<script>
  import required from 'vuelidate/lib/validators/required'
  import email from 'vuelidate/lib/validators/email'
  import numeric from 'vuelidate/lib/validators/numeric'

  import ConsultationRow from './ConsultationRow'

  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    components: {
      ConsultationRow
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
        dataIsHere: false
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

  .btn {
    font-size: .8em;
    cursor: pointer;
    outline: none;
    padding: 0.75em 2em;
    border-radius: 2em;
    display: inline-block;
    color: #fff;
    background-color: #4fc08d;
    transition: all 0.15s ease;
    box-sizing: border-box;
    border: 1px solid #4fc08d;

    color: #42b983;
    background-color: transparent;
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
</style>
