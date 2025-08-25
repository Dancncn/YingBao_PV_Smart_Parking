<template>
  <div class="user-permissions">
    <div class="page-header">
      <h2 class="page-title">用户权限管理</h2>
      <a-button type="primary">
        <template #icon>
          <font-awesome-icon icon="user-plus" />
        </template>
        添加用户
      </a-button>
    </div>

    <!-- 用户列表 -->
    <a-card :bordered="false" class="mb-6">
      <div class="table-header">
        <div></div>
        <a-input-search placeholder="搜索用户名或邮箱..." style="width: 250px" />
      </div>
      <a-table :columns="userColumns" :data-source="users" :pagination="userPagination">
        <template #bodyCell="{ column, record }">
          <template v-if="column.key === 'user'">
            <div class="user-info">
              <a-avatar :src="record.avatar" />
              <div class="user-details">
                <div class="user-name">{{ record.username }}</div>
                <div class="user-fullname">{{ record.name }}</div>
              </div>
            </div>
          </template>
          <template v-else-if="column.key === 'status'">
            <a-tag color="success">活跃</a-tag>
          </template>
          <template v-else-if="column.key === 'action'">
            <a-button type="link">编辑</a-button>
            <a-button type="link">权限</a-button>
            <a-button type="link">重置密码</a-button>
          </template>
        </template>
      </a-table>
    </a-card>

    <!-- 角色权限设置 -->
    <!-- 注释掉角色权限设置部分以避免冲突 -->
    <!--
    <a-card title="角色权限设置" :bordered="false">
      <a-row :gutter="24">
        <a-col :xs="24" :md="8">
          <h4 class="section-title">角色列表</h4>
          <div class="role-list">
            <a-button block :type="currentRole === 'admin' ? 'primary' : 'default'" @click="currentRole = 'admin'">
              系统管理员
            </a-button>
            <a-button block :type="currentRole === 'operator' ? 'primary' : 'default'" @click="currentRole = 'operator'">
              操作员
            </a-button>
            <a-button block :type="currentRole === 'viewer' ? 'primary' : 'default'" @click="currentRole = 'viewer'">
              查看者
            </a-button>
            <a-button block :type="currentRole === 'maintainer' ? 'primary' : 'default'" @click="currentRole = 'maintainer'">
              维护人员
            </a-button>
          </div>
        </a-col>
        
        <a-col :xs="24" :md="16">
          <h4 class="section-title">权限设置</h4>
          <div class="permission-settings">
            <a-card :bordered="false" class="permission-card">
              <template #title>
                <span>仪表盘权限</span>
              </template>
              <a-checkbox v-model:checked="permissions.dashboard.view">查看数据</a-checkbox>
              <a-checkbox v-model:checked="permissions.dashboard.export" class="ml-4">导出数据</a-checkbox>
            </a-card>
            
            <a-card :bordered="false" class="permission-card">
              <template #title>
                <span>设备管理权限</span>
              </template>
              <a-checkbox v-model:checked="permissions.device.view">查看设备</a-checkbox>
              <a-checkbox v-model:checked="permissions.device.add" class="ml-4">添加设备</a-checkbox>
              <a-checkbox v-model:checked="permissions.device.edit" class="ml-4">编辑设备</a-checkbox>
              <a-checkbox v-model:checked="permissions.device.delete" class="ml-4">删除设备</a-checkbox>
            </a-card>
            
            <a-card :bordered="false" class="permission-card">
              <template #title>
                <span>用户权限管理</span>
              </template>
              <a-checkbox v-model:checked="permissions.user.view">查看用户</a-checkbox>
              <a-checkbox v-model:checked="permissions.user.add" class="ml-4">添加用户</a-checkbox>
              <a-checkbox v-model:checked="permissions.user.edit" class="ml-4">编辑用户</a-checkbox>
              <a-checkbox v-model:checked="permissions.user.delete" class="ml-4">删除用户</a-checkbox>
            </a-card>
            
            <a-form-item>
              <a-button type="primary">保存权限设置</a-button>
            </a-form-item>
          </div>
        </a-col>
      </a-row>
    </a-card>
    -->
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';

// 当前选中角色
// const currentRole = ref('admin');

// 用户数据
const users = ref([
  { 
    username: 'admin', 
    name: '系统管理员', 
    email: 'admin@example.com', 
    role: '系统管理员', 
    department: '运维部', 
    lastLogin: '2024-08-23 09:45',
    avatar: 'https://picsum.photos/id/1005/32/32'
  },
  { 
    username: 'operator', 
    name: '张操作员', 
    email: 'operator@example.com', 
    role: '操作员', 
    department: '监控中心', 
    lastLogin: '2024-08-22 16:30',
    avatar: 'https://picsum.photos/id/1010/32/32'
  },
  { 
    username: 'viewer', 
    name: '李查看员', 
    email: 'viewer@example.com', 
    role: '查看者', 
    department: '数据分析部', 
    lastLogin: '2024-08-23 11:20',
    avatar: 'https://picsum.photos/id/1015/32/32'
  }
]);

// 权限数据
/*
const permissions = ref({
  dashboard: {
    view: true,
    export: true
  },
  device: {
    view: true,
    add: true,
    edit: true,
    delete: true
  },
  user: {
    view: true,
    add: true,
    edit: true,
    delete: true
  }
});
*/

// 用户表格列
const userColumns = [
  {
    title: '用户名',
    key: 'user'
  },
  {
    title: '邮箱',
    dataIndex: 'email',
    key: 'email'
  },
  {
    title: '角色',
    dataIndex: 'role',
    key: 'role'
  },
  {
    title: '部门',
    dataIndex: 'department',
    key: 'department'
  },
  {
    title: '最后登录',
    dataIndex: 'lastLogin',
    key: 'lastLogin'
  },
  {
    title: '状态',
    key: 'status'
  },
  {
    title: '操作',
    key: 'action'
  }
];

const userPagination = ref({
  pageSize: 10,
  total: 3
});

onMounted(() => {
  console.log('用户权限管理页面加载完成');
});
</script>

<style scoped>
.user-permissions {
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

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  flex-wrap: wrap;
  gap: 16px;
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

.user-name {
  font-weight: 500;
}

.user-fullname {
  font-size: 12px;
  color: #666;
}

.section-title {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 16px;
  color: #333;
}

.role-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.permission-settings {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.permission-card {
  border: 1px solid #e8e8e8;
  border-radius: 4px;
}

.permission-card :deep(.ant-card-head) {
  background: #fafafa;
  min-height: 36px;
  padding: 0 12px;
}

.permission-card :deep(.ant-card-head-title) {
  padding: 6px 0;
  font-size: 14px;
}

.ml-4 {
  margin-left: 16px;
}
</style>