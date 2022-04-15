<template>
<!-- šiek tiek modifikuotas "Ant Design Vue" -->
  <a-form-model class="form" ref="form" :model="form" :label-col="labelCol" :wrapper-col="wrapperCol">
    <slot v-if="loaded"/>
    <slot name="footer">
      <a-form-model-item class="form-item" :colon="false">
        <template #label>
          <span/>
        </template>
        <div class="form-footer">
          <button class="actionButton" @click="apply();close()">{{ $t('Save & Apply') }}</button>
          <button class="actionButton" @click="reset">{{ $t('Reset') }}</button>
        </div>
      </a-form-model-item>
    </slot>
  </a-form-model>
</template>

<script>
export default {
  name: 'VuciForm',
  provide () {
    return {
      vuciForm: this
    }
  },
  props: {
    uciConfig: String
  },
  data () {
    return {
      labelCol: { span: 6 },
      wrapperCol: { span: 14 },
      form: {},
      fields: {},
      loaded: false
    }
  },
  methods: {
    close: function () {
      this.$emit('close')
    },
    validate () {
      return new Promise(resolve => {
        this.$refs.form.validate(valid => resolve(valid))
      })
    },
    validateField (props, callback) {
      this.$refs.form.validateField(props, callback)
    },
    reset () {
      return new Promise(resolve => {
        this.loaded = false
        this.$uci.reset()
        this.form = {}

        this.$nextTick(() => {
          this.loaded = true
          resolve()
        })
      })
    },
    load () {
      return new Promise(resolve => {
        if (typeof this.uciConfig === 'string') {
          this.$uci.load(this.uciConfig).then(() => {
            this.loaded = true
            resolve()
          })
        } else {
          this.loaded = true
          resolve()
        }
      })
    },
    save () {
      return new Promise(resolve => {
        const promises = []

        Object.values(this.fields).forEach(item => promises.push(item.__save()))

        if (promises.length > 0) {
          Promise.all(promises).then(() => {
            resolve()
          })
        } else {
          resolve()
        }
      })
    },
    apply () {
      this.validate().then(valid => {
        if (!valid) return

        this.save().then(() => {
          const promises = []

          if (this.$uci.changed() > 0) {
            const p = new Promise(resolve => {
              this.$uci.save().then(() => {
                this.$uci.apply().then(() => resolve())
              })
            })

            promises.push(p)
          }

          Object.values(this.fields).forEach(item => {
            const p = item.__apply()
            if (window.vuci.isPromise(p)) promises.push(p)
          })

          if (promises.length === 0) {
            this.$message.warning(this.$t('There are no changes to apply'))
            return
          }

          this.$spin(this.$t('Waiting for configuration to be applied...'))

          Promise.all(promises).then(() => {
            this.$uci.reset()
            this.load().then(() => {
              this.$spin(false)
              this.$emit('applied')
              this.reset().then(() => this.$message.success(this.$t('Configuration has been applied')))
            })
          })
        })
      })
    }
  },
  created () {
    this.$spin()
    this.load().then(() => this.$spin(false))
  },
  destroyed () {
    this.$uci.reset()
  }
}
</script>

<style>
  .form .ant-card-bordered {
    border: none;
  }
  .form .ant-card-body {
    color: #0054a6;
    font-family: "Open Sans", sans-serif;
  }
  .form .ant-tabs-nav-scroll {
    text-transform: uppercase;
    color: #444;
  }
  .form:hover .ant-tabs-tab {
    color: #444;
  }
  .ant-tabs-bar {
    height: 47px;
    margin-bottom: 0;
  }
  .ant-tabs-tabpane-active {
    padding: 10px;
    border: 1px solid #e4e4e4;
    border-top: unset;
  }
  .form .ant-tabs-ink-bar, .ant-tabs-ink-bar-animated {
    background-color: unset;
  }
  .form-item {
    text-align: right;
  }
  .form .ant-tabs-tab-active {
    color: #0054a6;
    border: 1px solid #e4e4e4;
    border-top-left-radius: 7px;
    border-top-right-radius: 7px;
    border-bottom: 2px solid#fff;
    background-color: #fff;
  }
  .form:hover .ant-tabs-tab-active {
    color: #0054a6;
  }
  .ant-switch {
    background-color: #fff;
    border: 1.5px solid #a7a7a7;
    height: 23px;
  }
  .ant-switch:after {
    background-color: #a7a7a7;
    border: 1.5px solid #a7a7a7;
  }
  .ant-switch-checked::after {
    background-color: #0054a6;
    border: none;
    margin-right: 1px;
  }
  .form-item {
    display: flex;
    justify-content: right;
  }
  .ant-form-item {
    margin-bottom: 0;
  }
  .ant-col-14 {
    width: 100%;
    max-width: 300px;
  }
  .ant-form-item label {
    all: unset;
    color: #444;
    font-family: "Open Sans", sans-serif;
    word-wrap: break-word;
  }
  .ant-modal-confirm-title {
    font-family: "Open Sans", sans-serif;
    font-weight: 400;
  }
  .ant-modal-confirm-body > .anticon svg {
    color: #0054a6;
  }
  .actionButton, .ant-btn {
    all: unset;
    transition: border .2s linear,color .2s linear;
    font-family: "Oswald",sans-serif;
    font-weight: 400;
    font-size: 14px;
    text-transform: uppercase;
    border: unset;
    border: 1px solid #0054a6;
    color: #0054a6;
    background-color: #fff;
    border-radius: 5px;
    padding: 0.2em 1em;
    cursor: pointer;
    letter-spacing: 0.11em;
    margin: 2px;
    flex-direction: column;
    line-height: 1.5em;
  }
  .ant-btn:hover {
    color: #0054a6;
    border-color: #0054a6;
    background-color: #fff;
  }
  .ant-btn span {
    all: unset;
  }
  .ant-input {
    font-family: "Open Sans", sans-serif;
  }
  .iconButton {
    padding: 0;
    background: none;
    border: none;
    margin: 1px 3px;
    cursor: pointer;
  }
  .ant-card-head {
    display: none;
  }
  .ant-divider-horizontal {
    height: 0;
  }
</style>
