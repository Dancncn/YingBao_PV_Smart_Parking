# 🌞 萤宝智能光伏停车场能源管理系统

<div align="center">

![Logo](frontend/src/assets/images/logo.png)

**一个现代化的智能光伏停车场能源管理系统**

[![Vue](https://img.shields.io/badge/Vue-3.x-4FC08D?style=flat-square&logo=vue.js)](https://vuejs.org/)
[![Flask](https://img.shields.io/badge/Flask-2.x-000000?style=flat-square&logo=flask)](https://flask.palletsprojects.com/)
[![Ant Design Vue](https://img.shields.io/badge/Ant%20Design%20Vue-4.x-0170FE?style=flat-square&logo=ant-design)](https://antdv.com/)
[![ECharts](https://img.shields.io/badge/ECharts-5.x-AA344D?style=flat-square&logo=apache-echarts)](https://echarts.apache.org/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

</div>

## 📖 项目简介

萤宝智能光伏停车场能源管理系统（YingBao PV Parking EMS）是一个基于现代Web技术栈开发的综合性能源管理平台。系统集成了实时监控、发电量预测、设备管理、用户权限控制等核心功能，为光伏停车场的智能化运营提供全方位支持。

## ✨ 主要特性

### 🎯 核心功能
- **实时监控面板**：实时展示发电量、设备状态、环境参数
- **发电量预测**：基于历史数据和天气预报的智能预测（7/15/30天）
- **设备管理**：光伏设备状态监控、故障诊断、维护计划
- **数据报告**：多维度数据分析和可视化报告
- **系统管理**：用户权限管理、操作日志记录
- **设备优化**：智能优化建议和能效分析

### 🎨 界面设计
- **现代化UI**：基于Ant Design Vue的专业界面设计
- **响应式布局**：完美适配桌面端、平板和移动设备
- **深色主题**：护眼的深色侧边栏和专业配色方案
- **动画效果**：流畅的交互动画和加载状态
- **数据可视化**：基于ECharts的专业图表展示

### 🔐 安全特性
- **JWT认证**：基于Token的安全认证机制
- **角色权限**：管理员和操作员分级权限控制
- **操作日志**：完整的用户操作记录和审计
- **会话管理**：自动登录状态检查和超时处理

## 🛠 技术栈

### 前端技术
- **框架**：Vue 3 + Composition API
- **UI组件**：Ant Design Vue 4.x
- **状态管理**：Pinia
- **路由管理**：Vue Router 4
- **图表库**：Apache ECharts 5.x
- **图标**：Font Awesome 6
- **构建工具**：Vite 4.x
- **样式**：CSS3 + 响应式设计

### 后端技术
- **框架**：Flask 2.x
- **数据库**：SQLite + SQLAlchemy ORM
- **认证**：Flask-JWT-Extended
- **密码加密**：bcrypt
- **跨域**：Flask-CORS
- **数据迁移**：Flask-Migrate

### 开发工具
- **环境管理**：Conda
- **版本控制**：Git
- **代码规范**：ESLint + Prettier
- **API测试**：内置Mock数据

## 📁 项目结构

```
PVparking/
├── frontend/                    # 前端Vue应用
│   ├── src/
│   │   ├── components/         # 通用组件
│   │   │   └── common/         # 公共组件
│   │   │       ├── ECharts.vue # 图表组件
│   │   │       ├── Header.vue  # 头部组件
│   │   │       ├── Sidebar.vue # 侧边栏组件
│   │   │       └── Footer.vue  # 底部组件
│   │   ├── views/              # 页面组件
│   │   │   ├── Dashboard.vue   # 仪表盘
│   │   │   ├── Prediction.vue  # 发电预测
│   │   │   ├── Report.vue      # 数据报告
│   │   │   ├── DeviceManagement.vue # 设备管理
│   │   │   ├── Optimization.vue # 设备优化
│   │   │   ├── SystemManagement.vue # 系统管理
│   │   │   └── Login.vue       # 登录页面
│   │   ├── stores/             # Pinia状态管理
│   │   │   └── auth.js         # 认证状态
│   │   ├── router/             # 路由配置
│   │   │   └── index.js
│   │   ├── assets/             # 静态资源
│   │   ├── App.vue             # 根组件
│   │   └── main.js             # 入口文件
│   ├── package.json
│   └── vite.config.js          # Vite配置
├── backend/                     # Flask后端应用
│   ├── app.py                  # 主应用文件
│   ├── config.py               # 配置文件
│   ├── requirements.txt        # Python依赖
│   ├── run.py                  # 运行脚本
│   ├── init_db.py             # 数据库初始化
│   ├── create_master.py        # 创建管理员账户
│   ├── create_operators.py     # 创建操作员账户
│   └── README.md               # 后端API文档
├── data/                       # 数据存储目录
│   └── app.db                  # SQLite数据库文件
├── setup_env.bat              # Windows环境配置脚本
├── setup_env.sh               # Linux/Mac环境配置脚本
├── start.bat                   # Windows启动脚本
├── start.sh                    # Linux/Mac启动脚本
├── .gitignore                  # Git忽略配置
└── README.md                   # 项目说明文档
```

## 🚀 快速开始

### 环境要求

- **Python**: 3.9+
- **Node.js**: 16+
- **Conda**: Anaconda或Miniconda
- **npm**: 8+

### 一键环境配置

我们提供了自动化的环境配置脚本，可以一键完成所有环境的搭建：

#### Windows系统
```batch
# 双击运行或在命令行执行
setup_env.bat
```

#### Linux/Mac系统
```bash
# 赋予执行权限并运行
chmod +x setup_env.sh
./setup_env.sh
```

### 手动安装步骤

如果您prefer手动安装，请按以下步骤操作：

#### 1. 创建Conda环境
```bash
# 创建名为YingBao的conda环境
conda create -n YingBao python=3.9 -y

# 激活环境
conda activate YingBao
```

#### 2. 安装后端依赖
```bash
cd backend
pip install -r requirements.txt
```

#### 3. 安装前端依赖
```bash
cd frontend
npm install
```

#### 4. 初始化数据库
```bash
cd backend
python init_db.py
python create_master.py
python create_operators.py
```

### 启动系统

#### 方法一：使用启动脚本
```bash
# Windows
start.bat

# Linux/Mac  
./start.sh
```

#### 方法二：手动启动
```bash
# 启动后端（终端1）
cd backend
conda activate YingBao
python run.py

# 启动前端（终端2）
cd frontend
npm run dev
```

### 访问系统

打开浏览器访问：http://localhost:3000

## 👤 默认账户

系统预设了以下测试账户：

| 用户名 | 密码 | 角色 | 权限描述 |
|--------|------|------|----------|
| master | 123 | 管理员 | 完整系统管理权限 |
| admin | 123 | 管理员 | 完整系统管理权限 |
| 张工 | 123 | 操作员 | 只读权限，无法编辑用户 |
| 陈工 | 123 | 操作员 | 只读权限，无法编辑用户 |

## 📊 功能模块详解

### 🏠 实时监控面板
- 实时发电量监控
- 设备运行状态
- 环境参数显示
- 关键指标统计
- 告警信息展示

### 📈 发电量预测
- 7天/15天/30天预测
- 基于历史数据分析
- 天气因素考虑
- 交互式图表展示
- 数据缩放和筛选

### 📋 数据报告中心
- 发电量统计报告
- 设备效率分析
- 环境影响评估
- 收益分析报告
- 数据导出功能

### 🔧 设备管理
- 设备状态监控
- 故障诊断
- 维护记录
- 性能分析
- 设备档案管理

### ⚙️ 设备优化
- 智能优化建议
- 能效分析
- 参数调优
- 维护计划
- 成本效益分析

### 👥 系统管理
- **用户管理**：
  - 用户列表查看
  - 用户信息编辑（管理员）
  - 密码重置
  - 角色权限管理
- **操作日志**：
  - 完整操作记录
  - 日志搜索筛选
  - 操作统计分析
  - 数据可视化

## 🎨 界面展示

### 登录界面
- 现代化设计风格
- 快速登录选项
- 后端状态检测
- 响应式布局

### 主界面
- 深色侧边栏导航
- 专业数据卡片
- 交互式图表
- 实时数据更新

### 系统管理
- 用户权限控制
- 操作日志可视化
- 统计数据展示
- 批量操作支持

## 🔧 配置说明

### 前端配置 (vite.config.js)
```javascript
export default {
  server: {
    port: 3000,
    proxy: {
      '/api': 'http://localhost:5000'
    }
  }
}
```

### 后端配置 (config.py)
```python
class Config:
    SQLALCHEMY_DATABASE_URI = 'sqlite:///../data/app.db'
    JWT_SECRET_KEY = 'your-secret-key'
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=24)
```

## 📝 开发指南

### 添加新页面
1. 在 `frontend/src/views/` 创建Vue组件
2. 在 `frontend/src/router/index.js` 添加路由
3. 在 `frontend/src/components/common/Sidebar.vue` 添加菜单项

### 添加新API
1. 在 `backend/app.py` 添加路由处理函数
2. 更新数据模型（如需要）
3. 在前端添加API调用

### 自定义主题
修改 `frontend/src/App.vue` 中的CSS变量：
```css
:root {
  --primary-color: #1890ff;
  --success-color: #52c41a;
  --warning-color: #faad14;
  --error-color: #ff4d4f;
}
```

## 🧪 测试

### 运行测试
```bash
# 前端测试
cd frontend
npm run test

# 后端测试
cd backend
python -m pytest
```

## 📦 生产部署

### 构建前端
```bash
cd frontend
npm run build
```

### 配置生产环境
1. 设置环境变量
2. 配置反向代理（Nginx）
3. 设置SSL证书
4. 配置数据库

## 🤝 贡献指南

1. Fork本项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建Pull Request

## 📄 许可证

本项目基于 [MIT License](LICENSE) 开源协议。

## 🆘 常见问题

### Q: 端口被占用怎么办？
A: 修改 `frontend/vite.config.js` 中的端口配置，或使用 `netstat` 命令查找并关闭占用端口的进程。

### Q: 数据库初始化失败？
A: 确保 `data/` 目录存在，并检查Python环境是否正确激活。

### Q: 前端依赖安装失败？
A: 尝试清除npm缓存：`npm cache clean --force`，然后重新安装。

### Q: 后端API请求失败？
A: 检查后端服务是否正常启动，确认端口5000未被占用。

## 📞 技术支持

如果您在使用过程中遇到问题，请通过以下方式联系我们：

- 📧 邮箱：support@yingbao-pv.com
- 🐛 Issue：[GitHub Issues](https://github.com/your-repo/PVparking/issues)
- 📖 文档：[在线文档](https://docs.yingbao-pv.com)

## 🙏 致谢

感谢以下开源项目为本系统的开发提供支持：

- [Vue.js](https://vuejs.org/) - 渐进式JavaScript框架
- [Ant Design Vue](https://antdv.com/) - 企业级UI设计语言
- [Flask](https://flask.palletsprojects.com/) - 轻量级Web应用框架
- [ECharts](https://echarts.apache.org/) - 强大的数据可视化库
- [Font Awesome](https://fontawesome.com/) - 图标字体库

---

<div align="center">

**🌟 萤宝智能光伏停车场EMS系统 - 让绿色能源管理更智能、更高效！🌟**

Made with ❤️ by YingBao Team

</div>