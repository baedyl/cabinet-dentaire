<template>
  <div id="wrapper" class="content">
    <!--<img id="logo" src="~@/assets/logo.png" alt="electron-vue">-->
    <main>
      <div class="left-side">
        <span class="title">
          <h1>Gestion Cabinet Dentaire!</h1>
        </span>
        <h2>Bienvenue Docteur: {{ nom }} {{ prenom }}</h2>
        <system-information></system-information>
      </div>
      <!--
      <div class="left-side">
        <ButtonPatients class="btn"></ButtonPatients>
        <ButtonAgenda class="btn"></ButtonAgenda>
        <ButtonNewPatient class="btn"></ButtonNewPatient>
        <ButtonListePatients class="btn"></ButtonListePatients>
      </div>
      -->
    </main>
    <Modal v-if="!loggedIn">
      <h3 slot="header">
        <img class="lock" src="../assets/shield.png"/>
        <label class="form__label">Username</label>
        <input class="form__input" v-model="$data.username" type="text"/>
        <label class="form__label">Password</label>
        <input class="form__input" v-model="$data.password" type="password"/>
        <button class="btn" v-on:click="login">Se Connecter</button>
      </h3>
    </Modal>
  </div>
</template>

<script>
  import SystemInformation from './LandingPage/SystemInformation'
  import ButtonPatients from './LandingPage/ButtonPatients'
  import ButtonAgenda from './LandingPage/ButtonAgenda'
  import ButtonNewPatient from './LandingPage/ButtonNewPatient'
  import ButtonListePatients from './LandingPage/ButtonListePatients'
  import Modal from './Modal'

  const db = require('../database.js')
  const conn = db.getPool()

  conn.connect()
  /* conn.query('SELECT * FROM Patient', (err, results, fields) => {
    if (err) throw err
    console.log('Patients : ', results)
  })
  */

  export default {
    name: 'landing-page',
    components: {
      SystemInformation,
      ButtonPatients,
      ButtonAgenda,
      ButtonNewPatient,
      ButtonListePatients,
      Modal
    },
    data () {
      return {
        loggedIn: false,
        username: '',
        password: '',
        nom: '',
        prenom: ''
      }
    },
    methods: {
      open (link) {
        this.$electron.shell.openExternal(link)
      },
      login: function () {
        conn.query('SELECT * FROM Personnel WHERE mail = ?', [this.$data.username], (err, results, fields) => {
          if (err) throw err
          if (results[0].password === this.$data.password) {
            this.$data.loggedIn = true
            this.$data.nom = results[0].nom
            this.$data.prenom = results[0].prenom
          }
        })
      }
    }
  }
</script>

<style>
  @import url('https://fonts.googleapis.com/css?family=Source+Sans+Pro');

  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  body { font-family: 'Source Sans Pro', sans-serif; }

  #wrapper {
    background:
      radial-gradient(
        ellipse at top left,
        rgba(255, 255, 255, 1) 40%,
        rgba(229, 229, 229, .9) 100%
      );
    height: 100vh;
    padding: 60px 80px;
    width: 100vw;
  }

  #logo {
    height: auto;
    margin-bottom: 20px;
    width: 420px;
  }

  main {
    display: flex;
    justify-content: space-between;
  }

  main > div { flex-basis: 50%; }

  .left-side {
    display: flex;
    flex-direction: column;
  }

  .welcome {
    color: #555;
    font-size: 23px;
    margin-bottom: 10px;
  }

  .title {
    color: #2c3e50;
    font-size: 20px;
    font-weight: bold;
    margin-bottom: 6px;
  }

  .title.alt {
    font-size: 18px;
    margin-bottom: 10px;
  }

  .doc p {
    color: black;
    margin-bottom: 10px;
  }

  .btn {
    font-size: .8em;
    cursor: pointer;
    outline: none;
    padding: 0.75em 2em;
    border-radius: 2em;
    display: inline-block;
    color: #fff;
    background-color: #4fc08d;
    transition: all 0.15s ease;
    box-sizing: border-box;
    border: 1px solid #4fc08d;

    color: #42b983;
    background-color: transparent;
  }

  .btn:hover {
    background-color: #4CAF50;
    color: white;
  }

  .lock {
    height: 250px;
  }
</style>
