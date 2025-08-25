<template>
  <div class="device-management">
    <div class="page-header">
      <h2 class="page-title">设备管理</h2>
      <div class="header-actions">
        <a-input-search placeholder="搜索设备编号或名称..." style="width: 250px" />
        <a-button type="primary" class="ml-2">
          <template #icon>
            <font-awesome-icon icon="plus" />
          </template>
          添加设备
        </a-button>
      </div>
    </div>

    <!-- 设备状态筛选 -->
    <div class="filter-bar mb-6">
      <a-card :bordered="false">
        <div class="filter-content">
          <span class="filter-label">设备类型：</span>
          <a-radio-group v-model:value="deviceFilter">
            <a-radio-button value="all">全部设备</a-radio-button>
            <a-radio-button value="pv">光伏组件</a-radio-button>
            <a-radio-button value="charger">充电桩</a-radio-button>
            <a-radio-button value="storage">储能设备</a-radio-button>
            <a-radio-button value="monitor">监控设备</a-radio-button>
          </a-radio-group>
        </div>
      </a-card>
    </div>

    <!-- 图表展示 -->
    <a-card :bordered="false" class="mb-6">
      <div class="chart-container">
        <div ref="deviceStatusChart" style="width: 100%; height: 400px;"></div>
      </div>
    </a-card>

    <!-- 设备列表 -->
    <a-card :bordered="false">
      <a-table :columns="columns" :data-source="devices" :pagination="pagination">
        <template #bodyCell="{ column, record }">
          <template v-if="column.key === 'status'">
            <a-tag :color="getStatusColor(record.status)">{{ record.status }}</a-tag>
          </template>
          <template v-else-if="column.key === 'action'">
            <a-button type="link">详情</a-button>
            <a-button type="link">配置</a-button>
            <a-button type="link">维护</a-button>
          </template>
        </template>
      </a-table>
    </a-card>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import * as echarts from 'echarts';

const deviceFilter = ref('all');

// 设备数据
const devices = ref([
  { 
    id: 'PV-001', 
    name: '光伏组件阵列A', 
    type: '光伏组件', 
    status: '正常运行', 
    location: '实验中心停车场A区', 
    runtime: '1245小时' 
  },
  { 
    id: 'EV-012', 
    name: '快速充电桩12号', 
    type: '充电桩', 
    status: '待机中', 
    location: '实验中心停车场B区', 
    runtime: '876小时' 
  },
  { 
    id: 'ST-003', 
    name: '储能电池组C', 
    type: '储能设备', 
    status: '正常运行', 
    location: '设备间1号', 
    runtime: '2105小时' 
  },
  { 
    id: 'MN-007', 
    name: '环境监测传感器', 
    type: '监控设备', 
    status: '正常运行', 
    location: '停车场中央', 
    runtime: '756小时' 
  }
]);

// 表格列
const columns = [
  {
    title: '设备ID',
    dataIndex: 'id',
    key: 'id'
  },
  {
    title: '设备名称',
    dataIndex: 'name',
    key: 'name'
  },
  {
    title: '类型',
    dataIndex: 'type',
    key: 'type'
  },
  {
    title: '状态',
    key: 'status'
  },
  {
    title: '安装位置',
    dataIndex: 'location',
    key: 'location'
  },
  {
    title: '运行时长',
    dataIndex: 'runtime',
    key: 'runtime'
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

// 获取状态标签颜色
const getStatusColor = (status) => {
  if (status.includes('正常')) return 'success';
  if (status.includes('待机')) return 'warning';
  if (status.includes('故障')) return 'error';
  return 'default';
};

// ECharts实例
const deviceStatusChart = ref(null);
let chartInstance = null;

// 计算设备状态统计
const calculateStatusStats = () => {
  const stats = {
    '正常运行': 0,
    '待机中': 0,
    '故障': 0
  };
  
  devices.value.forEach(device => {
    if (device.status.includes('正常')) {
      stats['正常运行']++;
    } else if (device.status.includes('待机')) {
      stats['待机中']++;
    } else if (device.status.includes('故障')) {
      stats['故障']++;
    }
  });
  
  return stats;
};

// 初始化图表
const initChart = () => {
  if (!deviceStatusChart.value) return;
  
  chartInstance = echarts.init(deviceStatusChart.value);
  
  const stats = calculateStatusStats();
  
  const option = {
    title: {
      text: '设备状态统计',
      left: 'center'
    },
    tooltip: {
      trigger: 'item'
    },
    legend: {
      orient: 'vertical',
      left: 'left'
    },
    series: [{
      name: '设备状态',
      type: 'pie',
      radius: '50%',
      data: [
        { value: stats['正常运行'], name: '正常运行' },
        { value: stats['待机中'], name: '待机中' },
        { value: stats['故障'], name: '故障' }
      ],
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      }
    }]
  };
  
  chartInstance.setOption(option);
};

// 监听设备数据变化
watch(devices, () => {
  if (chartInstance) {
    const stats = calculateStatusStats();
    chartInstance.setOption({
      series: [{
        data: [
          { value: stats['正常运行'], name: '正常运行' },
          { value: stats['待机中'], name: '待机中' },
          { value: stats['故障'], name: '故障' }
        ]
      }]
    });
  }
});

// 页面挂载时初始化图表
onMounted(() => {
  console.log('设备管理页面加载完成');
  initChart();
});
</script>

<style scoped>
.device-management {
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
  flex-wrap: wrap;
}

.filter-bar {
  margin-bottom: 24px;
}

.filter-content {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 16px;
}

.filter-label {
  font-weight: 500;
  color: #666;
}

.ml-2 {
  margin-left: 8px;
}

.chart-container {
  padding: 24px;
  background: #ffffff;
  border-radius: 8px;
}

@media (max-width: 768px) {
  .filter-content {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .header-actions {
    width: 100%;
  }
  
  .filter-label {
    margin-bottom: 8px;
  }
}
</style>