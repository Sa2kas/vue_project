<template>
<!-- šiek tiek modifikuotas "Ant Design Vue" ir pakeista dalis elementų-->
  <component :is="container" :title="title">
    <vuci-table v-if="columns"
    :item="item"
    :name="title"
    :index="index">
      <template v-slot:tableData="slotProps">
        <span v-if="slotProps.column.dataIndex != '.name'">
          <slot :name="slotProps.column.dataIndex" :s="slotProps.data">
            {{slotProps.column.dataIndex}} <br/>
            {{slotProps.data}}
          </slot>
         </span>
        <span v-else>
          <a-button v-if="sortable" size="small" type="primary" style="margin-right: 5px" @click="handleSort(sid, -1)" icon="arrow-up"/>
          <a-button v-if="sortable" size="small" type="primary" style="margin-right: 5px" @click="handleSort(sid, 1)" icon="arrow-down"/>
          <button class="iconButton" v-if="addremove" @click="delSection(slotProps.data['.name'])">
            <img src="/icons/delete.png" alt="" style="height: 24px;">
          </button>
        </span>
      </template>
    </vuci-table>
    <template v-else-if="collapsible">
      <a-collapse v-model="collapse" :accordion="accordion">
        <a-collapse-panel v-for="s in sections" :key="s['.name']">
          <template #header>
            <span>{{ renderTeasers(s['.name']) }}</span>
          </template>
          <template #extra>
            <a-tooltip :title="$t('Delete')">
              <a-icon type="delete" style="color: red" @click.prevent="delSection(s['.name'])" />
            </a-tooltip>
          </template>
          <slot :s="s"/>
        </a-collapse-panel>
      </a-collapse>
    </template>
    <template v-else>
      <div :class="showBorder == true ? 'element' : ''" v-for="(s, i) in sections" :key="s['.name']">
        <vuci-typed-section-body :sid="s['.name']">
          <slot :s="s"/>
        </vuci-typed-section-body>
        <a-divider v-if="i < sections.length - 1"/>
      </div>
      <span v-if="sections.length <= 0" style="color: #444;">
        This section contains no values yet <br/>
      </span>
    </template>
    <button v-if="addremove" class="actionButton" @click="handleAdd">{{ $t('Add') }}</button>
  </component>
</template>

<script>
import VuciSection from './VuciSection.vue'
import VuciTypedSectionBody from './VuciTypedSectionBody.vue'
import VuciTable from '../../VuciLayout/src/VuciTable.vue'

export default {
  name: 'VuciTypedSection',
  mixins: [VuciSection],
  props: {
    showBorder: {
      type: Boolean,
      default: false,
      required: false
    },
    index: {
      type: Number,
      required: false,
      dafault: 0
    },
    type: {
      type: String,
      required: true
    },
    columns: Array,
    anonymous: {
      type: Boolean,
      default: true
    },
    addremove: Boolean,
    collapsible: {
      type: Boolean,
      default: true
    },
    teasers: Array,
    add: Function,
    sortable: Boolean,
    expanded: Boolean,
    filter: Function
  },
  components: {
    VuciTypedSectionBody,
    VuciTable
  },
  data () {
    return {
      accordion: false,
      collapse: [],
      sections: []
    }
  },
  computed: {
    dataSource () {
      return this.sections.map((v, i) => {
        v.key = i
        return v
      })
    },
    tableColumns () {
      const columns = []
      this.columns.forEach(c => {
        columns.push({
          dataIndex: c.name,
          title: c.label,
          slots: { title: c.titleSlot },
          width: c.width,
          scopedSlots: { customRender: c.name }
        })
      })

      let actionWidth = 0
      if (this.addremove) actionWidth += 60
      if (this.sortable) actionWidth += 80

      if (actionWidth > 0) {
        columns.push({
          dataIndex: '.name',
          width: actionWidth,
          scopedSlots: { customRender: 'vuci-form-table-action' }
        })
      }

      return columns
    },
    item () {
      const item = { columns: this.tableColumns, data: this.dataSource }
      return item
    }
  },
  methods: {
    updateCollapse (sid) {
      if (this.collapsible) {
        this.collapse = sid
      }
    },
    renderTeasers (sid) {
      return Object.values(this.vuciForm.fields).filter(f => {
        if (this.teasers && this.teasers.indexOf(f.name) === -1) return false
        return f.sid === sid
      }).map(f => {
        let value = f.model
        if (typeof value === 'undefined') { value = '' }
        return `${f.label}: ${value}`
      }).join('| ')
    },
    handleSort (sid, pos) {
      const sids = this.sections.map(s => s['.name'])
      let index = sids.indexOf(sid)

      index += pos

      if (index < 0 || index === sids.length) return

      const nsid = sids[index]

      this.$uci.swap(this.config, sid, nsid)
      this.load()
    },
    delSection (sid) {
      this.$uci.del(this.config, sid)
      this.load()
      if (this.collapsible && this.sections.length > 0) {
        this.collapse = this.sections[0]['.name']
      } else {
        this.collapse = null
      }
    },
    addSectionPost (sid) {
      this.load()
      this.updateCollapse(sid)
    },
    addSection (name) {
      const sid = this.$uci.add(this.config, this.type, name)
      return sid
    },
    handleAdd () {
      if (this.add) {
        this.addSectionPost(this.add(this))
        return
      }

      if (this.anonymous) {
        this.addSectionPost(this.addSection())
        return
      }

      this.$prompt({
        title: this.$t('Add'),
        placeholder: this.$t('Please input a name'),
        validator: value => {
          if (value.match(/^[a-zA-Z0-9_]+$/) === null) {
            return this.$t('validator.uci')
          }

          if (this.sections.filter(s => s['.name'] === value).length > 0) {
            return this.$t('Name already used')
          }
        }
      }).then(value => {
        this.addSectionPost(this.addSection())
      }).catch(() => {})
    },
    load () {
      this.sections = this.$uci.sections(this.config, this.type).filter(s => this.filter ? this.filter(s) : true)
    }
  },
  watch: {
    loaded () {
      this.load()
      if (this.collapsible && this.sections.length > 0) {
        this.collapse = this.sections.map(s => s['.name'])
        this.$nextTick(() => {
          this.accordion = true
        })
      }
    }
  }
}
</script>
<style scoped>
  .element {
    border: 1px solid #e4e4e4;
    border-radius: 7px;
    padding: 10px 38px 38px 38px;
    margin-bottom: 5px;
  }
  @media only screen and (max-width: 500px) {
    .element {
      border: unset;
    }
  }
</style>
