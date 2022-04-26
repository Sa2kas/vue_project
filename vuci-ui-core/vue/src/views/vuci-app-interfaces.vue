<template>
  <div class="interfaces">
    <expand-collapse
      :item="item"
      :name="name"
      >
      <div class="element" v-for="(data, indexD) in item.data" :key="indexD">
        <div class="element-data">
          <span class="element-number">{{indexD + 1}}</span>
          <span class="element-title">{{data.name}}</span>
        </div>
        <div class="element-data">
          <strong>Status:</strong>
            <span v-if="data.isUp() == true" style="color: #499c6c;"> Active</span>
            <span v-else style="color: #dd4b39"> Stopped</span><br>
          <strong>IP:</strong><span> {{ data.getIp() }}</span><br/>
          <strong>Protocol:</strong><span> {{ data.getProtocol() }}</span><br/>
          <strong>MAC:</strong><span> {{ data.getDevice() ? data.getDevice().macaddr : ' -' }}</span><br/>
        </div>
        <div class="element-data">
          <strong>{{ $t('Uptime') }}:</strong><span> {{ data.isUp() ? '%t'.format(data.getUptime()) : $t('interfaces.Interface is down') }}</span><br/>
          <strong>RX:</strong><span> {{ '%mB'.format(data.getStatistics().rx_bytes) }}</span><br/>
          <strong>TX:</strong><span> {{ '%mB'.format(data.getStatistics().tx_bytes) }}</span><br/>
        </div>
        <div class="element-data">
          <button class="iconButton" @click="ifup(data.name)"><img src="/icons/play.png" alt=""></button>
          <button class="iconButton" @click="ifdown(data.name)"><img src="/icons/stop.png" alt=""></button>
          <button class="iconButton" @click="edit(data.name, data.getProtocol());showModal(data.name)"><img src="/icons/edit.png" alt=""></button>
          <a-popconfirm @confirm="del(data.name)" placement="left" :title="$t('interfaces.DelConfirm')">
            <button class="iconButton"><img src="/icons/delete.png" alt=""></button>
          </a-popconfirm>
          </div>
          <modal
            v-show="isModalVisible"
            @close="closeModal()"
            :name="modalTitle"
            >
              <vuci-form uci-config="network" @close="closeModal()" v-if="editModal && !switchProto">
              <vuci-named-section :name="editorIface" v-slot="{ s }" @change-proto="protoChanged">
                <component :is="'proto-' + proto" :uci-section="s"/>
              </vuci-named-section>
            </vuci-form>
          </modal>
        </div>
      </expand-collapse>
    <div class="end-of-elements">
      <button class="actionButton" @click="handleAdd">+ {{ $t('interfaces.Add interface') }}</button>
    </div>
    <div class="space"/>
  </div>
</template>

<script>

