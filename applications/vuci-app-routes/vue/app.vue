<template>
  <div class="routes">
    <vuci-form uci-config="network">
      <vuci-typed-section index=0 :title="$t('routes.Static IPv4 Routes')" type="route" :columns="routeColumns" addremove>
        <template #interface="{ s }">
          <vuci-form-item-select :uci-section="s" name="interface" :options="interfaces" required/>
        </template>
        <template #target="{ s }">
          <vuci-form-item-input :uci-section="s" name="target" required rules="ip4addr"/>
        </template>
        <template #netmask="{ s }">
          <vuci-form-item-input :uci-section="s" name="netmask" placeholder="255.255.255.255" required rules="netmask4"/>
        </template>
        <template #gateway="{ s }">
          <vuci-form-item-input :uci-section="s" name="gateway" rules="ip4addr"/>
        </template>
        <template #metric="{ s }">
          <vuci-form-item-input :uci-section="s" name="metric" placeholder="0" :rules="{type: 'uinteger', min: 0, max: 255}"/>
        </template>
        <template #mtu="{ s }">
          <vuci-form-item-input :uci-section="s" name="mtu" placeholder="1500" :rules="{type: 'uinteger', min: 64, max: 9000}"/>
        </template>
      </vuci-typed-section>
      <vuci-typed-section index=1 :title="$t('routes.Static IPv6 Routes')" type="route6" :columns="route6Columns" addremove>
        <template #interface="{ s }">
          <vuci-form-item-select :uci-section="s" name="interface" :options="interfaces" required/>
        </template>
        <template #target="{ s }">
          <vuci-form-item-input :uci-section="s" name="target" required rules="ip6addr"/>
        </template>
        <template #gateway="{ s }">
          <vuci-form-item-input :uci-section="s" name="gateway" rules="ip6addr"/>
        </template>
        <template #metric="{ s }">
          <vuci-form-item-input :uci-section="s" name="metric" placeholder="0" :rules="{type: 'uinteger', min: 0, max: 255}"/>
        </template>
        <template #mtu="{ s }">
          <vuci-form-item-input :uci-section="s" name="mtu" placeholder="1500" :rules="{type: 'uinteger', min: 64, max: 9000}"/>
        </template>
      </vuci-typed-section>
    </vuci-form>
  </div>
</template>

<script>
export default {
  data () {
    return {
      routeColumns: [
        { name: 'interface', label: this.$t('routes.Interface'), width: 160 },
        { name: 'target', label: this.$t('routes.Target') },
        { name: 'netmask', label: this.$t('IPv4-Netmask') },
        { name: 'gateway', label: this.$t('IPv4-Gateway') },
        { name: 'metric', label: this.$t('routes.Metric') },
        { name: 'mtu', label: 'MTU' }
      ],
      route6Columns: [
        { name: 'interface', label: this.$t('routes.Interface'), width: 160 },
        { name: 'target', label: this.$t('routes.Target') },
        { name: 'gateway', label: this.$t('IPv6-Gateway') },
        { name: 'metric', label: this.$t('routes.Metric') },
        { name: 'mtu', label: 'MTU' }
      ],
      interfaces: []
    }
  },
  created () {
    this.$network.load().then(() => {
      const interfaces = this.$network.getInterfaces()
      this.interfaces = interfaces.map(item => item.name)
    })
  }
}
</script>
<style>
  .routes {
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
    .routes {
      border: unset;
    }
  }
</style>
