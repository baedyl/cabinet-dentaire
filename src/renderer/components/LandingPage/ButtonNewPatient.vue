<template>
  <button>
    <router-link to="/patients/add">{{ operation }}</router-link>
  </button>
</template>

<script>
  export default {
    data () {
      return {
        operation: 'New Patient'
      }
    },
    methods: {
    }
  }
</script>

<style>
</style>
