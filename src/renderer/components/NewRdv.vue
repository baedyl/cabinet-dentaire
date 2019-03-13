<template>
  <div class="content">
    <!--<router-link :to="{ name: 'fiche-patient', query: { infos: { 'id': form.idPatient }}}">Retour</router-link>-->
    <form class="edit-form">
      <div class="form-group" :class="{ 'form-group--error': $v.form.dateRdv.$error }">
        <label class="form__label">Date et Heure Rdv</label>
        <input class="form__input" v-model.trim="$v.form.dateRdv.$model" type="datetime-local" @change="verifyDate"/>
      </div>
      <div class="error" v-if="!$v.form.dateRdv.required">Le champ date et heure est obligatoire!</div>

      <div class="form-group">
        <label class="form__label">Patient</label>
        <select v-model="$data.form.patient" @change="onChange">
          {{ getIdPatients }}
          <option v-for="pat in patients" :value="pat.id">
            {{ pat.nomComplet }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label class="form__label">Medecin traitant</label>
        <select v-model="$data.form.medecin" @change="onChangeDocteur">
          {{ getIdDocteurs }}
          <option v-for="doc in docteurs" :value="doc.id">
            {{ doc.nomComplet }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label class="form__label">Notes </label>
        <input class="form__input" v-model="$data.form.note"/>
      </div>

      <h2><button type="submit" class="btn" v-on:click="newRdv">{{ title }}</button></h2>
      <div v-if="envoyerMail">
        {{ sendMail() }}
      </div>
      <!--<button class="btn" v-on:click="sendMail">Send Mail</button>-->
    </form>
  </div>

</template>

<script>
  import required from 'vuelidate/lib/validators/required'
  // import numeric from 'vuelidate/lib/validators/numeric'
  import * as emailjs from 'emailjs-com'

  const db = require('../database.js')
  const conn = db.getPool()

  var mailPatient = ''

  export default {
    name: 'add-patient',
    components: {
    },
    data () {
      return {
        envoyerMail: false,
        docteurs: [],
        patients: [],
        form: {
          dateRdv: '',
          patient: '',
          medecin: '',
          note: ''
        },
        title: 'Ajout Rdv',
        listMedecins: []
      }
    },
    props: {
    },
    computed: {
      setIdPatient: function () {
        this.$data.form.idPatient = Number(this.$route.query.infos.idPatient)
        console.log('idPatient: ' + this.$data.form.idPatient)
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
                    'id': results[0].idPersonnel,
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
      },
      getIdPatients: function () {
        conn.query('SELECT * FROM Patient',
          (err, results, fields) => {
            if (err) {
              throw err
            }
            for (var pat of results) {
              // console.log(pat)
              var patient = {
                'id': pat.idPatient,
                'nomPatient': pat.nomPatient,
                'prenomPatient': pat.prenomPatient,
                'nomComplet': pat.nomPatient + ' ' + pat.prenomPatient,
                'mailPatient': pat.mailPatient
              }
              this.$data.patients.push(patient)
            }
          })
      }
    },
    methods: {
      sendMail: function () {
        emailjs.init('user_awm2wX3M7EMMitXz238N3')
        var templateParams = {
          mail_patient: mailPatient,
          contact_number: Math.random() * 100000 | 0,
          nom_patient: this.$data.patients[Number(this.$data.form.patient) - 1].nomComplet,
          nom_docteur: this.$data.docteurs[Number(this.$data.form.medecin) - 1].nomComplet,
          date_rdv: this.$data.form.dateRdv,
          note: this.$data.form.note
        }

        emailjs.send('contact_service', 'new_rdv', templateParams)
          .then((response) => {
            console.log('SUCCESS!', response.status, response.text)
          }, (err) => {
            console.log('FAILED...', err)
          })
      },
      newRdv: function () {
        console.log('idDocteur: ' + this.$props.idDocteur)
        conn.query('INSERT INTO Rdv(dateRdv, Patient_idPatient, Docteur_idDocteur, noteRdv) VALUES(?, ?, ?, ?)',
          [this.$data.form.dateRdv, this.$data.form.patient, this.$data.form.medecin, this.$data.form.note],
          (err, results, fields) => {
            if (err) throw err
            console.log('New Rdv : ', results)
            this.$data.envoyerMail = true
            this.sendMail()
            this.$router.push({ name: 'liste-rdv' })
          })
      },
      onChange: function (event) {
        // console.log(event.target.value)
        let idP = Number(event.target.value)
        mailPatient = this.$data.patients.find(x => x.id === idP).mailPatient
        console.log('mailPatient: ' + mailPatient)
      },
      onChangeDocteur: function (event) {
        // Verifier si un Rdv n'existe pas pour le meme jour et heure
        // pour le docteur selectionne
        let idDoc = Number(event.target.value)
        console.log('Verifying Date... ' + idDoc)
        console.log('Reading the Database...')
        conn.query('SELECT * FROM Rdv WHERE dateRdv = ? AND Docteur_idDocteur = ?', [this.$data.form.dateRdv, idDoc], (err, results, fields) => {
          if (err) throw err
          // console.log('Patients SQL : ', patients)
          if (results.length > 0) {
            alert('Jour et heure de Rdv non disponible')
            this.$data.form.dateRdv = ''
          }
        })
      },
      verifyDate: function () {

      }
    },
    validations: {
      form: {
        dateRdv: {
          required
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
