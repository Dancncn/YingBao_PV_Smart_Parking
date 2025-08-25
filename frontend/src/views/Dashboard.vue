<template>
  <div class="dashboard-container">
    <!-- 顶部标题和操作区 -->
    <div class="dashboard-header">
      <h2 class="page-title">
        {{ getSectionTitle(currentSection) }}
      </h2>
      <div class="header-actions">
        <a-button type="primary" class="action-btn">
          <template #icon>
            <font-awesome-icon icon="sync-alt" />
          </template>
          刷新数据
        </a-button>
        <a-button class="action-btn">
          <template #icon>
            <font-awesome-icon icon="download" />
          </template>
          导出数据
        </a-button>
      </div>
    </div>

    <!-- 1. 实时监控面板 -->
    <div v-if="$route.path === '/dashboard' || currentSection === 'dashboard'">
      <!-- 数据概览卡片 -->
      <a-row :gutter="[32, 32]" class="data-cards-row">
        <a-col :xs="24" :sm="12" :lg="6">
          <a-card hoverable class="data-card">
            <div class="card-content">
              <div class="card-header">
                <span class="card-title">当前光伏发电量</span>
                <font-awesome-icon icon="solar-panel" class="card-icon text-primary" />
              </div>
              <div class="card-iconfont">
                <i class="iconfont icon-electricity"></i>
              </div>
              <div class="card-body">
                <span class="value text-primary">12.8</span>
                <span class="unit">kW·h</span>
              </div>
              <div class="card-footer">
                <span class="comparison-text text-success">
                  <font-awesome-icon icon="arrow-up" class="arrow-icon" />
                  昨日: 10.2 kW·h
                </span>
              </div>
            </div>
          </a-card>
        </a-col>
        <a-col :xs="24" :sm="12" :lg="6">
          <a-card hoverable class="data-card">
            <div class="card-content">
              <div class="card-header">
                <span class="card-title">充电桩使用数</span>
                <font-awesome-icon icon="car" class="card-icon text-primary" />
              </div>
              <div class="card-iconfont">
                <i class="iconfont icon-charging-pile"></i>
              </div>
              <div class="card-body">
                <span class="value text-primary">18</span>
                <span class="unit">个</span>
              </div>
              <div class="card-footer">
                <span class="comparison-text text-success">
                  <font-awesome-icon icon="arrow-up" class="arrow-icon" />
                  剩余可用: 7个
                </span>
              </div>
            </div>
          </a-card>
        </a-col>
        <a-col :xs="24" :sm="12" :lg="6">
          <a-card hoverable class="data-card">
            <div class="card-content">
              <div class="card-header">
                <span class="card-title">系统效率</span>
                <font-awesome-icon icon="tachometer-alt" class="card-icon text-primary" />
              </div>
              <div class="card-iconfont">
                <i class="iconfont icon-efficiency"></i>
              </div>
              <div class="card-body">
                <span class="value text-primary">92</span>
                <span class="unit">%</span>
              </div>
              <div class="card-footer">
                <span class="comparison-text text-warning">
                  <font-awesome-icon icon="arrow-down" class="arrow-icon" />
                  上周: 95%
                </span>
              </div>
            </div>
          </a-card>
        </a-col>
        <a-col :xs="24" :sm="12" :lg="6">
          <a-card hoverable class="data-card">
            <div class="card-content">
              <div class="card-header">
                <span class="card-title">储能电池电量</span>
                <font-awesome-icon icon="battery-three-quarters" class="card-icon text-primary" />
              </div>
              <div class="card-iconfont">
                <i class="iconfont icon-battery"></i>
              </div>
              <div class="card-body">
                <span class="value text-primary">65</span>
                <span class="unit">%</span>
              </div>
              <div class="progress-content">
                <a-progress :percent="65" :show-info="false" stroke-color="#1890ff" />
              </div>
              <div class="card-footer">
                <span class="comparison-text text-success">
                  <font-awesome-icon icon="arrow-up" class="arrow-icon" />
                  1小时前: 60%
                </span>
              </div>
            </div>
          </a-card>
        </a-col>
      </a-row>

      <!-- 图表区域 -->
      <a-row :gutter="[32, 32]" class="charts-row">
        <a-col :xs="24" :lg="12">
          <a-card title="今日发电量趋势（kW·h）" :bordered="false" class="chart-card">
            <template #extra>
              <span class="chart-update-time">更新于：14:30</span>
            </template>
            <div class="chart-container power-chart-container">
              <ECharts :option="powerChartOption" :loading="chartLoading" />
            </div>
          </a-card>
        </a-col>
        <a-col :xs="24" :lg="12">
          <a-card title="设备运行状态" :bordered="false" class="chart-card">
            <template #extra>
              <a-button type="link" class="detail-link">查看详情</a-button>
            </template>
            <div class="status-dashboard">
              <div class="chart-section">
                <div class="chart-container status-chart-container">
                  <ECharts ref="statusChartRef" :option="statusChartOption" :loading="chartLoading" />
                </div>
              </div>
              <div class="status-section">
                <div class="status-content">
                  <h4 class="status-title">设备状态统计</h4>
                  <div class="status-list">
                    <div class="status-item">
                      <a-badge status="success" text="正常运行" />
                      <span class="status-count">32台</span>
                    </div>
                    <div class="status-item">
                      <a-badge status="warning" text="待机中" />
                      <span class="status-count">8台</span>
                    </div>
                    <div class="status-item">
                      <a-badge status="error" text="故障维修" />
                      <span class="status-count">0台</span>
                    </div>
                    <div class="status-item">
                      <a-badge status="default" text="未启用" />
                      <span class="status-count">5台</span>
                    </div>
                  </div>
                  <div class="progress-section">
                    <a-progress :percent="84" status="active" :stroke-width="8">
                      <template #format>设备正常率: 84%</template>
                    </a-progress>
                  </div>
                </div>
              </div>
            </div>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <!-- 2. 发电量预测 -->
    <div v-if="$route.path === '/prediction' || currentSection === 'prediction'">
      <Prediction />
    </div>

    <!-- 3. 数据报告中心 -->
    <div v-if="$route.path === '/report' || currentSection === 'reports'">
      <Report />
    </div>

    <!-- 4. 设备优化管理 -->
    <div v-if="$route.path === '/optimization' || currentSection === 'optimization'">
      <Optimization />
    </div>

    <!-- 5. 设备管理 -->
    <div v-if="$route.path === '/device' || currentSection === 'device-management'">
      <DeviceManagement />
    </div>

    <!-- 6. 用户权限管理 -->
    <div v-if="$route.path === '/user' || currentSection === 'user-permissions'">
      <UserPermissions />
    </div>

    <!-- 7. 操作日志 -->
    <div v-if="$route.path === '/log' || currentSection === 'operation-log'">
      <OperationLog />
    </div>
  </div>
