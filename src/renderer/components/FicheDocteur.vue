<template>
  <div class="content">
    {{ getIdPersonnel }}
    {{ getSpecialite }}
    {{ getInfosPersonnel }}
    <h2>Nom Complet: {{ nomComplet }}</h2>
    <h2>ID Persnonnel : {{ idPersonnel }}</h2>
    <h2>Specialite : {{ specialite }}</h2>
    <h2>Nom : {{ nom }}</h2>
    <h2>Prenom : {{ prenom }}</h2>
    <h2>Tel : {{ tel }}</h2>
    <h2>Mail : {{ mail }}</h2>
  </div>
</template>

<script>
  const db = require('../database.js')
  const conn = db.getPool()
  export default {
    data () {
      return {
        nomComplet: this.$route.query.infos.nomComplet,
        idPersonnel: 0,
        specialite: 'Dentiste',
        nom: '',
        prenom: '',
        tel: '',
        mail: ''
      }
    },
    computed: {
      getIdPersonnel: function () {
        console.log('Reading the Database...')
        conn.query('SELECT Personnel_idPersonnel FROM Docteur WHERE nomComplet = ?', [this.$data.nomComplet], (err, results, fields) => {
          if (err) throw err
          console.log('IdPersonnel : ', results)
          for (var id of results) {
            this.idPersonnel = Number(id.Personnel_idPersonnel)
          }
        })
      },
      // Retrieve the infos of the doctor from the Personnel Table
      getInfosPersonnel: function () {
        console.log('Reading the Database...')
        conn.query('SELECT * FROM Personnel WHERE idPersonnel = ?', [this.$data.idPersonnel], (err, results, fields) => {
          if (err) throw err
          console.log('infosPersonnel : ', results)
          for (var col of results) {
            // console.log(col)
            this.nom = col.nom
            this.prenom = col.prenom
            this.tel = col.telephone
            this.mail = col.mail
          }
        })
      },
      getSpecialite: function () {
        console.log('Reading the Database...')
        conn.query('SELECT specialite FROM Docteur WHERE nomComplet = ?', [this.$data.nomComplet], (err, results, fields) => {
          if (err) throw err
          console.log('Specialite : ', results)
          for (var spec of results) {
            console.log('spec' + spec)
            if (spec.specialite !== null) {
              this.specialite = spec.specialite
            }
          }
        })
      }
    },
    methods: {
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
