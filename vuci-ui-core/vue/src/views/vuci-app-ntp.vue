<template>
  <div class="ntp-ntp">
    <expand-collapse index=0 name="NTP Client">
      <form class="section-body" >
        <div class="field">
          <label class="field-label" for="enable">Enable NTP Client</label>
          <div class="field-input">
            <label class="switch">
              <input v-model="ntpClient.enabled" type="checkbox">
              <span class="slider round"></span>
            </label>
          </div>
        </div>
        <div class="field">
          <label class="field-label" for="enable">Force Servers</label>
          <div class="field-input">
            <label class="switch">
              <input v-model="ntpClient.forceServers" type="checkbox">
              <span class="slider round"></span>
            </label>
          </div>
        </div>
        <div class="field">
          <label class="field-label" for="enable">Update Interval (in seconds)</label>
          <div class="field-input">
            <input type="text" v-model="ntpClient.interval" class="input">
          </div>
        </div>
        <div class="field">
          <label class="field-label" for="enable">Offset frequency</label>
          <div class="field-input">
            <input type="text" v-model="ntpClient.offsetFreq.value" class="input">
          </div>
        </div>
      </form>
    </expand-collapse>
      <h3 class="section-title">
        Hostname
      </h3>
      <div class="section-body">
        <ul>
          <li v-for="(server, index) in timeServers" :key="server.hostname + index" class="list-item">
            <input v-model="server.hostname" type="text" class="input" placeholder="my.host.example.com">
            <button class="iconButton" @click="removeTimeServer(index)"><img src="/icons/remove.svg" alt=""></button>
          </li>
          <button class="actionButton" style="float: right;" @click="addTimeServer()">ADD</button>
        </ul>
      </div>
      <expand-collapse index=1 name="NTP Server">
        <div class="section-body">
          <div class="field">
            <label class="field-label" for="enable">Enable NTP Server</label>
            <div class="field-input">
              <label class="switch">
                <input v-model="ntpServer" type="checkbox">
                <span class="slider round"></span>
              </label>
            </div>
          </div>
        </div>
      </expand-collapse>
    <button @click="saveNtpSettings" class="actionButton" style="float: right;">Save & Apply</button>
    <div class="space"/>
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
      ntpClient: {
        enabled: '',
        forceServers: '',
        offsetFreq: {
          value: '',
          name: ''
        },
        interval: ''
      },
      ntpServer: '',
      timeServers: []
    }
  },
  methods: {
    getNtpServer () {
      this.$uci.load('ntpserver').then((res) => {
        this.ntpServer = this.$uci.get('ntpserver', 'general', 'enabled') === '1'
      })
    },
    async getNtpClient () {
      await this.$uci.load('ntpclient')
      this.$uci.sections('ntpclient').forEach(object => {
        switch (object['.type']) {
          case 'ntpserver':
            this.timeServers.push(object)
            break
          case 'ntpdrift':
            this.ntpClient.offsetFreq.value = object.freq
            this.ntpClient.offsetFreq.name = object['.name']
            break
          default:
            this.ntpClient.enabled = object.enabled === '1'
            this.ntpClient.name = object['.name']
            this.ntpClient.interval = object.interval
            this.ntpClient.forceServers = object.force === '1'
            break
        }
      })
    },
    addTimeServer () {
      this.timeServers.push({ hostname: '', port: '' })
    },
    removeTimeServer (index) {
      this.$delete(this.timeServers, index)
    },
    async saveNtpSettings () {
      this.$store.commit('spin', 'Applying NTP changes')
      await this.$uci.load('ntpclient')
      this.$uci.sections('ntpclient', 'ntpserver').forEach(object => {
        this.$uci.del('ntpclient', object['.name'])
      })
      this.timeServers.forEach(server => {
        if (server.hostname && server.port) {
          const name = this.$uci.add('ntpclient', 'ntpserver')
          this.$uci.set('ntpclient', name, 'hostname', server.hostname)
          this.$uci.set('ntpclient', name, 'port', server.port)
        }
      })
      this.$uci.set('ntpclient', this.ntpClient.name, 'enabled', this.ntpClient.enabled === true ? 1 : 0)
      this.$uci.set('ntpclient', this.ntpClient.name, 'interval', this.ntpClient.interval)
      this.$uci.set('ntpclient', this.ntpClient.offsetFreq.name, 'freq', this.ntpClient.offsetFreq.value)
      this.$uci.set('ntpclient', this.ntpClient.name, 'force', this.ntpClient.forceServers === true ? 1 : 0)
      await this.$uci.load('ntpserver')
      this.$uci.set('ntpserver', 'general', 'enabled', this.ntpServerValue)
      await this.$uci.save()
      await this.$uci.apply().then(() => { this.$store.commit('spin', false) })
    }
  },
  created () {
    this.getNtpClient()
    this.getNtpServer()
  },
  computed: {
    ntpServerValue () {
      return this.ntpServer === true ? 1 : 0
    }
  }
}
</script>

