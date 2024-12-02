
DROP PROCEDURE IF EXISTS transform_load_data_to_warehouse;
DELIMITER $$

CREATE PROCEDURE transform_load_data_to_warehouse()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        ROLLBACK;

    -- Bắt đầu giao dịch
START TRANSACTION;

-- Bước 1: Chèn các tỉnh duy nhất vào bảng 'province' nếu chưa có
INSERT IGNORE INTO province (name)
SELECT DISTINCT province
FROM staging_lottery;

-- Bước 2: Chèn các ngày duy nhất vào bảng 'date' nếu chưa có
INSERT IGNORE INTO date (day, month, year)
SELECT DISTINCT
    DAY(STR_TO_DATE(date, '%d/%m/%Y')) AS day,
    MONTH(STR_TO_DATE(date, '%d/%m/%Y')) AS month,
    YEAR(STR_TO_DATE(date, '%d/%m/%Y')) AS year
FROM staging_lottery;

-- Bước 3: Chèn hoặc cập nhật vào bảng 'lottery'
INSERT INTO lottery (
    province_id, date_id, prize_special, prize_one, prize_two, prize_three,
    prize_four, prize_five, prize_six, prize_seven, prize_eight,
    date_delete, modify_date
)
SELECT
    p.id AS province_id,
    d.id AS date_id,
    stg.prize_special, stg.prize_one, stg.prize_two, stg.prize_three,
    stg.prize_four, stg.prize_five, stg.prize_six, stg.prize_seven, stg.prize_eight,
    NULL AS date_delete,
    NOW() AS modify_date
FROM staging_lottery stg
         INNER JOIN province p ON p.name = stg.province
         INNER JOIN date d ON d.day = DAY(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND d.month = MONTH(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND d.year = YEAR(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    LEFT JOIN lottery l ON l.province_id = p.id
    AND l.date_id = d.id
    AND l.prize_special = stg.prize_special
    AND l.prize_one = stg.prize_one
    AND l.prize_two = stg.prize_two
    AND l.prize_three = stg.prize_three
    AND l.prize_four = stg.prize_four
    AND l.prize_five = stg.prize_five
    AND l.prize_six = stg.prize_six
    AND l.prize_seven = stg.prize_seven
    AND l.prize_eight = stg.prize_eight
WHERE l.id IS NULL; -- Chỉ chèn nếu không có bản ghi nào hoàn toàn trùng khớp

-- Bước 4: Xóa các bản ghi đã xử lý trong bảng 'staging_lottery'
DELETE stg
FROM staging_lottery stg
INNER JOIN province p ON p.name = stg.province
INNER JOIN date d ON d.day = DAY(STR_TO_DATE(stg.date, '%d/%m/%Y'))
                  AND d.month = MONTH(STR_TO_DATE(stg.date, '%d/%m/%Y'))
                  AND d.year = YEAR(STR_TO_DATE(stg.date, '%d/%m/%Y'))
LEFT JOIN lottery l ON l.province_id = p.id
                   AND l.date_id = d.id
                   AND l.prize_special = stg.prize_special
                   AND l.prize_one = stg.prize_one
                   AND l.prize_two = stg.prize_two
                   AND l.prize_three = stg.prize_three
                   AND l.prize_four = stg.prize_four
                   AND l.prize_five = stg.prize_five
                   AND l.prize_six = stg.prize_six
                   AND l.prize_seven = stg.prize_seven
                   AND (l.prize_eight = stg.prize_eight OR (l.prize_eight IS NULL AND stg.prize_eight IS NULL)) -- Điều chỉnh này sẽ xử lý NULL
WHERE l.id IS NOT NULL;


    -- Kết thúc giao dịch
COMMIT;
END$$

DELIMITER ;