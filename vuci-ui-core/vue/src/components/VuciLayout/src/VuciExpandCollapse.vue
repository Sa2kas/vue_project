<template>
  <div class="expand-colllapse">
    <h3 class="table-title" @click="changeClass(index);hideTable(name)">
      <img :id="index" class="toggleImg" src="/icons/arrow-toggle.svg" alt="">
      {{name}}
    </h3>
    <div :id="name" class="parent">
      <slot></slot>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    index: {
      type: Number,
      required: false,
      default: 0
    },
    name: {
      type: String,
      required: true
    }
  },
  methods: {
    changeClass (index) {
      if (document.getElementById(index).className === 'toggleImg-rotated') {
        document.getElementById(index).className = 'toggleImg'
      } else {
        document.getElementById(index).className = 'toggleImg-rotated'
      }
    },
    hideTable (name) {
      if (document.getElementById(name).className === 'parent-hidden') {
        document.getElementById(name).className = 'parent'
      } else {
        document.getElementById(name).className = 'parent-hidden'
      }
    }
  }
}
</script>
<style>
 .parent {
    max-height: 3000px;
    overflow: hidden;
    transition: max-height 0.8s ease-in-out;
    display: block;
  }
  .parent-hidden {
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.4s ease-in-out;
    display: block;
  }
  .table-title {
    font-family: "Oswald",sans-serif;
    font-weight: 400;
    font-size: 18px;
    border-bottom: 1px solid #afafaf;
    color: #444;
    text-transform: uppercase;
    margin-bottom: 1.2em;
    position: relative;
    padding-bottom: 0.2em;
    display: block;
    margin-block-start: 1em;
    margin-block-end: 1em;
  }
  .toggleImg {
    margin-right: 8px;
    transition: all 0.4s;
  }
  .toggleImg-rotated {
    margin-right: 8px;
    transition: all 0.6s;
    transform: rotate(180deg);
  }
  .actionButton {
    transition: border .2s linear,color .2s linear;
    font-family: "Oswald",sans-serif;
    font-weight: 400;
    font-size: 14px;
    text-transform: uppercase;
    border: unset;
    border: 1px solid #0054a6;
    color: #0054a6;
    background-color: #fff;
    border-radius: 5px;
    padding: 0.2em 1em;
    cursor: pointer;
    letter-spacing: 0.11em;
    margin: 2px;
    flex-direction: column;
    line-height: 1.5em;
  }
  @media only screen and (max-width: 1100px) {
    .parent {
      max-height: 7000px;
    }
  }
  @media only screen and (max-width: 500px) {
    .parent {
      max-height: 11000px;
    }
  }
</style>
