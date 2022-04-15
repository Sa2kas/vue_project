<template>
<div class="processes">
  <vuci-table
      :item="item"
      :name="name"
    >
    <template v-slot:tableData="slotProps">
      <div v-if="slotProps.column.dataIndex == 'vsize_percent' || slotProps.column.dataIndex == 'cpu_percent'" class="table-data">{{slotProps.data[slotProps.column.dataIndex]}}%</div>
      <div v-else class="table-data">{{slotProps.data[slotProps.column.dataIndex]}}</div>
      <template v-if="slotProps.column.key == 'signal'">
        <button class="actionButton" @click="kill(slotProps.data['pid'], 1)">{{ $t('processes.Hang Up') }}</button>
        <button class="actionButton" @click="kill(slotProps.data['pid'], 15)">{{ $t('processes.Terminate') }}</button>
        <button class="actionButton" @click="kill(slotProps.data['pid'], 9)">{{ $t('processes.Kill immediately') }}</button>
      </template>
    </template>
    </vuci-table>
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
        { dataIndex: 'pid', title: 'PID', sorter: (a, b) => a.pid - b.pid, defaultSortOrder: 'ascend' },
        { dataIndex: 'user', title: this.$t('processes.Owner') },
        { dataIndex: 'command', title: this.$t('processes.Command') },
        { dataIndex: 'cpu_percent', title: this.$t('processes.CPU usage'), customRender: text => text + '%', sorter: (a, b) => a.cpu_percent - b.cpu_percent },
        { dataIndex: 'vsize_percent', title: this.$t('processes.Memory usage'), customRender: text => text + '%', sorter: (a, b) => a.vsize_percent - b.vsize_percent },
        { key: 'signal', title: this.$t('processes.Signal'), scopedSlots: { customRender: 'signal' }, width: 240 }
      ],
      data: [],
      loading: true,
      name: 'Processes'
    }
  },
  computed: {
    item () {
      const item = { columns: this.columns, loading: this.loading, data: this.data }
      return item
    }
  },
  methods: {
    kill (pid, signum) {
      // this.$rpc.ubus('system', 'signal', { pid, signum }).then(() => {
      this.$message.success(this.$t('Send signal to', { signum, pid }), 1)
      // })
    }
  },
  created () {
    this.$rpc.call('system', 'process_list').then(({ processes }) => {
      this.data = processes.map((p, i) => {
        p.key = i
        return p
      })
      this.loading = false
    })
  }
}
</script>
<style>
  .processes {
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
    .processes {
      border: unset;
    }
  }
</style>
