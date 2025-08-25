<template>
  <div class="sidebar-container">
    <div class="sidebar-logo">
      <div class="logo-container">
        <img src="@/assets/images/logo.png" alt="Logo" class="logo-image" />
      </div>
      <h2 class="system-name">萤宝智能光伏</h2>
      <p class="system-subtitle">停车场EMS系统</p>
    </div>

    <div class="sidebar-menu">
      <a-menu
        mode="inline"
        :default-selected-keys="[currentSection]"
        :inline-indent="16"
        class="custom-menu"
      >
        <a-menu-item key="dashboard" @click="navigateTo('dashboard')">
          <template #icon>
            <font-awesome-icon icon="tachometer-alt" />
          </template>
          实时监控
        </a-menu-item>
        
        <a-menu-item key="prediction" @click="navigateTo('prediction')">
          <template #icon>
            <font-awesome-icon icon="chart-line" />
          </template>
          发电量预测
        </a-menu-item>
        
        <a-menu-item key="reports" @click="navigateTo('reports')">
          <template #icon>
            <font-awesome-icon icon="file-alt" />
          </template>
          数据报告
        </a-menu-item>
        
        <a-menu-item key="optimization" @click="navigateTo('optimization')">
          <template #icon>
            <font-awesome-icon icon="sliders-h" />
          </template>
          设备优化
        </a-menu-item>
        
        <a-menu-item key="device-management" @click="navigateTo('device-management')">
          <template #icon>
            <font-awesome-icon icon="cogs" />
          </template>
          设备管理
        </a-menu-item>
        
        <a-menu-item key="user-permissions" @click="navigateTo('user-permissions')">
          <template #icon>
            <font-awesome-icon icon="users" />
          </template>
          用户权限
        </a-menu-item>
        
        <a-menu-item key="operation-log" @click="navigateTo('operation-log')">
          <template #icon>
            <font-awesome-icon icon="history" />
          </template>
          操作日志
        </a-menu-item>
      </a-menu>
    </div>

    <!-- 底部版本信息 -->
    <div class="sidebar-footer">
      <div class="version-info">
        <a-tag color="blue" size="small">v1.0.0</a-tag>
        <a-divider type="vertical" />
        <a-tag color="green" size="small">系统运行中</a-tag>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps, ref } from 'vue';
import { useRouter } from 'vue-router';

const props = defineProps({
  currentSection: {
    type: String,
    default: 'dashboard'
  }
});

const router = useRouter();

const navigateTo = (section) => {
  // 触发路由跳转
  router.push({
    path: `/${section === 'device-management' ? 'device' : section}`,
    query: {
      t: new Date().getTime() // 添加随机参数避免缓存
    }
  });
  
  // 同时触发section-changed事件保持兼容性
  emit('section-changed', section);
};

const emit = defineEmits({
  'section-changed': null
});
</script>

<style scoped>
.sidebar-container {
  height: 100%;
  display: flex;
  flex-direction: column;
  background: rgba(255, 255, 255, 0.85);
  color: #333;
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(20px);
  border-right: 1px solid rgba(255, 255, 255, 0.2);
}

.sidebar-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="rgba(24,144,255,0.02)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
  pointer-events: none;
}

.sidebar-logo {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 32px 16px;
  border-bottom: 1px solid rgba(24, 144, 255, 0.1);
  background: rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(10px);
  position: relative;
  z-index: 1;
}

.logo-container {
  margin-bottom: 16px;
  position: relative;
}

.logo-image {
  width: 48px;
  height: 48px;
  object-fit: contain;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.1));
  transition: transform 0.3s ease;
}

.logo-container:hover .logo-image {
  transform: scale(1.05);
}

.system-name {
  font-size: 18px;
  font-weight: 600;
  color: #1890ff;
  margin: 0 0 4px 0;
  text-align: center;
  letter-spacing: 0.5px;
  text-shadow: 0 1px 2px rgba(24, 144, 255, 0.1);
  font-family: 'Microsoft YaHei', 'PingFang SC', 'Helvetica Neue', Arial, sans-serif;
}

.system-subtitle {
  font-size: 11px;
  color: #666;
  margin: 0;
  text-align: center;
  letter-spacing: 0.3px;
  font-family: 'Microsoft YaHei', 'PingFang SC', 'Helvetica Neue', Arial, sans-serif;
}

.sidebar-menu {
  flex: 1;
  padding: 16px 0;
  position: relative;
  z-index: 1;
}

.custom-menu {
  background: transparent;
  border: none;
}

.custom-menu :deep(.ant-menu-item) {
  margin: 2px 16px;
  border-radius: 10px;
  height: 46px;
  line-height: 46px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
  background: transparent;
  color: #666;
}

.custom-menu :deep(.ant-menu-item:hover) {
  background: rgba(24, 144, 255, 0.08);
  color: #1890ff;
}

.custom-menu :deep(.ant-menu-item-selected) {
  background: rgba(24, 144, 255, 0.12);
  color: #1890ff;
  border-right: 3px solid #1890ff;
}

.custom-menu :deep(.ant-menu-item-selected::after) {
  display: none;
}

.custom-menu :deep(.ant-menu-item-icon) {
  color: inherit;
  font-size: 16px;
  margin-right: 12px;
}

.sidebar-footer {
  padding: 16px;
  border-top: 1px solid rgba(24, 144, 255, 0.1);
  background: rgba(255, 255, 255, 0.3);
  position: relative;
  z-index: 1;
}

.version-info {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .sidebar-logo {
    padding: 24px 12px;
  }
  
  .system-name {
    font-size: 16px;
  }
  
  .system-subtitle {
    font-size: 10px;
  }
  
  .custom-menu :deep(.ant-menu-item) {
    margin: 1px 12px;
    height: 42px;
    line-height: 42px;
  }
}

/* 滚动条美化 */
.sidebar-menu::-webkit-scrollbar {
  width: 3px;
}

.sidebar-menu::-webkit-scrollbar-track {
  background: rgba(24, 144, 255, 0.05);
  border-radius: 2px;
}

.sidebar-menu::-webkit-scrollbar-thumb {
  background: rgba(24, 144, 255, 0.2);
  border-radius: 2px;
}

.sidebar-menu::-webkit-scrollbar-thumb:hover {
  background: rgba(24, 144, 255, 0.3);
}
</style>