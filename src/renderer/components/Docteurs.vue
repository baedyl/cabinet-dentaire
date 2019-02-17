<template>
  <select>
    {{ getIdDocteurs }}
    <option v-for="doc in docteurs" :value="doc.idDocteur" @change="triggerEvent">
      {{ doc.nom }} {{ doc.prenom }}
    </option>
  </select>
</template>

<script>
  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    data () {
      return {
        docteurs: []
      }
    },
    props: ['value'],
    computed: {
      getIdDocteurs: function () {
        conn.query('SELECT Personnel_idPersonnel FROM Docteur',
          (err, results, fields) => {
            if (err) throw err
            for (var id of results) {
              console.log('Infos Docteur : ', id)
              // this.$data.docteurs.push(pers)
              conn.query('SELECT * FROM Personnel WHERE idPersonnel = ?', [id.Personnel_idPersonnel],
                (err, results, fields) => {
                  if (err) throw err
                  console.log(results)
                  var docteur = {
                    'nom': results[0].nom,
                    'prenom': results[0].prenom,
                    'idDocteur': id.Personnel_idPersonnel,
                    'mail': results[0].mail,
                    'tel': results[0].telephone
                  }
                  this.$data.docteurs.push(docteur)
                })
            }
          })
      }
    },
    methods: {
      triggerEvent: function (event) {
        this.$emit('option', event.target.value)
      }
    }
  }
</script>

<style>
</style>
