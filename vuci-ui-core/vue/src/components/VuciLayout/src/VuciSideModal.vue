<template>
  <div class="side-modal">
    <div class="side-modal-overlay" :style="[!showSideModal ? {'display' : 'none'} : {}]"/>
    <div class="side-modal-button" @click="showSideModal = !showSideModal" :style="[!showSideModal ? {'right' : '0'} : {}]">
      <img src="/icons/side_overview.svg" alt="" class="side-modal-btn-img">
    </div>
    <div class="side-modal-container" :style="[!showSideModal ? {'width' : '0', 'padding' : '10px 0 0 0', 'border': 'none'} : {}]">
      <div class="side-modal-content">
        <h3 class="side-modal-title">
          overview settings
        </h3>
        <slot></slot>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data () {
    return {
      showSideModal: false
    }
  }
}
</script>
<style>
.side-modal-overlay {
  display: flex;
  position: fixed;
  align-items: center;
  justify-content: center;
  height: 100vh;
  width: 100%;
  background-color: rgba(0,0,0,0.6);
  top: 0;
  left: 0;
  z-index: 1;
  transition: opacity 0.15s linear;
}
.side-modal-button {
  position: fixed;
  top: 132px;
  right: 350px;
  z-index: 2;
  background: #0054a6;
  cursor: pointer;
  border: 0;
  padding: 15px 10px;
  border-radius: unset;
  border-top-left-radius: 7px;
  border-bottom-left-radius: 7px;
  border: 1px solid #e4e4e4;
  border-color: #0054a6;
  margin-right: -1px;
  transition: 0.5s;
}
.side-modal-btn-img {
  width: 16px;
  height: 16px;
}
.side-modal-container {
  display: block;
  position: fixed;
  right: -1px;
  width: 350px;
  border: unset;
  border: 1px solid #e4e4e4;
  border-bottom-left-radius: 7px;
  top: 132px;
  background-color: #fff;
  z-index: 1;
  overflow-y: auto;
  transition: 0.5s;
  overflow-y: auto;
  padding: 10px 20px 0 20px;
  height: 60vh;
  pointer-events: all;
}
.side-modal-content {
  width: 300px;
  border: unset;
  border: 1px solid #e4e4e4;
  border-radius: 5px;
  padding: 1em;
  margin-top: 15px;
  margin-bottom: 15px;
}
.side-modal-title {
  margin-bottom: 1.2em;
  margin-top: 1em;
  padding-bottom: 0.2em;
  border: unset;
  border-bottom: 1px solid #e4e4e4;
  font-family: "Oswald",sans-serif;
  font-weight: 400;
  font-size: 18px;
  text-transform: uppercase;
}
.element-line {
  display: flex;
}
.checked-item-input, .checked-item-input:focus,
.overview-item-input, .overview-item-input:focus {
  background: #fff;
  appearance: none;
  width: 13px;
  height: 13px;
  padding: 0;
  cursor: pointer;
  margin-right: 8px;
  vertical-align: -2px;
  border: 1px solid #e4e4e4;
  border-radius: unset;
  border-radius: 7px;
  border-color: #afafaf;
  box-shadow: none;
  outline: none;
  display: inline-block;
  margin-top: 4px;
}
.checked-item-input::after {
  background-image: url(/icons/checkbox_tick.svg);
  background-position: 1px -3px;
  background-repeat: no-repeat;
  width: 15px;
  height: 15px;
  content: "";
  position: absolute;
}
.overview-item-name {
  text-transform: uppercase;
  display: inline-block;
}
.overview-element-label {
  text-overflow: ellipsis;
  overflow: hidden;
  white-space: nowrap;
}
</style>
