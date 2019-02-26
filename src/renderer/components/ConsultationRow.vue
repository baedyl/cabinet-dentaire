<template>
  <tr>
    {{ convertDate }}
    <router-link :to="{ name: 'fiche-consultation', query: { id: { 'idConsultation': consultation.idConsultation } } }">
      <td>{{ consultation.idConsultation }}</td>
    </router-link>
    <td>{{ consultation.dateConsultation }}</td>
    <td>{{ consultation.fraisConsultation }}</td>
    <td>{{ consultation.Patient_idPatient }}</td>
    <router-link :to="{ name: 'fiche-docteur', query: { infos: { 'nomComplet': consultation.nomDocteur } } }">
      <td>{{ consultation.nomDocteur }}</td>
    </router-link>
    <td>
      <button class="btn" v-on:click="deleteConsultation">Delete</button>
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
        },
        id: {
        }
      }
    },
    props: {
      consultation: {
        type: Object,
        required: true
      }
    },
    computed: {
      convertDate: function () {
        this.$props.consultation.dateConsultation = new Date(this.$props.consultation.dateConsultation).toISOString().split('T')[0]
        // console.log('convertDate: ' + this.$props.consultation.dateConsultation)
      }
    },
    methods: {
      deleteConsultation: function () {
        if (confirm('Confirmer suppression de cette consultation')) {
          conn.query('DELETE FROM Consultation WHERE idConsultation = ?',
            [this.$props.consultation.idConsultation],
            (err, results, fields) => {
              if (err) throw err
              console.log('Consultation Deleted, ' + results)
              alert('Consultation supprimee!')
              window.history.go(-1)
            })
        }
      }
    }
  }
</script>
