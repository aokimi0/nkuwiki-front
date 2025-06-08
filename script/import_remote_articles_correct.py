#!/usr/bin/env python3
import mysql.connector
from datetime import datetime
import hashlib
import re
from tenacity import retry, stop_after_attempt, wait_fixed

# 远程数据库连接配置
REMOTE_DB_CONFIG = {
    'host': '113.44.175.112',
    'port': 3306,
    'user': 'nkuwiki',
    'password': 'Nkuwiki0!',
    'database': 'nkuwiki',
    'charset': 'utf8mb4',
    'connect_timeout': 30  # 增加连接超时
}

# 本地数据库连接配置
LOCAL_DB_CONFIG = {
    'host': '127.0.0.1',
    'port': 3306,
    'user': 'root',
    'password': '123456',  # 恢复硬编码密码
    'database': 'ruoyi-vue-pro',
    'charset': 'utf8mb4'
}

@retry(stop=stop_after_attempt(3), wait=wait_fixed(5))
def connect_remote_database():
    """连接远程数据库"""
    try:
        conn = mysql.connector.connect(**REMOTE_DB_CONFIG)
        print("远程数据库连接成功")
        return conn
    except mysql.connector.Error as err:
        print(f"远程数据库连接失败: {err}")
        raise

@retry(stop=stop_after_attempt(3), wait=wait_fixed(3))
def connect_local_database():
    """连接本地数据库"""
    try:
        conn = mysql.connector.connect(**LOCAL_DB_CONFIG)
        print("本地数据库连接成功")
        return conn
    except mysql.connector.Error as err:
        print(f"本地数据库连接失败: {err}")
        raise

def get_or_create_department(local_cursor, dept_name):
    """获取或创建部门，返回dept_id"""
    if not dept_name:
        return None
    
    # 检查部门是否存在
    query = "SELECT id FROM system_dept WHERE name = %s AND deleted = 0"
    local_cursor.execute(query, (dept_name,))
    result = local_cursor.fetchone()
    
    if result:
        return result[0]
    
    # 创建新部门
    insert_query = """
    INSERT INTO system_dept 
    (name, parent_id, sort, status, creator, create_time, updater, update_time, deleted, tenant_id)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    
    values = (
        dept_name,
        0,  # parent_id (根部门)
        0,  # sort
        0,  # status (正常)
        'import_script',  # creator
        datetime.now(),  # create_time
        'import_script',  # updater
        datetime.now(),  # update_time
        0,  # deleted
        1   # tenant_id
    )
    
    local_cursor.execute(insert_query, values)
    dept_id = local_cursor.lastrowid
    # print(f"创建新部门: {dept_name} (ID: {dept_id})")
    return dept_id

def extract_department_from_author(author_name):
    """从作者名称中提取部门信息"""
    if not author_name:
        return None
    
    # 定义部门关键词映射
    dept_mapping = {
        '计算机': '计算机学院',
        '数学': '数学科学学院',
        '物理': '物理科学学院',
        '化学': '化学学院',
        '生命': '生命科学学院',
        '历史': '历史学院',
        '哲学': '哲学院',
        '文学': '文学院',
        '外国语': '外国语学院',
        '法学': '法学院',
        '商学': '商学院',
        '经济': '经济学院',
        '环境': '环境科学与工程学院',
        '材料': '材料科学与工程学院',
        '电子': '电子信息与光学工程学院',
        '医学': '医学院',
        '马克思': '马克思主义学院',
        '汉语言': '汉语言文化学院',
        '周恩来': '周恩来政府管理学院',
        '旅游': '旅游与服务学院',
        '红与紫': '南开大学',
        '天南情报站': '南开大学',
        '周政': '南开大学',
        '生物信息学': '生命科学学院'
    }
    
    for keyword, dept_name in dept_mapping.items():
        if keyword in author_name:
            return dept_name
    
    # 如果没有匹配到特定学院，默认返回南开大学
    return '南开大学'

def get_or_create_user(local_cursor, nickname, dept_name=None):
    """获取或创建用户，返回user_id"""
    if not nickname:
        nickname = "南开大学"
    
    # # 对 nickname 进行截断，以防超长 - 已由数据库层面解决
    # nickname = (nickname[:29] + '…') if len(nickname) > 30 else nickname

    # 检查用户是否存在
    query = "SELECT id FROM system_users WHERE nickname = %s AND deleted = 0"
    local_cursor.execute(query, (nickname,))
    result = local_cursor.fetchone()
    
    if result:
        return result[0]
    
    # 获取或创建部门
    dept_id = None
    if dept_name:
        dept_id = get_or_create_department(local_cursor, dept_name)
    
    # 生成用户名（基于昵称的hash）
    username = f"user_{hashlib.md5(nickname.encode()).hexdigest()[:8]}"
    
    # 创建新用户
    insert_query = """
    INSERT INTO system_users 
    (username, password, nickname, remark, dept_id, email, mobile, sex, avatar, status, 
     creator, create_time, updater, update_time, deleted, tenant_id)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    
    values = (
        username,
        '$2a$10$mRMIYElDuo02V9W8gLGVd..fdKKEqLKNdvE6VgqKcV/LxEPT86e/K',  # 默认密码hash (123456)
        nickname,
        f'从远程导入的用户: {nickname}',  # remark
        dept_id,  # dept_id
        '',  # email
        '',  # mobile
        0,   # sex (未知)
        '',  # avatar
        0,   # status (正常)
        'import_script',  # creator
        datetime.now(),  # create_time
        'import_script',  # updater
        datetime.now(),  # update_time
        0,   # deleted
        1    # tenant_id
    )
    
    local_cursor.execute(insert_query, values)
    user_id = local_cursor.lastrowid
    
    # 为用户分配角色102（官号）
    role_query = """
    INSERT INTO system_user_role 
    (user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """
    
    role_values = (
        user_id,
        102,  # 角色ID 102（官号）
        'import_script',  # creator
        datetime.now(),  # create_time
        'import_script',  # updater
        datetime.now(),  # update_time
        0,    # deleted
        1     # tenant_id
    )
    
    local_cursor.execute(role_query, role_values)
    # print(f"创建新用户: {nickname} (ID: {user_id}, 部门: {dept_name})")
    return user_id

