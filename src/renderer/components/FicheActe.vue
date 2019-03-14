<template>
  <div class="content">
    <router-link :to="{ name: 'fiche-consultation', query: { id: { 'idConsultation': $data.idConsultation }}}">
      <img class="icon left-arrow" src="../assets/back.png"/>
    </router-link>
    <br>
    <br>
    <br>
    <h2>ID Acte: {{ idActe }}</h2>
    {{ getActeData }}
    <form>
      <div class="form-group" :class="{ 'form-group--error': $v.form.libelle.$error }">
        <label class="form__label">libelle Consultation</label>
        <input class="form__input" v-model.trim="$v.form.libelle.$model" type="text"/>
      </div>
      <div class="error" v-if="!$v.form.libelle.required">Le champ libelle est obligatoire!</div>

      <div class="form-group">
        <label class="form__label">Notes</label>
        <textarea class="form__input" v-model="form.note"/>
      </div>

      <div class="form-group" :class="{ 'form-group--error': $v.form.dent.$error }">
        <label class="form__label">Dent Acte</label>
        <input class="form__input" v-model.trim="$v.form.dent.$model"/>
      </div>
      <div class="error" v-if="!$v.form.dent.numeric">Valeur de dent incorrecte!</div>

      <div class="form-group">
        <label class="form__label">Etat</label>
        <select class="form__input" v-model="form.etat">
          <option v-for="etat in etats" v-bind:value="etat.value">
            {{ etat.value }}
          </option>
        </select>
      </div>

      <h2><button v-on:click="editActe" class="btn">{{ title }}</button></h2>
    </form>
  </div>
</template>

<script>
import numeric from 'vuelidate/lib/validators/numeric'
import required from 'vuelidate/lib/validators/required'

const db = require('../database.js')
const conn = db.getPool()
export default {
  name: 'fiche-acte',
  data () {
    return {
      etats: [
        { value: 'Started' },
        { value: 'Done' },
        { value: 'Pending' }
      ],
      dataIsHere: false,
      idActe: Number(this.$route.query.id.idActe),
      form: {
        libelle: '',
        dent: '',
        note: '',
        etat: ''
      },
      title: 'Enregistrer Modifications'
    }
  },
  computed: {
    getActeData: function () {
      if (this.$data.dataIsHere === false) {
        console.log('Reading the Database...')
        conn.query('SELECT * FROM Acte WHERE idActe = ?', [this.$data.idActe], (err, results, fields) => {
          if (err) throw err
          console.log('Data Consultation SQL : ', results)
          for (var c of results) {
            console.log('Infos : ', c)
            // this.consultations.push(c)
            this.$data.form.libelle = c.libelle
            this.$data.form.note = c.noteActe
            this.$data.form.dent = c.dentActe
            this.$data.form.etat = c.etatActe
            this.$data.idConsultation = c.Consultation_idConsultation
          }
          this.$data.dataIsHere = true
        })
      }
    }
  },
  methods: {
    editActe: function () {
      conn.query('UPDATE Acte SET libelle = ?, noteActe = ?, dentActe = ?, etatActe = ? WHERE idActe = ?',
        [this.$data.form.libelle, this.$data.form.note, this.$data.form.dent, this.$data.form.etat, this.$data.idActe],
        (err, results, fields) => {
          if (err) throw err
          console.log('Acte Updated ', results)
          this.$router.push({ name: 'fiche-consultation', query: { id: { 'idConsultation': this.$data.idConsultation } } })
        })
    }
  },
  validations: {
    form: {
      libelle: {
        required
      },
      dent: {
        numeric
      }
    }
  }
}
</script>

<style lang="css" scoped>
</style>