<style>
  .ntp-ntp {
    border: 1px solid #e4e4e4;
    border-radius: 7px;
    padding: 10px 38px 38px 38px;
    font-family: "Open Sans", sans-serif;
    font-size: 12px;
  }
  .section {
    padding: 1rem 2rem;
  }
  .section-title {
    font-family: "Oswald",sans-serif;
    font-weight: 400;
    font-size: 16px;
    color: #444;
    text-transform: uppercase;
    position: relative;
    margin-bottom: 0.5em;
    display: block;
  }
  .section-body {
    margin: 0.5rem 0rem;
    display: flex;
    flex-flow:column nowrap;
  }
  .section-body ul {
    padding-left: 0;
  }
  .has-addons {
    transition: unset !important;
    display: flex;
    max-width: 200px;
    justify-content: flex-start;
  }
  .field {
    display:flex;
    flex-flow: row nowrap;
    align-content: center;
    justify-content:center;
    margin-bottom: 1em;
  }
  .field-label {
    width: 200px;
    flex-grow: 1;
    flex-shrink: 2;
    font-weight: 500;
    text-align: right;
    margin: 0.5rem 1rem;
    font-size: 12px;
    color: #444;
  }
  .input {
    flex-grow: 1;
    border-radius: 7px;
    max-width: 300px;
    width: 100%;
    border: 1px solid #a7a7a7;
    padding: 0.2rem 0.5rem;
    transition: all 100ms ease-in;
    color: #000;
  }
  input:focus {
    outline: unset;
    border: 1px solid rgba(82, 168, 236, 0.8) !important;
    box-shadow: 0px 0px 5px 2px rgba(82, 169, 236, 0.5);
  }
  .field-input {
    width: 400px;
    flex-grow: 1;
    align-self: center;
    margin: 0.2rem;
  }
  .list-item {
    padding: 0.5rem 0.5rem;
    border-top: 1px solid #e7e7e7;
    display: flex;
    justify-content: space-between;
    transition: all 500ms;
  }
  .list-item:hover {
    background-color: rgba(82, 168, 236, 0.1);
  }
  .space {
    margin-left: auto;
    width: max-content;
    margin-bottom: 50px;
    margin-top: 10px;
  }
  .switch {
    position: relative;
    display: inline-block;
    width: 44px;
    height: 24px;
  }
  .switch input {
    display: none;
  }
  .slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    transition: .4s;
    border: 1px solid #c7c7c7;
  }
  .slider:before {
    position: absolute;
    content: "";
    height: 19px;
    width: 19px;
    left: 3px;
    bottom: 2px;
    background-color: #c7c7c7;
    transition: .4s;
  }
  input:checked + .slider {
    background-color: #fff;

  }
  /* input:focus + .slider {
    box-shadow: 0 0 1px #a6001c;
  } */
  input:checked + .slider:before {
    transform: translateX(18px);
    background-color: #0054a6;
  }
  /* Rounded sliders */
  .slider.round {
    border-radius: 19px;
  }
  .slider.round:before {
    border-radius: 50%;
  }
  @media only screen and (max-width: 500px) {
    .ntp-ntp {
      border: unset;
    }
  }
  @media all and (max-width:900px) {
    .field-label {
      text-align: left;
    }
    .field {
      flex-flow: row wrap;
    }
  }
</style>
