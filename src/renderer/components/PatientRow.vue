<template>
  <tr>
    {{ convertDate }}
    <router-link :to="{ name: 'fiche-patient', query: { infos: { 'id': patient.idPatient }}}">
      <td>{{ patient.idPatient }}</td>
    </router-link>
    <td>{{ patient.nomPatient }}</td>
    <td>{{ patient.prenomPatient }}</td>
    <td>{{ patient.mailPatient }}</td>
    <td>{{ patient.telephonePatient }}</td>
    <td>{{ patient.dateNaissance }}</td>
    <td>
      <button v-on:click="deletePatient">Delete</button>
    </td>
  </tr>
</template>

<script>
  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    data () {
      return {
      }
    },
    props: {
      patient: {
        type: Object,
        required: true
      }
    },
    methods: {
      deletePatient: function () {
        conn.query('DELETE FROM Patient WHERE idPatient = ?',
          [this.$props.patient.idPatient],
          (err, results, fields) => {
            if (err) throw err
            console.log('Patient Deleted, ' + results)
          })
      }
    },
    computed: {
      convertDate: function () {
        this.$props.patient.dateNaissance = new Date(this.$props.patient.dateNaissance).toISOString().split('T')[0]
      }
    }
  }
</script>
