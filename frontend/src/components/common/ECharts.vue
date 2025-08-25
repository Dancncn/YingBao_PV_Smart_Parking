<template>
  <div ref="chartContainer" class="chart-container"></div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch, nextTick } from 'vue';
import * as echarts from 'echarts';

const props = defineProps({
  option: {
    type: Object,
    required: true
  },
  width: {
    type: String,
    default: '100%'
  },
  height: {
    type: String,
    default: '300px'
  },
  loading: {
    type: Boolean,
    default: false
  }
});

const chartContainer = ref(null);
let chartInstance = null;

const initChart = () => {
  if (chartContainer.value) {
    // 销毁旧实例
    if (chartInstance) {
      chartInstance.dispose();
    }
    
    // 创建新实例
    chartInstance = echarts.init(chartContainer.value, null, {
      renderer: 'canvas',
      useDirtyRect: true
    });
    
    // 设置图表选项
    chartInstance.setOption(props.option);
    
    // 显示加载状态
    if (props.loading) {
      chartInstance.showLoading({
        text: '数据加载中...',
        color: '#1890ff',
        textColor: '#666',
        maskColor: 'rgba(255, 255, 255, 0.8)',
        zlevel: 0
      });
    }
  }
};

const resizeChart = () => {
  if (chartInstance) {
    chartInstance.resize();
  }
};

// 监听选项变化
watch(
  () => props.option,
  () => {
    if (chartInstance) {
      chartInstance.setOption(props.option, true);
    }
  },
  { deep: true }
);

// 监听加载状态变化
watch(
  () => props.loading,
  (newLoading) => {
    if (chartInstance) {
      if (newLoading) {
        chartInstance.showLoading({
          text: '数据加载中...',
          color: '#1890ff',
          textColor: '#666',
          maskColor: 'rgba(255, 255, 255, 0.8)',
          zlevel: 0
        });
      } else {
        chartInstance.hideLoading();
      }
    }
  }
);

// 防抖的resize处理
let resizeTimer = null;
const debouncedResize = () => {
  if (resizeTimer) {
    clearTimeout(resizeTimer);
  }
  resizeTimer = setTimeout(() => {
    resizeChart();
  }, 100);
};

onMounted(async () => {
  await nextTick();
  initChart();
  
  // 监听窗口大小变化
  window.addEventListener('resize', debouncedResize);
  
  // 监听容器大小变化
  if (window.ResizeObserver) {
    const resizeObserver = new ResizeObserver(() => {
      debouncedResize();
    });
    if (chartContainer.value) {
      resizeObserver.observe(chartContainer.value);
    }
  }
});

onBeforeUnmount(() => {
  if (chartInstance) {
    chartInstance.dispose();
  }
  if (resizeTimer) {
    clearTimeout(resizeTimer);
  }
  window.removeEventListener('resize', debouncedResize);
});
</script>

<style scoped>
.chart-container {
  width: v-bind(width);
  height: v-bind(height);
  min-height: 200px;
  max-height: 400px;
  position: relative;
}

/* 确保图表容器有正确的尺寸 */
.chart-container:deep(canvas) {
  width: 100% !important;
  height: 100% !important;
}
</style>