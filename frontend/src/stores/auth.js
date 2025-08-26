import { ref, computed } from 'vue';
import { defineStore } from 'pinia';

export const useAuthStore = defineStore('auth', () => {
  // 状态
  const token = ref(localStorage.getItem('access_token') || null);
  const user = ref(JSON.parse(localStorage.getItem('user_info') || 'null'));
  const isLoading = ref(false);

  // 计算属性
  const isAuthenticated = computed(() => !!token.value);
  const isAdmin = computed(() => user.value?.role === 'admin');
  const username = computed(() => user.value?.username || '');

  // API基础URL
  const API_BASE_URL = 'http://localhost:5000/api';

  // 设置认证信息
  const setAuth = (authToken, userInfo) => {
    token.value = authToken;
    user.value = userInfo;
    
    // 保存到本地存储
    localStorage.setItem('access_token', authToken);
    localStorage.setItem('user_info', JSON.stringify(userInfo));
  };

  // 清除认证信息
  const clearAuth = () => {
    token.value = null;
    user.value = null;
    
    // 清除本地存储
    localStorage.removeItem('access_token');
    localStorage.removeItem('user_info');
  };

  // 登录方法
  const login = async (username, password) => {
    isLoading.value = true;
    
    try {
      const response = await fetch(`${API_BASE_URL}/auth/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          username,
          password
        })
      });

      const data = await response.json();

      if (response.ok && data.access_token) {
        // 登录成功
        setAuth(data.access_token, data.user);
        return true;
      } else {
        // 登录失败
        console.error('登录失败:', data.error || '未知错误');
        return false;
      }
    } catch (error) {
      console.error('网络错误:', error);
      
      // 如果后端不可用，使用模拟登录
      if (error.name === 'TypeError' && error.message.includes('fetch')) {
        console.warn('后端服务不可用，使用模拟登录');
        return simulateLogin(username, password);
      }
      
      return false;
    } finally {
      isLoading.value = false;
    }
  };

  // 模拟登录（用于开发和演示）
  const simulateLogin = (username, password) => {
    const mockUsers = {
      'master': { password: '123', role: 'admin', id: 1 },
      'admin': { password: 'admin123', role: 'admin', id: 2 },
      'operator1': { password: 'op123', role: 'operator', id: 3 },
      'operator2': { password: 'op456', role: 'operator', id: 4 }
    };

    const mockUser = mockUsers[username];
    
    if (mockUser && mockUser.password === password) {
      const mockToken = `mock_token_${Date.now()}`;
      const userInfo = {
        id: mockUser.id,
        username: username,
        role: mockUser.role,
        created_at: '2024-01-01T00:00:00',
        updated_at: new Date().toISOString()
      };
      
      setAuth(mockToken, userInfo);
      return true;
    }
    
    return false;
  };

  // 登出方法
  const logout = async () => {
    isLoading.value = true;
    
    try {
      // 如果有真实token，调用后端登出接口
      if (token.value && !token.value.startsWith('mock_token_')) {
        await fetch(`${API_BASE_URL}/auth/logout`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${token.value}`,
            'Content-Type': 'application/json',
          }
        });
      }
    } catch (error) {
      console.warn('登出请求失败:', error);
    } finally {
      clearAuth();
      isLoading.value = false;
    }
  };

  // 获取当前用户信息
  const getCurrentUser = async () => {
    // 如果是模拟token或者用户信息已存在，直接返回
    if (!token.value || token.value.startsWith('mock_token_') || user.value) {
      return user.value;
    }

    try {
      const response = await fetch(`${API_BASE_URL}/auth/me`, {
        headers: {
          'Authorization': `Bearer ${token.value}`,
          'Content-Type': 'application/json',
        }
      });

      if (response.ok) {
        const data = await response.json();
        user.value = data.user;
        localStorage.setItem('user_info', JSON.stringify(data.user));
        return data.user;
      } else {
        // Token可能已过期，但不立即清除，让用户继续使用
        console.warn('获取用户信息失败，状态码:', response.status);
        return user.value;
      }
    } catch (error) {
      console.warn('获取用户信息请求失败，可能是后端服务未启动:', error);
      return user.value;
    }
  };

  // 检查token有效性
  const checkTokenValidity = async () => {
    if (!token.value) return false;
    
    // 模拟token直接返回true，不需要验证
    if (token.value.startsWith('mock_token_')) {
      return true;
    }

    try {
      const response = await fetch(`${API_BASE_URL}/auth/me`, {
        headers: {
          'Authorization': `Bearer ${token.value}`,
          'Content-Type': 'application/json',
        }
      });

      if (response.ok) {
        const data = await response.json();
        // 更新用户信息
        user.value = data.user;
        localStorage.setItem('user_info', JSON.stringify(data.user));
        return true;
      } else {
        // 只有在真正的API错误时才清除认证信息
        if (response.status === 401 || response.status === 403) {
          clearAuth();
        }
        return false;
      }
    } catch (error) {
      console.warn('Token验证请求失败，可能是后端服务未启动:', error);
      // 如果是网络错误，不清除认证信息，允许使用模拟模式
      return token.value.startsWith('mock_token_');
    }
  };

  // 刷新token
  const refreshToken = async () => {
    // 这里可以实现token刷新逻辑
    // 目前暂不实现，使用较长的过期时间
    return false;
  };

  // 初始化认证状态
  const initAuth = async () => {
    if (token.value) {
      // 如果是模拟token，直接返回，不需要验证
      if (token.value.startsWith('mock_token_')) {
        return;
      }
      
      // 只有在真正需要时才验证token
      // 这里我们先不验证，等到实际使用API时再验证
      console.log('认证状态已初始化，token存在');
    }
  };

  return {
    // 状态
    token,
    user,
    isLoading,
    
    // 计算属性
    isAuthenticated,
    isAdmin,
    username,
    
    // 方法
    login,
    logout,
    getCurrentUser,
    checkTokenValidity,
    refreshToken,
    initAuth,
    setAuth,
    clearAuth
  };
});
