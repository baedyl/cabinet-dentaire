<template>
  <div id="app">
    <navigation></navigation>
    <router-view></router-view>
  </div>
</template>

<script>
  import Navigation from './components/NavBar'

  export default {
    name: 'pfa_final',
    components: {
      'navigation': Navigation
    }
  }
</script>

<style>
  /* CSS */
</style>
