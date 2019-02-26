<template>
  <tr>
    <router-link :to="{ name: 'fiche-acte', query: { id: { 'idActe': acte.idActe } } }">
      <td>{{ acte.idActe }}</td>
    </router-link>
    <td>{{ acte.libelle }}</td>
    <td>{{ acte.noteActe }}</td>
    <router-link :to="{ name: 'fiche-consultation', query: { infos: { 'idConsultation': acte.Consultation_idConsultation } } }">
      <td>{{ acte.Consultation_idConsultation }}</td>
    </router-link>
    <td>{{ acte.dentActe }}</td>
    <td>{{ acte.etatActe }}</td>
    <td>
      <button class="btn" v-on:click="deleteActe">Delete</button>
    </td>
  </tr>
</template>

<script>
  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    data () {
      return {
        infos: {
        }
      }
    },
    props: {
      acte: {
        type: Object,
        required: true
      }
    },
    methods: {
      deleteActe: function () {
        if (confirm('Confirmer la suppression de cet acte')) {
          conn.query('DELETE FROM Acte WHERE idActe = ?',
            [this.$props.acte.idActe],
            (err, results, fields) => {
              if (err) throw err
              console.log('Acte Deleted, ' + results)
              alert('Acte Supprime!')
            })
        }
      }
    }
  }
</script>
