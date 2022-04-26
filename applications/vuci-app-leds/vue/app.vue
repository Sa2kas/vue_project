<template>
  <div class="leds">
    <h3 class="leds-title">
      Led configuration
    </h3>
    <vuci-form uci-config="system">
      <vuci-typed-section :title="$t('LED Configuration')" type="led" v-slot="{ s }" addremove :teasers="['name', 'sysfs', 'default', 'trigger']" v-if="sysfs.length > 0" :collapsible="false" :showBorder="true">
        <vuci-form-item-input :uci-section="s" :label="$t('leds.Name')" name="name" required/>
        <vuci-form-item-select :uci-section="s" :label="$t('leds.Led Name')" name="sysfs" :options="sysfs" required/>
        <vuci-form-item-switch :uci-section="s" :label="$t('leds.Default state')" name="default"/>
        <vuci-form-item-select :uci-section="s" :label="$t('leds.Trigger')" name="trigger" :options="triggers" initial="none" required/>
        <vuci-form-item-input :uci-section="s" :label="$t('leds.On-State Delay')" name="delayon" required rules="uinteger" depend="trigger == 'timer'" :help="$t('leds.Time in milliseconds the LED stays on')"/>
        <vuci-form-item-input :uci-section="s" :label="$t('leds.Off-State Delay')" name="delayoff" required rules="uinteger" depend="trigger == 'timer'" :help="$t('leds.Time in milliseconds the LED stays off')"/>
        <vuci-form-item-select :uci-section="s" :label="$t('leds.Device')" name="dev" :options="devices" depend="trigger == 'netdev'" required allow-create/>
        <vuci-form-item-select :uci-section="s" :label="$t('leds.Trigger Mode')" name="mode" :options="modes" multiple depend="trigger == 'netdev'"/>
      </vuci-typed-section>
      <a-alert v-else>{{ $t('leds.No LEDs available') }}</a-alert>
    </vuci-form>
  </div>
</template>

<script>
export default {
  data () {
    return {
      sysfs: [],
      triggers: [],
      devices: [],
      modes: [
        ['link', this.$t('leds.Link On')],
        ['tx', this.$t('leds.Transmit')],
        ['rx', this.$t('leds.Receive')]
      ]
    }
  },
  methods: {
    listLEDs () {
      return this.$rpc.call('system', 'led_list')
    }
  },
  created () {
    this.listLEDs().then(({ leds }) => {
      if (leds.length === 0) { return }

      leds.forEach(led => {
        this.sysfs.push(led.name)
      })

      leds[0].triggers.forEach(trigger => {
        this.triggers.push(trigger)
      })
    })

    this.$network.load().then(() => {
      this.devices = this.$network.getDevices().map(dev => dev.name).filter(name => name !== 'lo')
    })
  }
}
</script>
<style>
  .leds-title {
    color: #444;
    font-family: "Oswald", sans-serif;
    text-transform: uppercase;
    border-bottom: 1px solid #a7a7a7;
    margin-bottom: 1em;
    font-size: 16px;
    letter-spacing: 0.05em;
    font-weight: 400;
  }
  .leds {
    border: 1px solid #e4e4e4;
    border-radius: 7px;
    padding: 10px 38px 38px 38px;
    margin-bottom: 5px;
  }
  @media only screen and (max-width: 500px) {
    .leds {
      border: unset;
    }
  }
</style>
