<template>
  <div class="system-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">系统管理</h2>
        <a-tag color="processing" class="subtitle">用户管理与操作日志</a-tag>
      </div>
      <div class="header-actions">
        <a-button type="default" @click="exportData">
          <template #icon>
            <font-awesome-icon icon="download" />
          </template>
          导出数据
        </a-button>
        <a-button 
          type="primary" 
          @click="showAddUserModal = true"
          v-if="authStore.isAdmin"
        >
          <template #icon>
            <font-awesome-icon icon="user-plus" />
          </template>
          添加用户
        </a-button>
      </div>
    </div>

    <!-- 统计概览卡片 -->
    <a-row :gutter="[16, 16]" class="stats-row">
      <a-col :xs="24" :sm="6" :lg="6">
        <a-card :bordered="false" class="stat-card">
          <a-statistic
            title="总用户数"
            :value="userStats.total"
            :value-style="{ color: '#1890ff' }"
          >
            <template #prefix>
              <font-awesome-icon icon="users" />
            </template>
          </a-statistic>
        </a-card>
      </a-col>
      <a-col :xs="24" :sm="6" :lg="6">
        <a-card :bordered="false" class="stat-card">
          <a-statistic
            title="管理员"
            :value="userStats.admins"
            :value-style="{ color: '#52c41a' }"
          >
            <template #prefix>
              <font-awesome-icon icon="user-shield" />
            </template>
          </a-statistic>
        </a-card>
      </a-col>
      <a-col :xs="24" :sm="6" :lg="6">
        <a-card :bordered="false" class="stat-card">
          <a-statistic
            title="操作员"
            :value="userStats.operators"
            :value-style="{ color: '#faad14' }"
          >
            <template #prefix>
              <font-awesome-icon icon="user-cog" />
            </template>
          </a-statistic>
        </a-card>
      </a-col>
      <a-col :xs="24" :sm="6" :lg="6">
        <a-card :bordered="false" class="stat-card">
          <a-statistic
            title="今日操作"
            :value="userStats.todayOperations"
            :value-style="{ color: '#722ed1' }"
          >
            <template #prefix>
              <font-awesome-icon icon="chart-line" />
            </template>
          </a-statistic>
        </a-card>
      </a-col>
    </a-row>

    <!-- 上层：用户管理卡片 -->
    <a-row :gutter="[24, 24]">
      <a-col :xs="24">
        <a-card title="用户管理" :bordered="false" class="user-management-card">
          <template #extra>
            <a-space>
              <a-input-search 
                placeholder="搜索用户名..." 
                style="width: 200px" 
                v-model:value="userSearchText"
                @search="searchUsers"
                allow-clear
              />
              <a-select 
                v-model:value="roleFilter" 
                style="width: 120px" 
                @change="filterByRole"
                placeholder="筛选角色"
              >
                <a-select-option value="">全部角色</a-select-option>
                <a-select-option value="admin">管理员</a-select-option>
                <a-select-option value="operator">操作员</a-select-option>
              </a-select>
            </a-space>
          </template>
          
          <a-table 
            :columns="userColumns" 
            :data-source="filteredUsers" 
            :pagination="userPagination"
            size="middle"
            :scroll="{ x: 800 }"
          >
            <template #bodyCell="{ column, record }">
              <template v-if="column.key === 'user'">
                <div class="user-info">
                  <a-avatar :style="{ backgroundColor: getUserAvatarColor(record.role) }">
                    {{ record.username.charAt(0) }}
                  </a-avatar>
                  <div class="user-details">
                    <div class="user-name">{{ record.username }}</div>
                    <div class="user-id">ID: {{ record.id }}</div>
                  </div>
                </div>
              </template>
              <template v-else-if="column.key === 'role'">
                <a-tag :color="getRoleColor(record.role)">
                  {{ getRoleText(record.role) }}
                </a-tag>
              </template>
              <template v-else-if="column.key === 'status'">
                <a-badge status="success" text="活跃" />
              </template>
              <template v-else-if="column.key === 'lastLogin'">
                <span class="last-login">{{ formatTime(record.lastLogin) }}</span>
              </template>
              <template v-else-if="column.key === 'action'">
                <a-space>
                  <a-button 
                    type="link" 
                    size="small" 
                    @click="viewUser(record)"
                  >
                    <template #icon>
                      <font-awesome-icon icon="eye" />
                    </template>
                    查看
                  </a-button>
                  <a-button 
                    type="link" 
                    size="small" 
                    @click="editUser(record)"
                    v-if="authStore.isAdmin"
                  >
                    <template #icon>
                      <font-awesome-icon icon="edit" />
                    </template>
                    编辑
                  </a-button>
                  <a-button 
                    type="link" 
                    size="small" 
                    @click="resetPassword(record)"
                    v-if="authStore.isAdmin && record.username !== 'master'"
                  >
                    <template #icon>
                      <font-awesome-icon icon="key" />
                    </template>
                    重置密码
                  </a-button>
                  <a-popconfirm
                    title="确定要删除这个用户吗？"
                    @confirm="deleteUser(record)"
                    v-if="authStore.isAdmin && record.username !== 'master'"
                  >
                    <a-button type="link" size="small" danger>
                      <template #icon>
                        <font-awesome-icon icon="trash" />
                      </template>
                      删除
                    </a-button>
                  </a-popconfirm>
                </a-space>
              </template>
            </template>
          </a-table>
        </a-card>
      </a-col>
    </a-row>

    <!-- 下层：操作日志卡片 -->
    <a-row :gutter="[24, 24]" class="operation-log-section">
      <a-col :xs="24" :lg="16">
        <a-card title="操作日志统计" :bordered="false" class="log-chart-card">
          <template #extra>
            <a-select 
              v-model:value="chartTimeRange" 
              style="width: 120px" 
              @change="updateChartData"
            >
              <a-select-option value="7">最近7天</a-select-option>
              <a-select-option value="15">最近15天</a-select-option>
              <a-select-option value="30">最近30天</a-select-option>
            </a-select>
          </template>
          
          <div class="chart-container">
            <ECharts :option="operationChartOption" :loading="chartLoading" />
          </div>
        </a-card>
      </a-col>
      
      <a-col :xs="24" :lg="8">
        <a-card title="操作类型分布" :bordered="false" class="log-pie-card">
          <div class="pie-chart-container">
            <ECharts :option="operationPieOption" :loading="chartLoading" />
          </div>
        </a-card>
      </a-col>
    </a-row>

    <!-- 操作日志详细列表 -->
    <a-row :gutter="[24, 24]">
      <a-col :xs="24">
        <a-card title="操作日志详情" :bordered="false" class="log-details-card">
          <template #extra>
            <a-space>
              <a-select 
                v-model:value="logFilter.user" 
                style="width: 120px" 
                placeholder="筛选用户"
                allow-clear
              >
                <a-select-option value="">全部用户</a-select-option>
                <a-select-option v-for="user in users" :key="user.id" :value="user.username">
                  {{ user.username }}
                </a-select-option>
              </a-select>
              <a-select 
                v-model:value="logFilter.type" 
                style="width: 120px" 
                placeholder="操作类型"
                allow-clear
              >
                <a-select-option value="">全部类型</a-select-option>
                <a-select-option value="登录">登录</a-select-option>
                <a-select-option value="用户管理">用户管理</a-select-option>
                <a-select-option value="系统操作">系统操作</a-select-option>
                <a-select-option value="数据查询">数据查询</a-select-option>
              </a-select>
              <a-range-picker v-model:value="logFilter.dateRange" />
              <a-button type="primary" @click="filterLogs">筛选</a-button>
            </a-space>
          </template>
          
          <a-table 
            :columns="logColumns" 
            :data-source="filteredLogs" 
            :pagination="logPagination"
            size="small"
          >
            <template #bodyCell="{ column, record }">
              <template v-if="column.key === 'user'">
                <a-space>
                  <a-avatar size="small" :style="{ backgroundColor: getUserAvatarColor(record.userRole) }">
                    {{ record.user.charAt(0) }}
                  </a-avatar>
                  <span>{{ record.user }}</span>
                </a-space>
              </template>
              <template v-else-if="column.key === 'type'">
                <a-tag :color="getLogTypeColor(record.type)" size="small">
                  {{ record.type }}
                </a-tag>
              </template>
              <template v-else-if="column.key === 'status'">
                <a-badge status="success" text="成功" />
              </template>
            </template>
          </a-table>
        </a-card>
      </a-col>
    </a-row>

    <!-- 添加用户模态框 -->
    <a-modal
      v-model:open="showAddUserModal"
      title="添加新用户"
      :confirm-loading="addUserLoading"
      @ok="handleAddUser"
      @cancel="resetAddUserForm"
    >
      <a-form
        ref="addUserFormRef"
        :model="addUserForm"
        :rules="addUserRules"
        layout="vertical"
      >
        <a-form-item label="用户名" name="username">
          <a-input v-model:value="addUserForm.username" placeholder="请输入用户名" />
        </a-form-item>
        <a-form-item label="密码" name="password">
          <a-input-password v-model:value="addUserForm.password" placeholder="请输入密码" />
        </a-form-item>
        <a-form-item label="确认密码" name="confirmPassword">
          <a-input-password v-model:value="addUserForm.confirmPassword" placeholder="请再次输入密码" />
        </a-form-item>
        <a-form-item label="角色" name="role">
          <a-select v-model:value="addUserForm.role" placeholder="请选择角色">
            <a-select-option value="admin">管理员</a-select-option>
            <a-select-option value="operator">操作员</a-select-option>
          </a-select>
        </a-form-item>
      </a-form>
    </a-modal>

    <!-- 编辑用户模态框 -->
    <a-modal
      v-model:open="showEditUserModal"
      title="编辑用户信息"
      :confirm-loading="editUserLoading"
      @ok="handleEditUser"
      @cancel="resetEditUserForm"
    >
      <a-form
        ref="editUserFormRef"
        :model="editUserForm"
        :rules="editUserRules"
        layout="vertical"
      >
        <a-form-item label="用户名" name="username">
          <a-input 
            v-model:value="editUserForm.username" 
            placeholder="请输入用户名"
            :disabled="editUserForm.originalUsername === 'master'"
          />
        </a-form-item>
        <a-form-item label="角色" name="role">
          <a-select 
            v-model:value="editUserForm.role" 
            placeholder="请选择角色"
            :disabled="editUserForm.originalUsername === 'master'"
          >
            <a-select-option value="admin">管理员</a-select-option>
            <a-select-option value="operator">操作员</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="新密码" name="password">
          <a-input-password v-model:value="editUserForm.password" placeholder="留空则不修改密码" />
        </a-form-item>
        <a-form-item label="确认新密码" name="confirmPassword" v-if="editUserForm.password">
          <a-input-password v-model:value="editUserForm.confirmPassword" placeholder="请再次输入新密码" />
        </a-form-item>
      </a-form>
    </a-modal>

    <!-- 查看用户模态框 -->
    <a-modal
      v-model:open="showViewUserModal"
      title="用户详细信息"
      :footer="null"
      width="600px"
    >
      <div class="user-detail-content" v-if="viewUserData">
        <a-descriptions :column="2" bordered>
          <a-descriptions-item label="用户名">
            {{ viewUserData.username }}
          </a-descriptions-item>
          <a-descriptions-item label="角色">
            <a-tag :color="getRoleColor(viewUserData.role)">
              {{ getRoleText(viewUserData.role) }}
            </a-tag>
          </a-descriptions-item>
          <a-descriptions-item label="用户ID">
            {{ viewUserData.id }}
          </a-descriptions-item>
          <a-descriptions-item label="状态">
            <a-badge status="success" text="活跃" />
          </a-descriptions-item>
          <a-descriptions-item label="创建时间">
            {{ viewUserData.createdAt }}
          </a-descriptions-item>
          <a-descriptions-item label="最后登录">
            {{ formatTime(viewUserData.lastLogin) }}
          </a-descriptions-item>
        </a-descriptions>
        
        <a-divider>最近操作记录</a-divider>
        <div class="user-operations">
          <a-timeline size="small">
            <a-timeline-item 
              v-for="log in getUserOperations(viewUserData.username)" 
              :key="log.id"
              :color="getLogTypeColor(log.type)"
            >
              <div class="operation-item">
                <div class="operation-header">
                  <span class="operation-type">{{ log.type }}</span>
                  <span class="operation-time">{{ log.time }}</span>
                </div>
                <div class="operation-content">{{ log.content }}</div>
              </div>
            </a-timeline-item>
          </a-timeline>
        </div>
      </div>
    </a-modal>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, reactive } from 'vue';
