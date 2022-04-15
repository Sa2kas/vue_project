<template>
  <div class="menu">
    <div class="left-menu-side">
      <!-- <div>
        <router-link to="/">home</router-link>
      </div> -->
      <div v-for="menu in menus" :key="menu.path">
        <router-link :class="menuTitle == menu.title ? 'left-sidebar-item-active' : 'left-sidebar-item'" :to="menu.children[0].children ? menu.children[0].children[0].path : menu.children[0].path">
          <div class="sidebar-menu-hided">
            <div v-for="submenu in menu.children" :key="submenu.path">
              <router-link class="menu-list-item" :style="[submenu.path == menu.children[0].path ? {'border-top': 'none'} : {}]" :to="submenu.children ? submenu.children[0].path : submenu.path">{{ $t(submenu.title) }}</router-link>
            </div>
          </div>
          <div @mouseover="focusPath = menu.path" @mouseleave="focusPath = null">
            <img class="left-sidebar-img" v-if="menuTitle == menu.title" :src="'/icons/' + menu.title.toLowerCase() + '_blue.svg'" alt="">
            <img class="left-sidebar-img" v-if="menuTitle != menu.title" :src="focusPath != menu.path ? '/icons/' + menu.title.toLowerCase() + '.svg' : '/icons/' + menu.title.toLowerCase() + '_focus.svg'" alt="">
            <div class="left-sidebar-data">
              {{ $t(menu.title)}}
            </div>
          </div>
        </router-link>
      </div>
    </div>
    <div class="right-menu-side">
      <!-- <div v-if="menuTitle == 'Home'" class="tab-title" >
        {{ menuTitle }}
      </div> -->
      <div class="right-side-title" v-for="menu in menus" :key="menu.path">
        <div v-if="menuTitle == menu.title">
          <div class="tab-title" >
            {{ menuTitle }}
          </div>
          <div class="sub-menu" v-for="submenu in menu.children" :key="submenu.path">
            <router-link :to="submenu.children ? submenu.children[0].path : submenu.path">
              <div :class="currentRoute == submenu.path || subRoute == submenu.path ? 'sub-menu-item-active' : 'sub-menu-item'">
                {{ submenu.title }}
                </div>
              <div class="sub-menu2">
                <div v-for="submenu2 in submenu.children" :key="submenu2.path">
                  <router-link :to="submenu2.path">
                    <div :class="currentRoute == submenu2.path ? 'sub2-active' : 'sub2'">
                      <div class="sub-menu2-item">
                        {{ $t(submenu2.title) }}
                      </div>
                    </div>
                  </router-link>
                </div>
              </div>
            </router-link>
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
      openKeys: [],
      selectedKeys: [],
      focusPath: null
    }
  },
  computed: {
    rootSubmenuKeys () {
      return this.menus.map(m => m.path)
    },
    ...mapState(['menus', 'hostname']),
    currentRoute () {
      return this.$route.path
    },
    menuTitle () {
      const title = this.currentRoute.split('/')[1]
      return title.charAt(0).toUpperCase() + title.slice(1)
    },
    menuTSubTitle () {
      const title = this.currentRoute.split('/')[2]
      return title
    },
    subRoute () {
      var route = this.$route.path.split('/')
      const subRoute = route.slice(0, route.length - 1).join('/')
      return subRoute
    }
  },
  watch: {
    '$route' () {
      this.updateSelection()
    }
  },
  methods: {
    updateSelection () {
      const path = this.$route.path
      if (path === '/home') {
        this.openKeys = []
        this.selectedKeys = []
        return
      }

      const paths = path.split('/')
      if (paths.length === 3) { this.openKeys = ['/' + paths[1]] } else { this.openKeys = [] }

      this.selectedKeys = [path]
    },
    onOpenChange (openKeys) {
      const latestOpenKey = openKeys.find(key => this.openKeys.indexOf(key) === -1)
      if (this.rootSubmenuKeys.indexOf(latestOpenKey) === -1) {
        this.openKeys = openKeys
      } else {
        this.openKeys = latestOpenKey ? [latestOpenKey] : []
      }
    },
    onClick (item) {
      if (item.key === this.$route.path) return
      this.$router.push(item.key)
    }
  },
  created () {
    this.$menu.load((menus, routes) => {
      this.$store.commit('setMenus', menus)
      this.$router.addRoutes(routes)
    })

    this.updateSelection()
  },
  beforeDestroy () {
    this.$store.commit('setMenus', {})
  }
}
</script>

