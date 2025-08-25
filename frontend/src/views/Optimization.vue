<template>
  <div class="optimization">
    <div class="page-header">
      <h2 class="page-title">设备优化管理</h2>
      <a-button type="primary">
        <template #icon>
          <font-awesome-icon icon="cog" />
        </template>
        执行优化
      </a-button>
    </div>

    <a-row :gutter="[24, 24]" class="mb-6">
      <!-- 太阳板优化建议 -->
      <a-col :xs="24" :md="12">
        <a-card title="太阳板倾角优化建议" :bordered="false">
          <template #extra>
            <a-tag color="blue">待优化</a-tag>
          </template>
          <div class="optimization-content">
            <div class="progress-item">
              <div class="progress-header">
                <span class="progress-label">当前倾角</span>
                <span class="progress-value">25°</span>
              </div>
              <a-progress :percent="65" :show-info="false" />
            </div>

            <div class="progress-item">
              <div class="progress-header">
                <span class="progress-label">优化建议倾角</span>
                <span class="progress-value text-success">28°</span>
              </div>
              <a-progress :percent="75" status="active" :show-info="false" />
            </div>

            <a-alert type="info" class="mt-4">
              <template #message>
                <div class="alert-content">
                  <p><font-awesome-icon icon="info-circle" class="mr-2" />优化依据：基于近30天太阳高度角、辐照强度数据计算</p>
                  <p><font-awesome-icon icon="line-chart" class="mr-2" />预期效果：优化后发电量可提升约5.2%-7.8%</p>
                </div>
              </template>
            </a-alert>

            <a-button type="primary" block class="mt-4">
              <template #icon>
                <font-awesome-icon icon="refresh" />
              </template>
              生成详细优化方案
            </a-button>
          </div>
        </a-card>
      </a-col>

      <!-- 设备维护提醒 -->
      <a-col :xs="24" :md="12">
        <a-card title="设备维护提醒" :bordered="false">
          <template #extra>
            <a-button type="link">查看全部</a-button>
          </template>
          <div class="maintenance-list">
            <a-alert message="P012充电桩滤网清洁" type="warning" class="mb-4">
              <template #description>
                <div class="alert-description">
                  <p>设备已连续运行30天，建议清洁滤网以保证散热效率</p>
                  <div class="alert-footer">
                    <span class="text-error">剩余2天</span>
                  </div>
                </div>
              </template>
            </a-alert>

            <a-alert message="光伏组件表面检查" type="info" class="mb-4">
              <template #description>
                <div class="alert-description">
                  <p>季度例行检查，确认组件表面无遮挡、无破损</p>
                  <div class="alert-footer">
                    <span class="text-muted">剩余7天</span>
                  </div>
                </div>
              </template>
            </a-alert>
            
            <a-alert message="储能电池容量检测" type="info">
              <template #description>
                <div class="alert-description">
                  <p>半年度容量检测，确保电池性能达标</p>
                  <div class="alert-footer">
                    <span class="text-muted">剩余15天</span>
                  </div>
                </div>
              </template>
            </a-alert>
          </div>
        </a-card>
      </a-col>
    </a-row>

    <!-- 历史优化记录 -->
    <a-card title="历史优化记录" :bordered="false" class="mb-6">
      <div class="table-header">
        <div></div>
        <a-input-search placeholder="搜索优化记录..." style="width: 250px" />
      </div>
      <a-table :columns="columns" :data-source="optimizationRecords" :pagination="pagination">
        <template #bodyCell="{ column }">
          <template v-if="column.key === 'effect'">
            <span class="text-success">发电量提升6.3%</span>
          </template>
        </template>
      </a-table>
    </a-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

// 优化记录数据
const optimizationRecords = ref([
  { 
    time: '2024-05-15 09:30', 
    type: '太阳板倾角调整', 
    device: 'A区1-10号光伏板', 
    params: '23° → 25°', 
    effect: '发电量提升6.3%', 
    operator: '张工' 
  },
  { 
    time: '2024-05-10 14:15', 
    type: '充电策略优化', 
    device: '全部充电桩', 
    params: '优先使用光伏电力', 
    effect: '电网用电量减少8.5%', 
    operator: '李工' 
  },
  { 
    time: '2024-05-05 11:20', 
    type: '储能充放电阈值调整', 
    device: '储能电池组', 
    params: '充电阈值80% → 85%', 
    effect: '储能利用率提升12%', 
    operator: '王工' 
  }
]);

// 表格列
const columns = [
  {
    title: '优化时间',
    dataIndex: 'time',
    key: 'time'
  },
  {
    title: '优化类型',
    dataIndex: 'type',
    key: 'type'
  },
  {
    title: '涉及设备',
    dataIndex: 'device',
    key: 'device'
  },
  {
    title: '优化参数',
    dataIndex: 'params',
    key: 'params'
  },
  {
    title: '优化效果',
    key: 'effect'
  },
  {
    title: '操作人',
    dataIndex: 'operator',
    key: 'operator'
  }
];

const pagination = ref({
  pageSize: 10,
  total: 3
});

onMounted(() => {
  console.log('设备优化管理页面加载完成');
});
</script>

<style scoped>
.optimization {
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

.optimization-content {
  padding: 8px 0;
}

.progress-item {
  margin-bottom: 20px;
}

.progress-item:last-child {
  margin-bottom: 0;
}

.progress-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.progress-label {
  color: #666;
  font-size: 14px;
}

.progress-value {
  font-weight: 500;
}

.text-success {
  color: #52c41a;
}

.mt-4 {
  margin-top: 16px;
}

.mb-4 {
  margin-bottom: 16px;
}

.text-error {
  color: #ff4d4f;
}

.text-muted {
  color: #666;
}

.alert-content {
  font-size: 12px;
}

.alert-description {
  font-size: 12px;
}

.alert-footer {
  margin-top: 8px;
  text-align: right;
}

.maintenance-list :deep(.ant-alert) {
  border-radius: 4px;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  flex-wrap: wrap;
  gap: 16px;
}

.chart-placeholder {
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #999;
  background: #fafafa;
  border-radius: 4px;
}
</style>