import { message } from 'ant-design-vue';
import { useAuthStore } from '@/stores/auth';
import ECharts from '@/components/common/ECharts.vue';

// 认证store
const authStore = useAuthStore();

// 数据状态
const users = ref([
  {
    id: 1,
    username: 'master',
    role: 'admin',
    createdAt: '2024-01-01 00:00:00',
    lastLogin: '2024-08-25 09:30:00'
  },
  {
    id: 2,
    username: 'admin',
    role: 'admin',
    createdAt: '2024-01-02 10:00:00',
    lastLogin: '2024-08-24 16:45:00'
  },
  {
    id: 3,
    username: '张工',
    role: 'operator',
    createdAt: '2024-01-15 14:30:00',
    lastLogin: '2024-08-25 08:15:00'
  },
  {
    id: 4,
    username: '陈工',
    role: 'operator',
    createdAt: '2024-02-01 09:00:00',
    lastLogin: '2024-08-24 17:20:00'
  }
]);

const operationLogs = ref([
  {
    id: 1,
    time: '2024-08-25 09:30:12',
    user: 'master',
    userRole: 'admin',
    ip: '192.168.1.100',
    type: '登录',
    content: '用户登录系统'
  },
  {
    id: 2,
    time: '2024-08-25 09:35:24',
    user: 'master',
    userRole: 'admin',
    ip: '192.168.1.100',
    type: '用户管理',
    content: '添加新用户 张工'
  },
  {
    id: 3,
    time: '2024-08-25 08:15:36',
    user: '张工',
    userRole: 'operator',
    ip: '192.168.1.105',
    type: '登录',
    content: '用户登录系统'
  },
  {
    id: 4,
    time: '2024-08-25 08:20:45',
    user: '张工',
    userRole: 'operator',
    ip: '192.168.1.105',
    type: '数据查询',
    content: '查看发电量预测数据'
  },
  {
    id: 5,
    time: '2024-08-24 17:20:18',
    user: '陈工',
    userRole: 'operator',
    ip: '192.168.1.108',
    type: '系统操作',
    content: '查看设备运行状态'
  },
  {
    id: 6,
    time: '2024-08-24 16:45:30',
    user: 'admin',
    userRole: 'admin',
    ip: '192.168.1.102',
    type: '用户管理',
    content: '重置用户 陈工 密码'
  },
  {
    id: 7,
    time: '2024-08-24 15:30:22',
    user: '张工',
    userRole: 'operator',
    ip: '192.168.1.105',
    type: '数据查询',
    content: '导出设备状态报告'
  },
  {
    id: 8,
    time: '2024-08-24 14:15:45',
    user: '陈工',
    userRole: 'operator',
    ip: '192.168.1.108',
    type: '系统操作',
    content: '查看操作日志'
  }
]);

