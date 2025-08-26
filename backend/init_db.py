#!/usr/bin/env python3
"""
数据库初始化脚本
用于创建数据库表和默认管理员账户
"""

import os
import sys
from app import app, db, User

def init_database():
    """初始化数据库"""
    # 确保数据目录存在
    data_dir = os.path.join(os.path.dirname(__file__), '..', 'data')
    os.makedirs(data_dir, exist_ok=True)
    
    with app.app_context():
        print("正在创建数据库表...")
        db.create_all()
        print("数据库表创建完成!")
        
        # 检查是否已有管理员账户
        admin_count = User.query.filter_by(role='admin').count()
        
        if admin_count == 0:
            print("正在创建默认管理员账户...")
            
            # 创建默认管理员账户
            admin = User(
                username='admin',
                role='admin'
            )
            admin.set_password('admin123')  # 默认密码
            
            db.session.add(admin)
            db.session.commit()
            
            print("默认管理员账户创建成功!")
            print("用户名: admin")
            print("密码: admin123")
            print("⚠️  请在生产环境中立即修改默认密码!")
        else:
            print(f"已存在 {admin_count} 个管理员账户，跳过创建默认账户")
        
        # 显示当前用户统计
        total_users = User.query.count()
        admin_users = User.query.filter_by(role='admin').count()
        operator_users = User.query.filter_by(role='operator').count()
        
        print("\n=== 用户统计 ===")
        print(f"总用户数: {total_users}")
        print(f"管理员: {admin_users}")
        print(f"操作员: {operator_users}")
        
        print("\n数据库初始化完成!")

if __name__ == '__main__':
    try:
        init_database()
    except Exception as e:
        print(f"数据库初始化失败: {e}")
        sys.exit(1)
