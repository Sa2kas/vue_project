<template>
  <div class="active-routes">
    <div v-for="(item, name, index) in items" :key="index">
      <vuci-table
        :item="item"
        :name="name"
        :index="index"
      />
    </div>
    <div class="space"/>
  </div>
</template>

<script>
import VuciTable from '../components/VuciLayout/src/VuciTable.vue'
export default {
  components: {
    VuciTable
  },
  data () {
    return {
      items: {
        arp: {
          columns: [
            { dataIndex: 'ipaddr', title: this.$t('IPv4-Address') },
            { dataIndex: 'macaddr', title: this.$t('MAC-Address') },
            { dataIndex: 'device', title: this.$t('active-routes.Device') }
          ],
          data: [],
          loading: true
        },
        routes: {
          columns: [
            { dataIndex: 'target', title: this.$t('active-routes.Target') },
            { dataIndex: 'nexthop', title: this.$t('active-routes.Nexthop') },
            { dataIndex: 'metric', title: this.$t('active-routes.Metric') },
            { dataIndex: 'device', title: this.$t('active-routes.Device') }
          ],
          data: [],
          loading: true
        },
        routes6: {
          columns: [
            { dataIndex: 'target', title: this.$t('active-routes.Target') },
            { dataIndex: 'source', title: this.$t('active-routes.Source') },
            { dataIndex: 'nexthop', title: this.$t('active-routes.Nexthop') },
            { dataIndex: 'metric', title: this.$t('active-routes.Metric') },
            { dataIndex: 'device', title: this.$t('active-routes.Device') }
          ],
          data: [],
          loading: true
        }
      }
    }
  },
  created () {
    this.$rpc.call('network', 'arp_table').then(({ entries }) => {
      this.items.arp.data = entries.map((v, i) => {
        v.key = i
        return v
      })
      this.items.arp.loading = false
    })

    this.$rpc.call('network', 'routes').then(({ routes }) => {
      this.items.routes.data = routes.map((v, i) => {
        v.key = i
        return v
      })
      this.items.routes.loading = false
    })

    this.$rpc.call('network', 'routes6').then(({ routes }) => {
      this.items.routes6.data = routes.map((v, i) => {
        v.key = i
        return v
      })
      this.items.routes6.loading = false
    })
  }
}
</script>
<style>
  .active-routes {
    border: 1px solid #e4e4e4;
    border-radius: 7px;
    padding: 10px 38px 38px 38px;
  }
  .space {
    margin-left: auto;
    width: max-content;
    margin-bottom: 50px;
    margin-top: 10px;
  }
  @media only screen and (max-width: 500px) {
    .active-routes {
      border: unset;
    }
  }
</style>