<style>
.menu {
  min-width: 300px;
  width: max-content;
  top: 0;
  display: flex;
}
.left-menu-side {
  background: #0054a6;
  display: flex;
  flex-direction: column;
  color: #fff;
  text-align: center;
  padding-top: 171px;
  min-width: 56px;
  max-width: 56px;
}
.sidebar-menu-hided {
  color: #444;
  font-family: "Open Sans",sans-serif;
  font-size: 1.167rem;
  height: max-content;
  max-height: 55vh;
  overflow-y: auto;
  overflow-x: hidden;
  scrollbar-color: #aaa #fff;
  scrollbar-width: thin;
  display: none;
  box-shadow: 0 8px 24px rgb(149 157 165 / 20%);
  left: 56px;
  position: absolute;
  background: #fff;
  border-radius: 7px;
  border: 1px solid #e4e4e4;
  z-index: 1000;
  list-style-type: none;
  width: 155px;
  padding: 5px 10px;
}
.menu-list-item {
  text-align: left;
  padding: 5px;
  display: block;
  cursor: pointer;
  color: #444;
  text-transform: none;
  font-size: 14px;
  border-top: 1px solid #e4e4e4;
  font-weight: 400;
}
.menu-list-item:hover {
  color: #0054a6;
  font-weight: 600;
}
.left-sidebar-item, .left-sidebar-item-active {
  position: relative;
  padding: 7.2px;
  margin-bottom: 33.6px;
  display: block;
  opacity: 1;
  position: relative;
  text-transform: uppercase;
}
.left-sidebar-item {
  color: #f7f7f7;
  background-color: #0054a6;
}
.left-sidebar-item-active {
  color: #0054a6;
  background-color: #f7f7f7;
  cursor: default;
}
.left-sidebar-item:hover .sidebar-menu-hided {
  display: block;
}
.left-sidebar-item:hover {
  color: #f7f7f7;
  font-weight: 500;
}
.left-sidebar-item-active:hover {
  color: #0054a6;
}
.left-sidebar-item-active::before {
  border-top: 0 !important;
  left: 0;
  border-radius: 0 0 8px 0;
  top: -8px;
  content: "";
  width: 60px;
  height: 10px;
  border: 4px solid #f7f7f7;
  position: absolute;
  border-left: 0;
}
.left-sidebar-item-active::after {
  border-bottom: 0 !important;
  left: 0;
  border-radius: 0 8px 0 0;
  bottom: -8px;
  content: "";
  width: 60px;
  height: 10px;
  border: 4px solid #f7f7f7;
  position: absolute;
  border-left: 0;
}
.left-sidebar-img {
  background-position: 50%;
  background-repeat: no-repeat;
  background-size: contain;
  height: 30px;
  margin-bottom: 4px;
}
.left-sidebar-data {
  font-family: "Oswald",sans-serif;
  font-size: 11px;
  display: block;
  text-transform: uppercase;
  height: 16px;
}
.right-menu-side {
  background-color: #f7f7f7;
  padding: 171px 2.5vw;
  width: 100%;
  font-family: "Oswald",sans-serif;
  text-transform: uppercase;
}
.tab-title {
  max-width: 100%;
  color: #0054a6;
  font-size: 30px;
  text-decoration: underline;
  margin-bottom: 30px
}
.sub-menu {
  cursor: pointer;
}
.sub-menu-item {
  text-transform: uppercase;
  color: #6f6f6f;
  font-size: 18px;
  text-decoration: unset;
}
.sub-menu-item:hover {
  color: #0054a6;
}
.sub-menu-item-active {
  color: #0054a6;
  font-size: 23px;
  text-decoration: unset;
}
.sub-menu-item-active ~ .sub-menu2 {
  display: block;
}
.sub-menu2 {
  display: none;
}
.sub-menu-item:hover ~ .sub-menu2 {
  display: block;
}
.sub-menu2:hover {
  display: block;
}
.sub2-active {
  font-size: 15px;
  color: #0054a6;
  border-left: 2px solid #0054a6;
  padding-left: 10px;
}
.sub2 {
  font-size: 15px;
  color: #6f6f6f;
  border-left: 2px solid #e4e4e4;
  padding-left: 10px;
  text-decoration: unset;
}
.sub2:hover {
  color: #0054a6;
}
@media only screen and (max-width: 1100px) {

}
</style>
