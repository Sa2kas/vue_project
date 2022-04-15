<template>
  <div id="table">
    <expand-collapse :index="index" :name="name">
      <div class="table-header" :style="[showHeader ? {'display': 'flex'} : {'display': 'none'}]">
        <div class="set-records-number">
          <div class="records-number-title">
            Events per page
          </div>
          <div id="records" class="records-number">
            <input class="choose-records-number" v-model="perPage">
            <div class="number-options">
              <ul :id="'number-options' + index">
                <li @click="perPage = 5">5</li>
                <li @click="perPage = 10">10</li>
                <li @click="perPage = 15">15</li>
                <li @click="perPage = 20">20</li>
                <li @click="perPage = 25">25</li>
              </ul>
            </div>
          </div>
        </div>
        <div class="search">
          <input @keyup="searchData" @keydown="searchData" type="text" class="search" placeholder="Search..." v-model="search">
        </div>
      </div>
      <div class="empty-table" v-if="splitedArray.length == 0">This section contains no values yet</div>
      <table id="table" class="data-table" v-else>
        <thead>
          <tr>
            <td v-for="(column, indexC) in item.columns" :key="indexC">
              <th class="th">{{column.title}}</th>
            </td>
          </tr>
        </thead>
          <tbody>
          <slot name="tableRow">
            <tr class="row-div" v-for="(data, indexD) in splitedArray[currentPage - 1]" :key="indexD">
              <td class="td" v-for="(column, indexC) in item.columns" :key="indexC">
                <div class="data-header">{{column.title}}</div>
                <slot name="tableData" v-bind:data="data" v-bind:column="column">
                  <div class="table-data">{{data[column.dataIndex]}}</div>
                </slot>
              </td>
            </tr>
          </slot>
        </tbody>
      </table>
        <div class="table-footer">
          <vuci-pagination
          :totalPages="splitedArray.length"
          :perPage="perPage"
          :currentPage="currentPage"
          @pagechanged="onPageChange"
          />
      </div>
      </expand-collapse>
    <!-- </div> -->
  </div>
