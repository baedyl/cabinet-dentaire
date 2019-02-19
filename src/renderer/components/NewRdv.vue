<template>
  <div class="content">
    <!--<router-link :to="{ name: 'fiche-patient', query: { infos: { 'id': form.idPatient }}}">Retour</router-link>-->
    <form>
      <div class="form-group" :class="{ 'form-group--error': $v.form.dateRdv.$error }">
        <label class="form__label">Date Rdv</label>
        <input class="form__input" v-model.trim="$v.form.dateRdv.$model" type="datetime-local"/>
      </div>
      <div class="error" v-if="!$v.form.dateRdv.required">Le champ date est obligatoire!</div>

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
        <select v-model="$data.form.medecin" @change="onChange">
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

      <button type="submit" class="btn" v-on:click="newRdv">{{ title }}</button>
    </form>
  </div>

</template>

<script>
  import required from 'vuelidate/lib/validators/required'
  // import numeric from 'vuelidate/lib/validators/numeric'

  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    name: 'add-patient',
    components: {
    },
    data () {
      return {
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
                'nomComplet': pat.nomPatient + ' ' + pat.prenomPatient
              }
              this.$data.patients.push(patient)
            }
          })
      }
    },
    methods: {
      newRdv: function () {
        console.log('idDocteur: ' + this.$props.idDocteur)
        conn.query('INSERT INTO Rdv(dateRdv, Patient_idPatient, Docteur_idDocteur, noteRdv) VALUES(?, ?, ?, ?)',
          [this.$data.form.dateRdv, this.$data.form.patient, this.$data.form.medecin, this.$data.form.note],
          (err, results, fields) => {
            if (err) throw err
            console.log('New Rdv : ', results)
          })
      },
      onChange: function (event) {
        console.log(event.target.value)
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
