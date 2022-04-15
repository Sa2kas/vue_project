<template>
  <div class="small-page-header">
    <div class="small-header">
      <div class="showHideLeft">
        <div class="leftLines" @click="showL = !showL;showR = false">
          <div :class="showL ? 'activeLeft' : ''">
            <span id="firstSpan" class="span"></span>
            <span id="secondSpan" class="span"></span>
            <span id="thirdSpan" class="span"></span>
          </div>
        </div>
      </div>
      <router-link to="/" style="all: inherit">
        <img src="/icons/teltonika_blue.svg" alt="" class="middleImage">
      </router-link>
      <div class="showHideRight" @click="showR = !showR;showL = false"/>
    </div>
    <div class="small-left-side">
      <div class="fixed-nav" :style="[!showL ? {'max-width': '0px', 'min-width': '0px'} : {}]">
        <vuci-left-side/>
      </div>
    </div>
    <div class="small-right-side" :style="[!showR ? {'max-width': '0px', 'min-width': '0px'} : {}]">
      <vuci-right-side/>
    </div>
    <div class="menu-overlay" :style="[showR || showL ? {'visibility': 'visible', 'opacity': '0.6'} : {}]" @click="showR = false;showL = false"/>
  </div>
</template>
<script>
import VuciLeftSide from './VuciLeftSide.vue'
import VuciRightSide from './VuciRightSide.vue'
export default {
  data () {
    return {
      showL: false,
      showR: false
    }
  },
  components: {
    VuciLeftSide,
    VuciRightSide
  }
}
</script>
<style>
.small-page-header {
  z-index: 2;
  position: fixed;
  background: #fff;
  border: unset;
  border-bottom: 1px solid #e4e4e4;
  top: 0;
  left: 0;
  height: 76px;
  width: 100%;
}
.small-header {
  height: 100%;
  display: flex;
  position: relative;
  justify-content: space-between;
}
.showHideLeft {
  display: flex;
  width: 76px;
}
.leftLines {
  margin: auto;
}
.span {
  background: #0054a6;
  display: block;
  width: 30px;
  height: 3px;
  border-radius: 5px;
  margin-bottom: 5px;
  transition: all .2s linear;
}
.activeLeft .span:first-child {
  transform: translateY(5px) rotate(-45deg) scalex(1.3);
}
.activeLeft .span:nth-child(2) {
  height: 0;
  transition: all .05s linear;
}
.activeLeft .span:nth-child(3) {
  transform: translateY(-3px) rotate(45deg) scalex(1.3);
}
.middleImage {
  height: 31px;
  margin-top: auto;
  margin-bottom: auto;
}
.showHideRight {
  width: 76px;
  transform: rotate(90deg);
  display: block;
}
.showHideRight::after {
  content: "...";
  color: #0054a6;
  font-size: 46px;
  height: 100%;
  width: 100%;
  display: inline-block;
  line-height: 46px;
  text-align: center;
  vertical-align: middle;
}
.small-left-side {
  position: absolute;
  width: 100vw;
  max-width: 0px;
  z-index: 1;
  min-height: 100%;
  display: flex;
}
.fixed-nav {
  height: calc(100vh - 76px);
  overflow: hidden;
  position: absolute;
  min-width: 350px;
  max-width: 350px;
  transition: max-width .3s ease-in, min-width .3s ease-in;
  display: flex;
  top: 0;
}
.small-right-side {
  z-index: 1;
  transition: max-width .3s ease-in, min-width .3s ease-in;
  position: absolute;
  right: 0;
  justify-content: space-between;
  display: flex;
  height: calc(100vh - 76px);
  min-width: 300px;
  max-width: 300px;
  background: #f7f7f7;
}
.menu-overlay {
  transition: visibility .3s linear,opacity .3s linear;
  visibility: hidden;
  background: #000;
  opacity: 0;
  width: 100vw;
  height: 100vh;
  display: block;
}
@media only screen and (max-width: 1100px) {
}
</style>
