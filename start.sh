#!/bin/bash

# 设置颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}========================================"
echo -e "    萤宝智能光伏停车场管理系统"
echo -e "    前后端服务启动脚本"
echo -e "========================================${NC}"

echo ""
echo -e "${YELLOW}[1/4] 检查Node.js环境...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js未安装或未添加到PATH${NC}"
    echo -e "${RED}请安装Node.js并重启终端${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Node.js环境正常${NC}"

echo ""
echo -e "${YELLOW}[2/4] 检查Python环境...${NC}"
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo -e "${RED}❌ Python未安装或未添加到PATH${NC}"
    echo -e "${RED}请安装Python并重启终端${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Python环境正常${NC}"

echo ""
echo -e "${YELLOW}[3/4] 安装前端依赖...${NC}"
cd frontend
if [ ! -d "node_modules" ]; then
    echo "正在安装前端依赖包..."
    npm install
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ 前端依赖安装失败${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ 前端依赖安装完成${NC}"
else
    echo -e "${GREEN}✅ 前端依赖已存在，跳过安装${NC}"
fi

echo ""
echo -e "${YELLOW}[4/4] 安装后端依赖...${NC}"
cd ../backend

# 尝试使用python3，如果不存在则使用python
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
    PIP_CMD="pip3"
else
    PYTHON_CMD="python"
    PIP_CMD="pip"
fi

$PIP_CMD install -r requirements.txt > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠️  后端依赖安装可能有问题，但继续启动...${NC}"
else
    echo -e "${GREEN}✅ 后端依赖安装完成${NC}"
fi

echo ""
echo -e "${CYAN}========================================"
echo -e "           启动服务"
echo -e "========================================${NC}"

echo ""
echo -e "${BLUE}🚀 正在启动后端服务 (端口: 5000)...${NC}"

# 在新终端窗口启动后端服务
if command -v gnome-terminal &> /dev/null; then
    gnome-terminal --title="后端服务" -- bash -c "$PYTHON_CMD app.py; read -p 'Press Enter to close...'"
elif command -v osascript &> /dev/null; then
    # macOS
    osascript -e 'tell app "Terminal" to do script "cd \"'$(pwd)'\"; '$PYTHON_CMD' app.py"'
else
    # 备用方案：在后台启动
    $PYTHON_CMD app.py &
    BACKEND_PID=$!
    echo "后端服务进程ID: $BACKEND_PID"
fi

echo ""
echo -e "${YELLOW}⏳ 等待后端服务启动...${NC}"
sleep 3

echo ""
echo -e "${BLUE}🚀 正在启动前端服务 (端口: 3000)...${NC}"
cd ../frontend

# 在新终端窗口启动前端服务
if command -v gnome-terminal &> /dev/null; then
    gnome-terminal --title="前端服务" -- bash -c "npm run dev; read -p 'Press Enter to close...'"
elif command -v osascript &> /dev/null; then
    # macOS
    osascript -e 'tell app "Terminal" to do script "cd \"'$(pwd)'\"; npm run dev"'
else
    # 备用方案：在后台启动
    npm run dev &
    FRONTEND_PID=$!
    echo "前端服务进程ID: $FRONTEND_PID"
fi

echo ""
echo -e "${CYAN}========================================"
echo -e "           服务启动完成"
echo -e "========================================${NC}"
echo ""
echo -e "${GREEN}📊 前端地址: http://localhost:3000${NC}"
echo -e "${GREEN}🔧 后端API: http://localhost:5000/api/health${NC}"
echo ""
echo -e "${PURPLE}默认登录账户:${NC}"
echo -e "  ${BLUE}管理员: master / 123${NC}"
echo -e "  ${BLUE}管理员: admin / admin123${NC}"
echo ""
echo -e "${YELLOW}⚠️  请等待前端编译完成后再访问页面${NC}"
echo -e "${YELLOW}💡 按Ctrl+C可以停止对应的服务${NC}"
echo ""
echo -e "${GREEN}🎉 系统启动成功！${NC}"

# 如果在后台启动了服务，等待用户输入
if [ ! -z "$BACKEND_PID" ] || [ ! -z "$FRONTEND_PID" ]; then
    echo ""
    echo "按Enter键停止所有服务..."
    read
    
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
        echo "后端服务已停止"
    fi
    
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null
        echo "前端服务已停止"
    fi
fi
