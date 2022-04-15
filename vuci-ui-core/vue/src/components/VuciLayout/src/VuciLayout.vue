<template>
  <div class="page">
    <!-- naudojamas kai mazesnis ekranas -->
    <div class="page-header">
      <vuci-header-2/>
    </div>
    <div class="page-body">
      <div class="page-left-side">
        <vuci-left-side/>
      </div>
      <!-- naudojamas kai ekranas didesnis -->
      <div class="page-content">
        <div class="content-header">
          <vuci-header/>
        </div>
        <div class="content-body">
          <transition name="main" mode="out-in">
            <router-view></router-view>
          </transition>
        </div>
      </div>
    </div>
    <div class="page-footer">
      <vuci-footer/>
    </div>
  </div>
</template>
<script>
import VuciLeftSide from './VuciLeftSide.vue'
import VuciHeader from './VuciHeader.vue'
import VuciHeader2 from './VuciHeader2.vue'
import VuciFooter from './VuciFooter.vue'

export default {
  components: {
    VuciLeftSide,
    VuciHeader,
    VuciHeader2,
    VuciFooter
  },
  computed: {
    hostname () {
      return this.$store.state.hostname
    }
  },
  watch: {
    hostname () {
      document.title = this.hostname + ' - vuci'
    }
  },
  created () {
    this.$system.getBoardInfo().then(r => {
      this.$store.commit('setHostname', r.hostname)
    })
  }
}
</script>

<style>
.page {
  flex-direction: column;
  display: flex;
}
.page-header {
  display: none;
}
.page-body {
  flex-direction: row;
  display: flex;
  min-height: calc(100vh - 40px);
}
.page-left-side {
  min-height: 100%;
  display: flex;
}
.page-content {
  padding: 0 16px 16px;
  width: calc(100vw - 300px);
  max-width: 100%;
}
.content-header {
  margin-bottom: 60px;
  width: 100%;
  margin-left: auto;
  margin-right: 300px;
  padding-right: 1em;
  padding-left: 1em;
  border-bottom: 1px solid #e4e4e4;
}
.content-body {
  padding: 5px;
  background-color: #fff;
}
.page-footer {
  border: unset;
  border-top: 1px solid #e4e4e4;
}
@media only screen and (max-width: 1100px) {
  .page-left-side {
    display: none;
  }
  .content-header {
    display: none;
  }
  .page-header {
    display: unset;
  }
  .page-body {
  margin-top: 76px;
  }
  .page-content {
    width: 100vw;
  }
}
@media only screen and (max-width: 500px) {
  .page-content {
    padding: unset;
  }
}
</style>
