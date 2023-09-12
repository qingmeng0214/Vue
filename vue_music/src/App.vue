<template>
  <div id="app">
    <div class="nav" v-if="$route.meta.keepAlive">
        <main-nav-bar/>
      </div>
    
      <router-view/>
      <play-bar></play-bar>
  </div>
</template>

<script>
import MainNavBar from '@/components/common/MainNavBar.vue'
import PlayBar from '@/components/content/PlayBar'
export default {
  name: 'App',
  components: {
    MainNavBar,
    PlayBar
  }
}
</script>
<style lang="less">
  .link-active,
  .link-exact-active {
    color: red !important;
  }

  @import "~assets/css/base.css";
</style>