import axios from 'axios'

export function request(config) {
  // 1.创建axios实例
  const instance = axios.create({
    // 开发环境下
    baseURL: 'http://localhost:3000/',
    timeout: 5000,
    withCredentials: true
  })

  // 2.axios的拦截器
  instance.interceptors.request.use(config => {
    // console.log(config)
    return config
  }, err => {
    console.log(err)
  });  // 拦截请求

  instance.interceptors.response.use(res => {
    // console.log(res)
    return res.data
  }, err => {
    console.log(err)
  })  // 拦截响应

  // 3.发送真正的网络请求
  return instance(config)
}