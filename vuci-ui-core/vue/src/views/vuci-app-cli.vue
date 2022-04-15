<template>
  <div class="cli">
    <expand-collapse name="Command Line Interface">
      <iframe ref="iframe" src="" srcdoc="" frameborder="0"></iframe>
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
      url: '',
      port: '',
      pid: '',
      session: '',
      hostname: '192.168.1.1',
      activeKey: ['1']
    }
  },
  methods: {
    getCLIInstance () {
      this.$rpc.call('cliTrigger', 'runCLI').then(response => {
        const res = response[0]
        this.port = res['X-ShellInABox-Port']
        this.session = res['X-ShellInABox-Session']
        this.pid = res['X-ShellInABox-Pid']
        this.$refs.iframe.srcdoc = response[1]
      })
    }
  },
  async created () {
    this.getCLIInstance()
  },
  beforeDestroy () {
    this.$rpc.ubus('system', 'signal', { pid: this.pid, signum: 9 })
  }
}

</script>
<style scoped>
  iframe {
    height: 600px;
    width: 100%;
  }
  .cli {
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
    .cli {
      border: unset;
    }
  }
</style>
