<template>
  <div class="report">
    <div class="page-header">
      <h2 class="page-title">数据报告中心</h2>
      <div class="header-actions">
        <a-button type="primary">
          <template #icon>
            <font-awesome-icon icon="download" />
          </template>
          下载报告
        </a-button>
      </div>
    </div>

    <a-row :gutter="[24, 24]" class="mb-6">
      <a-col :xs="24" :md="8">
        <a-card :bordered="false">
          <a-form-item label="报告类型">
            <a-select>
              <a-select-option>发电量统计报告</a-select-option>
              <a-select-option>设备运行报告</a-select-option>
              <a-select-option>能耗分析报告</a-select-option>
              <a-select-option>碳排放报告</a-select-option>
            </a-select>
          </a-form-item>
        </a-card>
      </a-col>
      <a-col :xs="24" :md="8">
        <a-card :bordered="false">
          <a-form-item label="时间范围">
            <a-range-picker style="width: 100%" />
          </a-form-item>
        </a-card>
      </a-col>
      <a-col :xs="24" :md="8">
        <a-card :bordered="false">
          <a-form-item label="&nbsp;">
            <a-button type="primary" block>生成报告</a-button>
          </a-form-item>
        </a-card>
      </a-col>
    </a-row>

    <!-- 今日能源数据总览 -->
    <a-card title="今日能源数据总览（截至14:30）" :bordered="false" class="mb-6">
      <template #extra>
        <div class="text-sm text-gray-500">生成时间：2024-05-20 14:30:22</div>
      </template>

      <a-row :gutter="[24, 24]" class="mb-6">
        <a-col :xs="24" :sm="12" :lg="6">
          <div class="data-card">
            <div class="data-card-header">
              <h4 class="data-card-title">总发电量</h4>
              <font-awesome-icon icon="bolt" class="text-primary text-xl" />
            </div>
            <div class="data-card-body">
              <div class="value-container">
                <span class="value text-primary">42.3</span>
                <span class="unit">kW·h</span>
              </div>
              <div class="change-indicator text-success">
                <font-awesome-icon icon="arrow-up" class="mr-1" /> 6.8%
                <span class="text-gray-500 ml-1">较昨日同期</span>
              </div>
            </div>
          </div>
        </a-col>
        
        <a-col :xs="24" :sm="12" :lg="6">
          <div class="data-card">
            <div class="data-card-header">
              <h4 class="data-card-title">总用电量</h4>
              <font-awesome-icon icon="plug" class="text-primary text-xl" />
            </div>
            <div class="data-card-body">
              <div class="value-container">
                <span class="value text-primary">38.5</span>
                <span class="unit">kW·h</span>
              </div>
              <div class="change-indicator text-danger">
                <font-awesome-icon icon="arrow-up" class="mr-1" /> 4.2%
                <span class="text-gray-500 ml-1">较昨日同期</span>
              </div>
            </div>
          </div>
        </a-col>
        
        <a-col :xs="24" :sm="12" :lg="6">
          <div class="data-card">
            <div class="data-card-header">
              <h4 class="data-card-title">储能充放电量</h4>
              <font-awesome-icon icon="battery-three-quarters" class="text-primary text-xl" />
            </div>
            <div class="data-card-body">
              <div class="value-container">
                <span class="value text-primary">12.6</span>
                <span class="unit">kW·h</span>
              </div>
              <div class="change-indicator text-success">
                <font-awesome-icon icon="arrow-up" class="mr-1" /> 18.3%
                <span class="text-gray-500 ml-1">较昨日同期</span>
              </div>
            </div>
          </div>
        </a-col>
        
        <a-col :xs="24" :sm="12" :lg="6">
          <div class="data-card">
            <div class="data-card-header">
              <h4 class="data-card-title">碳排放减少量</h4>
              <font-awesome-icon icon="leaf" class="text-primary text-xl" />
            </div>
            <div class="data-card-body">
              <div class="value-container">
                <span class="value text-primary">32.8</span>
                <span class="unit">kg</span>
              </div>
              <div class="change-indicator text-success">
                <font-awesome-icon icon="arrow-up" class="mr-1" /> 5.7%
                <span class="text-gray-500 ml-1">较昨日同期</span>
              </div>
            </div>
          </div>
        </a-col>
      </a-row>

      <!-- 关键指标分析 -->
      <a-card :bordered="false" class="key-indicators">
        <template #title>
          <span>关键指标分析</span>
        </template>
        <a-row :gutter="16">
          <a-col :xs="24" :md="12">
            <div class="indicator-item">
              <span class="indicator-label">光伏电力就地消纳率</span>
              <span class="indicator-value">89.2%</span>
            </div>
            <div class="indicator-item">
              <span class="indicator-label">平均充电功率</span>
              <span class="indicator-value">6.8 kW</span>
            </div>
            <div class="indicator-item">
              <span class="indicator-label">设备平均运行效率</span>
              <span class="indicator-value">92.5%</span>
            </div>
          </a-col>
          <a-col :xs="24" :md="12">
            <div class="indicator-item">
              <span class="indicator-label">电网补充电量</span>
              <span class="indicator-value">5.8 kW·h</span>
            </div>
            <div class="indicator-item">
              <span class="indicator-label">电费节省金额</span>
              <span class="indicator-value">¥45.2</span>
            </div>
            <div class="indicator-item">
              <span class="indicator-label">系统综合能效</span>
              <span class="indicator-value">87.3%</span>
            </div>
          </a-col>
        </a-row>
      </a-card>
    </a-card>

    <!-- 报告图表 -->
    <a-row :gutter="[24, 24]" class="mb-6">
      <a-col :xs="24" :lg="12">
        <a-card title="能源收支平衡分析" :bordered="false" class="chart-card">
          <div class="chart-container">
            <ECharts :option="balanceChartOption" :loading="chartLoading" />
          </div>
        </a-card>
      </a-col>
      <a-col :xs="24" :lg="12">
        <a-card title="充电桩使用频次分析" :bordered="false" class="chart-card">
          <div class="chart-container">
            <ECharts :option="frequencyChartOption" :loading="chartLoading" />
          </div>
        </a-card>
      </a-col>
    </a-row>

    <!-- 历史报告 -->
    <a-card title="历史报告" :bordered="false">
      <div class="table-header">
        <div></div>
        <a-input-search placeholder="搜索报告..." style="width: 250px" />
      </div>
      <a-table :columns="columns" :data-source="reports" :pagination="pagination">
        <template #bodyCell="{ column, record }">
          <template v-if="column.key === 'action'">
            <a-button type="link">
              <template #icon>
                <font-awesome-icon icon="eye" />
              </template>
              查看
            </a-button>
            <a-button type="link">
              <template #icon>
                <font-awesome-icon icon="download" />
              </template>
              下载
            </a-button>
          </template>
        </template>
      </a-table>
    </a-card>
  </div>
