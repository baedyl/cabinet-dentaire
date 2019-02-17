<template>
  <div class="content">
    <router-link :to="{ name: 'fiche-patient', query: { infos: { 'id': form.idPatient }}}">Retour</router-link>
    <form>
      <div class="form-group" :class="{ 'form-group--error': $v.form.dateConsultation.$error }">
        <label class="form__label">Date Consultation</label>
        <input class="form__input" v-model.trim="$v.form.dateConsultation.$model" type="date"/>
      </div>
      <div class="error" v-if="!$v.form.dateConsultation.required">Le champ date est obligatoire!</div>

      <div class="form-group" :class="{ 'form-group--error': $v.form.frais.$error }">
        <label class="form__label">Frais Consultation</label>
        <input class="form__input" v-model.trim="$v.form.frais.$model"/>
      </div>
      <div class="error" v-if="!$v.form.frais.numeric">Frais de consultation non valide!</div>

      <div class="form-group">
        <label class="form__label">Medecin traitant</label>
        <select v-model="$data.form.medecin" @change="onChange">
          {{ getIdDocteurs }}
          <option v-for="doc in docteurs" :value="doc.nomComplet">
            {{ doc.nomComplet }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label class="form__label">Notes </label>
        <input class="form__input" v-model="$data.form.note"/>
      </div>

      <button type="submit" class="btn" v-on:click="newConsultation">{{ title }}</button>
    </form>
  </div>

</template>

<script>
  // const { required, email, minLength } = require('vuelidate/lib/validators')
  // import minLength from 'vuelidate/lib/validators/minLength'
  import required from 'vuelidate/lib/validators/required'
  import numeric from 'vuelidate/lib/validators/numeric'

  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    name: 'add-patient',
    components: {
    },
    data () {
      return {
        docteurs: [],
        form: {
          dateConsultation: '',
          frais: 0,
          idPatient: Number(this.$route.query.infos.idPatient),
          medecin: '',
          note: ''
        },
        title: 'Ajout Consultation',
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
      newConsultation: function () {
        console.log('idDocteur: ' + this.$props.idDocteur)
        conn.query('INSERT INTO Consultation(dateConsultation, fraisConsultation, Patient_idPatient, nomDocteur, note) VALUES(?, ?, ?, ?, ?)',
          [this.$data.form.dateConsultation, this.$data.form.frais, this.$data.form.idPatient, this.$data.form.medecin, this.$data.form.note],
          (err, results, fields) => {
            if (err) throw err
            console.log('New Consultation : ', results)
          })
      },
      getMedecins: {
      },
      onChange: function (event) {
        console.log(event.target.value)
      }
    },
    validations: {
      form: {
        dateConsultation: {
          required
        },
        frais: {
          numeric
        },
        medecin: {
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
