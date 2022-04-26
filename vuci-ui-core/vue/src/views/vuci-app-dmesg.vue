<template>
  <div class="kernel-log">
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
export default {
  data () {
    return {
      columns: [
        { dataIndex: 'time', title: this.$t('dmesg.Time') },
        { dataIndex: 'msg', title: 'Message' }
      ],
      loading: true,
      dmesg: [],
      search: '',
      name: 'Kernel log'
    }
  },
  computed: {
    dataSource () {
      return this.dmesg.filter(log => !this.search || log.msg.includes(this.search))
    },
    item () {
      const item = { columns: this.columns, loading: this.loading, data: this.dataSource }
      return item
    }
  },
  created () {
    this.$rpc.call('system', 'dmesg').then(({ log }) => {
      this.dmesg = log.map((v, i) => {
        v.key = i
        return v
      })
      this.loading = false
    })
  },
  methods: {
    getSearchedData (search) {
      this.search = search
    }
  }
}
</script>
<style>
  .kernel-log {
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
    .kernel-log {
      border: unset;
    }
  }
</style>