</template>

<script setup>
import ECharts from '@/components/common/ECharts.vue';
import { ref, computed, onMounted } from 'vue';

const chartLoading = ref(false);

const reports = ref([
  { title: '8月发电量统计报告', date: '2024-08-23 09:15' },
  { title: '设备运行月度报告', date: '2024-08-01 10:30' },
  { title: '7月能耗分析报告', date: '2024-07-28 14:22' },
  { title: '第二季度碳排放报告', date: '2024-07-15 09:45' }
]);

const columns = [
  {
    title: '报告名称',
    dataIndex: 'title',
    key: 'title'
  },
  {
    title: '生成时间',
    dataIndex: 'date',
    key: 'date'
  },
  {
    title: '操作',
    key: 'action'
  }
];

const pagination = ref({
  pageSize: 10,
  total: 4
});

// 能源收支平衡分析图配置
const balanceChartOption = computed(() => {
  return {
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data: ['发电量（kW·h）', '用电量（kW·h）']
    },
    xAxis: {
      type: 'category',
      data: ['06:00', '08:00', '10:00', '12:00', '14:00']
    },
    yAxis: {
      type: 'value',
      name: '电量 (kW·h)'
    },
    series: [
      {
        name: '发电量（kW·h）',
        type: 'line',
        data: [0.8, 5.2, 10.8, 12.8, 12.8],
        smooth: true,
        itemStyle: { color: '#165DFF' }
      },
      {
        name: '用电量（kW·h）',
        type: 'line',
        data: [0.5, 3.8, 8.2, 10.5, 9.8],
        smooth: true,
        itemStyle: { color: '#F87272' }
      }
    ]
  };
});

// 充电桩使用频次分析图配置
const frequencyChartOption = computed(() => {
  return {
    tooltip: {
      trigger: 'axis'
    },
    xAxis: {
      type: 'category',
      data: ['08:00前', '08:00-10:00', '10:00-12:00', '12:00-14:00', '14:00-16:00', '16:00后']
    },
    yAxis: {
      type: 'value',
      name: '使用次数'
    },
    series: [{
      data: [5, 12, 18, 25, 16, 8],
      type: 'bar',
      itemStyle: { color: 'rgba(22, 93, 255, 0.7)' },
      barWidth: '60%'
    }]
  };
});

onMounted(() => {
  // 初始化数据
});
</script>

<style scoped>
.report {
  padding: 24px;
  background: #f0f2f5;
  min-height: calc(100vh - 128px);
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  flex-wrap: wrap;
  gap: 16px;
}

.page-title {
  font-size: 24px;
  font-weight: bold;
  color: #1890ff;
  margin: 0;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.data-card {
  background: #fff;
  border: 1px solid #e8e8e8;
  border-radius: 6px;
  padding: 16px;
  height: 100%;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

.data-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.data-card-title {
  font-size: 14px;
  color: #666;
  margin: 0;
}

.data-card-body {
  display: flex;
  flex-direction: column;
}

.value-container {
  display: flex;
  align-items: baseline;
  gap: 4px;
  margin-bottom: 8px;
}

.value {
  font-size: 24px;
  font-weight: bold;
}

.unit {
  font-size: 14px;
  color: #666;
}

.change-indicator {
  font-size: 12px;
  display: flex;
  align-items: center;
}

.key-indicators {
  margin-top: 24px;
  border: 1px solid #e8e8e8;
}

.indicator-item {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px dashed #e8e8e8;
}

.indicator-item:last-child {
  border-bottom: none;
}

.indicator-label {
  color: #666;
}

.indicator-value {
  font-weight: 500;
}

.chart-card {
  height: 100%;
}

.chart-container {
  height: 300px;
  width: 100%;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  flex-wrap: wrap;
  gap: 16px;
}

.text-success {
  color: #52c41a;
}

.text-danger {
  color: #ff4d4f;
}

.text-primary {
  color: #165DFF;
}

.text-gray-500 {
  color: #666;
}

.mr-1 {
  margin-right: 4px;
}

.ml-1 {
  margin-left: 4px;
}
</style>