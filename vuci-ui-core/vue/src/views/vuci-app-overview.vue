<template>
  <div class="overview">
    <vuci-side-modal
    :items="items"
    :checked="checked"
    >
    <template>
      <div v-for="item in items" :key="item.id" class="element-line">
        <input
          type="checkbox"
          @click="showHideCard(item)"
          :class="item.show ? 'checked-item-input' : 'item-input'"
        />
        <label for="item" class="item-name">
          <div class="overview-element-label">{{item.title}}</div>
        </label>
      </div>
    </template>
    </vuci-side-modal>
    <div v-for="item in items" :key="item.id" class="overview-element" :style="[item.show ? {'display': 'block'} : {'display': 'none'}]"
      @dragover="newDragIndex = item.dragIndex;changePlace();"
      @dragend="savePlace()" @drag="existingIndex = item.dragIndex" @dragstart="started = true"
        >
        <vuci-card
          :style="[!(started && existingIndex == item.dragIndex) ? {'display': 'block'} : {'opacity': '40%'}]"
          :elemDragIndex="existingIndex"
          :item="item"
          :index="newDragIndex"
          :started="started"
          draggable
          >
          <template v-slot:cpu v-if="item.name === 'system'">
            <vuci-gauge title="CPU load" :percent="cpuPercentage"/>
          </template>
          <template v-slot:gauge>
            <vuci-gauge title="RAM" :percent="ramPercentage"/>
            <vuci-gauge title="FLASH" :percent="storagePercentage"/>
          </template>
          <template v-slot:events v-if="item.name === 'netEvents'">
            <div class="card-row" v-for="(event, indexE) in syslog" :key="indexE">
              <div class="card-row-title" v-if="event">
                {{event.datetime}}
              </div>
              <div class="card-row-data" v-if="event">
                {{event.msg}}
              </div>
            </div>
          </template>
          <template v-slot:events v-else-if="item.name === 'sysEvents'">
            <div class="card-row" v-for="(event, indexE) in dmesg" :key="indexE">
              <div class="card-row-title" v-if="event">
                {{new Date(event.time * 1000).toLocaleString()}}
              </div>
              <div class="card-row-data" v-if="event">
                {{event.msg}}
              </div>
            </div>
          </template>
        </vuci-card>
      </div>
    <div class="space"/>
  </div>
