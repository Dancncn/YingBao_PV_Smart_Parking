<template>
  <div id="app">
    <!-- 登录页面 -->
    <template v-if="$route.name === 'Login'">
      <router-view />
    </template>
    
    <!-- 主应用布局 -->
    <template v-else>
      <a-layout class="layout">
        <a-layout-header class="header">
          <Header />
        </a-layout-header>
        <a-layout class="main-layout">
          <a-layout-sider 
            width="280" 
            class="sider"
            v-model:collapsed="collapsed"
            :trigger="null"
            collapsible
          >
            <Sidebar 
              :current-section="currentSection" 
              @section-changed="handleSectionChange"
            />
          </a-layout-sider>
          <a-layout class="content-layout">
            <a-layout-content class="content">
              <router-view v-slot="{ Component }">
                <component :is="Component" :key="$route.fullPath" />
              </router-view>
            </a-layout-content>
            <a-layout-footer class="footer">
              <Footer />
            </a-layout-footer>
          </a-layout>
        </a-layout>
      </a-layout>
    </template>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import Header from './components/common/Header.vue';
import Sidebar from './components/common/Sidebar.vue';
import Footer from './components/common/Footer.vue';

const currentSection = ref('dashboard');
const router = useRouter();
const route = useRoute();
const collapsed = ref(false);

// 检查是否需要强制刷新
const checkForUpdate = () => {
  // 生成当前时间戳作为版本标识
  const currentVersion = new Date().getTime().toString().slice(0, 10);
  const storedVersion = localStorage.getItem('app-version');
  
  // 如果版本不同，强制刷新页面
  if (!storedVersion || storedVersion !== currentVersion) {
    localStorage.setItem('app-version', currentVersion);
    window.location.reload(true); // 强制刷新，忽略缓存
  }
};

// 处理侧边栏区域切换
const handleSectionChange = (section) => {
  currentSection.value = section;
  // 切换区域时添加随机参数，避免组件缓存
  router.push({
    path: `/${section === 'device-management' ? 'device' : section}`,
    query: {
      t: new Date().getTime()
    }
  });
};

// 监听路由变化，更新当前区域
watch(
  () => route.path,
  (newPath) => {
    // 根据路由路径更新currentSection
    if (newPath === '/dashboard') {
      currentSection.value = 'dashboard';
    } else if (newPath === '/prediction') {
      currentSection.value = 'prediction';
    } else if (newPath === '/report') {
      currentSection.value = 'reports';
    } else if (newPath === '/optimization') {
      currentSection.value = 'optimization';
    } else if (newPath === '/device') {
      currentSection.value = 'device-management';
    } else if (newPath === '/system') {
      currentSection.value = 'system-management';
    }
  },
  { immediate: true }
);

onMounted(() => {
  checkForUpdate();
  
  // 清除可能的组件缓存
  if (window.performance) {
    if (performance.navigation.type === 1) {
      console.log('页面已重新加载，缓存已清除');
    }
  }
});
</script>

<style scoped>
.layout {
  min-height: 100vh;
  background: #f5f7fa;
}

.main-layout {
  margin-top: 72px;
}

.header {
  padding: 0;
  background: transparent;
  box-shadow: none;
  position: fixed;
  width: 100%;
  z-index: 100;
  height: 72px;
}

.sider {
  background: transparent;
  height: calc(100vh - 72px);
  position: fixed;
  left: 0;
  top: 72px;
  bottom: 0;
  overflow: hidden;
  box-shadow: none;
  border-right: 1px solid rgba(255, 255, 255, 0.1);
}

.content-layout {
  margin-left: 280px;
  background: transparent;
}

.content {
  margin: 0;
  padding: 24px;
  background: transparent;
  transition: all 0.3s ease;
  min-height: calc(100vh - 72px - 80px);
}

.footer {
  text-align: center;
  background: transparent;
  padding: 0;
  box-shadow: none;
  height: 80px;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .sider {
    width: 260px;
  }
  
  .content-layout {
    margin-left: 260px;
  }
}

@media (max-width: 768px) {
  .main-layout {
    margin-top: 64px;
  }
  
  .header {
    height: 64px;
  }
  
  .sider {
    top: 64px;
    height: calc(100vh - 64px);
  }
  
  .content-layout {
    margin-left: 0;
  }
  
  .content {
    padding: 16px;
    min-height: calc(100vh - 64px - 80px);
  }
}

/* 滚动条美化 */
.sider::-webkit-scrollbar {
  width: 4px;
}

.sider::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 2px;
}

.sider::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 2px;
}

.sider::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}
</style>