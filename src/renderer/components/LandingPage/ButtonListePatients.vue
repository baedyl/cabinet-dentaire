<template>
  <button>
    <router-link to="/patients/liste">{{ operation }}</router-link>
  </button>
</template>

<script>
  export default {
    data () {
      return {
        operation: 'Liste Patients'
      }
    },
    methods: {
    }
  }
</script>

<style>
</style>
