<template>
  <div class="content">
    {{ getRecette() }}
    {{ nbPatients() }}
    {{ nbConsultations() }}
    <h3>Recette Totale: {{ recette }}</h3>
    <h3>Nombre de patients: {{ nbPat }}</h3>
    <h3>Nombre de consultations: {{ nbCons }}</h3>
  </div>

</template>

<script>
const db = require('../database.js')
const conn = db.getPool()

export default {
  name: 'finances',
  data () {
    return {
      recette: 0,
      nbCons: 0,
      nbPat: 0
    }
  },
  methods: {
    getRecette: function () {
      conn.query('SELECT SUM(fraisConsultation) AS recette FROM Consultation', (err, results, fields) => {
        if (err) throw err
        // console.log('Patients SQL : ', patients)
        console.log('Somme: ' + results)
        this.$data.recette = results[0].recette
      })
    },
    nbConsultations: function () {
      conn.query('SELECT COUNT(idConsultation) AS nbCons FROM Consultation', (err, results, fields) => {
        if (err) throw err
        // console.log('Patients SQL : ', patients)
        console.log('Nb Cons: ' + results)
        this.$data.nbCons = results[0].nbCons
      })
    },
    nbPatients: function () {
      conn.query('SELECT COUNT(idPatient) AS nbPat FROM Patient', (err, results, fields) => {
        if (err) throw err
        // console.log('Patients SQL : ', patients)
        console.log('Nb Pat: ' + results)
        this.$data.nbPat = results[0].nbPat
      })
    }
  }
}
</script>

<style>
</style>
