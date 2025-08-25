import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  // 配置开发服务器端口为8080
  server: {
    port: 8080,         // 强制使用8080端口
    strictPort: true,   // 端口被占用时直接退出，而不是尝试其他端口
    hmr: {
      protocol: 'ws',
      host: 'localhost'
    },
    // 增强缓存控制，确保浏览器不缓存任何资源
    headers: {
      'Cache-Control': 'no-store, no-cache, must-revalidate, proxy-revalidate',
      'Pragma': 'no-cache',
      'Expires': '0',
      'Surrogate-Control': 'no-store',
      'Cache': 'no-store'
    },
    // 禁用预构建缓存
    cacheDir: false,
    // 强制每次启动时重新构建
    force: true
  },
  // 构建时添加内容哈希值，确保生产环境缓存正确更新
  build: {
    rollupOptions: {
      output: {
        entryFileNames: `assets/[name].[hash].js`,
        chunkFileNames: `assets/[name].[hash].js`,
        assetFileNames: `assets/[name].[hash].[ext]`
      }
    },
    // 禁用构建缓存
    cacheDir: false
  },
  // 禁用Vite自身的缓存机制
  optimizeDeps: {
    cacheDir: false
  }
})
