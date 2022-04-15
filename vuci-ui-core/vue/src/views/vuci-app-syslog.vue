<template>
  <div class="system-log">
    <vuci-table
      :item="item"
      :name="name"
      :showHeader="true"
      @clicked="getSearchedData"
    />
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
      columns: [
        { dataIndex: 'datetime', title: this.$t('syslog.Datetime'), width: 220 },
        { dataIndex: 'facility', title: this.$t('syslog.Facility'), width: 100 },
        { dataIndex: 'level', title: this.$t('syslog.Level'), width: 100 },
        { dataIndex: 'msg', title: 'Message' }
      ],
      loading: true,
      syslog: [],
      search: '',
      name: 'Events'
    }
  },
  computed: {
    dataSource () {
      return this.syslog.filter(log => !this.search || log.msg.includes(this.search))
    },
    item () {
      const item = { columns: this.columns, loading: this.loading, data: this.dataSource }
      return item
    }
  },
  methods: {
    getSearchedData (search) {
      this.search = search
    }
  },
  created () {
    this.$rpc.call('system', 'syslog').then(({ log }) => {
      this.syslog = log.map((v, i) => {
        v.key = i
        return v
      })
      this.loading = false
    })
  }
}
</script>
<style>
  .system-log {
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
    .system-log {
      border: unset;
    }
  }
</style>
