@echo off
chcp 65001 > nul
echo ========================================
echo    光伏停车场管理系统环境配置脚本
echo ========================================
echo.

REM 检查conda是否安装
where conda >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ 错误：未找到conda命令
    echo 请先安装Anaconda或Miniconda
    echo 下载地址：https://www.anaconda.com/products/distribution
    pause
    exit /b 1
)

echo ✅ 检测到conda环境
echo.

REM 检查YingBao环境是否存在
echo 🔍 检查YingBao环境是否存在...
conda env list | findstr "YingBao" >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ⚠️  YingBao环境已存在，跳过创建步骤
    goto :activate_env
)

echo 📦 创建YingBao conda环境...
conda create -n YingBao python=3.9 -y
if %ERRORLEVEL% NEQ 0 (
    echo ❌ 创建conda环境失败
    pause
    exit /b 1
)

:activate_env
echo 🚀 激活YingBao环境...
call conda activate YingBao
if %ERRORLEVEL% NEQ 0 (
    echo ❌ 激活环境失败
    pause
    exit /b 1
)

echo ✅ YingBao环境已激活

echo.
echo 📥 安装Python后端依赖...
cd backend
if exist requirements.txt (
    pip install -r requirements.txt
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ Python依赖安装失败
        pause
        exit /b 1
    )
    echo ✅ Python依赖安装完成
) else (
    echo ⚠️  未找到requirements.txt文件
)

cd ..

echo.
echo 📥 检查Node.js环境...
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ 未找到Node.js
    echo 请先安装Node.js: https://nodejs.org/
    pause
    exit /b 1
)

echo ✅ 检测到Node.js环境
node --version
npm --version

echo.
echo 📥 安装前端依赖...
cd frontend
if exist package.json (
    npm install
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ 前端依赖安装失败
        pause
        exit /b 1
    )
    echo ✅ 前端依赖安装完成
) else (
    echo ⚠️  未找到package.json文件
)

cd ..

echo.
echo 🗄️  初始化数据库...
cd backend
if exist init_db.py (
    python init_db.py
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ 数据库初始化失败
        pause
        exit /b 1
    )
    echo ✅ 数据库初始化完成
)

if exist create_master.py (
    python create_master.py
    echo ✅ 管理员账户创建完成
)

if exist create_operators.py (
    python create_operators.py
    echo ✅ 操作员账户创建完成
)

cd ..

echo.
echo ========================================
echo    🎉 环境配置完成！
echo ========================================
echo.
echo 📋 使用方法：
echo.
echo 1. 激活conda环境：
echo    conda activate YingBao
echo.
echo 2. 启动系统：
echo    方法一：双击 start.bat（Windows）
echo    方法二：手动启动
echo      - 后端：cd backend ^&^& python run.py
echo      - 前端：cd frontend ^&^& npm run dev
echo.
echo 3. 访问系统：
echo    http://localhost:3000
echo.
echo 4. 默认账户：
echo    管理员：master / 123
echo    操作员：张工 / 123, 陈工 / 123
echo.
echo ========================================
pause