// 搜索和筛选
const userSearchText = ref('');
const roleFilter = ref('');
const chartTimeRange = ref('7');
const chartLoading = ref(false);

// 日志筛选
const logFilter = reactive({
  user: '',
  type: '',
  dateRange: []
});

// 模态框状态
const showAddUserModal = ref(false);
const showEditUserModal = ref(false);
const showViewUserModal = ref(false);
const addUserLoading = ref(false);
const editUserLoading = ref(false);

// 表单数据
const addUserForm = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  role: 'operator'
});

const editUserForm = reactive({
  id: null,
  username: '',
  originalUsername: '',
  role: '',
  password: '',
  confirmPassword: ''
});

const viewUserData = ref(null);

// 表单引用
const addUserFormRef = ref();
const editUserFormRef = ref();

// 计算属性
const userStats = computed(() => ({
  total: users.value.length,
  admins: users.value.filter(u => u.role === 'admin').length,
  operators: users.value.filter(u => u.role === 'operator').length,
  todayOperations: operationLogs.value.filter(log => 
    log.time.startsWith('2024-08-25')
  ).length
}));

const filteredUsers = computed(() => {
  let filtered = users.value;
  
  if (userSearchText.value) {
    filtered = filtered.filter(user =>
      user.username.toLowerCase().includes(userSearchText.value.toLowerCase())
    );
  }
  
  if (roleFilter.value) {
    filtered = filtered.filter(user => user.role === roleFilter.value);
  }
  
  return filtered;
});

