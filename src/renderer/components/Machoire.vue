<template>
  <div  v-on:click="showCoords($event)">
    <img src="../assets/dents.png"/>
    <p id="img_coordinate"></p>
  </div>
</template>

<script>
  // const { createCanvas } = require('canvas')
  // const canvas = createCanvas(200, 200)
  // const ctx = canvas.getContext('2d')
  export default {
    data () {
      return {
      }
    },
    methods: {
      showCoords: function (event) {
        var x = event.clientX
        var y = event.clientY
        console.log(x + ', ' + y)
      }
    },
    computed: {
    }
  }
</script>

<style>
  img{
    position: absolute;
    height: 400px;
    top: 50px;
    margin: 20px;
    /* border: 3px solid #73AD21; */
  }
</style>
