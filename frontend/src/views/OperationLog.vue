<template>
  <div class="operation-log">
    <div class="page-header">
      <h2 class="page-title">操作日志</h2>
      <div class="header-actions">
        <a-button>
          <template #icon>
            <font-awesome-icon icon="download" />
          </template>
          导出日志
        </a-button>
      </div>
    </div>

    <!-- 筛选条件 -->
    <a-card :bordered="false" class="mb-6">
      <a-row :gutter="24">
        <a-col :xs="24" :md="6">
          <a-form-item label="用户">
            <a-select placeholder="所有用户">
              <a-select-option value="all">所有用户</a-select-option>
              <a-select-option value="admin">admin</a-select-option>
              <a-select-option value="operator01">operator01</a-select-option>
              <a-select-option value="viewer01">viewer01</a-select-option>
            </a-select>
          </a-form-item>
        </a-col>
        <a-col :xs="24" :md="6">
          <a-form-item label="操作类型">
            <a-select placeholder="所有操作类型">
              <a-select-option value="all">所有操作类型</a-select-option>
              <a-select-option value="login">登录</a-select-option>
              <a-select-option value="query">数据查询</a-select-option>
              <a-select-option value="config">配置修改</a-select-option>
              <a-select-option value="system">系统管理</a-select-option>
            </a-select>
          </a-form-item>
        </a-col>
        <a-col :xs="24" :md="8">
          <a-form-item label="日期范围">
            <a-range-picker style="width: 100%" />
          </a-form-item>
        </a-col>
        <a-col :xs="24" :md="4">
          <a-form-item label="&nbsp;">
            <a-button type="primary" block>筛选</a-button>
          </a-form-item>
        </a-col>
      </a-row>
    </a-card>

    <!-- 日志列表 -->
    <a-card :bordered="false">
      <a-table :columns="columns" :data-source="logs" :pagination="pagination">
        <template #bodyCell="{ column, record }">
          <template v-if="column.key === 'status'">
            <a-tag color="success">成功</a-tag>
          </template>
        </template>
      </a-table>
    </a-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

// 日志数据
const logs = ref([
  { 
    time: '2024-08-23 09:45:12', 
    user: 'admin', 
    ip: '192.168.1.105', 
    type: '登录', 
    content: '用户登录系统' 
  },
  { 
    time: '2024-08-23 10:12:36', 
    user: 'operator01', 
    ip: '192.168.1.112', 
    type: '数据查询', 
    content: '查询今日发电量统计数据' 
  },
  { 
    time: '2024-08-23 11:05:47', 
    user: 'admin', 
    ip: '192.168.1.105', 
    type: '配置修改', 
    content: '修改光伏组件倾角优化参数' 
  },
  { 
    time: '2024-08-23 14:30:22', 
    user: 'admin', 
    ip: '192.168.1.105', 
    type: '系统管理', 
    content: '生成8月发电量统计报告' 
  },
  { 
    time: '2024-08-22 16:42:18', 
    user: 'admin', 
    ip: '192.168.1.100', 
    type: '系统管理', 
    content: '添加新用户operator' 
  }
]);

// 表格列
const columns = [
  {
    title: '时间',
    dataIndex: 'time',
    key: 'time'
  },
  {
    title: '用户',
    dataIndex: 'user',
    key: 'user'
  },
  {
    title: 'IP地址',
    dataIndex: 'ip',
    key: 'ip'
  },
  {
    title: '操作类型',
    dataIndex: 'type',
    key: 'type'
  },
  {
    title: '操作内容',
    dataIndex: 'content',
    key: 'content'
  },
  {
    title: '状态',
    key: 'status'
  }
];

// 分页信息
const pagination = ref({
  current: 1,
  pageSize: 10,
  total: 5
});

onMounted(() => {
  console.log('操作日志页面加载完成');
});
</script>

<style scoped>
.operation-log {
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

.filter-row {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}

.filter-label {
  color: #666;
}

.ml-2 {
  margin-left: 8px;
}
</style>