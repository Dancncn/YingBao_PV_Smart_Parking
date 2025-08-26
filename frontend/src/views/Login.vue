<template>
  <div class="login-container">
    <!-- 背景装饰 -->
    <div class="login-background">
      <div class="bg-shape shape-1"></div>
      <div class="bg-shape shape-2"></div>
      <div class="bg-shape shape-3"></div>
    </div>

    <!-- 登录卡片 -->
    <div class="login-card">
      <div class="login-header">
        <div class="logo-section">
          <img src="@/assets/images/logo.png" alt="Logo" class="logo" />
          <div class="system-info">
            <h1 class="system-title">萤宝智能光伏</h1>
            <p class="system-subtitle">停车场EMS管理系统</p>
          </div>
        </div>
      </div>

      <div class="login-form-container">
        <a-form
          ref="loginFormRef"
          :model="loginForm"
          :rules="loginRules"
          @finish="handleLogin"
          layout="vertical"
          size="large"
        >
          <a-form-item name="username" class="form-item">
            <a-input
              v-model:value="loginForm.username"
              placeholder="请输入用户名"
              :prefix="usernameIcon"
              allow-clear
            />
          </a-form-item>

          <a-form-item name="password" class="form-item">
            <a-input-password
              v-model:value="loginForm.password"
              placeholder="请输入密码"
              :prefix="passwordIcon"
              allow-clear
            />
          </a-form-item>

          <a-form-item class="form-item">
            <div class="login-options">
              <a-checkbox v-model:checked="rememberMe">
                记住我
              </a-checkbox>
              <a href="#" class="forgot-password">忘记密码？</a>
            </div>
          </a-form-item>

          <a-form-item class="form-item">
            <a-button
              type="primary"
              html-type="submit"
              :loading="loginLoading"
              block
              class="login-button"
            >
              <template #icon v-if="!loginLoading">
                <font-awesome-icon icon="sign-in-alt" />
              </template>
              {{ loginLoading ? '登录中...' : '登录' }}
            </a-button>
          </a-form-item>
        </a-form>

        <!-- 快速登录提示 -->
        <div class="quick-login-tips">
          <a-divider>
            <span class="divider-text">快速登录</span>
          </a-divider>
          <div class="demo-accounts">
            <a-tag 
              color="blue" 
              class="demo-tag" 
              @click="quickLogin('master', '123')"
            >
              管理员: master/123
            </a-tag>
            <a-tag 
              color="green" 
              class="demo-tag" 
              @click="quickLogin('admin', 'admin123')"
            >
              管理员: admin/admin123
            </a-tag>
          </div>
        </div>
      </div>

      <!-- 底部信息 -->
      <div class="login-footer">
        <div class="version-info">
          <a-space>
            <a-tag color="processing" size="small">v1.0.0</a-tag>
            <span class="copyright">© 2024 萤宝智能科技</span>
          </a-space>
        </div>
      </div>
    </div>

    <!-- 系统状态指示器 -->
    <div class="system-status">
      <a-space>
        <a-badge status="processing" text="前端服务" />
        <a-badge :status="backendStatus" text="后端API" />
      </a-space>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, h } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { message } from 'ant-design-vue';
import { UserOutlined, LockOutlined } from '@ant-design/icons-vue';
import { useAuthStore } from '@/stores/auth';

// 图标组件
const usernameIcon = h(UserOutlined);
const passwordIcon = h(LockOutlined);

// 路由和状态管理
const router = useRouter();
const route = useRoute();
const authStore = useAuthStore();

// 响应式数据
const loginLoading = ref(false);
const rememberMe = ref(false);
const backendStatus = ref('default');

// 表单数据
const loginForm = reactive({
  username: '',
  password: ''
});

// 表单引用
const loginFormRef = ref();

// 表单验证规则
const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 2, max: 20, message: '用户名长度应在2-20个字符之间', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 3, message: '密码长度至少3个字符', trigger: 'blur' }
  ]
};

// 检查后端状态
const checkBackendStatus = async () => {
  try {
    const response = await fetch('http://localhost:5000/api/health');
    if (response.ok) {
      backendStatus.value = 'success';
    } else {
      backendStatus.value = 'error';
    }
  } catch (error) {
    backendStatus.value = 'error';
    console.warn('后端服务未启动:', error);
  }
};

// 登录处理函数
const handleLogin = async () => {
  try {
    loginLoading.value = true;
    
    // 调用认证store的登录方法
    const success = await authStore.login(loginForm.username, loginForm.password);
    
    if (success) {
      message.success('登录成功！');
      
      // 记住我功能
      if (rememberMe.value) {
        localStorage.setItem('rememberedUsername', loginForm.username);
      } else {
        localStorage.removeItem('rememberedUsername');
      }
      
      // 短暂延迟确保状态更新完成
      setTimeout(() => {
        // 获取重定向地址，如果没有则默认跳转到仪表盘
        const redirect = route.query.redirect || '/dashboard';
        
        // 使用replace而不是push，避免用户按后退键回到登录页
        router.replace(redirect);
      }, 100);
    } else {
      message.error('用户名或密码错误');
    }
  } catch (error) {
    console.error('登录失败:', error);
    message.error('登录失败，请稍后重试');
  } finally {
    loginLoading.value = false;
  }
};

