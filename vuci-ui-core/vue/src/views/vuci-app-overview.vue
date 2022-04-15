<template>
  <div class="overview">
    <div v-for="item in items" :key="item.id" class="element"
    @dragover="newDragIndex = item.dragIndex;changePlace();"
      @dragend="started = false; existingIndex = -2; newDragIndex = -1" @drag="existingIndex = item.dragIndex" @dragstart="started = true"
        >
        <vuci-card
          :style="[!(started && existingIndex == item.dragIndex) ? {'display': 'block'} : {'opacity': '40%'}]"
          :elemDragIndex="existingIndex"
          :item="item"
          :index="newDragIndex"
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
      newDragIndex: -1,
      existingIndex: -2,
      items: [
        {
          name: 'system',
          columns: [
            { title: 'Router uptime' },
            { title: 'Local device time' },
            { title: 'Memory usage' },
            { title: 'Firmware version' }
          ],
          dragIndex: 0,
          id: 0
        },
        {
          name: 'lan',
          columns: [
            { title: 'Type' },
            { title: 'IP address' }
          ],
          dragIndex: 1,
          id: 1
        },
        {
          name: 'wan',
          columns: [
            { title: 'Type' },
            { title: 'Failover' }
          ],
          dragIndex: 2,
          id: 2
        },
        {
          name: 'wan',
          columns: [
            { title: 'Type' }
          ],
          dragIndex: 3,
          id: 3
        },
        {
          name: 'recent system events',
          columns: [
            { title: 'Date' }
          ],
          dragIndex: 4,
          id: 4
        },
        {
          name: 'recent network events',
          columns: [
            { title: 'Date' }
          ],
          dragIndex: 5,
          id: 5
        }
      ]
    }
  },
  methods: {
    changePlace () {
      // this.items.sort((a, b) => a.dragIndex - b.dragIndex)
      if (this.items[this.existingIndex].dragIndex > this.items[this.newDragIndex].dragIndex) {
        for (let index = 0; index < this.items.length; index++) {
          if (this.items[index].dragIndex > this.items[this.newDragIndex].dragIndex && this.items[index].dragIndex < this.items[this.existingIndex].dragIndex) {
            this.items[index].dragIndex += 1
          }
        }
        this.items[this.existingIndex].dragIndex = this.items[this.newDragIndex].dragIndex
        this.items[this.newDragIndex].dragIndex += 1
      } else if (this.items[this.existingIndex].dragIndex < this.items[this.newDragIndex].dragIndex) {
        for (let index = 0; index < this.items.length; index++) {
          if (this.items[index].dragIndex < this.items[this.newDragIndex].dragIndex && this.items[index].dragIndex > this.items[this.existingIndex].dragIndex) {
            this.items[index].dragIndex -= 1
          }
        }
        this.items[this.existingIndex].dragIndex = this.items[this.newDragIndex].dragIndex
        this.items[this.newDragIndex].dragIndex -= 1
      }
      this.items.sort((a, b) => a.dragIndex - b.dragIndex)
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
