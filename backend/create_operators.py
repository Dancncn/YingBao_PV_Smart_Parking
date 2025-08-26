#!/usr/bin/env python3
"""
创建张工和陈工操作者账户脚本
"""

import os
import sys
from app import app, db, User

def create_operator_accounts():
    """创建操作者账户"""
    with app.app_context():
        operators = [
            {'username': '张工', 'password': '123', 'role': 'operator'},
            {'username': '陈工', 'password': '123', 'role': 'operator'}
        ]
        
        created_count = 0
        
        for op_data in operators:
            # 检查用户是否已存在
            existing_user = User.query.filter_by(username=op_data['username']).first()
            if existing_user:
                print(f"用户 {op_data['username']} 已存在，跳过创建")
                continue
            
            print(f"正在创建操作者账户: {op_data['username']}")
            
            # 创建新用户
            user = User(
                username=op_data['username'],
                role=op_data['role']
            )
            user.set_password(op_data['password'])
            
            try:
                db.session.add(user)
                db.session.commit()
                created_count += 1
                
                print(f"✅ 操作者 {op_data['username']} 创建成功!")
                print(f"   用户名: {op_data['username']}")
                print(f"   密码: {op_data['password']}")
                print(f"   角色: {op_data['role']}")
                print()
                
            except Exception as e:
                db.session.rollback()
                print(f"❌ 创建用户 {op_data['username']} 失败: {e}")
                continue
        
        # 显示当前用户统计
        total_users = User.query.count()
        admin_users = User.query.filter_by(role='admin').count()
        operator_users = User.query.filter_by(role='operator').count()
        
        print("=" * 50)
        print("用户创建完成!")
        print(f"本次创建: {created_count} 个操作者账户")
        print()
        print("=== 系统用户统计 ===")
        print(f"总用户数: {total_users}")
        print(f"管理员: {admin_users}")
        print(f"操作员: {operator_users}")
        print()
        
        print("=== 所有用户列表 ===")
        all_users = User.query.all()
        for user in all_users:
            role_text = "管理员" if user.role == 'admin' else "操作员"
            print(f"- {user.username} ({role_text}) [ID: {user.id}]")

if __name__ == '__main__':
    # 确保数据目录存在
    data_dir = os.path.join(os.path.dirname(__file__), '..', 'data')
    os.makedirs(data_dir, exist_ok=True)
    
    try:
        create_operator_accounts()
        print("\n🎉 操作者账户创建脚本执行完成!")
    except Exception as e:
        print(f"❌ 脚本执行失败: {e}")
        sys.exit(1)
