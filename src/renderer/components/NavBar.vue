<template>
  <div class="sidenav">
        <router-link v-for="routes in links"
        v-bind:key="routes.id"
        :to="`${routes.page}`">
          <nav>{{ routes.text }}</nav>
        </router-link>
  </div>
</template>

<script>
  export default {
    name: 'nav-var',
    data () {
      return {
        links: [
          {
            id: 0,
            text: 'Home',
            page: '/'
          },
          {
            id: 1,
            text: 'Ajouter Patient',
            page: '/patients/add'
          },
          {
            id: 2,
            text: 'Liste Patients',
            page: '/patients/liste'
          },
          {
            id: 3,
            text: 'Ajouter RDV',
            page: '/rdv/add'
          },
          {
            id: 4,
            text: 'Agenda',
            page: '/rdv/liste'
          }
        ]
      }
    }
  }
</script>

<style>
  * {
    box-sizing: border-box;
  }

  /* Style the side navigation */
  .sidenav {
    height: 100%;
    width: 200px;
    position: fixed;
    z-index: 1;
    top: 0;
    left: 0;
    background-color: #111;
    overflow-x: hidden;
  }

  /* Side navigation links */
  .sidenav a {
    color: white;
    padding: 16px;
    text-decoration: none;
    display: block;
  }

  /* Change color on hover */
  .sidenav a:hover {
    background-color: #ddd;
    color: black;
  }
</style>
