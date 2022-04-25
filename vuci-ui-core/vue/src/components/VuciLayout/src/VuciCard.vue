<template>
  <div :class="!started ? 'vuci-card' : 'vuci-draggable-card'">
    <div class="vuci-card-header">
      {{item.title}}
      <div style="float: right; display: flex; text-transform: none">
        <slot name="cpu"></slot>
      </div>
    </div>
    <div class="vuci-card-body">
      <div v-if="item.title.includes('events')">
        <slot name="events"></slot>
      </div>
      <div class="card-row" v-else v-for="(column, indexC) in item.columns" :key="indexC">
        <div class="card-row-title">
          {{column.title}}
        </div>
        <div class="card-row-data">
          <slot v-if="column.title === 'Memory usage'" name="gauge"></slot>
          <span v-else>{{column.data}}</span>
        </div>
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
  .vuci-card {
    pointer-events: none;
  }
  .vuci-card-header {
    pointer-events: auto;
    cursor: grab;
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
    color: #444;
  }
  .card-row {
    border-bottom: 1px solid #e4e4e4;
    padding: 0.5em 0;
  }
  .card-row:last-child {
    border-bottom: none;
  }
  .card-row-title {
    font-family: "Oswald", sans-serif;
    text-transform: uppercase;
    font-size: 14px;
    color: #444;
  }
  .card-row-data {
    font-family: "Open Sans", sans-serif;
    font-size: 11px;
    color: #7e7e7e;
    padding-bottom: 0.1em;
  }
</style>