import NetworkBadge from './interfaces/NetworkBadge.vue'
import ProtoNone from './interfaces/proto/None.vue'
import ProtoDhcp from './interfaces/proto/Dhcp.vue'
import ProtoStatic from './interfaces/proto/Static.vue'
import ProtoPppoe from './interfaces/proto/Pppoe.vue'
export default {
  components: {
    NetworkBadge,
    ProtoNone,
    ProtoDhcp,
    ProtoStatic,
    ProtoPppoe
  },
  data () {
    return {
      interfaces: [],
      columns: [
        { key: 'network', title: this.$t('Network'), width: 140, scopedSlots: { customRender: 'network' } },
        { key: 'status', title: this.$t('Status'), scopedSlots: { customRender: 'status' } },
        { key: 'action', title: 'Actions', width: 240, scopedSlots: { customRender: 'action' } }
      ],
      editorIface: '',
      editModal: false,
      proto: null,
      switchProto: false,
      name: 'Interfaces',
      isModalVisible: false
    }
  },
  timers: {
    load: { time: 3000, autostart: true, immediate: true, repeat: true }
  },
  computed: {
    interfacesDataSource () {
      return this.interfaces.map((v, i) => {
        v.key = i
        return v
      })
    },
    modalTitle () {
      return `${this.$t('interfaces.Configure')} "${this.editorIface}"`
    },
    item () {
      const item = { columns: this.columns, data: this.interfacesDataSource }
      return item
    }
  },
  methods: {
    protoComponentName (proto) {
      if (!proto) return 'proto-none'
      return 'proto-' + proto
    },
    protoChanged (self) {
      if (!self.changed()) return

      this.$confirm({
        title: this.$t('interfaces.Switch protocol'),
        content: this.$t('interfaces.Are you sure you want to switch the protocol?'),
        onOk: () => {
          this.switchProto = true
          this.$nextTick(() => {
            this.$uci.reset()
            this.$uci.set('network', this.editorIface, 'proto', self.model)
            this.$uci.save()
            this.$uci.apply().then(() => {
              this.switchProto = false
            })
          })
        },
        onCancel: () => {
          self.reset()
        }
      })
    },
    load () {
      this.$network.load().then(() => {
        this.interfaces = this.$network.getInterfaces()
      })
    },
    ifup (name) {
      this.$rpc.ubus(`network.interface.${name}`, 'up')
    },
    ifdown (name) {
      this.$rpc.ubus(`network.interface.${name}`, 'down')
    },
    del (name) {
      this.$spin()
      this.$uci.del('network', name)
      this.$uci.save().then(() => {
        this.$uci.apply().then(() => {
          this.load()
          this.$spin(false)
        })
      })
    },
    edit (iface, proto) {
      // this.proto = this.$uci.get('network', iface, 'proto')
      this.proto = proto
      this.editorIface = iface
      this.editModal = true
    },
    add (name) {
      this.$spin()
      this.$uci.add('network', 'interface', name)
      this.$uci.save().then(() => {
        this.$uci.apply().then(() => {
          this.load()
          this.$spin(false)
        })
      })
    },
    handleAdd () {
      this.$prompt({
        title: this.$t('interfaces.Add interface'),
        placeholder: this.$t('Please input a name')
      }).then(name => {
        if (!name) return

        if (name.match(/^[a-zA-Z0-9_]+$/) === null) {
          this.$message.error(this.$t('validator.uci'))
          return
        }

        for (let i = 0; i < this.interfaces.length; i++) {
          if (this.interfaces[i].name === name) {
            this.$message.error(this.$t('Name already used'))
            return
          }
        }

        this.add(name)
      }).catch(() => {})
    },
    showModal (data) {
      this.isModalVisible = true
    },
    closeModal () {
      this.isModalVisible = false
    }
  },
  created () {
    this.load()
  }
}
</script>
<style>
  .interfaces {
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
  .element {
    border: 1.5px solid #e4e4e4;
    border-radius: 7px;
    margin-bottom: 15px;
    display: flex;
    width: 100%;
    vertical-align: middle;
  }
  .element:hover {
    border: 1.5px solid #0054a6;
  }
  .element-data {
    border-left: 1px solid #e4e4e4;
    display: block;
    position: relative;
    overflow: hidden;
    color: #444;
    padding: 10px 5px 10px 25px;
  }
  .element-data:nth-child(1) {
    border-left: none;
    width: 15%;
    min-width: 15%;
    padding: 32px 5px 5px 25px;
    font-family: "Oswald", sans-serif;
    text-transform: uppercase;
    text-align: left;
  }
  .element-data:nth-child(1) .element-number {
    all: unset;
    width: 24px;
    padding-right: 8px;
    margin-right: 8px;
    font-size: 15px;
    border-right: 1.5px solid #e4e4e4;
  }
  .element-data:nth-child(1) .element-title {
    all: unset;
    color: #0054a6;
    text-overflow: ellipsis;
    font-size: 16px;
  }
  .element-data:nth-child(2),
  .element-data:nth-child(3) {
    width: 35%;
    min-width: 35%;
    font-family: "Open Sans", sans-serif;
    font-size: 12px;
  }
  .element-data:nth-child(4) {
    align-self: center;
  }
  .iconButton {
    padding: 0;
    background: none;
    border: none;
    margin: 1px 3px;
    cursor: pointer;
  }
  .iconButton img{
    height: 24px;
    width: 24px;
  }
  .end-of-elements {
    width: 100%;
    text-align: right;
  }

  @media only screen and (max-width: 1445px) {
    .element-data:nth-child(4) {
      padding: 0px 3%;
    }
  }
  @media only screen and (max-width: 820px) {
    .element-data:nth-child(4) {
      padding: 0px 2.5%;
    }
  }
  @media only screen and (max-width: 800px) {
    .element {
      border: unset;
      border-bottom: 1.5px solid #e4e4e4;
      margin-bottom: 15px;
      display: block;
      width: 100%;
      min-width: 100%;
    }
    .element:hover {
      border: unset;
      border-bottom: 1.5px solid #e4e4e4;
    }
    .element-data {
      border-left: none;
      display: block;
      color: #444;
      padding: unset;
      padding-bottom: 5px;
      width: 100%;
      min-width: 100%;
      margin: unset;
    }
    .element-data span{
      float: right;
    }
    .element-data:nth-child(1),
    .element-data:nth-child(2),
    .element-data:nth-child(3) {
      width: 100%;
      min-width: 100%;
      line-height: 25px;
    }
    .element-data:nth-child(4) {
      padding-left: 0px;
      padding-bottom: 15px;
    }
  }
  @media only screen and (max-width: 500px) {
    .interfaces {
      border: unset;
    }
  }
</style>
