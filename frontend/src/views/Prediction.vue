<template>
  <div class="prediction">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">发电量预测</h2>
        <a-tag color="processing" class="subtitle">智能预测系统</a-tag>
      </div>
      <div class="header-actions">
        <a-select 
          style="width: 140px" 
          :value="timeRange" 
          @change="handleTimeRangeChange"
          placeholder="选择预测时间"
        >
          <a-select-option value="7">未来7天</a-select-option>
          <a-select-option value="15">未来15天</a-select-option>
          <a-select-option value="30">未来30天</a-select-option>
        </a-select>
        <a-button type="primary" @click="updatePrediction" :loading="chartLoading">
          <template #icon>
            <font-awesome-icon icon="sync-alt" />
          </template>
          更新预测
        </a-button>
      </div>
    </div>

    <!-- 统计概览卡片 -->
    <a-row :gutter="[16, 16]" class="stats-row">
      <a-col :xs="24" :sm="8" :lg="6">
        <a-card :bordered="false" class="stat-card">
          <a-statistic
            title="预测总发电量"
            :value="totalPredictedPower"
            suffix="kW·h"
            :value-style="{ color: '#3f8600' }"
          />
        </a-card>
      </a-col>
      <a-col :xs="24" :sm="8" :lg="6">
        <a-card :bordered="false" class="stat-card">
          <a-statistic
            title="日均发电量"
            :value="avgDailyPower"
            suffix="kW·h"
            :value-style="{ color: '#1890ff' }"
          />
        </a-card>
      </a-col>
      <a-col :xs="24" :sm="8" :lg="6">
        <a-card :bordered="false" class="stat-card">
          <a-statistic
            title="最高单日发电"
            :value="maxDailyPower"
            suffix="kW·h"
            :value-style="{ color: '#cf1322' }"
          />
        </a-card>
      </a-col>
      <a-col :xs="24" :sm="24" :lg="6">
        <a-card :bordered="false" class="stat-card">
          <a-statistic
            title="晴天占比"
            :value="sunnyDaysRatio"
            suffix="%"
            :value-style="{ color: '#faad14' }"
          />
        </a-card>
      </a-col>
    </a-row>

    <!-- 主要内容区域 -->
    <a-row :gutter="[24, 24]">
      <!-- 预测趋势图 - 调整为全宽度 -->
      <a-col :xs="24" :xl="16">
        <a-card title="发电量预测趋势" :bordered="false" class="chart-card">
          <template #extra>
            <div class="chart-extra">
              <a-space>
                <a-tag color="green">晴天</a-tag>
                <a-tag color="orange">多云</a-tag>
                <a-tag color="blue">阴天</a-tag>
                <a-tag color="gray">雨天</a-tag>
              </a-space>
            </div>
          </template>
          <div class="chart-container">
            <ECharts :option="predictionChartOption" :loading="chartLoading" />
          </div>
        </a-card>
      </a-col>

      <!-- 预测详情 -->
      <a-col :xs="24" :xl="8">
        <a-card title="预测详情" :bordered="false" class="details-card">
          <template #extra>
            <a-space>
              <a-button type="link" size="small" @click="exportData">
                <template #icon>
                  <font-awesome-icon icon="download" />
                </template>
                导出
              </a-button>
            </a-space>
          </template>
          <div class="prediction-details">
            <a-list 
              :data-source="displayPredictionData" 
              :split="true"
              size="small"
              :pagination="listPagination"
            >
              <template #renderItem="{ item }">
                <a-list-item class="prediction-item">
                  <a-list-item-meta>
                    <template #title>
                      <div class="prediction-header">
                        <span class="date-text">{{ item.date }}</span>
                        <a-tag :color="getWeatherColor(item.weather)" size="small">
                          {{ item.weather }}
                        </a-tag>
                      </div>
                    </template>
                    <template #description>
                      <div class="prediction-desc">
                        <div class="power-info">
                          <span class="power-label">预测发电：</span>
                          <span class="power-value">{{ item.power }} kW·h</span>
                        </div>
                        <div class="charge-info">
                          <span class="charge-label">最佳时段：</span>
                          <span class="charge-time">{{ item.chargeTime }}</span>
                        </div>
                      </div>
                    </template>
                  </a-list-item-meta>
                </a-list-item>
              </template>
            </a-list>
          </div>
        </a-card>
      </a-col>
    </a-row>

    <!-- 天气分析卡片 -->
    <a-row :gutter="[24, 24]" class="weather-analysis">
      <a-col :xs="24">
        <a-card title="天气影响分析" :bordered="false">
          <template #extra>
            <a-button type="text" size="small">查看详细分析</a-button>
          </template>
          <a-row :gutter="[16, 16]">
            <a-col :xs="24" :sm="12" :lg="6" v-for="weather in weatherAnalysis" :key="weather.type">
              <div class="weather-item">
                <div class="weather-icon" :class="`weather-${weather.type}`">
                  <font-awesome-icon :icon="weather.icon" />
                </div>
                <div class="weather-content">
                  <div class="weather-type">{{ weather.label }}</div>
                  <div class="weather-days">{{ weather.days }}天</div>
                  <div class="weather-power">{{ weather.avgPower }} kW·h/天</div>
                </div>
              </div>
            </a-col>
          </a-row>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script setup>
