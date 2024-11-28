USE lottery_db;

-- Xóa thủ tục nếu nó đã tồn tại
DROP PROCEDURE IF EXISTS load_To_staging_lottery;

DELIMITER $$

CREATE PROCEDURE load_To_staging_lottery(
    IN p_province VARCHAR(255),
    IN p_date VARCHAR(255),
    IN p_prize_special VARCHAR(255),
    IN p_prize_one VARCHAR(255),
    IN p_prize_two VARCHAR(255),
    IN p_prize_three VARCHAR(255),
    IN p_prize_four VARCHAR(255),
    IN p_prize_five VARCHAR(255),
    IN p_prize_six VARCHAR(255),
    IN p_prize_seven VARCHAR(255),
    IN p_prize_eight VARCHAR(255)
)
BEGIN
INSERT INTO staging_lottery (
    province,
    date,
    prize_special,
    prize_one,
    prize_two,
    prize_three,
    prize_four,
    prize_five,
    prize_six,
    prize_seven,
    prize_eight,
    created_at
)
VALUES (
           p_province,
           p_date,
           p_prize_special,
           p_prize_one,
           p_prize_two,
           p_prize_three,
           p_prize_four,
           p_prize_five,
           p_prize_six,
           p_prize_seven,
           p_prize_eight,
           NOW()  -- Gán giá trị mặc định là NOW() cho created_at
       );
END$$

DELIMITER ;
