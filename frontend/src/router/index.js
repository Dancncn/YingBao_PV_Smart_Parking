import { createRouter, createWebHistory } from 'vue-router';
import Dashboard from '../views/Dashboard.vue';
import Prediction from '../views/Prediction.vue';
import Report from '../views/Report.vue';
import Optimization from '../views/Optimization.vue';
import DeviceManagement from '../views/DeviceManagement.vue';
import UserPermissions from '../views/UserPermissions.vue';
import OperationLog from '../views/OperationLog.vue';

const routes = [
  {
    path: '/',
    redirect: '/dashboard'
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: Dashboard,
    meta: {
      title: '实时监控面板',
      icon: 'tachometerAlt',
      noCache: true  // 标记为不缓存
    }
  },
  {
    path: '/prediction',
    name: 'Prediction',
    component: Prediction,
    meta: {
      title: '发电量预测',
      icon: 'chartLine',
      noCache: true
    }
  },
  {
    path: '/report',
    name: 'Report',
    component: Report,
    meta: {
      title: '数据报告中心',
      icon: 'fileAlt',
      noCache: true
    }
  },
  {
    path: '/optimization',
    name: 'Optimization',
    component: Optimization,
    meta: {
      title: '设备优化管理',
      icon: 'slidersH',
      noCache: true
    }
  },
  {
    path: '/device',
    name: 'DeviceManagement',
    component: DeviceManagement,
    meta: {
      title: '设备管理',
      icon: 'cogs',
      noCache: true
    }
  },
  {
    path: '/user',
    name: 'UserPermissions',
    component: UserPermissions,
    meta: {
      title: '用户权限管理',
      icon: 'users',
      noCache: true
    }
  },
  {
    path: '/log',
    name: 'OperationLog',
    component: OperationLog,
    meta: {
      title: '操作日志',
      icon: 'history',
      noCache: true
    }
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 };
  }
});

// 路由守卫：添加时间戳参数，避免缓存
router.beforeEach((to, from, next) => {
  // 设置页面标题
  if (to.meta.title) {
    document.title = `${to.meta.title} - 实验中心停车场管理系统`;
  }
  
  // 为所有请求添加时间戳参数，确保每次请求都是新的
  if (to.path && !to.query.t) {
    next({
      path: to.path,
      query: {
        ...to.query,
        t: new Date().getTime()  // 添加时间戳作为参数
      }
    });
    return;
  }
  
  next();
});

export default router;