import ECharts from '@/components/common/ECharts.vue';
import { ref, computed, onMounted, watch } from 'vue';

const timeRange = ref('7');
const chartLoading = ref(false);

// 动态生成预测数据
const generatePredictionData = (days) => {
  const weatherTypes = ['晴天', '多云', '阴天', '雨天'];
  const weatherWeights = [0.4, 0.3, 0.2, 0.1]; // 天气出现概率权重
  const baseDate = new Date();
  const data = [];

  for (let i = 0; i < days; i++) {
    const currentDate = new Date(baseDate);
    currentDate.setDate(baseDate.getDate() + i + 1);
    
    // 随机选择天气（带权重）
    const rand = Math.random();
    let weatherIndex = 0;
    let cumWeight = 0;
    for (let j = 0; j < weatherWeights.length; j++) {
      cumWeight += weatherWeights[j];
      if (rand <= cumWeight) {
        weatherIndex = j;
        break;
      }
    }
    const weather = weatherTypes[weatherIndex];
    
    // 根据天气计算发电量（基础值 + 随机波动）
    let basePower = 0;
    let chargeStart = 10;
    let chargeEnd = 15;
    
    switch (weather) {
      case '晴天':
        basePower = 45 + Math.random() * 15; // 45-60
        chargeStart = 9 + Math.floor(Math.random() * 2);
        chargeEnd = 15 + Math.floor(Math.random() * 2);
        break;
      case '多云':
        basePower = 25 + Math.random() * 15; // 25-40
        chargeStart = 10 + Math.floor(Math.random() * 2);
        chargeEnd = 14 + Math.floor(Math.random() * 3);
        break;
      case '阴天':
        basePower = 15 + Math.random() * 15; // 15-30
        chargeStart = 11 + Math.floor(Math.random() * 2);
        chargeEnd = 16 + Math.floor(Math.random() * 2);
        break;
      case '雨天':
        basePower = 5 + Math.random() * 10; // 5-15
        chargeStart = 12 + Math.floor(Math.random() * 2);
        chargeEnd = 15 + Math.floor(Math.random() * 3);
        break;
    }

    const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    
    data.push({
      date: `${currentDate.getMonth() + 1}月${currentDate.getDate()}日`,
      weekday: weekdays[currentDate.getDay()],
      weather,
      power: basePower.toFixed(1),
      chargeTime: `${chargeStart.toString().padStart(2, '0')}:00 - ${chargeEnd.toString().padStart(2, '0')}:00`
    });
  }
  
  return data;
};

const predictionData = ref(generatePredictionData(7));

// 分页显示的数据
const displayPredictionData = computed(() => {
  return predictionData.value;
});