</template>

<script setup>
import ECharts from '@/components/common/ECharts.vue';
import { ref, onMounted, computed, nextTick } from 'vue';
import { useRoute } from 'vue-router';
import Prediction from './Prediction.vue';
import Report from './Report.vue';
import Optimization from './Optimization.vue';
import DeviceManagement from './DeviceManagement.vue';
import UserPermissions from './UserPermissions.vue';
import OperationLog from './OperationLog.vue';

// 当前显示的功能区域
const currentSection = ref('dashboard');
const route = useRoute();

// 图表引用
const statusChartRef = ref(null);

// 图表加载状态
const chartLoading = ref(true);

// 发电量趋势图表配置
const powerChartOption = computed(() => {
  return {
    tooltip: {
      trigger: 'axis',
      backgroundColor: 'rgba(255, 255, 255, 0.95)',
      borderColor: '#e8e8e8',
      borderWidth: 1,
      textStyle: {
        color: '#333'
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      top: '15%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: ['0:00', '4:00', '8:00', '12:00', '16:00', '20:00', '24:00'],
      axisLine: {
        lineStyle: {
          color: '#e8e8e8'
        }
      },
      axisTick: {
        lineStyle: {
          color: '#e8e8e8'
        }
      },
      axisLabel: {
        color: '#666',
        fontSize: 12
      }
    },
    yAxis: {
      type: 'value',
      name: '发电量 (kW·h)',
      nameTextStyle: {
        color: '#666',
        fontSize: 12
      },
      axisLine: {
        lineStyle: {
          color: '#e8e8e8'
        }
      },
      axisTick: {
        lineStyle: {
          color: '#e8e8e8'
        }
      },
      axisLabel: {
        color: '#666',
        fontSize: 12
      },
      splitLine: {
        lineStyle: {
          color: '#f0f0f0'
        }
      }
    },
    series: [{
      data: [2.3, 3.1, 8.5, 12.8, 10.2, 5.6, 1.2],
      type: 'line',
      smooth: true,
      areaStyle: {
        color: {
          type: 'linear',
          x: 0,
          y: 0,
          x2: 0,
          y2: 1,
          colorStops: [{
            offset: 0, color: 'rgba(24, 144, 255, 0.3)'
          }, {
            offset: 1, color: 'rgba(24, 144, 255, 0.05)'
          }]
        }
      },
      lineStyle: {
        color: '#1890ff',
        width: 3
      },
      itemStyle: {
        color: '#1890ff'
      }
    }]
  };
});

// 设备状态图表配置
const statusChartOption = computed(() => {
  return {
    tooltip: {
      trigger: 'item',
      backgroundColor: 'rgba(255, 255, 255, 0.95)',
      borderColor: '#e8e8e8',
      borderWidth: 1,
      textStyle: {
        color: '#333'
      },
      formatter: '{a} <br/>{b}: {c} ({d}%)'
    },
    legend: {
      orient: 'vertical',
      left: 'left',
      top: 'middle',
      textStyle: {
        color: '#666',
        fontSize: 12
      },
      itemGap: 12
    },
    series: [
      {
        name: '设备状态',
        type: 'pie',
        radius: ['40%', '70%'],
        center: ['65%', '50%'],
        avoidLabelOverlap: true,
        label: {
          show: false
        },
        labelLine: {
          show: false
        },
        data: [
          { 
            value: 32, 
            name: '正常运行',
            itemStyle: { color: '#52c41a' }
          },
          { 
            value: 8, 
            name: '待机中',
            itemStyle: { color: '#faad14' }
          },
          { 
            value: 0, 
            name: '故障维修',
            itemStyle: { color: '#ff4d4f' }
          },
          { 
            value: 5, 
            name: '未启用',
            itemStyle: { color: '#d9d9d9' }
          }
        ],
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  };
});

// 获取区域标题
const getSectionTitle = (section) => {
  const titles = {
    'dashboard': '实时监控面板',
    'prediction': '发电量预测',
    'reports': '数据报告中心',
    'optimization': '设备优化管理',
    'device-management': '设备管理',
    'user-permissions': '用户权限管理',
    'operation-log': '操作日志'
  };
  return titles[section] || '光伏管理系统';
};

onMounted(() => {
  setTimeout(() => {
    chartLoading.value = false;
  }, 800);
});
</script>

<style scoped>
.dashboard-container {
  padding: 24px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: calc(100vh - 128px);
}

.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 40px;
  flex-wrap: wrap;
  gap: 20px;
  background: rgba(255, 255, 255, 0.9);
  padding: 24px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  backdrop-filter: blur(10px);
}

.data-cards-row {
  margin-bottom: 40px;
}

.charts-row {
  margin-bottom: 32px;
}

.page-title {
  font-size: 28px;
  font-weight: 700;
  background: linear-gradient(135deg, #1890ff 0%, #722ed1 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin: 0;
}

.header-actions {
  display: flex;
  gap: 16px;
}

.action-btn {
  border-radius: 8px;
  font-weight: 500;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.2);
  transition: all 0.3s ease;
}

.action-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(24, 144, 255, 0.3);
}

.data-card {
  height: 100%;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: none;
  overflow: hidden;
}

.data-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
}

