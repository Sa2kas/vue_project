<template>
  <div class="ntp-general">
    <expand-collapse name="Time synchronisation">
      <form method="POST" @submit.prevent="updateTime">
        <!-- <div>
          <label for="current">
            Current system time
          </label>
        </div>
        <div>
          <span><b>{{ localTime }}</b></span>
          <button type="button" class="actionButton" @click="syncTime" role="button">SYNC WITH BROWSER</button>
          <button type="button" class="actionButton" @click="setDummyTime">DummyTime</button>
        </div>
          <div>
            <label for="timezone">Select Timezone</label>
          </div>
        <select name="timezone" @change="selectTimezone($event.target.value)">
          <option v-for="(zone, index) in $zoneinfo" :key="zone[0]" :value="index" :selected='zoneName == zone[0]'>{{ zone[0] }}</option>
        </select>
        <div>
          <button class="actionButton" type="submit">Save & Apply</button>
        </div> -->
        <div class="current-time">
          <div class="ntp-general-title">
            <div>
              Current system time
            </div>
          </div>
          <div class="ntp-general-data">
            <span>{{ localTime }}</span>
          </div>
        </div>
        <div class="ntp-general-sync">
          <div class="ntp-general-title"/>
          <div class="ntp-general-data">
            <button type="button" class="actionButton" @click="syncTime" role="button">SYNC WITH BROWSER</button>
            <button type="button" class="actionButton" @click="setDummyTime">DummyTime</button>
          </div>
        </div>
        <div class="select-time">
          <div class="ntp-general-title">
            <div>
              Time zone
            </div>
          </div>
          <div class="ntp-general-data">
            <select name="timezone" @change="selectTimezone($event.target.value)">
              <option v-for="(zone, index) in $zoneinfo" :key="zone[0]" :value="index" :selected='zoneName == zone[0]'>{{ zone[0] }}</option>
            </select>
          </div>
        </div>
      </form>
      <div class="ntp-general-actions">
        <button class="actionButton" type="submit">Save & Apply</button>
      </div>
    </expand-collapse>
  </div>
</template>
<script>
import ExpandCollapse from '../components/VuciLayout/src/VuciExpandCollapse.vue'
export default {
  components: {
    ExpandCollapse
  },
  data () {
    return {
      timezone: 'loading...',
      zoneName: '',
      initialZone: '',
      localTime: ''
    }
  },
  methods: {
    async updateTime () {
      this.$store.commit('spin', 'Setting system time')
      await this.$uci.load('system')
      this.$uci.set('system', 'system', 'timezone', this.timezone)
      this.$uci.set('system', 'system', 'zonename', this.zoneName)
      this.$uci.save().then(() => {
        this.$store.commit('spin', 'Applying timezone configuration changes')
        this.$uci.apply().then(() => {
          setTimeout(() => {
            this.initialZone = this.zoneName
            this.getTime()
            this.$store.commit('spin', false)
            this.$store.commit('spin', false)
          }, 1000)
        })
      })
    },
    syncTime () {
      const currentTime = Math.floor(Date.now() / 1000)
      this.$rpc.call('system', 'time', { time: currentTime }).then(res => {
        this.localTime = new Date(res.time * 1000).toLocaleString('lt-LT', { timeZone: this.initialZone })
      })
    },
    setDummyTime () {
      this.$rpc.call('system', 'time', { time: Date.UTC(1970, 5, 3) / 1000 }).then(res => {
        this.localTime = new Date(res.time * 1000).toLocaleString('lt-LT', { timeZone: this.initialZone })
      })
    },
    selectTimezone (i) {
      this.timezone = this.$zoneinfo[i][1]
      this.zoneName = this.$zoneinfo[i][0]
    },
    getTime () {
      this.$rpc.call('system', 'time').then(response => {
        this.localTime = new Date(response.time * 1000).toLocaleString('lt-LT', { timeZone: this.initialZone })
      })
    }
  },
  created () {
    this.$uci.load('system').then(res => {
      this.timezone = this.$uci.get('system', 'system', 'timezone')
      this.zoneName = this.$uci.get('system', 'system', 'zonename')
      this.initialZone = this.zoneName
      this.getTime()
    })
    setInterval(() => {
      this.getTime()
    }, 5000)
  }
}
</script>

<style scoped>
  .ntp-general {
    border: 1px solid #e4e4e4;
    border-radius: 7px;
    padding: 10px 38px 38px 38px;
    font-family: "Open Sans", sans-serif;
    font-size: 12px;
  }
  .current-time {
    margin-bottom: 20px;
    display: flex;
    justify-content: flex-end;
  }
  .ntp-general-title {
    width: 35%;
    display: flex;
    align-items: center;
    flex-direction: row-reverse;
    text-align: right;
  }
  .ntp-general-title div {
    position: relative;
    padding-right: 1rem;
  }
  .ntp-general-data {
    display: flex;
    width: 65%;
    flex-grow: 1;
    position: relative;
  }
  .ntp-general-data select {
    max-width: 300px;
    width: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    color: #444;
    background-color: #fff;
    border: 1px solid #a7a7a7;
    font-size: 11px;
    padding: 5.5px 24px 5.5px 11px;
    border-radius: 7px;
    outline: unset;
  }
  .ntp-general-sync {
    margin-bottom: 20px;
    display: flex;
    justify-content: flex-end;
  }
  .select-time {
    margin-bottom: 20px;
    display: flex;
    justify-content: flex-end;
  }
  .ntp-general-actions {
    float: right;
  }
  .space {
    margin-left: auto;
    width: max-content;
    margin-bottom: 50px;
    margin-top: 10px;
  }
  @media only screen and (max-width: 500px) {
    .ntp-general {
      border: unset;
    }
  }
</style>