def clean_content(content):
    """清理文章内容"""
    if not content:
        return ""
    
    # 移除HTML标签
    content = re.sub(r'<[^>]+>', '', content)
    # 移除多余空行
    content = re.sub(r'\n\s*\n\s*\n', '\n\n', content)
    # 移除首尾空白
    content = content.strip()
    
    return content

def parse_publish_date(date_str):
    """解析发布日期"""
    if not date_str:
        return datetime.now()
    
    try:
        if isinstance(date_str, datetime):
            return date_str
        
        # 尝试多种日期格式
        for fmt in ["%Y-%m-%d %H:%M:%S", "%Y-%m-%d", "%Y/%m/%d", "%Y年%m月%d日"]:
            try:
                return datetime.strptime(str(date_str), fmt)
            except ValueError:
                continue
        
        # 如果都失败了，返回当前时间
        return datetime.now()
    except:
        return datetime.now()

def fetch_remote_data_properly(remote_cursor, table_name):
    """正确获取远程数据，使用字典格式"""
    query = f"SELECT * FROM {table_name}"
    remote_cursor.execute(query)
    
    # 获取列名
    column_names = [desc[0] for desc in remote_cursor.description]
    
    # 获取所有行数据
    rows = remote_cursor.fetchall()
    
    # 转换为字典格式
    result = []
    for row in rows:
        row_dict = {}
        for i, value in enumerate(row):
            if i < len(column_names):
                row_dict[column_names[i]] = value
        result.append(row_dict)
    
    return result

