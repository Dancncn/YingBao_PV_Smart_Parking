<template>
  <div class="header-container">
    <!-- 左侧Logo和标题 -->
    <div class="header-left">
      <div class="header-logo">
        <img src="@/assets/images/logo.svg" alt="Logo" class="header-logo-image" />
      </div>
      <a-divider type="vertical" class="header-divider" />
      <div class="header-title-section">
        <h1 class="header-title">萤宝智能光伏</h1>
        <p class="header-subtitle">停车场智慧能源管理平台</p>
      </div>
    </div>

    <!-- 中间信息区 -->
    <div class="header-center">
      <a-space :size="24">
        <div class="info-item">
          <a-tooltip title="当前位置">
            <EnvironmentOutlined class="info-icon" />
            <span class="info-text">实验中心停车场</span>
          </a-tooltip>
        </div>
        <div class="info-item">
          <a-tooltip title="系统时间">
            <ClockCircleOutlined class="info-icon" />
            <span class="info-text">{{ currentTime }}</span>
          </a-tooltip>
        </div>
      </a-space>
    </div>

    <!-- 右侧用户信息 -->
    <div class="header-right">
      <a-space :size="16">
        <a-dropdown>
          <template #overlay>
            <a-menu>
              <a-menu-item key="profile">
                <UserOutlined />
                个人资料
              </a-menu-item>
              <a-menu-item key="settings">
                <SettingOutlined />
                系统设置
              </a-menu-item>
              <a-menu-divider />
              <a-menu-item key="logout">
                <LogoutOutlined />
                退出登录
              </a-menu-item>
            </a-menu>
          </template>
          <a-button type="text" class="user-button">
            <a-space>
              <a-avatar :size="32" src="https://picsum.photos/id/1005/32/32">
                <template #icon><UserOutlined /></template>
              </a-avatar>
              <span class="username">管理员</span>
              <DownOutlined />
            </a-space>
          </a-button>
        </a-dropdown>
      </a-space>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import {
  EnvironmentOutlined,
  ClockCircleOutlined,
  UserOutlined,
  SettingOutlined,
  LogoutOutlined,
  DownOutlined
} from '@ant-design/icons-vue';

const currentTime = ref('');
let timer = null;

// 实时时间更新
function updateCurrentTime() {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  const hours = String(now.getHours()).padStart(2, '0');
  const minutes = String(now.getMinutes()).padStart(2, '0');
  const seconds = String(now.getSeconds()).padStart(2, '0');
  currentTime.value = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

onMounted(() => {
  updateCurrentTime();
  timer = setInterval(updateCurrentTime, 1000);
});

onUnmounted(() => {
  if (timer) {
    clearInterval(timer);
  }
});
</script>

<style scoped>
.header-container {
  width: 100%;
  height: 72px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.95) 0%, rgba(248, 250, 255, 0.95) 100%);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(24, 144, 255, 0.1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  position: relative;
  z-index: 100;
}

.header-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="header-pattern" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="rgba(24,144,255,0.02)"/></pattern></defs><rect width="100" height="100" fill="url(%23header-pattern)"/></svg>');
  pointer-events: none;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
  position: relative;
  z-index: 1;
}

.header-logo {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 48px;
  height: 48px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(24, 144, 255, 0.15);
  transition: all 0.3s ease;
}

.header-logo:hover {
  transform: scale(1.05);
  box-shadow: 0 6px 24px rgba(24, 144, 255, 0.25);
}

.header-logo-image {
  width: 40px;
  height: 40px;
  object-fit: contain;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.header-divider {
  height: 32px;
  margin: 0 8px;
}

.header-title-section {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.header-title {
  font-size: 20px;
  font-weight: 700;
  color: #1890ff;
  margin: 0;
  line-height: 1.2;
  font-family: 'Microsoft YaHei', 'PingFang SC', 'Helvetica Neue', Arial, sans-serif;
  text-shadow: 0 1px 2px rgba(24, 144, 255, 0.1);
}

.header-subtitle {
  font-size: 12px;
  color: #666;
  margin: 0;
  line-height: 1.2;
  font-family: 'Microsoft YaHei', 'PingFang SC', 'Helvetica Neue', Arial, sans-serif;
}

.header-center {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: flex-end;
  position: relative;
  z-index: 1;
  padding-bottom: 1px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  background: rgba(255, 255, 255, 0.6);
  border-radius: 8px 8px 0 0;
  border: 1px solid rgba(24, 144, 255, 0.05);
  border-bottom: none;
  transition: all 0.3s ease;
  margin-bottom: 0;
}

.info-item:hover {
  background: rgba(255, 255, 255, 0.8);
  border-color: rgba(24, 144, 255, 0.08);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.08);
}

.info-icon {
  color: rgba(24, 144, 255, 0.8);
  font-size: 16px;
}

.info-text {
  font-size: 13px;
  color: rgba(51, 51, 51, 0.85);
  font-weight: 500;
  font-family: 'Microsoft YaHei', 'PingFang SC', 'Helvetica Neue', Arial, sans-serif;
}

.header-right {
  display: flex;
  align-items: center;
  position: relative;
  z-index: 1;
}

.user-button {
  height: 40px;
  padding: 0 12px;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.user-button:hover {
  background: rgba(24, 144, 255, 0.08);
}

.username {
  font-size: 14px;
  color: #333;
  font-weight: 500;
  font-family: 'Microsoft YaHei', 'PingFang SC', 'Helvetica Neue', Arial, sans-serif;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .header-container {
    padding: 0 20px;
  }
  
  .header-center {
    margin: 0 20px;
  }
}

@media (max-width: 768px) {
  .header-container {
    padding: 0 16px;
  }
  
  .header-left {
    gap: 12px;
  }
  
  .header-title {
    font-size: 18px;
  }
  
  .header-subtitle {
    font-size: 11px;
  }
  
  .header-center {
    display: none;
  }
  
  .info-text {
    font-size: 12px;
  }
  
  .username {
    font-size: 13px;
  }
}

@media (max-width: 576px) {
  .header-container {
    padding: 0 12px;
  }
  
  .header-left {
    gap: 8px;
  }
  
  .header-logo {
    width: 40px;
    height: 40px;
  }
  
  .header-title {
    font-size: 16px;
  }
  
  .header-subtitle {
    display: none;
  }
  
  .username {
    display: none;
  }
}
</style>