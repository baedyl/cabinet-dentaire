<template>
  <button v-on:click="menuPatients">{{ operation }}</button>
</template>

<script>
  export default {
    data () {
      return {
        operation: 'Patients'
      }
    }
  }
</script>

<style>
</style>
