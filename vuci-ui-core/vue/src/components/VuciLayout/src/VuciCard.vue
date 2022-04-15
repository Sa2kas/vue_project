<template>
  <div :class="!started ? 'vuci-card' : 'vuci-draggable-card'">
    <div class="vuci-card-header">
      {{item.name}}
    </div>
    <div class="vuci-card-body">
      <div class="card-row" v-for="(column, indexC) in item.columns" :key="indexC">
        <div class="card-row-title">
          {{column.title}}
        </div>
        <div class="card-row-data"></div>
      </div>
      <slot></slot>
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
    item: {
      type: Object,
      required: true
    },
    index: {
      type: Number,
      required: false,
      default: 0
    },
    elemDragIndex: {
      type: Number,
      required: false,
      default: 0
    },
    started: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  methods: {
    refreshList () {
      this.$emit('refList')
    }
  },
  watch: {
    index (newIndex, oldIndex) {
      if (this.item.id === this.elemDragIndex) {
        // this.item.dragIndex = newIndex
        // this.refreshList()
      }
    }
  }
}
</script>
<style>
  .vuci-card, .vuci-draggable-card {
    width: 100%;
    height: 100%;
    padding: 20px 15px;
    border: 1px solid #e4e4e4;
    border-radius: 7px;
  }
  .vuci-card:hover {
    border: 1px solid #0054a6;
  }
  .vuci-card:hover .vuci-card-header{
    border-bottom: 1px solid #0054a6;
  }
  .vuci-card-header {
    font-family: "Oswald", sans-serif;
    text-transform: uppercase;
    font-size: 18px;
    padding-bottom: 5px;
    border-bottom: 1px solid #a7a7a7;
  }
  .vuci-card-body {

  }
  .card-row {

  }
  .card-row-title {

  }
  .card-row-data {

  }
</style>