</template>
<script>
import ExpandCollapse from './VuciExpandCollapse.vue'
import VuciPagination from './VuciPagination.vue'
export default {
  components: {
    VuciPagination,
    ExpandCollapse
  },
  data () {
    return {
      currentPage: 1,
      perPage: 10,
      numberOptions: false,
      search: '',
      objectArray: this.item.data
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
    name: {
      type: String,
      required: true
    },
    showHeader: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  methods: {
    onPageChange (page) {
      this.currentPage = page
    },
    showNumberOptions () {
      document.getElementById('number-options' + this.index).style.display = 'block'
    },
    hideNumberOptions () {
      document.getElementById('number-options' + this.index).style.display = 'none'
    },
    searchData () {
      this.$emit('clicked', this.search)
    }
  },
  computed: {
    splitedArray () {
      var arrayOfArrays = []
      for (var y = 0; y < this.item.data.length; y += this.perPage) {
        arrayOfArrays.push(this.item.data.slice(y, y + this.perPage))
      }
      return arrayOfArrays
    }
  }
}
</script>
<style>
  .table-header {
    /* display: none; */
    justify-content: space-between;
    font-family: "Open Sans",sans-serif;
    font-weight: 400;
    font-size: 12px;
    text-transform: none;
    height: 40px;
    padding: 6px 0;
  }
  .set-records-number {
    width: max-content;
    display: flex;
    justify-content: flex-end;
    vertical-align: middle;
  }
  .records-number-title {
    padding-top: 3px;
    margin-right: 5px;
    color: #444;
  }
  .choose-records-number {
    width: 50px;
    border: 1px solid #afafaf;
    border-radius: 7px;
    position: relative;
    flex-grow: 1;
    margin-left: 5px;
    height: 27px;
    background-image: url(/icons/arrow_down.svg);
    background-repeat: no-repeat;
    background-size: 12px 8px;
    appearance: none;
    padding: 2px 24px 2px 5px;
    background-position: center right 7px;
    cursor: pointer;
    color: #000;
    display: flex;
    flex-direction: column;
    justify-content: center;
    /* tas mirksintis cursorius */
    caret-color: transparent;
  }
  .choose-records-number:focus + .number-options{
    display: block;
  }
  .number-options:hover {
    display: block;
  }
  .number-options {
    width: 50px;
    position: relative;
    display: none;
  }
  .number-options ul {
    border: 1px solid #e4e4e4;
    box-shadow: 0 10px 5px 0 rgb(0 0 0 / 25%);
    width: 50px;
    padding-left: 0;
    max-height: 200px;
    overflow: auto;
    position: absolute;
    left: 5px;
    z-index: 1;
    background-color: #fff;
  }
  .number-options li {
    color: #444;
    font-family: "Open Sans",sans-serif;
    font-weight: 400;
    font-size: 11px;
    text-transform: none;
    list-style: none;
    text-align: left;
    padding: 0.3em 1em;
    cursor: pointer;
  }
  .number-options li:hover {
    border-left: 3px solid #0054a6;
    color: #0054a6;
  }
  div.search {
    position: relative;
    flex-grow: 1;
    justify-content: flex-end;
  }
  input.search {
    width: 100%;
    max-width: 175px;
    border: 1px solid #afafaf;
    border-radius: 7px;
    transition: border .2s linear,box-shadow .2s linear;
    position: relative;
    display: flex;
    float: right;
    font-size: 11px;
    padding: 0.5em 1em;
    height: 27px;
  }
  input:focus {
    outline: none;
    box-shadow: 0px 0px 5px rgba(24, 143, 255, 0.5);
    border: 1.5px solid rgba(24, 143, 255, 0.5);
    transition: 0.2s;
  }
  input:hover {
    all: none;
  }
  .data-table {
    cursor: default;
    border-collapse: collapse;
    width: 100%;
    display: table;
    text-indent: initial;
    border-spacing: 2px;
    border-color: grey;
    color: #444;
    font-family: "Open Sans", sans-serif;
    font-size: 12px;
  }
  .th {
    font-family: "Oswald",sans-serif;
    font-weight: 400;
    font-size: 15px;
    text-transform: uppercase;
    padding: 8px;
    text-align: left;
    position: relative;
    color: #444;
    display: table-cell;
    vertical-align: inherit;
  }
  .td {
    padding: 8px;
    padding-left: 16px;
  }
  .data-header {
    display: none;
  }
  .table-data {
    min-width: 60px;
  }
  .row-div {
    border: unset;
    border-top: 1px solid #e4e4e4;
    width: 100%;
  }
  .row-div:hover {
    background-color: #f7f7f7;
  }
  .empty-table {
    padding: 8px;
    font-family: "Open Sans", sans-serif;
    font-size: 12px;
    font-weight: 400;
    color: #444;
  }
  .empty-table:hover {
    background-color: #f7f7f7;
  }
  .table-footer {
    display: block;
  }
  @media only screen and (max-width: 1100px) {
    thead {
      display: none;
    }
    tbody {
      width: 100%;
    }
    .row-div {
      border: unset;
      border-top: 1px solid #e4e4e4;
      display: flex;
      flex-direction: column;
    }
    .row-div:nth-child(1) {
      border-top: none;
    }
    .td {
      display: flex;
      justify-content: space-between;
      padding: 8px;
    }
    .data-header {
      display: block;
      margin-right: 25%;
    }
    .table-title {
      font-size: 15.6px;
    }
  }
  @media only screen and (max-width: 500px) {
    .row-div, .row-div:nth-child(1) {
      border-radius: 7px;
      border: 1px solid #e4e4e4;
      margin-top: 15px;
    }
    .td {
      border: unset;
      border-top: 1px solid #e4e4e4;
      flex-direction: column;
      color: #777;
    }
    .td:nth-child(1) {
      border-top: none;
    }
    .data-header {
      color: #444;
      font-family: "Oswald", sans-serif;
      font-weight: 400;
      font-size: 13.2px;
      text-transform: uppercase;
    }
  }
</style>
