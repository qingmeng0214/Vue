// 路由-相关模块
import Vue from 'vue'
import VueRouter from 'vue-router'



// 懒加载
const Home = () => import('@/views/home/Home')
const Login = () => import('@/views/login/Login')
const User = () => import('@/views/user/User')
const SongList = () => import('@/views/songlist/SongList')
const Singers = () => import('@/views/singers/Singers')
const Mv = () => import('@/views/mv/Mv')
const Rank = () => import('@/views/rank/Rank')
const SongListDetail = () => import('@/views/songListDetail/SongListDetail')
const MvDetail = () => import('@/views/mvDetail/MvDetail')
const Search = () => import('@/views/search/Search')
const NotFound = () => import('@/views/notfound/NotFound')

Vue.use(VueRouter)

const routes = [
    {
        path: '/',
        redirect: '/home'
    },
    {
        path: '/home',
        component: Home,
        meta: {
            keepAlive: true
        }
    },
    {
        path: '/login',
        component: Login,
        meta: {
            keepAlive: false//导航栏和底部说明栏在该页面不显示
        }
    },
    {
        path: '/user',
        component: User,
        meta: {
            keepAlive: true
        }
    },
    {
        path: '/songlist',
        component: SongList,
        meta: {
            keepAlive: true
        }
    },
    {
        path: '/singers',
        component: Singers,
        meta: {
            keepAlive: true
        }
    },
    {
        path: '/mv',
        component: Mv,
        meta: {
            keepAlive: true
        }
    },
    {
        path: '/rank',
        component: Rank,
        meta: {
            keepAlive: true
        }
    },
    {
        path: '/playlist/detail',
        component: SongListDetail,
        meta: {
            keepAlive: true
        }
    },
    {
        path: '/mv/detail',
        component: MvDetail,
        meta: {
            keepAlive: true
        }
    },
    {
        path: '/search',
        component: Search,
        meta: {
            keepAlive: true
        }
    },
    {
        path: '*',
        component: NotFound,
        meta: {
            keepAlive: true
        }
    }
]

const router = new VueRouter({
    mode: 'hash',
    base: process.env.BASE_URL,
    routes,
    linkActiveClass: 'link-active',
    linkExactActiveClass: 'link-exact-active'
})

export default router