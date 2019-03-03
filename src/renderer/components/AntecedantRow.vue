<template>
  <tr>
    <td>{{ ante.idAntecedant }}</td>
    <td>{{ ante.description }}</td>
    <td>{{ ante.note }}</td>
    <td>
      <button class="btn" v-on:click="deleteAntecedant">Delete</button>
    </td>
  </tr>
</template>

<script>
  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    data () {
      return {
        id: {
        }
      }
    },
    props: {
      ante: {
        type: Object,
        required: true
      }
    },
    computed: {
    },
    methods: {
      deleteAntecedant: function () {
        if (confirm('Confirmer suppression de cet antecedant')) {
          conn.query('DELETE FROM Antecedant WHERE idAntecedant = ?',
            [this.$props.ante.idAntecedant],
            (err, results, fields) => {
              if (err) throw err
              console.log('Antecedant Deleted, ' + results)
              alert('Antecedant supprime!')
              // window.history.go(-1)
            })
        }
      }
    }
  }
</script>
