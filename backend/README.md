# PV Parking Backend API

光伏停车场管理系统后端API服务

## 功能特性

- 🔐 JWT身份认证
- 👥 用户管理系统（管理员/操作员角色）
- 🗄️ SQLite数据库
- 🌐 CORS跨域支持
- 📝 完整的API文档

## 快速开始

### 1. 安装依赖

```bash
cd backend
pip install -r requirements.txt
```

### 2. 初始化数据库

```bash
python init_db.py
```

### 3. 启动服务

```bash
python run.py
```

或者直接运行：

```bash
python app.py
```

服务将在 `http://localhost:5000` 启动

## API接口

### 基础接口

#### 健康检查
```http
GET /api/health
```

### 用户认证

#### 用户登录
```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123"
}
```

响应：
```json
{
  "message": "登录成功",
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "username": "admin",
    "role": "admin",
    "created_at": "2024-01-01T00:00:00",
    "updated_at": "2024-01-01T00:00:00"
  }
}
```

#### 用户注册（仅管理员）
```http
POST /api/auth/register
Authorization: Bearer <token>
Content-Type: application/json

{
  "username": "operator1",
  "password": "password123",
  "role": "operator"
}
```

#### 获取当前用户信息
```http
GET /api/auth/me
Authorization: Bearer <token>
```

### 用户管理（仅管理员）

#### 获取用户列表
```http
GET /api/users?page=1&per_page=10
Authorization: Bearer <token>
```

#### 更新用户信息
```http
PUT /api/users/{user_id}
Authorization: Bearer <token>
Content-Type: application/json

{
  "username": "new_username",
  "role": "operator",
  "password": "new_password"
}
```

#### 删除用户
```http
DELETE /api/users/{user_id}
Authorization: Bearer <token>
```

## 数据模型

### User（用户）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Integer | 主键 |
| username | String(80) | 用户名（唯一） |
| password_hash | String(255) | 密码哈希 |
| role | String(20) | 角色（admin/operator） |
| created_at | DateTime | 创建时间 |
| updated_at | DateTime | 更新时间 |

## 权限说明

### 管理员（admin）
- 创建新用户账户
- 编辑用户信息
- 删除用户账户
- 查看用户列表
- 所有操作员权限

### 操作员（operator）
- 查看个人信息
- 修改个人密码（待实现）

## 默认账户

系统初始化时会创建默认管理员账户：
- 用户名: `admin`
- 密码: `admin123`

⚠️ **重要提醒**: 请在生产环境中立即修改默认密码！

## 环境变量

可以通过环境变量配置以下参数：

- `SECRET_KEY`: Flask应用密钥
- `JWT_SECRET_KEY`: JWT令牌密钥
- `DATABASE_URL`: 数据库连接URL

## 错误码

| 状态码 | 说明 |
|--------|------|
| 200 | 请求成功 |
| 201 | 创建成功 |
| 400 | 请求参数错误 |
| 401 | 未授权（需要登录） |
| 403 | 权限不足 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

## 开发说明

### 项目结构
```
backend/
├── app.py              # 主应用文件
├── config.py           # 配置文件
├── init_db.py         # 数据库初始化脚本
├── run.py             # 启动脚本
├── requirements.txt   # 依赖包列表
└── README.md         # 项目文档
```

### 数据库文件
数据库文件存储在项目根目录的 `data/` 文件夹中：
```
data/
└── pvparking.db      # SQLite数据库文件
```
