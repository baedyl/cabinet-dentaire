<template>
  <div class="content">
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

      <div class="form-group" :class="{ 'form-group--error': $v.form.naissance.$error }">
        <label class="form__label">Date de naissance Patient</label>
        <input class="form__input" v-model.trim="$v.form.naissance.$model" type="date"/>
      </div>
      <div class="error" v-if="!$v.form.emailValue.required">Le champ date de naissance est obligatoire!</div>

      <!--<button v-on:click="newPatient">{{ title }}</button>-->
      <input type="submit" name="" :value="title" v-on:click="newPatient">
    </form>
  </div>
</template>

<script>
  import required from 'vuelidate/lib/validators/required'
  import email from 'vuelidate/lib/validators/email'
  import numeric from 'vuelidate/lib/validators/numeric'

  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    name: 'add-patient',
    data () {
      return {
        form: {
          emailValue: '',
          firstName: '',
          lastName: '',
          telephone: '',
          naissance: ''
        },
        title: 'Ajout Patient'
      }
    },
    methods: {
      newPatient: function () {
        conn.query('INSERT INTO Patient(nomPatient, prenomPatient, telephonePatient, mailPatient, dateNaissance) VALUES(?, ?, ?, ?, ?)',
          [this.$data.form.firstName, this.$data.form.lastName, this.$data.form.telephone, this.$data.form.emailValue, this.$data.form.naissance],
          (err, results, fields) => {
            if (err) throw err
            console.log('New Patient : ', results)
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
        },
        naissance: {
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

  input, select, textarea {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
  }

  input[type=submit] {
    width: 100%;
    background-color: #4CAF50;
    color: white;
    padding: 14px 20px;
    margin: 8px 0;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }

  input[type=submit]:hover {
    background-color: #45a049;
  }
</style>
