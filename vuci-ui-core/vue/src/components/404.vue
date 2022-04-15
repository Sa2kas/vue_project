<template>
  <div v-if="loaded">
    <div class="page-404">
      <div class="error-404">
        <h1 class="h1-404">404</h1>
        <h2 class="h2-404">{{ $t("Page not found") }}</h2>
      </div>
      <h4 class="h4-404">{{ $t("click the button below.") }}</h4>
      <button class="button-404">
        <router-link to="/">return to home</router-link>
      </button>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      loaded: false
    }
  },
  computed: {
    menus () {
      return this.$store.state.menus
    }
  },
  beforeRouteEnter (to, from, next) {
    next((vm) => {
      if (vm.menus.length === 0) {
        vm.$menu.load((menus, routes) => {
          vm.$store.commit('setMenus', menus)
          vm.$router.addRoutes(routes)
          vm.$router.push(to.path)
        })
      } else {
        vm.loaded = true
      }
    })
  }
}
</script>
<style scoped>
.page-404 {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
  border: 1px solid #0054a6;
  border-radius: 7px;
  padding: 50px;
  max-width: calc(100vw - 50px);
  text-transform: uppercase;
  /* width: fit-content; */
  /* width: 615px; */
  /* height: 573px; */
  /* box-sizing: border-box; */
}
.error-404 {
  width: 100%;
  max-width: 520px;
  display: flex;
  align-items: center;
}
.h1-404 {
  color: #0054a6;
  font-family: "Oswald", sans-serif;
  display: block;
  width: 80%;
  font-weight: 500;
  font-size: 17em;
  letter-spacing: -0.03em;
  text-align: left;
  margin: 0;
  margin-right: 0.05em;;
}
.h2-404 {
  display: block;
  text-align: left;
  line-height: 109.7%;
  letter-spacing: -0.01em;
  color: #0054a6;
  text-transform: uppercase;
  font-family: "Oswald", sans-serif;
  font-size: 4.625em;
  font-weight: 500;
  width: 149px;
  margin: 18px 0 0 0;
  /* padding-left: 5px; */
}
.h4-404 {
  display: block;
  color: #77807f;
  font-family: "Oswald", sans-serif;
  font-size: 22px;
  font-weight: 400;
  text-transform: uppercase;
  text-align: center;
  margin: 0 0 10% 0;
}
.button-404 {
  color: #0054a6;
  padding: 0.2em 1em;
  border: 1px solid #0054a6;
  background-color: white;
  text-transform: uppercase;
  border-radius: 5px;
  letter-spacing: 0.11em;
  cursor: pointer;
  font-family: "Oswald", sans-serif;
  font-size: 1.167em;
}
.button-404 a {
  color: #0054a6;
}
  @media only screen and (max-width: 650px) {
    .h1-404 {
      width: 65%;
      font-size: 6em;
      padding-right: 20px;
      margin-right: 0;
    }
    .h2-404 {
      width: 20%;
      font-size: 1.625em;
      margin-top: 10px;
    }
    .h4-404 {
      font-size: 1.325em;
    }
  }
</style>
