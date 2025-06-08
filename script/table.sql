-- 设置字符集
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. 文章信息表
DROP TABLE IF EXISTS `knowledge_articles`;
CREATE TABLE `knowledge_articles` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文章编号',
  `title` varchar(255) NOT NULL COMMENT '文章标题',
  `content` text NOT NULL COMMENT '文章内容',
  `publish_date` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `author_id` bigint NOT NULL COMMENT '作者ID',
  `source_platform` varchar(255) DEFAULT NULL COMMENT '来源平台',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_author_id` (`author_id`),
  KEY `idx_publish_date` (`publish_date`),
  CONSTRAINT `fk_articles_users` FOREIGN KEY (`author_id`) REFERENCES `system_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章信息表';

-- 2. 课程信息表
DROP TABLE IF EXISTS `knowledge_courses`;
CREATE TABLE `knowledge_courses` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '课程编号',
  `course_name` varchar(255) NOT NULL COMMENT '课程名称',
  `description` text DEFAULT NULL COMMENT '课程描述',
  `teacher_id` bigint NOT NULL COMMENT '授课教师ID',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_teacher_id` (`teacher_id`),
  CONSTRAINT `fk_courses_teachers` FOREIGN KEY (`teacher_id`) REFERENCES `system_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程信息表';

-- 3. 评论信息表
DROP TABLE IF EXISTS `knowledge_comments`;
CREATE TABLE `knowledge_comments` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论编号',
  `comment_content` text NOT NULL COMMENT '评论内容',
  `comment_date` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  `user_id` bigint NOT NULL COMMENT '评论用户ID',
  `article_id` bigint NOT NULL COMMENT '文章ID',
  `likes_count` int NOT NULL DEFAULT 0 COMMENT '点赞数量',
  `reply_count` int NOT NULL DEFAULT 0 COMMENT '回复数量',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`),
  KEY `idx_article_id` (`article_id`),
  KEY `idx_comment_date` (`comment_date`),
  KEY `idx_article_id_create_time` (`article_id`, `create_time` DESC) COMMENT '文章评论查询索引',
  CONSTRAINT `fk_comments_users` FOREIGN KEY (`user_id`) REFERENCES `system_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comments_articles` FOREIGN KEY (`article_id`) REFERENCES `knowledge_articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论信息表';

-- 4. 评论点赞记录表
DROP TABLE IF EXISTS `knowledge_comment_likes`;
CREATE TABLE `knowledge_comment_likes` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `comment_id` bigint NOT NULL COMMENT '评论ID',
  `user_id` bigint NOT NULL COMMENT '点赞用户ID',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_comment_user` (`comment_id`, `user_id`, `deleted`) COMMENT '评论用户唯一索引',
  KEY `idx_comment_id` (`comment_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_comment_likes_comment_id` FOREIGN KEY (`comment_id`) REFERENCES `knowledge_comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_likes_user_id` FOREIGN KEY (`user_id`) REFERENCES `system_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论点赞记录表';

-- 5. 评论回复表
DROP TABLE IF EXISTS `knowledge_comment_replies`;
CREATE TABLE `knowledge_comment_replies` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `parent_comment_id` bigint NOT NULL COMMENT '父评论ID',
  `reply_to_comment_id` bigint NULL COMMENT '回复的评论ID（用于多级回复）',
  `reply_content` text NOT NULL COMMENT '回复内容',
  `user_id` bigint NOT NULL COMMENT '回复用户ID',
  `reply_to_user_id` bigint NULL COMMENT '被回复的用户ID',
  `article_id` bigint NOT NULL COMMENT '文章ID',
  `likes_count` int NOT NULL DEFAULT 0 COMMENT '点赞数量',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_parent_comment_id` (`parent_comment_id`),
  KEY `idx_article_id_create_time` (`article_id`, `create_time` DESC) COMMENT '文章回复查询索引',
  KEY `idx_user_id` (`user_id`),
  KEY `idx_reply_to_user_id` (`reply_to_user_id`),
  CONSTRAINT `fk_comment_replies_parent_id` FOREIGN KEY (`parent_comment_id`) REFERENCES `knowledge_comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_replies_user_id` FOREIGN KEY (`user_id`) REFERENCES `system_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_replies_article_id` FOREIGN KEY (`article_id`) REFERENCES `knowledge_articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_replies_reply_to_user_id` FOREIGN KEY (`reply_to_user_id`) REFERENCES `system_users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论回复表';

