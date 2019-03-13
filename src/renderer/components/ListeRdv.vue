<template>
  <div class="content">
    {{ loadCalendar }}
    <div id='calendar'>
      <div v-if="clickedRdv">
        {{ detailsRdv() }}
      </div>
    </div>
  </div>
</template>

<script>
  // import moment from 'moment'
  import $ from 'jquery'
  import 'fullcalendar'
  import 'fullcalendar-scheduler'

  const db = require('../database.js')
  const conn = db.getPool()

  var globalEvents = []
  var currentEvent = {}
  export default {
    data () {
      return {
        rdvs: [],
        clickedRdv: false
      }
    },
    methods: {
      detailsRdv: function () {
        console.log(currentEvent)
        this.$router.push({ name: 'liste-patient' })
      },
      getAllRdv: function () {
        if (globalEvents.length === 0) {
          console.log('Reading the Database...')
          conn.query('SELECT * FROM Rdv', (err, results, fields) => {
            if (err) throw err
            console.log('Rdvs SQL : ', results)
            for (var r of results) {
              console.log('Rdv : ', r)
              var rdv = {
                'title': r.noteRdv,
                'start': r.dateRdv,
                'allDay': false,
                'idPatient': r.Patient_idPatient,
                'url': '/patients/liste'
              }
              globalEvents.push(rdv)
            }
          })
        }
      }
    },
    computed: {
      loadCalendar: function () {
        this.getAllRdv()
        $(document).ready(function () {
          console.log('Hello Calendar!')
          $('#calendar').fullCalendar({
            // put your options and callbacks here
            defaultView: 'agendaWeek',
            lazyFetching: true,
            schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
            header: {
              left: 'prev, next, today',
              right: 'agendaWeek, agendaDay'
            },
            events: globalEvents,
            eventClick: function (event) {
              // this.$router.push({ name: 'liste-patient' })
              currentEvent = event
              console.log(event)
              // change the border color just for fun
              $(this).css('border-color', 'red')
              this.open(event.url)
              return false
            }
          })
        })
      }
    }
  }
</script>

<style>
  html, body {
    margin: 10px;
    padding: 0;
    font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
    font-size: 14px;
  }
</style>
