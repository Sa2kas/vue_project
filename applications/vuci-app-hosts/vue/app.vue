<template>
  <div class="hosts">
    <vuci-form uci-config="dhcp" @applied="onApplied">
      <vuci-typed-section title="Hosts" type="domain" addremove :columns="columns" index=0>
        <template v-slot:name="{ s }">
          <vuci-form-item-input :uci-section="s" name="name" required rules="hostname"/>
        </template>
        <template v-slot:ip="{ s }">
          <vuci-form-item-input :uci-section="s" name="ip" required rules="ipaddr"/>
        </template>
      </vuci-typed-section>
    </vuci-form>
  </div>
</template>

<script>
export default {
  data () {
    return {
      columns: [
        { name: 'name', label: this.$t('Hostname') },
        { name: 'ip', label: this.$t('IP address') }
      ]
    }
  },
  methods: {
    onApplied () {
      this.$system.initRestart('dnsmasq')
    }
  }
}
</script>
<style>
  .hosts {
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
    .hosts {
      border: unset;
    }
  }
</style>
