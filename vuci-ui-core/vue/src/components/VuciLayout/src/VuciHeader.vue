<template>
  <div class="header">
    <router-link class="home-link" to="/">
      <img src="/icons/teltonika_blue.svg" alt="">
    </router-link>
    <div class="header-info">
      <div class="header-item">
        user
        <div class="header-item-data">
          {{username}}
        </div>
      </div>
      <div class="header-item">
        fw version
        <div class="header-item-data">
          {{fw}}
        </div>
      </div>
      <div class="header-item" id="logout" @click="logout">
        -
        <div class="header-item-data">
          <div class="logout">
            logout
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  data () {
    return {
      breadcrumbs: [],
      username: '',
      fw: ''
    }
  },
  computed: {
    selectedLangKeys () {
      return [this.lang]
    },
    ...mapState(['lang', 'fullscreen'])
  },
  timers: {
    getFW: { time: 2000, autostart: true, immediate: true, repeat: true }
  },
  methods: {
    fullScreen () {
      this.$store.commit('toggleFullscreen')
    },
    getBreadCrumbList (route) {
      const homeRoute = this.$router.options.routes.find(r => r.path === '/').children[0]
      const homeItem = { title: homeRoute.meta.title }
      const matched = route.matched

      if (matched.some(item => item.path === '/home')) {
        return [{
          title: homeRoute.meta.title,
          breadcrumbName: homeRoute.meta.title
        }]
      }

      homeItem.path = '/'

      const list = [homeItem, matched[0].meta]

      if (!matched[0].redirect) { list.push(matched[1].meta) }

      return list.map((v, i) => {
        return {
          path: v.path || '',
          breadcrumbName: i + '',
          title: v.title
        }
      })
    },
    onLangClick (item) {
      const lang = item.key
      this.$rpc.call('ui', 'set_lang', { lang: lang }).then(({ lang }) => {
        this.$store.commit('setLang', lang)
        if (lang === 'auto') { lang = navigator.language.toLowerCase() }

        if (lang === 'zh') lang = 'zh-cn'

        if (!this.$i18n.loaded(lang)) {
          this.$rpc.call('ui', 'load_locales', { locale: lang }).then(locales => {
            locales.forEach(locale => this.$i18n.mergeLocaleMessage(lang, locale))
            this.$i18n.locale = lang
          })
        } else {
          this.$i18n.locale = lang
        }
      })
    },
    onUserClick (item) {
      const action = item.key
      if (action === 'logout') {
        this.$router.push('/login')
      } else if (action === 'reboot') {
        this.$confirm({
          title: this.$t('Reboot'),
          content: this.$t('Really reboot now?'),
          onOk: () => {
            this.$system.reboot().then(() => {
              this.$reconnect(this.$t('Rebooting...'))
            })
          }
        })
      }
    },
    logout () {
      this.$router.push('/login')
    },
    getFW () {
      this.$system.getInfo().then(({ release }) => { this.fw = release.revision })
    }
  },
  watch: {
    '$route' (newRoute) {
      this.breadcrumbs = this.getBreadCrumbList(newRoute)
    }
  },
  created () {
    this.breadcrumbs = this.getBreadCrumbList(this.$route)

    this.username = this.$session.username()
  }
}
</script>
<style>
.header {
  padding-top: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.home-link {
  cursor: pointer;
}
.header-info {
  font-family: "Oswald",sans-serif;
  font-weight: 400;
  font-size: 16px;
  display: flex;
  color: #0054a6;
  text-transform: uppercase;
}
.header-item {
  padding: 10px;
  color: #6f6f6f;
  font-size: 14px;
  text-decoration: none;
  cursor: pointer;
  display: block;
}
.header-item-data {
  color: #0054a6;
  font-size: 16px;
  display: block;
}
#logout {
  color: #ffffff;
}
.logout {
  background-image: url(/icons/logout.png);
  background-repeat: no-repeat;
  background-position: right 4px;
  padding-right: 1.5em;
  background-color: transparent;
}
</style>
