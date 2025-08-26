import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { createPinia } from 'pinia'

// 导入Ant Design Vue
import Antd from 'ant-design-vue';
import 'ant-design-vue/dist/reset.css';

// 导入FontAwesome
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { 
  faSignInAlt, 
  faSignOutAlt, 
  faUser, 
  faLock, 
  faUsersCog,
  faEdit,
  faKey,
  faTrash,
  faUserPlus,
  faDownload,
  faSyncAlt,
  faSun,
  faCloudSun,
  faCloud,
  faCloudRain,
  faHistory,
  faTachometerAlt,
  faChartLine,
  faFileAlt,
  faSlidersH,
  faCogs
} from '@fortawesome/free-solid-svg-icons'

// 添加图标到库
library.add(
  faSignInAlt, 
  faSignOutAlt, 
  faUser, 
  faLock, 
  faUsersCog,
  faEdit,
  faKey,
  faTrash,
  faUserPlus,
  faDownload,
  faSyncAlt,
  faSun,
  faCloudSun,
  faCloud,
  faCloudRain,
  faHistory,
  faTachometerAlt,
  faChartLine,
  faFileAlt,
  faSlidersH,
  faCogs
)

// 创建Pinia实例
const pinia = createPinia()

// 创建应用
const app = createApp(App)

app.use(pinia)
app.use(router)
app.use(Antd)
app.component('font-awesome-icon', FontAwesomeIcon)

app.mount('#app')