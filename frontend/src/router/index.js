import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../stores/auth';
import Login from '../views/Login.vue';
import Dashboard from '../views/Dashboard.vue';
import Prediction from '../views/Prediction.vue';
import Report from '../views/Report.vue';
import Optimization from '../views/Optimization.vue';
import DeviceManagement from '../views/DeviceManagement.vue';
import SystemManagement from '../views/SystemManagement.vue';

const routes = [
  {
    path: '/',
    redirect: (to) => {
      // 如果用户已登录，重定向到仪表盘；否则重定向到登录页
      const token = localStorage.getItem('access_token');
      return token ? '/dashboard' : '/login';
    }
  },
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: {
      title: '用户登录',
      requiresAuth: false
    }
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: Dashboard,
    meta: {
      title: '实时监控面板',
      icon: 'tachometerAlt',
      noCache: true,
      requiresAuth: true
    }
  },
  {
    path: '/prediction',
    name: 'Prediction',
    component: Prediction,
    meta: {
      title: '发电量预测',
      icon: 'chartLine',
      noCache: true,
      requiresAuth: true
    }
  },
  {
    path: '/report',
    name: 'Report',
    component: Report,
    meta: {
      title: '数据报告中心',
      icon: 'fileAlt',
      noCache: true,
      requiresAuth: true
    }
  },
  {
    path: '/optimization',
    name: 'Optimization',
    component: Optimization,
    meta: {
      title: '设备优化管理',
      icon: 'slidersH',
      noCache: true,
      requiresAuth: true
    }
  },
  {
    path: '/device',
    name: 'DeviceManagement',
    component: DeviceManagement,
    meta: {
      title: '设备管理',
      icon: 'cogs',
      noCache: true,
      requiresAuth: true
    }
  },

  {
    path: '/system',
    name: 'SystemManagement',
    component: SystemManagement,
    meta: {
      title: '系统管理',
      icon: 'cogs',
      noCache: true,
      requiresAuth: true
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

// 路由守卫：认证和权限检查
router.beforeEach(async (to, from, next) => {
  // 设置页面标题
  if (to.meta.title) {
    document.title = `${to.meta.title} - 萤宝智能光伏停车场管理系统`;
  }
  
  // 获取认证store
  const authStore = useAuthStore();
  
  // 轻量级初始化认证状态（不调用API）
  await authStore.initAuth();
  
  // 检查是否需要认证
  if (to.meta.requiresAuth !== false && !authStore.isAuthenticated) {
    // 需要认证但未登录，跳转到登录页
    next({
      path: '/login',
      query: { redirect: to.fullPath }
    });
    return;
  }
  
  // 检查管理员权限
  if (to.meta.requiresAdmin && !authStore.isAdmin) {
    // 需要管理员权限但当前用户不是管理员
    next({
      path: '/dashboard',
      query: { error: 'insufficient_permissions' }
    });
    return;
  }
  
  // 如果已登录且访问登录页，重定向到仪表盘
  if (to.path === '/login' && authStore.isAuthenticated) {
    next('/dashboard');
    return;
  }
  
  // 为所有请求添加时间戳参数，确保每次请求都是新的
  if (to.path && !to.query.t && to.meta.noCache) {
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