.card-content {
  height: 100%;
  display: flex;
  flex-direction: column;
  padding: 24px 20px;
  min-height: 140px;
  position: relative;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.card-iconfont {
  position: absolute;
  top: 20px;
  right: 20px;
  font-size: 24px;
  color: rgba(0, 0, 0, 0.15);
}

.card-title {
  font-size: 15px;
  color: #666;
  font-weight: 600;
  line-height: 1.4;
}

.card-icon {
  font-size: 28px;
  opacity: 0.8;
  transition: all 0.3s ease;
}

.data-card:hover .card-icon {
  transform: scale(1.1);
  opacity: 1;
}

.card-body {
  display: flex;
  align-items: baseline;
  gap: 12px;
  flex-grow: 1;
  align-items: center;
  justify-content: flex-start;
}

.value {
  font-size: 36px;
  font-weight: 700;
  line-height: 1;
}

.unit {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.progress-content {
  margin: 16px 0;
}

.card-footer {
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid #f0f0f0;
}

.comparison-text {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  font-weight: 500;
}

.text-success {
  color: #52c41a;
}

.text-warning {
  color: #faad14;
}

.arrow-icon {
  font-size: 10px;
}

.chart-card {
  height: 100%;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border: none;
  transition: all 0.3s ease;
  overflow: hidden;
}

.chart-card:hover {
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

.chart-update-time {
  font-size: 12px;
  color: #999;
  font-style: italic;
}

.detail-link {
  color: #1890ff;
  font-weight: 500;
}

.chart-container {
  width: 100%;
  min-height: 200px;
  max-height: 400px;
}

.power-chart-container {
  height: 320px;
}

.status-chart-container {
  height: 280px;
  width: 100%;
}

.status-dashboard {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

@media (min-width: 992px) {
  .status-dashboard {
    flex-direction: row;
  }
  
  .chart-section {
    flex: 1;
  }
  
  .status-section {
    flex: 1;
    display: flex;
    align-items: center;
  }
}

.status-content {
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 20px;
  padding: 20px 0;
}

.status-title {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin: 0 0 16px 0;
  text-align: center;
}

.status-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.status-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid #f0f0f0;
}

.status-item:last-child {
  border-bottom: none;
}

.status-count {
  font-weight: 600;
  color: #333;
  font-size: 14px;
}

.progress-section {
  margin-top: 8px;
}

.progress-section :deep(.ant-progress-text) {
  font-size: 12px;
  color: #666;
}

.prediction-chart-container {
  height: 320px;
  min-height: 250px;
  max-height: 400px;
}

.optimization-chart-container {
  height: 250px;
  min-height: 200px;
  max-height: 300px;
}

.text-success {
  color: #52c41a;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  flex-wrap: wrap;
  gap: 16px;
}

.table-title {
  font-size: 16px;
  font-weight: bold;
  margin: 0;
}

.table-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-details {
  display: flex;
  flex-direction: column;
}

.user-email {
  font-size: 12px;
  color: #666;
}

.best-day :deep(.ant-statistic-content) {
  font-size: 20px;
}

.analysis-item {
  margin-bottom: 24px;
}

.analysis-item:last-child {
  margin-bottom: 0;
}

.analysis-title {
  font-size: 14px;
  color: #666;
  margin: 0 0 8px 0;
}

.analysis-content {
  display: flex;
  align-items: baseline;
  gap: 4px;
  margin-bottom: 8px;
}

.analysis-change {
  font-size: 12px;
}

.mt-4 {
  margin-top: 16px;
}

/* 响应式优化 */
@media (max-width: 768px) {
  .dashboard-container {
    padding: 16px;
  }
  
  .dashboard-header {
    padding: 20px;
    margin-bottom: 32px;
  }
  
  .data-cards-row {
    margin-bottom: 32px;
  }
  
  .charts-row {
    margin-bottom: 24px;
  }
  
  .card-content {
    padding: 20px 16px;
    min-height: 120px;
  }
  
  .page-title {
    font-size: 24px;
  }
  
  .header-actions {
    gap: 12px;
  }
  
  .value {
    font-size: 28px;
  }
  
  .chart-container {
    min-height: 180px;
  }
  
  .power-chart-container {
    height: 280px;
  }
  
  .status-chart-container {
    height: 240px;
  }
  
  .status-dashboard {
    gap: 16px;
  }
  
  .status-content {
    gap: 16px;
    padding: 16px 0;
  }
}

@media (max-width: 576px) {
  .dashboard-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
    padding: 16px;
    margin-bottom: 24px;
  }
  
  .data-cards-row {
    margin-bottom: 24px;
  }
  
  .charts-row {
    margin-bottom: 20px;
  }
  
  .card-content {
    padding: 16px 12px;
    min-height: 100px;
  }
  
  .card-header {
    margin-bottom: 16px;
  }
  
  .header-actions {
    width: 100%;
    justify-content: space-between;
  }
  
  .value {
    font-size: 24px;
  }
  
  .chart-container {
    min-height: 160px;
  }
  
  .power-chart-container {
    height: 240px;
  }
  
  .status-chart-container {
    height: 200px;
  }
}
</style>