#!/bin/bash

# 设置颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo -e "    光伏停车场管理系统环境配置脚本"
echo -e "========================================${NC}"
echo

# 检查conda是否安装
if ! command -v conda &> /dev/null; then
    echo -e "${RED}❌ 错误：未找到conda命令${NC}"
    echo -e "${YELLOW}请先安装Anaconda或Miniconda${NC}"
    echo -e "${YELLOW}下载地址：https://www.anaconda.com/products/distribution${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 检测到conda环境${NC}"
echo

# 检查YingBao环境是否存在
echo -e "${BLUE}🔍 检查YingBao环境是否存在...${NC}"
if conda env list | grep -q "YingBao"; then
    echo -e "${YELLOW}⚠️  YingBao环境已存在，跳过创建步骤${NC}"
else
    echo -e "${BLUE}📦 创建YingBao conda环境...${NC}"
    conda create -n YingBao python=3.9 -y
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ 创建conda环境失败${NC}"
        exit 1
    fi
fi

# 激活环境
echo -e "${BLUE}🚀 激活YingBao环境...${NC}"
source $(conda info --base)/etc/profile.d/conda.sh
conda activate YingBao
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 激活环境失败${NC}"
    exit 1
fi

echo -e "${GREEN}✅ YingBao环境已激活${NC}"

echo
echo -e "${BLUE}📥 安装Python后端依赖...${NC}"
cd backend
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Python依赖安装失败${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Python依赖安装完成${NC}"
else
    echo -e "${YELLOW}⚠️  未找到requirements.txt文件${NC}"
fi

cd ..

echo
echo -e "${BLUE}📥 检查Node.js环境...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ 未找到Node.js${NC}"
    echo -e "${YELLOW}请先安装Node.js: https://nodejs.org/${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 检测到Node.js环境${NC}"
echo -e "${GREEN}Node.js版本: $(node --version)${NC}"
echo -e "${GREEN}npm版本: $(npm --version)${NC}"

echo
echo -e "${BLUE}📥 安装前端依赖...${NC}"
cd frontend
if [ -f "package.json" ]; then
    npm install
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ 前端依赖安装失败${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ 前端依赖安装完成${NC}"
else
    echo -e "${YELLOW}⚠️  未找到package.json文件${NC}"
fi

cd ..

echo
echo -e "${BLUE}🗄️  初始化数据库...${NC}"
cd backend
if [ -f "init_db.py" ]; then
    python init_db.py
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ 数据库初始化失败${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ 数据库初始化完成${NC}"
fi

if [ -f "create_master.py" ]; then
    python create_master.py
    echo -e "${GREEN}✅ 管理员账户创建完成${NC}"
fi

if [ -f "create_operators.py" ]; then
    python create_operators.py
    echo -e "${GREEN}✅ 操作员账户创建完成${NC}"
fi

cd ..

echo
echo -e "${BLUE}========================================"
echo -e "    🎉 环境配置完成！"
echo -e "========================================${NC}"
echo
echo -e "${GREEN}📋 使用方法：${NC}"
echo
echo -e "${YELLOW}1. 激活conda环境：${NC}"
echo -e "   conda activate YingBao"
echo
echo -e "${YELLOW}2. 启动系统：${NC}"
echo -e "   方法一：执行 ./start.sh"
echo -e "   方法二：手动启动"
echo -e "     - 后端：cd backend && python run.py"
echo -e "     - 前端：cd frontend && npm run dev"
echo
echo -e "${YELLOW}3. 访问系统：${NC}"
echo -e "   http://localhost:3000"
echo
echo -e "${YELLOW}4. 默认账户：${NC}"
echo -e "   管理员：master / 123"
echo -e "   操作员：张工 / 123, 陈工 / 123"
echo
echo -e "${BLUE}========================================${NC}"