-- 6. 课程资源表
DROP TABLE IF EXISTS `knowledge_course_resources`;
CREATE TABLE `knowledge_course_resources` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '资源编号',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `article_id` bigint NOT NULL COMMENT '文章ID',
  `resource_type` varchar(255) DEFAULT NULL COMMENT '资源类型',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户编号',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_course_id` (`course_id`),
  KEY `idx_article_id` (`article_id`),
  CONSTRAINT `fk_courseresources_courses` FOREIGN KEY (`course_id`) REFERENCES `knowledge_courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_courseresources_articles` FOREIGN KEY (`article_id`) REFERENCES `knowledge_articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程资源表';

-- 创建触发器：限制用户对同一文章的评论数量
DELIMITER //
DROP TRIGGER IF EXISTS `trg_limit_user_comments`;
CREATE TRIGGER `trg_limit_user_comments`
BEFORE INSERT ON `knowledge_comments`
FOR EACH ROW
BEGIN
    DECLARE current_comment_count INT;
    SELECT COUNT(*) INTO current_comment_count
    FROM knowledge_comments
    WHERE user_id = NEW.user_id AND article_id = NEW.article_id AND deleted = b'0';
    
    IF current_comment_count >= 5 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = '评论数量已达上限，您已对该文章发表了5条评论。';
    END IF;
END //
DELIMITER ;

-- 创建触发器：评论点赞数自动更新
DELIMITER //
DROP TRIGGER IF EXISTS `trg_comment_like_insert`;
CREATE TRIGGER `trg_comment_like_insert`
AFTER INSERT ON `knowledge_comment_likes`
FOR EACH ROW
BEGIN
    IF NEW.deleted = b'0' THEN
        UPDATE knowledge_comments 
        SET likes_count = likes_count + 1 
        WHERE id = NEW.comment_id;
    END IF;
END //

DROP TRIGGER IF EXISTS `trg_comment_like_update`;
CREATE TRIGGER `trg_comment_like_update`
AFTER UPDATE ON `knowledge_comment_likes`
FOR EACH ROW
BEGIN
    IF OLD.deleted = b'0' AND NEW.deleted = b'1' THEN
        UPDATE knowledge_comments 
        SET likes_count = GREATEST(likes_count - 1, 0)
        WHERE id = NEW.comment_id;
    ELSEIF OLD.deleted = b'1' AND NEW.deleted = b'0' THEN
        UPDATE knowledge_comments 
        SET likes_count = likes_count + 1 
        WHERE id = NEW.comment_id;
    END IF;
END //

-- 创建触发器：评论回复数自动更新
DROP TRIGGER IF EXISTS `trg_comment_reply_insert`;
CREATE TRIGGER `trg_comment_reply_insert`
AFTER INSERT ON `knowledge_comment_replies`
FOR EACH ROW
BEGIN
    IF NEW.deleted = b'0' THEN
        UPDATE knowledge_comments 
        SET reply_count = reply_count + 1 
        WHERE id = NEW.parent_comment_id;
    END IF;
END //

DROP TRIGGER IF EXISTS `trg_comment_reply_update`;
CREATE TRIGGER `trg_comment_reply_update`
AFTER UPDATE ON `knowledge_comment_replies`
FOR EACH ROW
BEGIN
    IF OLD.deleted = b'0' AND NEW.deleted = b'1' THEN
        UPDATE knowledge_comments 
        SET reply_count = GREATEST(reply_count - 1, 0)
        WHERE id = NEW.parent_comment_id;
    ELSEIF OLD.deleted = b'1' AND NEW.deleted = b'0' THEN
        UPDATE knowledge_comments 
        SET reply_count = reply_count + 1 
        WHERE id = NEW.parent_comment_id;
    END IF;
END //
DELIMITER ;

-- 创建存储过程：用户晋升为教师
DELIMITER //
DROP PROCEDURE IF EXISTS `sp_promote_user_to_teacher`;
CREATE PROCEDURE `sp_promote_user_to_teacher` (
    IN p_user_id BIGINT,
    IN p_department_name VARCHAR(255),
    IN p_post_name VARCHAR(255)
)
BEGIN
    DECLARE v_user_exists INT DEFAULT 0;
    DECLARE v_teacher_role_id BIGINT;
    DECLARE v_user_is_teacher INT DEFAULT 0;
    DECLARE v_dept_id BIGINT;
    DECLARE v_post_id BIGINT;
    
    -- 1. 检查用户是否存在
    SELECT COUNT(*) INTO v_user_exists FROM system_users WHERE id = p_user_id;
    IF v_user_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '用户不存在，无法晋升。';
    END IF;
    
    -- 2. 获取 'teacher' 角色的 ID (假设 code = 'teacher')
    SELECT id INTO v_teacher_role_id FROM system_role WHERE code = 'teacher' LIMIT 1;
    IF v_teacher_role_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '教师角色(teacher)不存在，请先创建。';
    END IF;

    -- 3. 检查用户是否已经是教师
    SELECT COUNT(*) INTO v_user_is_teacher FROM system_user_role WHERE user_id = p_user_id AND role_id = v_teacher_role_id;
    IF v_user_is_teacher > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '该用户已经是教师身份，无需重复晋升。';
    END IF;

    -- 4. 获取部门 ID
    SELECT id INTO v_dept_id FROM system_dept WHERE name = p_department_name LIMIT 1;
    IF v_dept_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '指定的部门不存在。';
    END IF;

    -- 5. 获取岗位 ID
    SELECT id INTO v_post_id FROM system_post WHERE name = p_post_name LIMIT 1;
    IF v_post_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '指定的岗位不存在。';
    END IF;
    
    -- 6. 分配角色并更新用户信息
    START TRANSACTION;
    INSERT INTO system_user_role (user_id, role_id) VALUES (p_user_id, v_teacher_role_id);
    UPDATE system_users SET dept_id = v_dept_id, post_ids = CAST(v_post_id AS CHAR) WHERE id = p_user_id;
    COMMIT;

END //
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1; 