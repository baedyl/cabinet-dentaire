<template>
  <div class="content">
    <router-link :to="{ name: 'fiche-consultation', query: { id: { 'idConsultation': this.$data.idConsultation } } }">Retour</router-link>
    <form>
      <div class="form-group" :class="{ 'form-group--error': $v.form.libelle.$error }">
        <label class="form__label">Libelle Acte</label>
        <input class="form__input" v-model.trim="$v.form.libelle.$model"/>
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
      <div class="error" v-if="!$v.form.dent.required">Le champ dent est obligatoire!</div>
      <div class="error" v-if="!$v.form.dent.numeric">Valeur numerique obligatoire!</div>

      <div class="form-group">
        <label class="form__label">Etat</label>
        <select class="form__input" v-model="form.etatActe">
          <option v-for="etat in etats" v-bind:value="etat.value">
            {{ etat.value }}
          </option>
        </select>
      </div>

      <!--<button v-on:click="newActe">{{ title }}</button>-->
      <input type="submit" name="" :value="title" v-on:click="newActe">

      <!-- Illustration des dents -->
      <Machoire/>
    </form>
  </div>
</template>

<script>
  import required from 'vuelidate/lib/validators/required'
  import numeric from 'vuelidate/lib/validators/numeric'

  import Machoire from './Machoire'

  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    name: 'add-acte',
    components: {
      Machoire
    },
    data () {
      return {
        id: {
        },
        etats: [
          { value: 'Started' },
          { value: 'Done' },
          { value: 'Pending' }
        ],
        form: {
          libelle: '',
          note: '',
          dent: '',
          etatActe: 'Started'
        },
        idConsultation: Number(this.$route.params.id),
        title: 'Ajout Acte'
      }
    },
    methods: {
      newActe: function () {
        console.log('idConsultation: ' + this.$data.idConsultation)
        conn.query('INSERT INTO Acte(libelle, noteActe, Consultation_idConsultation, dentActe, etatActe) VALUES(?, ?, ?, ?, ?)',
          [this.$data.form.libelle, this.$data.form.note, this.$data.idConsultation, this.$data.form.dent, this.$data.form.etatActe],
          (err, results, fields) => {
            if (err) throw err
            console.log('New Acte : ', results)
          })
      }
    },
    validations: {
      form: {
        libelle: {
          required
        },
        dent: {
          required,
          numeric
        }
      }
    }
  }
</script>

<style>
</style>