// 快速登录
const quickLogin = (username, password) => {
  loginForm.username = username;
  loginForm.password = password;
  handleLogin();
};

// 页面加载时的初始化
onMounted(() => {
  // 检查后端状态
  checkBackendStatus();
  
  // 恢复记住的用户名
  const rememberedUsername = localStorage.getItem('rememberedUsername');
  if (rememberedUsername) {
    loginForm.username = rememberedUsername;
    rememberMe.value = true;
  }
  
  // 检查是否已经登录
  if (authStore.isAuthenticated) {
    router.push('/dashboard');
  }
});
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  position: relative;
  overflow: hidden;
}

/* 背景装饰 */
.login-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  overflow: hidden;
  z-index: 0;
}

.bg-shape {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  animation: float 6s ease-in-out infinite;
}

.shape-1 {
  width: 300px;
  height: 300px;
  top: -150px;
  right: -150px;
  animation-delay: 0s;
}

.shape-2 {
  width: 200px;
  height: 200px;
  bottom: -100px;
  left: -100px;
  animation-delay: 2s;
}

.shape-3 {
  width: 150px;
  height: 150px;
  top: 50%;
  left: -75px;
  animation-delay: 4s;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px) rotate(0deg);
  }
  50% {
    transform: translateY(-20px) rotate(180deg);
  }
}

/* 登录卡片 */
.login-card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 420px;
  padding: 40px;
  position: relative;
  z-index: 1;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

/* 登录头部 */
.login-header {
  text-align: center;
  margin-bottom: 40px;
}

.logo-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
}

.logo {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
}

.system-title {
  font-size: 28px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0;
  background: linear-gradient(135deg, #667eea, #764ba2);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.system-subtitle {
  font-size: 16px;
  color: #666;
  margin: 0;
  font-weight: 400;
}

/* 表单样式 */
.login-form-container {
  margin-bottom: 30px;
}

.form-item {
  margin-bottom: 24px;
}

.form-item:last-child {
  margin-bottom: 0;
}

.login-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.forgot-password {
  color: #1890ff;
  text-decoration: none;
  font-size: 14px;
  transition: color 0.3s;
}

.forgot-password:hover {
  color: #40a9ff;
  text-decoration: underline;
}

.login-button {
  height: 50px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 10px;
  background: linear-gradient(135deg, #667eea, #764ba2);
  border: none;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
  transition: all 0.3s ease;
}

.login-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
}

/* 快速登录 */
.quick-login-tips {
  margin-top: 30px;
}

.divider-text {
  color: #999;
  font-size: 12px;
}

.demo-accounts {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-top: 16px;
  flex-wrap: wrap;
}

.demo-tag {
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 6px;
  padding: 4px 12px;
  font-size: 12px;
}

.demo-tag:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* 底部信息 */
.login-footer {
  text-align: center;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
}

.version-info {
  color: #999;
  font-size: 12px;
}

.copyright {
  color: #bbb;
}

/* 系统状态 */
.system-status {
  position: fixed;
  bottom: 20px;
  right: 20px;
  background: rgba(255, 255, 255, 0.9);
  padding: 12px 16px;
  border-radius: 8px;
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  z-index: 1000;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .login-card {
    margin: 20px;
    padding: 30px 24px;
    max-width: none;
  }
  
  .system-title {
    font-size: 24px;
  }
  
  .system-subtitle {
    font-size: 14px;
  }
  
  .demo-accounts {
    flex-direction: column;
    align-items: center;
  }
  
  .system-status {
    bottom: 10px;
    right: 10px;
    left: 10px;
    text-align: center;
  }
}

@media (max-width: 480px) {
  .login-card {
    margin: 10px;
    padding: 24px 20px;
  }
  
  .logo {
    width: 60px;
    height: 60px;
  }
  
  .system-title {
    font-size: 20px;
  }
}

/* 深度样式覆盖 */
:deep(.ant-input-affix-wrapper) {
  border-radius: 8px;
  border: 1px solid #e0e0e0;
  transition: all 0.3s ease;
}

:deep(.ant-input-affix-wrapper:focus),
:deep(.ant-input-affix-wrapper-focused) {
  border-color: #667eea;
  box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
}

:deep(.ant-checkbox-wrapper) {
  font-size: 14px;
  color: #666;
}

:deep(.ant-divider-horizontal.ant-divider-with-text) {
  margin: 20px 0;
}

:deep(.ant-badge-status-text) {
  font-size: 12px;
}

/* 动画效果 */
.login-card {
  animation: slideInUp 0.6s ease-out;
}

@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
