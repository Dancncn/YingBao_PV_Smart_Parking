<template>
  <div class="footer-container">
    <div class="footer-content">
      <div class="footer-copyright">
        <div class="copyright-main">
          © 2025 萤宝-智能光伏停车场EMS系统
        </div>
        <div class="copyright-sub">
          版权所有 © 萤宝-智能光伏停车场开发团队
        </div>
      </div>
      <div class="footer-links">
        <a href="#" class="footer-link">
          <font-awesome-icon icon="question-circle" />
          系统帮助
        </a>
        <a-divider type="vertical" />
        <a href="#" class="footer-link">
          <font-awesome-icon icon="envelope" />
          联系我们
        </a>
        <a-divider type="vertical" />
        <a href="#" class="footer-link">
          <font-awesome-icon icon="shield-alt" />
          隐私政策
        </a>
      </div>
    </div>
    <div class="footer-bottom">
      <div class="footer-info">
        <span class="info-item">
          <font-awesome-icon icon="code-branch" />
          版本 v1.0.0
        </span>
        <span class="info-item">
          <font-awesome-icon icon="heart" />
          用心打造绿色能源管理平台
        </span>
      </div>
    </div>
  </div>
</template>

<script setup>
// 底部栏逻辑
</script>

<style scoped>
.footer-container {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.95) 0%, rgba(248, 250, 255, 0.95) 100%);
  padding: 20px 24px;
  border-top: 1px solid rgba(24, 144, 255, 0.1);
  backdrop-filter: blur(10px);
  position: relative;
}

.footer-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="footer-grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="rgba(24,144,255,0.02)"/></pattern></defs><rect width="100" height="100" fill="url(%23footer-grain)"/></svg>');
  pointer-events: none;
}

.footer-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 20px;
  position: relative;
  z-index: 1;
}

.footer-copyright {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.copyright-main {
  color: #1890ff;
  font-size: 14px;
  font-weight: 600;
  font-family: 'Microsoft YaHei', 'PingFang SC', 'Helvetica Neue', Arial, sans-serif;
}

.copyright-sub {
  color: #666;
  font-size: 12px;
  font-family: 'Microsoft YaHei', 'PingFang SC', 'Helvetica Neue', Arial, sans-serif;
}

.footer-links {
  display: flex;
  align-items: center;
  gap: 8px;
}

.footer-link {
  font-size: 12px;
  color: #666;
  text-decoration: none;
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 6px 12px;
  border-radius: 6px;
  transition: all 0.3s ease;
  font-family: 'Microsoft YaHei', 'PingFang SC', 'Helvetica Neue', Arial, sans-serif;
}

.footer-link:hover {
  color: #1890ff;
  background: rgba(24, 144, 255, 0.08);
  transform: translateY(-1px);
}

.footer-bottom {
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid rgba(24, 144, 255, 0.1);
  position: relative;
  z-index: 1;
}

.footer-info {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 24px;
  flex-wrap: wrap;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 11px;
  color: #999;
  font-family: 'Microsoft YaHei', 'PingFang SC', 'Helvetica Neue', Arial, sans-serif;
}

.info-item svg {
  color: #1890ff;
  opacity: 0.7;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .footer-container {
    padding: 16px 20px;
  }
  
  .footer-content {
    flex-direction: column;
    text-align: center;
    gap: 16px;
  }
  
  .footer-links {
    justify-content: center;
    flex-wrap: wrap;
  }
  
  .footer-info {
    gap: 16px;
  }
  
  .info-item {
    font-size: 10px;
  }
}

@media (max-width: 576px) {
  .footer-container {
    padding: 12px 16px;
  }
  
  .copyright-main {
    font-size: 13px;
  }
  
  .copyright-sub {
    font-size: 11px;
  }
  
  .footer-link {
    font-size: 11px;
    padding: 4px 8px;
  }
  
  .footer-info {
    flex-direction: column;
    gap: 8px;
  }
}
</style>