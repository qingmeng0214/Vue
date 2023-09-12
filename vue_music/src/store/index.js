
import Vue from 'vue'
import Vuex from 'vuex'
import mutations from './mutations.js'
import actions from './actions.js'
import getters from './getters.js'

Vue.use(Vuex)

const state = {
  // 是否登录
  loginStatu: null,
  // 用户信息
  userInfo: null,
  // 歌手信息
  singer: {},
  // 播放状态
  playing: false,
  // 播放列表
  playList: [],
  // 播放索引
  currentIndex: -1
}

export default new Vuex.Store({
  state,
  mutations,
  actions,
  getters
})
