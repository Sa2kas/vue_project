<template>
  <div>
    <div class="login-container">
      <div class="login-left">
        <img class="teltonika" src="/icons/teltonika.svg" alt="teltonika">
        <div class="login-title">{{ $t("login.Authorization Required") }}</div>
        <div class="login-info">
          <!-- naudojamas paparastas tekstas, nes neveikia translate failo atnaujinimas -->
          Please enter your username and password
          <!-- {{ $t("login.Please enter your username and password") }} -->
        </div>
      </div>
      <div class="login-right">
        <form :model="form" onsubmit="return false">
          <div class="form-div">
            <input v-model="form.username" @pressEnter="handleLogin" :placeholder="$t('login.Please input username')"/>
            <label>Username</label>
          </div>
          <div class="form-div">
            <input id="password" v-model="form.password" @pressEnter="handleLogin" type="password" :placeholder="$t('login.Please input password')"/>
            <label class="form-label">Password</label>
            <button type="button" id="showHide" @click="showHidePassword">
            </button>
          </div>
          <div id="error">
            Invalid username and/or password! Please try again.
          </div>
          <button id="login" @click="handleLogin">{{ $t("login.Login") }}</button>
        </form>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data () {
    return {
      form: {
        username: '',
        password: ''
      },
      show: false
    }
  },
  methods: {
    handleLogin () {
      this.$session.login(this.form.username, this.form.password).then((ok) => {
        if (ok) {
          this.$router.push('/')
          return
        }
        document.getElementById('error').style.height = '16.25px'
        document.getElementById('error').style.visibility = 'visible'
      })
    },
    showHidePassword () {
      if (this.show === true) {
        document.querySelector('#password').setAttribute('type', 'password')
        document.getElementById('showHide').style.background = 'url("/icons/input_show.svg") no-repeat 80%'
        this.show = false
      } else {
        document.querySelector('#password').setAttribute('type', 'text')
        document.getElementById('showHide').style.background = 'url("/icons/input_hide.svg") no-repeat 80%'
        this.show = true
      }
    }
  },
  created () {
    this.$session.logout()
  }
}
</script>

<style>
.login-container {
  margin: 0;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: max-content;
  height: 426px;
  display: flex;
}
.login-left {
  width: 360px;
  background-color: #0054a6;
  padding: 50px 40px;
  border-radius: 7px;
}
.login-right {
  width: 422.5px;
  height: 386px;
  background-color: #ffffff;
  padding: 80px 60px;
  margin: 20px 0;
  border: 1.25px solid #e4e4e4;
  border-radius: 0 7px 7px 0;
}
.teltonika {
  margin-bottom: 34px;
}
.login-title {
  letter-spacing: 0.12em;
  width: 100%;
  font-family: "Oswald", sans-serif;
  font-size: 19px;
  text-transform: uppercase;
  margin-bottom: 19px;
  display: block;
  color: #ffffff;
}
.login-info {
  color: #ffffff;
  display: block;
  font-family: "Open Sans", sans-serif;
  font-size: 14px;
  width: 60%;
  margin-bottom: 20px;
  line-height: 19px;
}
form-model-item {
  margin: 10px 0;
}
.form-div {
  position: relative;
  width: 300px;
  height: 40px;
  margin-bottom: 20px;
  margin-left: auto;
}
input {
  width: 300px;
  height: 40px;
  margin-bottom: 20px;
  color: #000;
  font-size: 11px;
  font-weight: 400;
  font-family: Arial, Helvetica, sans-serif;
  display: flex;
  padding: 6.6px 40px 5.5px 5.5px;
  border: 1.5px solid #afafaf;
  border-radius: 7px;
  position: relative;
}
input:focus {
  outline: none;
  box-shadow: 0px 0px 5px rgba(24, 143, 255, 0.5);
  border: 1.5px solid rgba(24, 143, 255, 0.5);
  transition: 0.2s;
}
#showHide {
  position: absolute;
  width: 27px;
  height: 25px;
  background: url("/icons/input_show.svg") no-repeat 80%;
  top: 0.5em;
  left: 19em;
  border: none;
  cursor: pointer;
  z-index: 5;
}
label {
  position: absolute;
  /* sito nereik, bet tada neatrodo taip nukirsta */
  background: linear-gradient(to right, #ffffff00 0%, #ffffff 5px, #ffffff calc(100% - 5px), #ffffff00 100%);
  color: #9090a5;
  font-size: 12px;
  display: inline-block;
  padding: 0 6px;
  z-index: 1;
  font-weight: 400;
  font-family: "Open Sans", sans-serif;
  letter-spacing: 0.01em;
  padding: 0 0.5em;
  top: -0.75em;
  left: 1em;
}
#error {
  width: 300px;
  height: 0px;
  color: #dd4b39;
  font-size: 12px;
  font-weight: 400;
  text-align: center;
  font-family: "Open Sans", sans-serif;
  margin-bottom: 16.25px;
  visibility: hidden;
}
#login {
  background-color: #ffffff;
  padding: 2.8px 14px;
  border: 1.25px solid #0054a6;
  border-radius: 5px;
  cursor: pointer;
  display: block;
  font-family: "Oswald", sans-serif;
  font-weight: 400;
  font-size: 14px;
  letter-spacing: 0.11em;
  margin: 0 auto;
  text-transform: uppercase;
  color: #0054a6;
}
@media only screen and (max-width: 700px) {
  .login-container {
    display: block;
    position: relative;
    min-width: unset;
    top: unset;
    left: unset;
    transform: unset;
    width: 100%;
    height: 100%;
  }
  .login-left {
    width: 100%;
    border-radius: 0;
    padding: 50px 40px 20px 40px;
  }
  .login-right {
    border: unset;
    width: max-content;
    margin-left: auto;
    margin-right: auto;
  }
}
@media only screen and (max-width: 500px) {
  #login {
    max-width: 160px;
    font-size: 13px;
    padding: 1px 12.5px;
  }
}
</style>
