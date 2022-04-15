<template>
  <div class="overview">
    <div v-for="item in items" :key="item.id" class="element"
    @dragover="naujas = item.dragIndex;changePlace();"
      @dragend="started = false; esamas = -2; naujas = -1" @drag="esamas = item.dragIndex" @dragstart="started = true"
        >
        <vuci-card
          :style="[!(started && esamas == item.dragIndex) ? {'display': 'block'} : {'opacity': '40%'}]"
          :elemId="esamas"
          :item="item"
          :index="naujas"
          :started="started"
          @refList="sort"
          draggable
          >
        </vuci-card>
      </div>
    <div class="space"/>
  </div>
</template>
<script>
import VuciCard from '../components/VuciLayout/src/VuciCard.vue'
export default {
  components: {
    VuciCard
  },
  data () {
    return {
      started: false,
      naujas: -1,
      esamas: -2,
      items: [
        {
          name: 'pirmas',
          columns: [
            { dataIndex: 'ipaddr', title: this.$t('IPv4-Address') },
            { dataIndex: 'macaddr', title: this.$t('MAC-Address') },
            { dataIndex: 'device', title: this.$t('active-routes.Device') }
          ],
          dragIndex: 0,
          id: 0
        },
        {
          name: 'antras',
          columns: [
            { dataIndex: 'ipaddr', title: this.$t('IPv4-Address') },
            { dataIndex: 'macaddr', title: this.$t('MAC-Address') },
            { dataIndex: 'device', title: this.$t('active-routes.Device') }
          ],
          dragIndex: 1,
          id: 1
        },
        {
          name: 'trecias',
          columns: [
            { dataIndex: 'ipaddr', title: this.$t('IPv4-Address') },
            { dataIndex: 'macaddr', title: this.$t('MAC-Address') },
            { dataIndex: 'device', title: this.$t('active-routes.Device') }
          ],
          dragIndex: 2,
          id: 2
        },
        {
          name: 'ketvirtas',
          columns: [
            { dataIndex: 'ipaddr', title: this.$t('IPv4-Address') },
            { dataIndex: 'macaddr', title: this.$t('MAC-Address') },
            { dataIndex: 'device', title: this.$t('active-routes.Device') }
          ],
          dragIndex: 3,
          id: 3
        }
      ]
    }
  },
  methods: {
    changePlace () {
      // this.items.sort((a, b) => a.dragIndex - b.dragIndex)
      if (this.items[this.esamas].dragIndex > this.items[this.naujas].dragIndex) {
        for (let index = 0; index < this.items.length; index++) {
          if (this.items[index].dragIndex > this.items[this.naujas].dragIndex && this.items[index].dragIndex < this.items[this.esamas].dragIndex) {
            this.items[index].dragIndex += 1
          }
        }
        this.items[this.esamas].dragIndex = this.items[this.naujas].dragIndex
        this.items[this.naujas].dragIndex += 1
      } else if (this.items[this.esamas].dragIndex < this.items[this.naujas].dragIndex) {
        for (let index = 0; index < this.items.length; index++) {
          if (this.items[index].dragIndex < this.items[this.naujas].dragIndex && this.items[index].dragIndex > this.items[this.esamas].dragIndex) {
            this.items[index].dragIndex -= 1
          }
        }
        this.items[this.esamas].dragIndex = this.items[this.naujas].dragIndex
        this.items[this.naujas].dragIndex -= 1
      }
      this.items.sort((a, b) => a.dragIndex - b.dragIndex)
      // this.naujas = -1
      // this.esamas = -2
    }
  }
}
</script>
<style>
  .overview {
    display: flex;
    flex-wrap: wrap;
    padding: 0px 18px 28px 28px;
  }
  .element {
    display: block;
    height: 300px;
    min-width: 340px;
    max-width: 100vw;
    margin: 10px 10px 15px 10px;
  }
  .space {
    margin-left: auto;
    width: max-content;
    margin-bottom: 50px;
    margin-top: 10px;
  }
  @media only screen and (max-width: 1100px) {
    .overview {
      padding-left: 8%;
      /* cursor: grab; */
    }
  }
</style>
