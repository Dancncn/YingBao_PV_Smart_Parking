#!/usr/bin/env python3
"""
Flask应用启动脚本
"""

import os
from app import app, init_db

def main():
    """主函数"""
    # 确保数据目录存在
    data_dir = os.path.join(os.path.dirname(__file__), '..', 'data')
    os.makedirs(data_dir, exist_ok=True)
    
    # 初始化数据库
    print("正在初始化数据库...")
    init_db()
    
    # 启动应用
    print("正在启动Flask应用...")
    print("API服务地址: http://localhost:5000")
    print("健康检查: http://localhost:5000/api/health")
    print("按 Ctrl+C 停止服务")
    
    app.run(
        debug=True,
        host='0.0.0.0',
        port=5000,
        use_reloader=True
    )

if __name__ == '__main__':
    main()