def import_articles_from_remote():
    """从远程数据库导入文章"""
    remote_conn = connect_remote_database()
    local_conn = connect_local_database()
    
    if not remote_conn or not local_conn:
        return
    
    remote_cursor = remote_conn.cursor()
    local_cursor = local_conn.cursor()
    
    try:
        success_count = 0
        error_count = 0
        
        # # 处理 wechat_nku 表 - 根据要求跳过
        print("\n=== 处理 wechat_nku 表 ===")
        wechat_articles = fetch_remote_data_properly(remote_cursor, 'wechat_nku')
        print(f"获取到 {len(wechat_articles)} 条微信文章")
        
        for i, article in enumerate(wechat_articles):
            try:
                title = article.get('title', f'无标题文章_{i}')
                content = article.get('content', '')
                author = article.get('author', '南开大学')
                publish_time = article.get('publish_time')
                
                # 简单的进度反馈
                if (i + 1) % 100 == 0:
                    local_conn.commit() # 分批提交
                    print(f"  ... 已提交 {i + 1} / {len(wechat_articles)} 篇微信文章")

                # 检查文章是否已存在
                check_query = "SELECT id FROM knowledge_articles WHERE title = %s"
                local_cursor.execute(check_query, (title,))
                if local_cursor.fetchone():
                    # print(f"文章已存在，跳过: {title}")
                    continue
                
                # 提取部门信息
                dept_name = extract_department_from_author(author)
                
                # 获取或创建用户
                author_id = get_or_create_user(local_cursor, author, dept_name)
                
                # 清理内容
                cleaned_content = clean_content(content)
                
                # 插入文章
                insert_query = """
                INSERT INTO knowledge_articles 
                (title, content, publish_date, author_id, source_platform, tenant_id, 
                 creator, create_time, updater, update_time, deleted)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """
                
                values = (
                    title,
                    cleaned_content,
                    parse_publish_date(publish_time),
                    author_id,
                    'wechat',
                    1,  # tenant_id
                    'import_script',
                    datetime.now(),
                    'import_script',
                    datetime.now(),
                    0   # deleted
                )
                
                local_cursor.execute(insert_query, values)
                success_count += 1
                
            except Exception as e:
                error_count += 1
                print(f"处理微信文章《{title}》时出错: {e}") # 恢复错误日志
        
        local_conn.commit() # 确保最后不足100篇的批次也被提交
        print("微信文章处理完毕，最终提交。")

        # 处理 website_nku 表
        print("\n=== 处理 website_nku 表 ===")
        website_articles = fetch_remote_data_properly(remote_cursor, 'website_nku')
        print(f"获取到 {len(website_articles)} 条网站文章")
        
        for i, article in enumerate(website_articles):
            try:
                title = article.get('title', f'无标题文章_{i}')
                content = article.get('content', '')
                author = article.get('author', '南开大学')
                publish_time = article.get('publish_time')
                
                # print(f"处理网站文章: {title}")
                
                # 简单的进度反馈
                if (i + 1) % 100 == 0:
                    local_conn.commit() # 分批提交
                    print(f"  ... 已提交 {i + 1} / {len(website_articles)} 篇网站文章")

                # 检查文章是否已存在
                check_query = "SELECT id FROM knowledge_articles WHERE title = %s"
                local_cursor.execute(check_query, (title,))
                if local_cursor.fetchone():
                    # print(f"文章已存在，跳过: {title}")
                    continue
                
                # 提取部门信息
                dept_name = extract_department_from_author(author)
                
                # 获取或创建用户
                author_id = get_or_create_user(local_cursor, author, dept_name)
                
                # 清理内容
                cleaned_content = clean_content(content)
                
                # 插入文章
                insert_query = """
                INSERT INTO knowledge_articles 
                (title, content, publish_date, author_id, source_platform, tenant_id, 
                 creator, create_time, updater, update_time, deleted)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """
                
                values = (
                    title,
                    cleaned_content,
                    parse_publish_date(publish_time),
                    author_id,
                    'website',
                    1,  # tenant_id
                    'import_script',
                    datetime.now(),
                    'import_script',
                    datetime.now(),
                    0   # deleted
                )
                
                local_cursor.execute(insert_query, values)
                success_count += 1
                # print(f"成功导入网站文章: {title}")
                
            except Exception as e:
                error_count += 1
                print(f"处理网站文章《{title}》时出错: {e}") # 恢复错误日志
        
        local_conn.commit() # 确保最后不足100篇的批次也被提交
        print(f"\n=== 导入完成 ===")
        print(f"成功导入: {success_count} 篇文章")
        print(f"失败/跳过: {error_count} 篇文章")
        
    except Exception as e:
        print(f"导入过程发生错误: {e}")
        local_conn.rollback()
    
    finally:
        remote_cursor.close()
        remote_conn.close()
        local_cursor.close()
        local_conn.close()

if __name__ == "__main__":
    print("开始从远程数据库导入文章...")
    import_articles_from_remote()
    print("导入任务完成!") 