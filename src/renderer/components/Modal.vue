<template>
  <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container">
          <button id="close-btn" class="btn" @click="$emit('close')">
            X
          </button>
          <div class="modal-header">
            <slot name="header">
            </slot>
          </div>

          <div class="modal-body">
            <slot name="body">
            </slot>
            <!--<Machoire/>-->
          </div>

          <div class="modal-footer">
            <slot name="footer">
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
  import Machoire from './Machoire.vue'

  export default {
    components: {
      Machoire
    }
  }
</script>

<style>
  #close-btn {
    top: 0px;
    right: -400px;
    position: relative;
  }
</style>
