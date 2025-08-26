#!/usr/bin/env python3
"""
创建master管理员账户脚本
"""

import os
import sys
from app import app, db, User

def create_master_user():
    """创建master管理员账户"""
    with app.app_context():
        # 检查master用户是否已存在
        existing_master = User.query.filter_by(username='master').first()
        if existing_master:
            print("master用户已存在，跳过创建")
            return
        
        print("正在创建master管理员账户...")
        
        # 创建master管理员账户
        master = User(
            username='master',
            role='admin'
        )
        master.set_password('123')  # 密码为123
        
        try:
            db.session.add(master)
            db.session.commit()
            
            print("master管理员账户创建成功!")
            print("用户名: master")
            print("密码: 123")
            print("角色: 管理员")
        except Exception as e:
            db.session.rollback()
            print(f"创建master用户失败: {e}")
            sys.exit(1)
        
        # 显示当前用户统计
        total_users = User.query.count()
        admin_users = User.query.filter_by(role='admin').count()
        operator_users = User.query.filter_by(role='operator').count()
        
        print("\n=== 用户统计 ===")
        print(f"总用户数: {total_users}")
        print(f"管理员: {admin_users}")
        print(f"操作员: {operator_users}")

if __name__ == '__main__':
    # 确保数据目录存在
    data_dir = os.path.join(os.path.dirname(__file__), '..', 'data')
    os.makedirs(data_dir, exist_ok=True)
    
    try:
        create_master_user()
    except Exception as e:
        print(f"脚本执行失败: {e}")
        sys.exit(1)