const filteredLogs = computed(() => {
  let logs = operationLogs.value;
  
  if (logFilter.user) {
    logs = logs.filter(log => log.user === logFilter.user);
  }
  
  if (logFilter.type) {
    logs = logs.filter(log => log.type === logFilter.type);
  }
  
  return logs.sort((a, b) => new Date(b.time) - new Date(a.time));
});

// ECharts配置
const operationChartOption = computed(() => {
  const days = [];
  const data = [];
  
  for (let i = parseInt(chartTimeRange.value) - 1; i >= 0; i--) {
    const date = new Date();
    date.setDate(date.getDate() - i);
    const dateStr = `${date.getMonth() + 1}-${date.getDate()}`;
    days.push(dateStr);
    
    // 模拟数据
    const count = Math.floor(Math.random() * 20) + 5;
    data.push(count);
  }
  
  return {
    title: {
      text: `最近${chartTimeRange.value}天操作统计`,
      textStyle: {
        fontSize: 14,
        fontWeight: 'normal',
        color: '#666'
      },
      left: 'center'
    },
    tooltip: {
      trigger: 'axis',
      backgroundColor: 'rgba(255, 255, 255, 0.95)',
      borderColor: '#ccc',
      borderWidth: 1
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
      data: days,
      axisLine: {
        lineStyle: { color: '#e8e8e8' }
      },
      axisLabel: {
        color: '#666',
        fontSize: 12
      }
    },
    yAxis: {
      type: 'value',
      name: '操作次数',
      nameTextStyle: {
        color: '#666',
        fontSize: 12
      },
      axisLine: {
        lineStyle: { color: '#e8e8e8' }
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
    series: [{
      data: data,
      type: 'line',
      smooth: true,
      areaStyle: {
        color: {
          type: 'linear',
          x: 0, y: 0, x2: 0, y2: 1,
          colorStops: [
            { offset: 0, color: 'rgba(24, 144, 255, 0.3)' },
            { offset: 1, color: 'rgba(24, 144, 255, 0.05)' }
          ]
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

const operationPieOption = computed(() => {
  const typeStats = {};
  operationLogs.value.forEach(log => {
    typeStats[log.type] = (typeStats[log.type] || 0) + 1;
  });
  
  const data = Object.entries(typeStats).map(([type, count]) => ({
    name: type,
    value: count
  }));
  
  return {
    title: {
      text: '操作类型分布',
      textStyle: {
        fontSize: 14,
        fontWeight: 'normal',
        color: '#666'
      },
      left: 'center',
      top: '10px'
    },
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b}: {c} ({d}%)'
    },
    legend: {
      orient: 'vertical',
      left: 'left',
      top: 'middle',
      textStyle: {
        color: '#666',
        fontSize: 12
      }
    },
    series: [{
      name: '操作类型',
      type: 'pie',
      radius: ['40%', '70%'],
      center: ['60%', '55%'],
      avoidLabelOverlap: true,
      label: {
        show: false
      },
      labelLine: {
        show: false
      },
      data: data,
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      }
    }]
  };
});

// 表格配置
const userColumns = [
  {
    title: '用户信息',
    key: 'user',
    width: 200,
    fixed: 'left'
  },
  {
    title: '角色',
    key: 'role',
    width: 100
  },
  {
    title: '创建时间',
    dataIndex: 'createdAt',
    key: 'createdAt',
    width: 150
  },
  {
    title: '最后登录',
    key: 'lastLogin',
    width: 150
  },
  {
    title: '状态',
    key: 'status',
    width: 80
  },
  {
    title: '操作',
    key: 'action',
    width: 200,
    fixed: 'right'
  }
];

const logColumns = [
  {
    title: '时间',
    dataIndex: 'time',
    key: 'time',
    width: 150
  },
  {
    title: '用户',
    key: 'user',
    width: 120
  },
  {
    title: 'IP地址',
    dataIndex: 'ip',
    key: 'ip',
    width: 120
  },
  {
    title: '操作类型',
    key: 'type',
    width: 100
  },
  {
    title: '操作内容',
    dataIndex: 'content',
    key: 'content'
  },
  {
    title: '状态',
    key: 'status',
    width: 80
  }
];

const userPagination = {
  pageSize: 10,
  showSizeChanger: true,
  showQuickJumper: true
};

const logPagination = {
  pageSize: 10,
  showSizeChanger: true,
  showQuickJumper: true
};

// 表单验证规则
const addUserRules = {
  username: [
    { required: true, message: '请输入用户名' },
    { min: 2, max: 20, message: '用户名长度应在2-20个字符之间' }
  ],
  password: [
    { required: true, message: '请输入密码' },
    { min: 3, message: '密码长度至少3个字符' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码' },
    {
      validator: (rule, value) => {
        if (value !== addUserForm.password) {
          return Promise.reject('两次输入的密码不一致');
        }
        return Promise.resolve();
      }
    }
  ],
  role: [
    { required: true, message: '请选择角色' }
  ]
};

const editUserRules = {
  username: [
    { required: true, message: '请输入用户名' },
    { min: 2, max: 20, message: '用户名长度应在2-20个字符之间' }
  ],
  role: [
    { required: true, message: '请选择角色' }
  ],
  confirmPassword: [
    {
      validator: (rule, value) => {
        if (editUserForm.password && value !== editUserForm.password) {
          return Promise.reject('两次输入的密码不一致');
        }
        return Promise.resolve();
      }
    }
  ]
};

// 工具函数
const getUserAvatarColor = (role) => {
  return role === 'admin' ? '#52c41a' : '#1890ff';
};

const getRoleColor = (role) => {
  return role === 'admin' ? 'green' : 'blue';
};

const getRoleText = (role) => {
  return role === 'admin' ? '管理员' : '操作员';
};

const getLogTypeColor = (type) => {
  const colorMap = {
    '登录': 'green',
    '用户管理': 'blue',
    '系统操作': 'orange',
    '数据查询': 'purple'
  };
  return colorMap[type] || 'default';
};

const formatTime = (time) => {
  if (!time) return '-';
  const now = new Date();
  const logTime = new Date(time);
  const diff = now - logTime;
  
  if (diff < 60000) return '刚刚';
  if (diff < 3600000) return `${Math.floor(diff / 60000)}分钟前`;
  if (diff < 86400000) return `${Math.floor(diff / 3600000)}小时前`;
  return time.split(' ')[0];
};

const getUserOperations = (username) => {
  return operationLogs.value
    .filter(log => log.user === username)
    .slice(0, 5)
    .sort((a, b) => new Date(b.time) - new Date(a.time));
};

// 事件处理函数
const searchUsers = () => {
  // 搜索逻辑已在计算属性中处理
};

const filterByRole = () => {
  // 筛选逻辑已在计算属性中处理
};

const filterLogs = () => {
  // 筛选逻辑已在计算属性中处理
};

const updateChartData = () => {
  chartLoading.value = true;
  setTimeout(() => {
    chartLoading.value = false;
  }, 500);
};

const exportData = () => {
  message.success('数据导出功能开发中...');
};

// 用户操作
const viewUser = (record) => {
  viewUserData.value = record;
  showViewUserModal.value = true;
};

const editUser = (record) => {
  Object.assign(editUserForm, {
    id: record.id,
    username: record.username,
    originalUsername: record.username,
    role: record.role,
    password: '',
    confirmPassword: ''
  });
  showEditUserModal.value = true;
};

const resetPassword = (record) => {
  message.success(`已重置用户 ${record.username} 的密码为默认密码`);
  
  // 添加操作日志
  operationLogs.value.unshift({
    id: operationLogs.value.length + 1,
    time: new Date().toISOString().slice(0, 19).replace('T', ' '),
    user: authStore.username,
    userRole: authStore.user?.role || 'admin',
    ip: '192.168.1.100',
    type: '用户管理',
    content: `重置用户 ${record.username} 密码`
  });
};

const deleteUser = (record) => {
  const userIndex = users.value.findIndex(u => u.id === record.id);
  if (userIndex !== -1) {
    users.value.splice(userIndex, 1);
    
    // 添加操作日志
    operationLogs.value.unshift({
      id: operationLogs.value.length + 1,
      time: new Date().toISOString().slice(0, 19).replace('T', ' '),
      user: authStore.username,
      userRole: authStore.user?.role || 'admin',
      ip: '192.168.1.100',
      type: '用户管理',
      content: `删除用户 ${record.username}`
    });
    
    message.success('用户删除成功');
  }
};

const handleAddUser = async () => {
  try {
    await addUserFormRef.value.validateFields();
    addUserLoading.value = true;
    
    // 模拟API调用
    setTimeout(() => {
      const newUser = {
        id: users.value.length + 1,
        username: addUserForm.username,
        role: addUserForm.role,
        createdAt: new Date().toISOString().slice(0, 19).replace('T', ' '),
        lastLogin: '-'
      };
      
      users.value.push(newUser);
      
      // 添加操作日志
      operationLogs.value.unshift({
        id: operationLogs.value.length + 1,
        time: new Date().toISOString().slice(0, 19).replace('T', ' '),
        user: authStore.username,
        userRole: authStore.user?.role || 'admin',
        ip: '192.168.1.100',
        type: '用户管理',
        content: `添加新用户 ${addUserForm.username}`
      });
      
      message.success('用户添加成功');
      addUserLoading.value = false;
      showAddUserModal.value = false;
      resetAddUserForm();
    }, 1000);
  } catch (error) {
    console.error('表单验证失败:', error);
  }
};

const resetAddUserForm = () => {
  Object.assign(addUserForm, {
    username: '',
    password: '',
    confirmPassword: '',
    role: 'operator'
  });
  addUserFormRef.value?.resetFields();
};

const handleEditUser = async () => {
  try {
    await editUserFormRef.value.validateFields();
    editUserLoading.value = true;
    
    // 模拟API调用
    setTimeout(() => {
      const userIndex = users.value.findIndex(u => u.id === editUserForm.id);
      if (userIndex !== -1) {
        users.value[userIndex].username = editUserForm.username;
        users.value[userIndex].role = editUserForm.role;
        
        // 添加操作日志
        operationLogs.value.unshift({
          id: operationLogs.value.length + 1,
          time: new Date().toISOString().slice(0, 19).replace('T', ' '),
          user: authStore.username,
          userRole: authStore.user?.role || 'admin',
          ip: '192.168.1.100',
          type: '用户管理',
          content: `编辑用户 ${editUserForm.originalUsername} 信息`
        });
        
        message.success('用户信息更新成功');
      }
      
      editUserLoading.value = false;
      showEditUserModal.value = false;
      resetEditUserForm();
    }, 1000);
  } catch (error) {
    console.error('表单验证失败:', error);
  }
};

const resetEditUserForm = () => {
  Object.assign(editUserForm, {
    id: null,
    username: '',
    originalUsername: '',
    role: '',
    password: '',
    confirmPassword: ''
  });
  editUserFormRef.value?.resetFields();
};

onMounted(() => {
  console.log('系统管理页面加载完成');
  updateChartData();
});
</script>

<style scoped>
.system-management {
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

/* 卡片样式 */
.user-management-card,
.log-chart-card,
.log-pie-card,
.log-details-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid #f0f0f0;
  margin-bottom: 24px;
}

.operation-log-section {
  margin-top: 24px;
  margin-bottom: 24px;
}

/* 用户信息样式 */
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
  font-weight: 600;
  color: #262626;
  font-size: 14px;
}

.user-id {
  font-size: 12px;
  color: #8c8c8c;
}

.last-login {
  color: #666;
  font-size: 13px;
}

/* 图表容器 */
.chart-container {
  height: 300px;
  width: 100%;
}

.pie-chart-container {
  height: 300px;
  width: 100%;
}

/* 用户详情模态框 */
.user-detail-content {
  padding: 16px 0;
}

.user-operations {
  max-height: 300px;
  overflow-y: auto;
}

.operation-item {
  padding: 8px 0;
}

.operation-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 4px;
}

.operation-type {
  font-weight: 500;
  color: #1890ff;
}

.operation-time {
  font-size: 12px;
  color: #999;
}

.operation-content {
  font-size: 13px;
  color: #666;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .system-management {
    padding: 16px;
  }
  
  .page-header {
    padding: 16px 20px;
  }
  
  .page-title {
    font-size: 24px;
  }
  
  .chart-container,
  .pie-chart-container {
    height: 250px;
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
  
  .chart-container,
  .pie-chart-container {
    height: 200px;
  }
}

/* 动画效果 */
.stat-card,
.user-management-card,
.log-chart-card,
.log-pie-card,
.log-details-card {
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

/* 深度样式 */
:deep(.ant-card-head-title) {
  font-weight: 600;
  color: #262626;
  font-size: 16px;
}

:deep(.ant-card-extra) {
  color: #8c8c8c;
  font-size: 12px;
}

:deep(.ant-statistic-title) {
  font-weight: 500;
  color: #8c8c8c;
  margin-bottom: 8px;
}

:deep(.ant-statistic-content) {
  font-weight: 600;
}

:deep(.ant-table-thead > tr > th) {
  background-color: #fafafa;
  font-weight: 600;
}
</style>
