<template>
  <div class="prediction">
    <div class="page-header">
      <h2 class="page-title">发电量预测</h2>
      <div class="header-actions">
        <a-select style="width: 120px" :value="timeRange" @change="handleTimeRangeChange">
          <a-select-option value="7">未来7天</a-select-option>
          <a-select-option value="15">未来15天</a-select-option>
          <a-select-option value="30">未来30天</a-select-option>
        </a-select>
        <a-button type="primary" @click="updatePrediction">
          <template #icon>
            <font-awesome-icon icon="sync-alt" />
          </template>
          更新预测
        </a-button>
      </div>
    </div>

    <a-row :gutter="[24, 24]">
      <!-- 预测趋势图 -->
      <a-col :xs="24" :lg="12">
        <a-card title="未来发电量预测（kW·h）" :bordered="false">
          <template #extra>
            <span class="text-sm text-gray-500">基于气象数据与历史模型</span>
          </template>
          <div class="chart-container">
            <ECharts :option="predictionChartOption" :loading="chartLoading" />
          </div>
        </a-card>
      </a-col>

      <!-- 预测详情 -->
      <a-col :xs="24" :lg="12">
        <a-card title="每日预测详情" :bordered="false">
          <template #extra>
            <a-button type="link">导出Excel</a-button>
          </template>
          <div class="prediction-details">
            <a-list :data-source="predictionData" :split="true">
              <template #renderItem="{ item }">
                <a-list-item>
                  <a-list-item-meta :description="`最佳充电时段：${item.chargeTime}`">
                    <template #title>
                      <div class="prediction-header">
                        <span>{{ item.date }}（{{ item.weekday }}）</span>
                        <a-tag :color="getWeatherColor(item.weather)">{{ item.weather }}</a-tag>
                      </div>
                    </template>
                  </a-list-item-meta>
                  <div class="prediction-value">
                    预测发电量：<span class="value">{{ item.power }} kW·h</span>
                  </div>
                </a-list-item>
              </template>
            </a-list>
          </div>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script setup>
import ECharts from '@/components/common/ECharts.vue';
import { ref, computed, onMounted } from 'vue';

const timeRange = ref('7');
const chartLoading = ref(false);

const predictionData = ref([
  {
    date: '5月21日',
    weekday: '周二',
    weather: '晴天',
    power: '48.5',
    chargeTime: '10:00 - 15:00'
  },
  {
    date: '5月22日',
    weekday: '周三',
    weather: '多云',
    power: '32.8',
    chargeTime: '11:00 - 14:00'
  },
  {
    date: '5月23日',
    weekday: '周四',
    weather: '阴天',
    power: '25.3',
    chargeTime: '12:00 - 16:00'
  },
  {
    date: '5月24日',
    weekday: '周五',
    weather: '晴天',
    power: '51.2',
    chargeTime: '09:30 - 15:30'
  }
]);

const getWeatherColor = (weather) => {
  if (weather === '晴天') return 'green';
  if (weather === '多云') return 'warning';
  if (weather === '阴天') return 'blue';
  return 'default';
};

const handleTimeRangeChange = (value) => {
  timeRange.value = value;
  updatePrediction();
};

const updatePrediction = () => {
  chartLoading.value = true;
  // 模拟更新预测数据
  setTimeout(() => {
    chartLoading.value = false;
  }, 800);
};

// 预测图表配置
const predictionChartOption = computed(() => {
  const labels = predictionData.value.map(item => item.date);
  const data = predictionData.value.map(item => parseFloat(item.power));
  const backgroundColors = predictionData.value.map(item => {
    if (item.weather === '晴天') return 'rgba(54, 211, 153, 0.7)';
    if (item.weather === '多云') return 'rgba(251, 189, 35, 0.7)';
    if (item.weather === '阴天') return 'rgba(22, 93, 255, 0.7)';
    return 'rgba(22, 93, 255, 0.7)';
  });

  return {
    tooltip: {
      trigger: 'axis'
    },
    xAxis: {
      type: 'category',
      data: labels
    },
    yAxis: {
      type: 'value',
      name: '发电量 (kW·h)'
    },
    series: [{
      data: data,
      type: 'bar',
      itemStyle: {
        color: (params) => backgroundColors[params.dataIndex]
      },
      borderRadius: 4
    }]
  };
});

onMounted(() => {
  // 初始化预测数据
});
</script>

<style scoped>
.prediction {
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

.chart-container {
  height: 350px;
  width: 100%;
}

.prediction-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.prediction-value {
  font-size: 14px;
  color: #666;
}

.value {
  font-weight: bold;
  color: #1890ff;
}
</style>