// 列表分页配置
const listPagination = computed(() => {
  if (predictionData.value.length <= 10) {
    return false;
  }
  return {
    pageSize: 10,
    size: 'small',
    showSizeChanger: false,
    showQuickJumper: false
  };
});

// 统计数据计算
const totalPredictedPower = computed(() => {
  return predictionData.value.reduce((sum, item) => sum + parseFloat(item.power), 0).toFixed(1);
});

const avgDailyPower = computed(() => {
  const total = parseFloat(totalPredictedPower.value);
  return (total / predictionData.value.length).toFixed(1);
});

const maxDailyPower = computed(() => {
  return Math.max(...predictionData.value.map(item => parseFloat(item.power))).toFixed(1);
});

const sunnyDaysRatio = computed(() => {
  const sunnyDays = predictionData.value.filter(item => item.weather === '晴天').length;
  return ((sunnyDays / predictionData.value.length) * 100).toFixed(0);
});

// 天气分析数据
const weatherAnalysis = computed(() => {
  const analysis = [
    { type: 'sunny', label: '晴天', icon: 'sun', days: 0, totalPower: 0 },
    { type: 'cloudy', label: '多云', icon: 'cloud-sun', days: 0, totalPower: 0 },
    { type: 'overcast', label: '阴天', icon: 'cloud', days: 0, totalPower: 0 },
    { type: 'rainy', label: '雨天', icon: 'cloud-rain', days: 0, totalPower: 0 }
  ];

  predictionData.value.forEach(item => {
    const power = parseFloat(item.power);
    switch (item.weather) {
      case '晴天':
        analysis[0].days++;
        analysis[0].totalPower += power;
        break;
      case '多云':
        analysis[1].days++;
        analysis[1].totalPower += power;
        break;
      case '阴天':
        analysis[2].days++;
        analysis[2].totalPower += power;
        break;
      case '雨天':
        analysis[3].days++;
        analysis[3].totalPower += power;
        break;
    }
  });

  return analysis.map(item => ({
    ...item,
    avgPower: item.days > 0 ? (item.totalPower / item.days).toFixed(1) : '0.0'
  }));
});

const getWeatherColor = (weather) => {
  switch (weather) {
    case '晴天': return 'green';
    case '多云': return 'orange';
    case '阴天': return 'blue';
    case '雨天': return 'gray';
    default: return 'default';
  }
};

const handleTimeRangeChange = (value) => {
  timeRange.value = value;
  updatePrediction();
};

const updatePrediction = () => {
  chartLoading.value = true;
  // 模拟API调用延迟
  setTimeout(() => {
    predictionData.value = generatePredictionData(parseInt(timeRange.value));
    chartLoading.value = false;
  }, 1000);
};

const exportData = () => {
  // 导出数据逻辑
  console.log('导出预测数据');
};

