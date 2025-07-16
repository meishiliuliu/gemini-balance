# -*- coding: utf-8 -*-
import os
import psycopg2
from dotenv import load_dotenv

# 加载环境变量（使用绝对路径确保正确加载）
load_dotenv('.env')

try:
    # 建立数据库连接
    conn = psycopg2.connect(os.getenv('DATABASE_URL'))
    print("✅ 数据库连接成功！")
    # 验证连接状态
    if conn.closed == 0:
        print("🔍 连接状态: 活跃")
        # 尝试执行简单查询
        with conn.cursor() as cur:
            cur.execute("SELECT version();")
            db_version = cur.fetchone()
            print(f"📦 数据库版本: {db_version[0].split()[0]}")
        conn.close()
    else:
        print("⚠️ 连接已关闭")
except psycopg2.OperationalError as e:
    print(f"❌ 连接失败: 数据库服务未响应\n详细错误: {str(e)}")
except Exception as e:
    print(f"""❌ 发生错误: {str(e)}
请检查neon_db.env文件中的连接字符串是否正确""")