<template>
  <div class="content">
    <div v-if="dataIsNotHere">
      {{ getPatientsData() }}
    </div>
    <div>{{ filteredAndSortedData }}</div>
    <form id="search">
      Search <input name="query" v-model="searchQuery" placeholder="Rechercher un patient">
    </form>
    <table>
      <thead>
        <tr>
          <th>idPatient</th>
          <th>nomPatient</th>
          <th>PrenomPatient</th>
          <th>MailPatient</th>
          <th>TelephonePatient</th>
          <th>DateNaissance</th>
          <th>Action</th>

        </tr>
      </thead>
      <tbody>
        <PatientRow v-for="patient in filteredPatients"
        :key="patient.idPatient"
        :patient="patient"
        />
      </tbody>
    </table>

    <!--<GridTemplate
      :heroes="gridData"
      :columns="gridColumns"
      :filterKey="searchQuery">
    </GridTemplate>
  -->


  </div>
</template>

<script>
  // For some memory improvements
  // Not read the DB each time...
  // Call the method only once, and use
  // the stored array for the next requests.
  import PatientRow from './PatientRow.vue'
  // import GridTemplate from './GridTemplate.vue'

  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    name: 'liste-patient',
    components: {
      PatientRow
    },
    data () {
      return {
        patients: [],
        filteredPatients: [],
        sortAsc: true,
        searchQuery: '',
        dataIsNotHere: true
      }
    },
    computed: {
      getPatients: function () {
        console.log('length: ' + this.patients.length)

        if (this.patients.length === 0) {
          console.log('Reading the Database...')
          conn.query('SELECT * FROM Patient', (err, results, fields) => {
            if (err) throw err
            // console.log('Patients SQL : ', patients)
            for (var p of results) {
              // console.log('Patient : ', p)
              console.log('in! ' + this.patients.includes(p))
              if (this.patients.includes(p) === false) {
                this.patients.push(p)
              }
            }
          })
        }
      },
      // Search the nomPatient and prenomPatient
      filteredAndSortedData: function () {
        let result = this.patients
        this.searchQuery = this.searchQuery.toLowerCase()
        if (this.searchQuery) {
          let halfSorted = result.filter(item => item.nomPatient.toLowerCase().includes(this.searchQuery))
          // Copy both results arrays and remove duplicates
          result = [...new Set([...halfSorted, ...result.filter(item => item.prenomPatient.toLowerCase().includes(this.searchQuery))])]
        }

        let ascDesc = this.sortAsc ? 1 : -1
        this.filteredPatients = result.sort((a, b) => ascDesc * a.nomPatient.localeCompare(b.nomPatient))
        // return this.filteredPatients
      }
    },
    methods: {
      sortBy: function (sortKey) {
        this.reverse = (this.sortKey === sortKey) ? !this.reverse : false
        this.sortKey = sortKey
      },
      getPatientsData: function () {
        console.log('Reading the Database...')
        conn.query('SELECT * FROM Patient', (err, results, fields) => {
          if (err) throw err
          // console.log('Patients SQL : ', patients)
          for (var p of results) {
            // console.log('Patient : ', p)
            console.log('in! ' + this.patients.includes(p))
            if (this.patients.includes(p) === false) {
              this.patients.push(p)
            }
          }
        })
        this.dataIsNotHere = false
      }
    },
    filters: {
      capitalize: function (value) {
        if (!value) return ''
        value = value.toString()
        return value.charAt(0).toUpperCase() + value.slice(1)
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
