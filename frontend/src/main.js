import { createApp } from 'vue'
import App from './App.vue'
import router from './router'


// 导入Ant Design Vue
import Antd from 'ant-design-vue';


// 创建应用
createApp(App)
  .use(router)
  .use(Antd)
  .mount('#app')