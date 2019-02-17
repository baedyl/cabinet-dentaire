<template>
  <div class="content">
    {{ getPatients }}
    <table>
      <tr>
        <th>IdPatient</th>
        <th>NomPatient</th>
        <th>PrenomPatient</th>
        <th>MailPatient</th>
        <th>TelephonePatient</th>
        <th>DateNaissance</th>
        <th>Action</th>
      </tr>
      <PatientRow v-for="patient in patients"
      :key="patient.idPatient"
      :patient="patient"
      />
    </table>
  </div>
</template>

<script>
  // Needs some memory improvements
  // Not read the DB each time...
  // Call the method only once, and use
  // the stored array for the next requests.
  import PatientRow from './PatientRow.vue'

  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    name: 'liste-patient',
    components: {
      PatientRow
    },
    data () {
      return {
        patients: []
      }
    },
    computed: {
      getPatients: function () {
        if (this.patients.length === 0) {
          console.log('Reading the Database...')
          conn.query('SELECT * FROM Patient', (err, patients, fields) => {
            if (err) throw err
            // Vue.set(patients, Array(results))
            console.log('Patients SQL : ', patients)
            for (var p of patients) {
              console.log('Patient : ', p)
              this.patients.push(p)
            }
            // this.patients = Array(results)
          })
        }
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

  /* Style the table */
  table {
    border-collapse: collapse;
    border-spacing: 0;
    width: 100%;
    border: 1px solid #ddd;
  }

  /* Style table headers and table data */
  th, td {
    text-align: center;
    padding: 16px;
  }

  th {
    padding-top: 12px;
    padding-bottom: 12px;
    text-align: left;
    background-color: #4CAF50;
    color: white;
  }

  tr:nth-child(even) {
    background-color: #f2f2f2
  }
</style>