</template>
<script>
export default {
  data () {
    return {
      configFile: 'overview',
      overview: [],
      syslog: [],
      dmesg: [],
      interfaces: [],
      started: false,
      newDragIndex: -1,
      existingIndex: -2,
      cpuPercentage: '100',
      storagePercentage: '100',
      ramPercentage: '100',
      system: [],
      checked: [],
      items: [
        {
          name: 'system',
          title: 'System',
          columns: [
            { title: 'Router uptime', data: this.interfaces },
            { title: 'Local device time', data: '' },
            { title: 'Memory usage', data: '' },
            { title: 'Firmware version', data: '' }
          ],
          dragIndex: 0,
          id: 0,
          show: true
        },
        {
          name: 'lan',
          title: 'Lan',
          columns: [
            { title: 'Type', data: '' },
            { title: 'IP address', data: '' }
          ],
          dragIndex: 1,
          id: 1,
          show: true
        },
        {
          name: 'wan',
          title: 'Wan',
          columns: [
            { title: 'Type', data: '' },
            { title: 'Failover', data: '' }
          ],
          dragIndex: 2,
          id: 2,
          show: true
        },
        {
          name: 'wan6',
          title: 'Wan6',
          columns: [
            { title: 'Type', data: '' }
          ],
          dragIndex: 3,
          id: 3,
          show: true
        },
        {
          name: 'sysEvents',
          title: 'Recent system events',
          columns: [
            { title: 'Date', data: '' },
            { title: 'Date', data: '' },
            { title: 'Date', data: '' },
            { title: 'Date', data: '' }
          ],
          dragIndex: 4,
          id: 4,
          show: true
        },
        {
          name: 'netEvents',
          title: 'Recent network events',
          columns: [
            { title: 'Date', data: '' },
            { title: 'Date', data: '' },
            { title: 'Date', data: '' },
            { title: 'Date', data: '' }
          ],
          dragIndex: 5,
          id: 5,
          show: true
        }
      ]
    }
  },
  timers: {
    update: { time: 2000, autostart: true, immediate: true, repeat: true },
    updateCpuUsage: { time: 1000, autostart: true, immediate: true, repeat: true },
    loadInterfaces: { time: 3000, autostart: true, immediate: true, repeat: true }
  },
  methods: {
    async loadFile () {
      await this.$uci.load(this.configFile)
      if (this.$uci.state.values.overview == null || this.$uci.state.values.overview.length === 0) return
      Object.values(this.$uci.state.values.overview)
        .map(v => {
          this.items.forEach(element => {
            if (element.name === v['.name']) {
              element.dragIndex = parseInt(v.order)
              element.show = typeof v.checked === 'string' ? v.checked === '1' : v.checked
            }
          })
        })
      this.items.sort((a, b) => a.dragIndex - b.dragIndex)
    },
    saveConfig () {
      this.$uci.save().then(() => {
        this.$uci.apply().then(() => {
          this.loadFile()
        })
      })
    },
    updateItem (item) {
      this.$uci.set(this.configFile, item.name, 'order', item.dragIndex)
      this.$uci.set(this.configFile, item.name, 'checked', item.show ? 1 : 0)
    },
    changePlace () {
      const existingPlace = this.items[this.existingIndex].dragIndex
      const newPlace = this.items[this.newDragIndex].dragIndex
      if (existingPlace > newPlace) {
        for (let index = 0; index < this.items.length; index++) {
          if (this.items[index].dragIndex > newPlace && this.items[index].dragIndex < existingPlace) {
            this.items[index].dragIndex += 1
          }
        }
        this.items[this.existingIndex].dragIndex = newPlace
        this.items[this.newDragIndex].dragIndex += 1
      } else if (existingPlace < newPlace) {
        for (let index = 0; index < this.items.length; index++) {
          if (this.items[index].dragIndex < newPlace && this.items[index].dragIndex > existingPlace) {
            this.items[index].dragIndex -= 1
          }
        }
        this.items[this.existingIndex].dragIndex = newPlace
        this.items[this.newDragIndex].dragIndex -= 1
      }
      this.items.sort((a, b) => a.dragIndex - b.dragIndex)
    },
    savePlace () {
      this.started = false
      this.existingIndex = -2
      this.newDragIndex = -1
      this.items.forEach(element => {
        this.updateItem(element)
      })
      this.saveConfig()
    },
    showHideCard (item) {
      item.show = !item.show
      this.updateItem(item)
      this.saveConfig()
    },
    updateCpuUsage () {
      this.$rpc.call('system', 'cpu_time').then(times => {
        if (!this.lastCPUTime) {
          this.cpuPercentage = '0'
          this.lastCPUTime = times
          return
        }
        const idle1 = this.lastCPUTime[3]
        const idle2 = times[3]
        let total1 = 0
        let total2 = 0
        this.lastCPUTime.forEach(t => {
          total1 += t
        })
        times.forEach(t => {
          total2 += t
        })
        this.cpuPercentage = (((total2 - total1 - (idle2 - idle1)) / (total2 - total1)) * 100).toFixed(2)
        this.lastCPUTime = times
      })
    },
    update () {
      this.$system.getInfo().then((data) => {
        this.system = data
      })
      this.items.forEach(element => {
        if (element.name === 'system') {
          this.$system.getInfo().then(({ hostname, model, system, release, kernel, localtime, uptime, memory }) => {
            element.columns[0].data = '%t'.format(uptime)
            element.columns[1].data = new Date(localtime * 1000).toLocaleString()
            this.ramPercentage = ((memory.total - memory.free) / memory.total * 100).toFixed(2)
            element.columns[2].data = 'RAM: ' + this.ramPercentage + '% FLASH: ' + this.storagePercentage + '%'
            element.columns[3].data = release.revision
          })
          this.$system.getDiskInfo().then(({ root }) => {
            this.storagePercentage = (root.used / root.total * 100).toFixed(2)
          })
        }
      })
    },
    loadInterfaces () {
      this.$network.load().then(() => {
        this.interfaces = this.$network.getInterfaces()
        this.items.forEach(element => {
          if (element.name === 'lan') {
            element.columns[0].data = this.interfaces[1].status.device
            element.columns[1].data = this.interfaces[1].getIp()
          }
          if (element.name === 'wan') {
            element.columns[0].data = this.interfaces[2].status.device
          }
          if (element.name === 'wan6') {
            element.columns[0].data = this.interfaces[3].status.device
          }
        })
      })
    }
  },
  async created () {
    await this.loadFile()
    this.$uci.set('test')
    this.saveConfig()
    if (this.$uci.state.values.overview == null || Object.keys(this.$uci.state.values.overview).length === 0) {
      this.items.map(item => {
        this.$uci.add(this.configFile, 'overview', item.name)
        this.$uci.set(this.configFile, item.name, 'order', item.dragIndex)
        this.$uci.set(this.configFile, item.name, 'checked', 1)
      })
      this.saveConfig()
    }
    this.loadInterfaces()
    this.$rpc.call('system', 'syslog').then(({ log }) => {
      this.syslog = log.map((v, i) => {
        v.key = i
        return v
      }).slice(-4)
    })
    this.$rpc.call('system', 'dmesg').then(({ log }) => {
      this.dmesg = log.map((v, i) => {
        v.key = i
        return v
      }).slice(-4)
      this.loading = false
    })
  },
  watch: {
    checked (newValue, oldValue) {
      localStorage.setItem('checked', JSON.stringify(newValue))
    }
  },
  mounted () {
    this.checked = JSON.parse(localStorage.getItem('checked')) || []
  }
}
</script>
<style>
  .overview {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
    padding: 0px 18px 28px 28px;
  }
  .overview-element {
    display: block;
    margin-bottom: 25px;
    margin-right: 1.3%;
    min-height: 290px;
    width: 23.7%;
    min-width: 300px;
  }
  .space {
    margin-left: auto;
    width: max-content;
    margin-bottom: 50px;
    margin-top: 10px;
  }
  @media (max-width: 1700px) {
    .overview-element {
      width: 32%;
    }
  }
  @media (max-width: 1400px) {
    .overview-element {
      width: 48%;
    }
  }
  @media (max-width: 800px) {
    .overview-element {
      width: 100%;
    }
  }
</style>