// 改进的ECharts配置，参考官方示例
const predictionChartOption = computed(() => {
  const labels = predictionData.value.map(item => item.date);
  const data = predictionData.value.map(item => parseFloat(item.power));
  const weatherData = predictionData.value.map(item => item.weather);
  
  // 根据天气设置颜色
  const getColorByWeather = (weather) => {
    switch (weather) {
      case '晴天': return '#52c41a';
      case '多云': return '#faad14';
      case '阴天': return '#1890ff';
      case '雨天': return '#8c8c8c';
      default: return '#1890ff';
    }
  };

  return {
    title: {
      text: `未来${timeRange.value}天发电量预测`,
      textStyle: {
        fontSize: 16,
        fontWeight: 'normal',
        color: '#666'
      },
      left: 'center',
      top: 10
    },
    tooltip: {
      trigger: 'axis',
      backgroundColor: 'rgba(255, 255, 255, 0.95)',
      borderColor: '#ccc',
      borderWidth: 1,
      textStyle: {
        color: '#333'
      },
      formatter: function(params) {
        const dataIndex = params[0].dataIndex;
        const item = predictionData.value[dataIndex];
        return `
          <div style="padding: 8px;">
            <div style="font-weight: bold; margin-bottom: 4px;">${item.date}（${item.weekday}）</div>
            <div style="margin-bottom: 2px;">
              <span style="display: inline-block; width: 10px; height: 10px; background: ${getColorByWeather(item.weather)}; border-radius: 50%; margin-right: 6px;"></span>
              天气：${item.weather}
            </div>
            <div style="margin-bottom: 2px;">预测发电量：<strong>${item.power} kW·h</strong></div>
            <div>最佳充电时段：${item.chargeTime}</div>
          </div>
        `;
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '8%',
      top: '15%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: labels,
      axisLine: {
        lineStyle: {
          color: '#e8e8e8'
        }
      },
      axisLabel: {
        color: '#666',
        fontSize: 12,
        interval: timeRange.value > 15 ? 1 : 0, // 超过15天时间隔显示标签
        rotate: timeRange.value > 15 ? 45 : 0
      },
      axisTick: {
        show: false
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
        show: false
      },
      axisTick: {
        show: false
      },
      axisLabel: {
        color: '#666',
        fontSize: 12
      },
      splitLine: {
        lineStyle: {
          color: '#f0f0f0',
          type: 'dashed'
        }
      }
    },
    dataZoom: timeRange.value > 15 ? [
      {
        type: 'slider',
        show: true,
        xAxisIndex: [0],
        start: 0,
        end: 50,
        height: 20,
        bottom: 30
      }
    ] : [],
    series: [
      {
        name: '发电量预测',
        type: 'bar',
        data: data.map((value, index) => ({
          value,
          itemStyle: {
            color: getColorByWeather(weatherData[index])
          }
        })),
        barWidth: timeRange.value > 15 ? '60%' : '70%',
        itemStyle: {
          borderRadius: [4, 4, 0, 0],
          shadowBlur: 3,
          shadowColor: 'rgba(0, 0, 0, 0.1)',
          shadowOffsetY: 2
        },
        emphasis: {
          itemStyle: {
            shadowBlur: 8,
            shadowColor: 'rgba(0, 0, 0, 0.2)'
          }
        },
        animationDelay: function (idx) {
          return idx * 50;
        }
      },
      {
        name: '趋势线',
        type: 'line',
        data: data,
        smooth: true,
        symbol: 'none',
        lineStyle: {
          color: '#ff7875',
          width: 2,
          type: 'dashed'
        },
        emphasis: {
          focus: 'series'
        }
      }
    ],
    animation: true,
    animationDuration: 1000,
    animationEasing: 'cubicOut'
  };
});

// 监听时间范围变化
watch(timeRange, (newRange) => {
  predictionData.value = generatePredictionData(parseInt(newRange));
});

onMounted(() => {
  // 初始化预测数据
  updatePrediction();
});
</script>

<style scoped>
.prediction {
  padding: 24px;
  background: #f0f2f5;
  min-height: calc(100vh - 128px);
}

/* 页面头部样式 */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  flex-wrap: wrap;
  gap: 16px;
  padding: 20px 24px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(102, 126, 234, 0.15);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.page-title {
  font-size: 28px;
  font-weight: 600;
  color: #fff;
  margin: 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.subtitle {
  background: rgba(255, 255, 255, 0.2) !important;
  color: #fff !important;
  border: 1px solid rgba(255, 255, 255, 0.3) !important;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

/* 统计卡片样式 */
.stats-row {
  margin-bottom: 24px;
}

.stat-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  transition: all 0.3s ease;
  border: 1px solid #f0f0f0;
}

.stat-card:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transform: translateY(-2px);
}

/* 图表卡片样式 */
.chart-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid #f0f0f0;
}

.chart-extra {
  display: flex;
  align-items: center;
  gap: 8px;
}

.chart-container {
  height: 450px;
  width: 100%;
  padding: 16px 0;
}

/* 详情卡片样式 */
.details-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid #f0f0f0;
  height: fit-content;
}

.prediction-details {
  max-height: 500px;
  overflow-y: auto;
}

.prediction-item {
  padding: 12px 0;
  border-radius: 8px;
  transition: background-color 0.2s ease;
}

