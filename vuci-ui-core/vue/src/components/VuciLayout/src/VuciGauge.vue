<template>
  <div class="gauge">
    <div class="gauge-title">
      {{title + ' (' + percent + '%)'}}
    </div>
    <div class="meter-gauge">
      <div class="meter-gauge-progress" :style="{'width' : percent + 'px'}"/>
    </div>
  </div>
</template>
<script>
export default {
  data () {
    return {
    }
  },
  props: {
    title: {
      type: String,
      required: false,
      default: ''
    },
    percent: {
      type: String,
      required: false,
      default: ''
    }
  }
}
</script>
<style>
.gauge {
  display: inline-block;
  position: relative;
  margin-right: 5px;
}
.gauge-title {
  font-family: "Open Sans",sans-serif;
  font-weight: 400;
  font-size: 13px;
  color: #0054a6;
}
.meter-gauge {
  width: 100px;
  box-shadow: 0 0 5px rgba(0,0,0,0.2);
  border-radius: 5px;
  height: 7px;
  position: relative;
  display: block;
}
.meter-gauge-progress {
  height: inherit;
  display: block;
  background: none;
  background-color: #0054a6;
  border-radius: 5px;
}
</style>
