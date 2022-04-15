<template>
  <div class="diagnostics">
   <expand-collapse name="Diagnostics" index=0>
      <a-input class="diagnostics_input" v-model="host"/>
    <a-select class="diagnostics_select" v-model="tool">
      <a-select-option v-for="tool in tools" :key="tool[0]" :value="tool[0]">{{ tool[1] }}</a-select-option>
    </a-select>
    <button class="actionButton" style="padding-bottom: 5px" @click="test" :loading="loading">>></button>
    <a-textarea v-if="stdout !== ''" auto-size readonly :value="stdout"/>
    <span v-if="stderr !== ''" style="color: red; display: block">{{ stderr }}</span>
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
      host: 'openwrt.org',
      tool: 'runPing',
      tools: [],
      stdout: '',
      stderr: '',
      loading: false
    }
  },
  methods: {
    runPing (name) {
      return this.$rpc.call('diagnose', 'ping', { args: '-c 5 -W 1 ' + name })
    },
    runPing6 (name) {
      return this.$rpc.call('diagnose', 'ping6', { args: '-c 5 -W 1 ' + name })
    },
    runTraceroute (name) {
      return this.$rpc.call('diagnose', 'traceroute', { args: '-q 1 -w 1 -n ' + name }, 30000)
    },
    runTraceroute6 (name) {
      return this.$rpc.call('diagnose', 'traceroute6', { args: '-q 1 -w 2 -n ' + name }, 30000)
    },
    runNslookup (name) {
      return this.$rpc.call('diagnose', 'nslookup', { args: name })
    },
    test () {
      this.loading = true

      this.stdout = ''
      this.stderr = ''

      this[this.tool](this.host).then(r => {
        if (r.stdout) { this.stdout = r.stdout }

        if (r.stderr) { this.stderr = r.stderr }
        this.loading = false
      })
    }
  },
  created () {
    this.runPing('?').then(() => {
      this.tools.push(['runPing', 'IPv4 Ping'])
    })

    this.runPing6('?').then(() => {
      this.tools.push(['runPing6', 'IPv6 Ping'])
    })

    this.runTraceroute('?').then(() => {
      this.tools.push(['runTraceroute', 'IPv4 Traceroute'])
    })

    this.runTraceroute6('?').then(() => {
      this.tools.push(['runTraceroute6', 'IPv6 Traceroute'])
    })

    this.runNslookup('?').then(() => {
      this.tools.push(['runNslookup', 'DNS Lookup'])
    })
  }
}
</script>
<style>
  .diagnostics {
    border: 1px solid #e4e4e4;
    border-radius: 7px;
    padding: 10px 38px 38px 38px;
  }
  .diagnostics_input {
    height: 32px;
    width: 30%;
    font-family: "Open Sans", sans-serif;
    margin-right: 10px;
  }
  .diagnostics_select {
    height: 32px;
    width: 25%;
    margin-right: 10px;
  }
  .space {
    margin-left: auto;
    width: max-content;
    margin-bottom: 50px;
    margin-top: 10px;
  }
  @media only screen and (max-width: 500px) {
    .diagnostics {
      border: unset;
    }
  }
</style>
