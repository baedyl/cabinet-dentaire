<template>
  <div class="content">
    <router-link :to="{ name: 'fiche-patient', query: { infos: { 'id': form.idPatient }}}">Retour</router-link>
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

      <button v-on:click="editConsultation" class="btn">{{ title }}</button>
    </form>

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
      <router-link :to="{ name: 'add-acte', params: { id: this.$data.idConsultation } }">New Acte</router-link>
      <!--<router-link :to="{ name: 'add-acte', query: { id: { 'idConsultation': this.$data.idConsultation } } }">New Acte</router-link>-->
    </fieldset>
  </div>
</template>

<script>
  import numeric from 'vuelidate/lib/validators/numeric'
  import required from 'vuelidate/lib/validators/required'

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
        form: {
          dateConsultation: '', // this.$route.query.infos.dateConsultation,
          fraisConsultation: '', // this.$route.query.infos.fraisConsultation,
          nomDocteur: '', // this.$route.query.infos.nomDocteur,
          note: '', // this.$route.query.infos.note,
          medecin: '',
          idPatient: ''// this.$route.query.infos.idPatient
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
