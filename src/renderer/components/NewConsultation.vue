<template>
  <div class="content">
    <router-link :to="{ name: 'fiche-patient', query: { infos: { 'id': form.idPatient }}}">
      <img class="left-arrow" src="../assets/back.png"/>
    </router-link>
    <br>
    <br>
    <br>
    <form>
      <div class="form-group" :class="{ 'form-group--error': $v.form.dateConsultation.$error }">
        <label class="form__label">Date Consultation</label>
        <input class="form__input" v-model.trim="$v.form.dateConsultation.$model" type="date"/>
      </div>
      <div class="error" v-if="!$v.form.dateConsultation.required">Le champ date est obligatoire!</div>

      <div class="form-group" :class="{ 'form-group--error': $v.form.frais.$error }">
        <label class="form__label">Frais Consultation</label>
        <input class="form__input" v-model.trim="$v.form.frais.$model"/>
      </div>
      <div class="error" v-if="!$v.form.frais.numeric">Frais de consultation non valide!</div>

      <div class="form-group">
        <label class="form__label">Medecin traitant</label>
        <select v-model="$data.form.medecin" @change="onChange">
          {{ getIdDocteurs }}
          <option v-for="doc in docteurs" :value="doc.nomComplet">
            {{ doc.nomComplet }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label class="form__label">Notes </label>
        <input class="form__input" v-model="$data.form.note"/>
      </div>

      <h2><button type="submit" class="btn" v-on:click="newConsultation">{{ title }}</button></h2>
    </form>
    <br>
    <fieldset v-if="addOrdonnance">
      <legend>Ordonnance</legend>
      <label class="form__label">Note Ordonnance</label>
      <input class="form__input" v-model="$data.form.noteOrdonnance"/>

      <div class="form-group">
        <label class="switch" for="hasExtra">Another One?
          <input type="checkbox" id="hasExtra" v-model="hasExtra">
          <span class="slider round"></span>
        </label>
        <!--<div class="toggle">
          <input id="hasExtra" type="checkbox" v-model="hasExtra"/>
          <label for="hasExtra">
            <div class="toggle__switch"></div>
          </label>
        </div>-->
      </div>
      <div class="form-group" v-if="hasExtra">
        <label class="form__label">Extra</label>
        <textarea class="form__input" v-model="extra"/>
      </div>
      <br>
      <h2><button class="btn" v-on:click="newOrdonnance">Ajouter</button></h2>
    </fieldset>

  </div>

</template>

<script>
  // const { required, email, minLength } = require('vuelidate/lib/validators')
  // import minLength from 'vuelidate/lib/validators/minLength'
  import required from 'vuelidate/lib/validators/required'
  import numeric from 'vuelidate/lib/validators/numeric'
  import JsPDF from 'jspdf'

  const db = require('../database.js')
  const conn = db.getPool()

  export default {
    name: 'add-patient',
    components: {
    },
    data () {
      return {
        docteurs: [],
        hasExtra: false,
        addOrdonnance: false,
        extra: '',
        form: {
          dateConsultation: new Date(),
          frais: 0,
          idPatient: Number(this.$route.query.infos.idPatient),
          medecin: '',
          note: '',
          noteOrdonnance: ''
        },
        title: 'Ajout Consultation',
        listMedecins: []
      }
    },
    props: {
    },
    computed: {
      setIdPatient: function () {
        this.$data.form.idPatient = Number(this.$route.query.infos.idPatient)
        console.log('idPatient: ' + this.$data.form.idPatient)
      },
      getIdDocteurs: function () {
        conn.query('SELECT idDocteur, Personnel_idPersonnel FROM Docteur',
          (err, results, fields) => {
            if (err) throw err
            for (var id of results) {
              console.log('ID Docteur : ', id.idDocteur)
              // var idDoc = id.idDocteur
              var idPers = id.Personnel_idPersonnel
              // this.$data.docteurs.push(pers)
              conn.query('SELECT * FROM Personnel WHERE idPersonnel = ?', [idPers],
                (err, results, fields) => {
                  if (err) throw err
                  // console.log(results)
                  var docteur = {
                    'nom': results[0].nom,
                    'prenom': results[0].prenom,
                    'mail': results[0].mail,
                    'nomComplet': results[0].nom + ' ' + results[0].prenom,
                    'tel': results[0].telephone
                  }
                  this.$data.docteurs.push(docteur)
                })
            }
            console.log(this.$data.docteurs)
          })
      }
    },
    methods: {
      newConsultation: function () {
        console.log('idDocteur: ' + this.$props.idDocteur)
        conn.query('INSERT INTO Consultation(dateConsultation, fraisConsultation, Patient_idPatient, nomDocteur, note) VALUES(?, ?, ?, ?, ?)',
          [this.$data.form.dateConsultation, this.$data.form.frais, this.$data.form.idPatient, this.$data.form.medecin, this.$data.form.note],
          (err, results, fields) => {
            if (err) throw err
            console.log('New Consultation : ', results)
            this.$router.push({ name: 'fiche-patient', query: { infos: { id: this.$data.form.idPatient } } })
          })
      },
      onChange: function (event) {
        console.log(event.target.value)
        this.$data.addOrdonnance = true
      },
      newOrdonnance: function () {
        let noteFinale = this.$data.form.noteOrdonnance + ';' + this.$data.extra
        conn.query('INSERT INTO Ordonnance(idPatient, note) VALUES(?, ?)', [this.$data.form.idPatient, noteFinale],
          (err, results, fields) => {
            if (err) throw err
            console.log('New Ordonnance: ', results)
            // Default export is a4 paper, portrait, using milimeters for units
            var doc = new JsPDF()

            doc.text(this.$data.form.medecin, 20, 20)
            doc.text(this.$data.form.dateConsultation, 120, 20)
            doc.text(80, 30, 'Ordonnance')
            doc.text(40, 60, this.$data.form.noteOrdonnance)
            doc.text(40, 70, this.$data.extra)
            doc.text(120, 120, 'Signature')
            doc.save('a4.pdf')
          })
      }
    },
    validations: {
      form: {
        dateConsultation: {
          required
        },
        frais: {
          numeric
        },
        medecin: {
          required
        }
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

  .switch {
    position: relative;
    display: inline-block;
    width: 60px;
    height: 34px;
  }

  .switch input {
    opacity: 0;
    width: 0;
    height: 0;
  }

  .slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #ccc;
    -webkit-transition: .4s;
    transition: .4s;
  }

  .slider:before {
    position: absolute;
    content: "";
    height: 26px;
    width: 26px;
    left: 4px;
    bottom: 4px;
    background-color: white;
    -webkit-transition: .4s;
    transition: .4s;
  }

  input:checked + .slider {
    background-color: #2196F3;
  }

  input:focus + .slider {
    box-shadow: 0 0 1px #2196F3;
  }

  input:checked + .slider:before {
    -webkit-transform: translateX(26px);
    -ms-transform: translateX(26px);
    transform: translateX(26px);
  }

  /* Rounded sliders */
  .slider.round {
    border-radius: 34px;
  }

  .slider.round:before {
    border-radius: 50%;
  }
</style>
