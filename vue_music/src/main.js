import Vue from 'vue'
import store from './store'
import App from './App.vue'
import router from './router' // 路由对象

import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

import VueLazyload from 'vue-lazyload'

import VueAwesomeSwiper from 'vue-awesome-swiper'
// import 'swiper/dist/css/swiper.css'
Vue.use(VueAwesomeSwiper)

Vue.use(ElementUI);
// 图片懒加载
Vue.use(VueLazyload, {
  loading: require('./assets/img/placeholder.png')
})

Vue.config.productionTip = false

new Vue({
  store,
  router,
  render: h => h(App),
}).$mount('#app')
