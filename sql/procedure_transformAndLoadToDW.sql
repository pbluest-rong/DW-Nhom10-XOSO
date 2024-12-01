USE lottery_db;

-- Xóa thủ tục nếu nó đã tồn tại
DROP PROCEDURE IF EXISTS transform_load_data_to_warehouse;
-- Đặt lại DELIMITER để sử dụng dấu phân cách khác cho thủ tục (tránh xung đột với dấu chấm phẩy)
DELIMITER $$

CREATE PROCEDURE transform_load_data_to_warehouse()
BEGIN
    DECLARE curr_date DATE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        ROLLBACK;  -- Nếu có lỗi xảy ra, hoàn tác tất cả các thao tác

    SET curr_date = CURDATE(); -- Lấy ngày hiện tại

    -- Bắt đầu giao dịch
START TRANSACTION;

-- Bước 1: Chèn các tỉnh duy nhất vào bảng 'province' nếu chưa có
INSERT INTO province (name)
SELECT DISTINCT province
FROM staging_lottery
WHERE province NOT IN (SELECT name FROM province);

-- Bước 2: Chèn các ngày duy nhất vào bảng 'date' nếu chưa có
INSERT INTO date (day, month, year)
SELECT DISTINCT
    DAY(STR_TO_DATE(date, '%d/%m/%Y')) AS day,
    MONTH(STR_TO_DATE(date, '%d/%m/%Y')) AS month,
    YEAR(STR_TO_DATE(date, '%d/%m/%Y')) AS year
FROM staging_lottery
WHERE (DAY(STR_TO_DATE(date, '%d/%m/%Y')),
    MONTH(STR_TO_DATE(date, '%d/%m/%Y')),
    YEAR(STR_TO_DATE(date, '%d/%m/%Y')))
    NOT IN (SELECT day, month, year FROM date);

-- Bước 3: Chèn các bản ghi mới vào bảng 'lottery'
INSERT INTO lottery (
    province_id, date_id, prize_special, prize_one, prize_two, prize_three,
    prize_four, prize_five, prize_six, prize_seven, prize_eight,
    created_at, date_insert, is_delete
)
SELECT
    (SELECT id FROM province WHERE name = stg.province) AS province_id,
    (SELECT id FROM date
     WHERE day = DAY(STR_TO_DATE(stg.date, '%d/%m/%Y'))
               AND month = MONTH(STR_TO_DATE(stg.date, '%d/%m/%Y'))
               AND year = YEAR(STR_TO_DATE(stg.date, '%d/%m/%Y'))) AS date_id,
        stg.prize_special, stg.prize_one, stg.prize_two, stg.prize_three,
        stg.prize_four, stg.prize_five, stg.prize_six, stg.prize_seven, stg.prize_eight,
        NOW() AS created_at, NOW() AS date_insert, FALSE AS is_delete
FROM staging_lottery AS stg
    LEFT JOIN lottery AS l
ON (SELECT id FROM province WHERE name = stg.province) = l.province_id
    AND (SELECT id FROM date
    WHERE day = DAY(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND month = MONTH(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND year = YEAR(STR_TO_DATE(stg.date, '%d/%m/%Y'))) = l.date_id
WHERE l.id IS NULL;

-- Bước 4: Xóa các bản ghi đã được chèn vào bảng 'lottery' khỏi bảng 'staging_lottery'
DELETE FROM staging_lottery
WHERE EXISTS (
    SELECT 1
    FROM lottery AS l
    WHERE l.province_id = (SELECT id FROM province WHERE name = staging_lottery.province)
      AND l.date_id = (SELECT id FROM date
                       WHERE day = DAY(STR_TO_DATE(staging_lottery.date, '%d/%m/%Y'))
                             AND month = MONTH(STR_TO_DATE(staging_lottery.date, '%d/%m/%Y'))
                             AND year = YEAR(STR_TO_DATE(staging_lottery.date, '%d/%m/%Y')))
    );

-- Nếu không có lỗi, commit để lưu các thay đổi vào cơ sở dữ liệu
COMMIT;

END$$

DELIMITER ;