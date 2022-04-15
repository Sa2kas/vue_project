<template>
  <div class="right-side">
    <div class="links">
      <div class="links-item">
        user
        <div class="links-item-data">
          {{username}}
        </div>
      </div>
      <div class="links-item">
        fw version
        <div class="links-item-data">
          {{fw}}
        </div>
      </div>
      <div class="links-item" @click="logout">
        <div class="links-item-data">
          logout
        </div>
      </div>
    </div>
    <div class="side-line"></div>
  </div>
</template>
<script>
export default {
  data () {
    return {
      username: '',
      fw: ''
    }
  },
  timers: {
    getFW: { time: 2000, autostart: true, immediate: true, repeat: true }
  },
  methods: {
    logout () {
      this.$router.push('/login')
    },
    getFW () {
      this.$system.getInfo().then(({ release }) => { this.fw = release.revision })
    }
  },
  created () {
    this.username = this.$session.username()
  }
}
</script>
<style>
.right-side {
  justify-content: space-between;
  display: flex;
  width: 100%;
}
.links {
  margin-top: 30px;
  margin-left: 30px;
}
.links-item {
  font-family: "Oswald",sans-serif;
  font-weight: 400;
  font-size: 16px;
  text-transform: uppercase;
  cursor: pointer;
  margin-bottom: 20px;
  color: #6f6f6f;
  display: flex;
  flex-direction: column;
}
.links-item-data {
  color: #0054a6;
}
.side-line {
  background: #0054a6;
  width: 56px;
  height: 100%;
}
@media only screen and (max-width: 1100px) {

}
</style>
