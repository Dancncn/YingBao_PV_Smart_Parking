@echo off
chcp 65001
echo ========================================
echo    萤宝智能光伏停车场管理系统
echo    前后端服务启动脚本
echo ========================================

echo.
echo [1/4] 检查Node.js环境...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js未安装或未添加到PATH
    echo 请安装Node.js并重启命令行
    pause
    exit /b 1
)
echo ✅ Node.js环境正常

echo.
echo [2/4] 检查Python环境...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python未安装或未添加到PATH
    echo 请安装Python并重启命令行
    pause
    exit /b 1
)
echo ✅ Python环境正常

echo.
echo [3/4] 安装前端依赖...
cd frontend
if not exist node_modules (
    echo 正在安装前端依赖包...
    npm install
    if %errorlevel% neq 0 (
        echo ❌ 前端依赖安装失败
        pause
        exit /b 1
    )
    echo ✅ 前端依赖安装完成
) else (
    echo ✅ 前端依赖已存在，跳过安装
)

echo.
echo [4/4] 安装后端依赖...
cd ..\backend
pip install -r requirements.txt >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  后端依赖安装可能有问题，但继续启动...
) else (
    echo ✅ 后端依赖安装完成
)

echo.
echo ========================================
echo           启动服务
echo ========================================

echo.
echo 🚀 正在启动后端服务 (端口: 5000)...
start "后端服务" cmd /c "python app.py & pause"

echo.
echo ⏳ 等待后端服务启动...
timeout /t 3 /nobreak >nul

echo.
echo 🚀 正在启动前端服务 (端口: 3000)...
cd ..\frontend
start "前端服务" cmd /c "npm run dev & pause"

echo.
echo ========================================
echo           服务启动完成
echo ========================================
echo.
echo 📊 前端地址: http://localhost:3000
echo 🔧 后端API: http://localhost:5000/api/health
echo.
echo 默认登录账户:
echo   管理员: master / 123
echo   管理员: admin / admin123
echo.
echo ⚠️  请等待前端编译完成后再访问页面
echo 💡 按Ctrl+C可以停止对应的服务
echo.
echo 🎉 系统启动成功！
pause
