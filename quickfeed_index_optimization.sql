-- QUICKFEED: đo dung lượng và tối ưu các index dư thừa.
-- Điều kiện chạy: đã chạy Legacy Script của đề để có quickfeed_db.Posts
-- cùng năm index: idx_user_id, idx_content, idx_post_type,
-- idx_is_visible và idx_created_at.
USE quickfeed_db;

-- 1. Ghi nhận dung lượng trước tối ưu.
SHOW TABLE STATUS LIKE 'Posts';

SELECT
    TABLE_NAME,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) AS data_size_mb,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) AS index_size_mb,
    TABLE_ROWS AS estimated_rows
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'quickfeed_db'
  AND TABLE_NAME = 'Posts';

-- 2. Giữ idx_user_id và idx_created_at; xóa ba index B-Tree dư thừa.
ALTER TABLE Posts DROP INDEX idx_content;
ALTER TABLE Posts DROP INDEX idx_post_type;
ALTER TABLE Posts DROP INDEX idx_is_visible;

-- 3. Kiểm tra index còn lại và dung lượng sau tối ưu.
SHOW INDEX FROM Posts;
SHOW TABLE STATUS LIKE 'Posts';

SELECT
    TABLE_NAME,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) AS data_size_mb,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) AS index_size_mb,
    TABLE_ROWS AS estimated_rows
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'quickfeed_db'
  AND TABLE_NAME = 'Posts';