.prediction-item:hover {
  background-color: #fafafa;
}

.prediction-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.date-text {
  font-weight: 600;
  color: #262626;
  font-size: 14px;
}

.prediction-desc {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.power-info, .charge-info {
  display: flex;
  align-items: center;
  font-size: 12px;
}

.power-label, .charge-label {
  color: #8c8c8c;
  margin-right: 4px;
  min-width: 60px;
}

.power-value {
  font-weight: 600;
  color: #1890ff;
}

.charge-time {
  color: #595959;
  font-family: 'Monaco', 'Menlo', monospace;
}

/* 天气分析样式 */
.weather-analysis {
  margin-top: 24px;
}

.weather-item {
  display: flex;
  align-items: center;
  padding: 16px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
  transition: all 0.3s ease;
  border: 1px solid #f0f0f0;
}

.weather-item:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
  transform: translateY(-1px);
}

.weather-icon {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
  font-size: 20px;
  color: #fff;
}

.weather-sunny {
  background: linear-gradient(135deg, #52c41a, #73d13d);
}

.weather-cloudy {
  background: linear-gradient(135deg, #faad14, #ffc53d);
}

.weather-overcast {
  background: linear-gradient(135deg, #1890ff, #40a9ff);
}

.weather-rainy {
  background: linear-gradient(135deg, #8c8c8c, #bfbfbf);
}

.weather-content {
  flex: 1;
}

.weather-type {
  font-size: 16px;
  font-weight: 600;
  color: #262626;
  margin-bottom: 4px;
}

.weather-days {
  font-size: 24px;
  font-weight: 700;
  color: #1890ff;
  margin-bottom: 2px;
}

.weather-power {
  font-size: 12px;
  color: #8c8c8c;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .chart-container {
    height: 400px;
  }
}

@media (max-width: 992px) {
  .prediction {
    padding: 16px;
  }
  
  .page-header {
    padding: 16px 20px;
  }
  
  .page-title {
    font-size: 24px;
  }
  
  .chart-container {
    height: 350px;
  }
  
  .stats-row {
    margin-bottom: 16px;
  }
}

@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: stretch;
    text-align: center;
    padding: 16px;
  }
  
  .header-left {
    justify-content: center;
    margin-bottom: 16px;
  }
  
  .header-actions {
    justify-content: center;
  }
  
  .page-title {
    font-size: 22px;
  }
  
  .chart-container {
    height: 300px;
  }
  
  .weather-item {
    padding: 12px;
  }
  
  .weather-icon {
    width: 40px;
    height: 40px;
    font-size: 18px;
    margin-right: 12px;
  }
  
  .weather-days {
    font-size: 20px;
  }
}

@media (max-width: 576px) {
  .prediction {
    padding: 12px;
  }
  
  .page-header {
    padding: 12px;
    margin-bottom: 16px;
  }
  
  .page-title {
    font-size: 20px;
  }
  
  .chart-container {
    height: 280px;
  }
  
  .stat-card {
    margin-bottom: 12px;
  }
  
  .weather-item {
    flex-direction: column;
    text-align: center;
    padding: 16px 12px;
  }
  
  .weather-icon {
    margin-right: 0;
    margin-bottom: 12px;
  }
}

/* 滚动条美化 */
.prediction-details::-webkit-scrollbar {
  width: 6px;
}

.prediction-details::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.prediction-details::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.prediction-details::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

/* 动画效果 */
.stat-card,
.chart-card,
.details-card,
.weather-item {
  animation: fadeInUp 0.6s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 卡片标题样式增强 */
:deep(.ant-card-head-title) {
  font-weight: 600;
  color: #262626;
  font-size: 16px;
}

:deep(.ant-card-extra) {
  color: #8c8c8c;
  font-size: 12px;
}

/* 统计数字样式增强 */
:deep(.ant-statistic-title) {
  font-weight: 500;
  color: #8c8c8c;
  margin-bottom: 8px;
}

:deep(.ant-statistic-content) {
  font-weight: 600;
}
</style>