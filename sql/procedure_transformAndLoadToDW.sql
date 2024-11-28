-- Chuyển sang cơ sở dữ liệu 'lottery_db'
USE lottery_db;

-- Xóa thủ tục nếu nó đã tồn tại
DROP PROCEDURE IF EXISTS transform_load_data_to_warehouse;

DELIMITER $$

-- Tạo thủ tục transform_load_data_to_warehouse
CREATE PROCEDURE transform_load_data_to_warehouse()
BEGIN
    DECLARE curr_date DATE;
    SET curr_date = CURDATE(); -- Lấy ngày hiện tại

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

-- Bước 3: Cập nhật các bản ghi đã xóa trong bảng 'lottery'
UPDATE lottery AS l
    LEFT JOIN staging_lottery AS stg
ON l.province_id = (SELECT id FROM province WHERE name = stg.province)
    AND l.date_id = (SELECT id FROM date
    WHERE day = DAY(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND month = MONTH(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND year = YEAR(STR_TO_DATE(stg.date, '%d/%m/%Y')))
    SET l.is_delete = TRUE, -- Đánh dấu bản ghi là đã xóa
        l.expired_date = curr_date,
        l.date_delete = curr_date
WHERE stg.id IS NULL AND l.is_delete = FALSE;

-- Bước 4: Chèn các bản ghi mới vào bảng 'lottery'
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

-- Bước 5: Cập nhật các bản ghi trong bảng 'lottery' nếu có thay đổi
UPDATE lottery AS l
    INNER JOIN staging_lottery AS stg
ON l.province_id = (SELECT id FROM province WHERE name = stg.province)
    AND l.date_id = (SELECT id FROM date
    WHERE day = DAY(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND month = MONTH(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND year = YEAR(STR_TO_DATE(stg.date, '%d/%m/%Y')))
    SET l.prize_special = stg.prize_special,
        l.prize_one = stg.prize_one,
        l.prize_two = stg.prize_two,
        l.prize_three = stg.prize_three,
        l.prize_four = stg.prize_four,
        l.prize_five = stg.prize_five,
        l.prize_six = stg.prize_six,
        l.prize_seven = stg.prize_seven,
        l.prize_eight = stg.prize_eight,
        l.expired_date = NULL, -- Reset ngày hết hạn
        l.is_delete = FALSE; -- Đánh dấu là không bị xóa

END$$

DELIMITER ;
