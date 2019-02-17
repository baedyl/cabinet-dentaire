<template>
  <button v-on:click="agenda">{{ operation }}</button>
</template>

<script>
  export default {
    data () {
      return {
        operation: 'Agenda'
      }
    }
  }
</script>

<style>
</style>
