<template>
<div class="pagination">
  <ul class="buttons" v-if="totalPages > 1">
    <li class="button">
      <button type="button" @click="onClickFirstPage" :disabled="isInFirstPage">«</button>
    </li>
    <li class="button">
      <button type="button" @click="onClickPreviousPage" :disabled="isInFirstPage">‹</button>
    </li>
    <!-- jei dabartinis puslapis > 5-->
    <li class="button" v-if="currentPage > 5 && totalPages > 9">
      <button type="button" @click="onClickFirstPage">1</button>
    </li>
    <!-- jei dabartinis puslapis > 6 -->
    <li class="button" v-if="currentPage > 6 && totalPages > 9">...</li>
    <!-- prasukamas for viduriniam puslapiam matyt -->
    <li class="button" v-for="page in pages" :key="page.name">
      <button :class="{ active: isPageActive(page.name) }" type="button" @click="onClickPage(page.name)" :disabled="page.isDisabled">
        {{ page.name }}
      </button>
    </li>
    <!-- jei dabartinis puslapis 6-iais puslapiais mazesnis uz didziausia  -->
    <li class="button" v-if="currentPage < (totalPages - 5) && totalPages > 9">...</li>
    <!-- jei dabartinis puslapis 5-iais puslapiais mazesnis uz didziausia  -->
    <li class="button" v-if="currentPage < (totalPages - 4) && totalPages > 9">
      <button type="button" @click="onClickLastPage">{{totalPages}}</button>
    </li>
    <!-- Visible Buttons End -->
    <li class="button">
      <button type="button" @click="onClickNextPage" :disabled="isInLastPage">›</button>
    </li>
    <li class="button">
      <button type="button" @click="onClickLastPage" :disabled="isInLastPage">»</button>
    </li>
  </ul>
</div>
</template>
<script>
export default {
  props: {
    maxVisibleButtons: {
      type: Number,
      required: false,
      default: 5
    },
    totalPages: {
      type: Number,
      required: true
    },
    perPage: {
      type: Number,
      required: true
    },
    currentPage: {
      type: Number,
      required: true
    },
    setPerPage: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  computed: {
    startPage () {
      // jei bendrai puslapiu daugiau nei 9
      if (this.totalPages > 9) {
        // pirmam puslapyje, jei jis mazesnis uz 6
        if (this.currentPage > 0 && this.currentPage < 6) {
          return 1
        }
        // paskutiniam puslapyje
        if (this.currentPage === this.totalPages) {
          const start = this.totalPages - (this.maxVisibleButtons - 1)
          if (start <= 0) {
            return 1
          } else {
            return start
          }
        }
        // viduriniuose puslapiuose
        return this.currentPage - 4
      }
      // jei is viso puslapiu maziau nei 10
      return 1
    },
    pages () {
      const range = []
      var max = Math.min(this.startPage + this.maxVisibleButtons - 1, this.totalPages)
      // jei is viso puslapiu maziau nei 10
      if (this.totalPages < 10) {
        max = this.totalPages
      }
      for (
        let i = this.startPage;
        i <= max;
        i++
      ) {
        range.push({
          name: i,
          isDisabled: i === this.currentPage
        })
      }
      return range
    },
    isInFirstPage () {
      return this.currentPage === 1
    },
    isInLastPage () {
      return this.currentPage === this.totalPages
    }
  },
  methods: {
    onClickFirstPage () {
      this.$emit('pagechanged', 1)
      if (this.totalPages > 9) {
        this.maxVisibleButtons = 5
      }
    },
    // pakeisti esama puslapi ir
    // priklausomai nuo matomu puslapiu skaiciaus
    // ju kieki sumazinti arba padidinti
    onClickPreviousPage () {
      this.$emit('pagechanged', this.currentPage - 1)
      if (this.totalPages > 9) {
        if (this.maxVisibleButtons > 5 && this.maxVisibleButtons < 10 && (this.currentPage - 5) <= 1) {
          this.maxVisibleButtons -= 1
        }
        if (this.maxVisibleButtons < 9 && this.currentPage >= (this.totalPages - 4)) {
          this.maxVisibleButtons += 1
        }
      }
    },
    onClickPage (page) {
      this.$emit('pagechanged', page)
    },
    // pakeisti esama puslapi ir
    // priklausomai nuo matomu puslapiu skaiciaus
    // ju kieki sumazinti arba padidinti
    onClickNextPage () {
      this.$emit('pagechanged', this.currentPage + 1)
      if (this.totalPages > 9) {
        if (this.maxVisibleButtons > 4 && this.maxVisibleButtons < 9 && (this.currentPage - 5) <= 1) {
          this.maxVisibleButtons += 1
        }
        if (this.maxVisibleButtons < 10 && this.currentPage >= (this.totalPages - 4)) {
          this.maxVisibleButtons -= 1
        }
      }
    },
    onClickLastPage () {
      this.$emit('pagechanged', this.totalPages)
      if (this.totalPages > 9) {
        this.maxVisibleButtons = 5
      }
    },
    isPageActive (page) {
      return this.currentPage === page
    }
  }
}
</script>
<style>
  .pagination {
    display:block;
    text-align: center;
    font-style: normal;
    width: 100%;
  }
  ul.buttons {
    padding: 0;
    display: inline-block;
    margin: 1em;
    text-align: center;
  }
  li.button {
    font-family: "Open Sans", sans-serif;
    font-weight: 400;
    margin: 1px 0;
    display: inline-block;
    padding: 0 1px;
    color: #0054a6;
    font-style: normal;
    font-size: 18px;
  }
  li button {
    border: none;
    background: none;
    cursor: pointer;
  }
  .active {
    font-family: "Open Sans", sans-serif;
    font-weight: 600;
    font-size: 17px;
}
</style>
