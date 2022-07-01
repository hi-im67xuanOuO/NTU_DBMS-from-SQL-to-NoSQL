h_shift_fn = """
CREATE FUNCTION h_shift(pic BLOB, width INT, height INT, shift INT)
RETURNS BLOB

BEGIN
    DECLARE pad BINARY DEFAULT 0x00;
    DECLARE pad_row VARBINARY(100) DEFAULT 0x00;
    DECLARE pic_ VARBINARY(100);
    DECLARE out_pic BLOB DEFAULT 0x00;
    DECLARE x INT;

    SET x = 1;
    WHILE x <= ABS(shift)-1 DO
        SELECT CONCAT(pad_row, pad) INTO pad_row;
        SET x = x+1;
    END WHILE;
    SET x = 1;
    IF shift >=0 THEN
        WHILE x <= height DO
            SELECT SUBSTRING(pic, width*(x-1)+1, width-shift) INTO pic_;
            SELECT CONCAT(out_pic, pad_row, pic_) INTO out_pic;
            SET x = x + 1;
        END WHILE;
    ELSE
        WHILE x <= height DO
            SELECT SUBSTRING(pic, width*(x-1)+1+ABS(shift), width-ABS(shift)) INTO pic_;
            SELECT CONCAT(out_pic, pic_, pad_row) INTO out_pic;
            SET x = x + 1;
        END WHILE;
    END IF;
    SELECT SUBSTRING(out_pic, 2, width*height) INTO out_pic;
    RETURN out_pic;
END
"""

v_shift_fn = """
CREATE FUNCTION v_shift(pic BLOB, width INT, height INT, shift INT)
RETURNS BLOB

BEGIN
    DECLARE pad BINARY DEFAULT 0x00;
    DECLARE pad_row VARBINARY(100) DEFAULT 0x00;
    DECLARE out_pic BLOB DEFAULT 0x00;
    DECLARE pic_ BLOB;
    DECLARE x INT;

    SET x = 1;
    WHILE x <= width-1 DO
        SELECT CONCAT(pad_row, pad) INTO pad_row;
        SET x = x+1;
    END WHILE;
    SET x = 1;
    IF shift >=0 THEN
        SELECT SUBSTRING(pic, width*shift+1, width*(height-shift)) INTO out_pic;
        WHILE x <= shift DO
            SELECT CONCAT(out_pic, pad_row) INTO out_pic;
            SET x = x + 1;
        END WHILE;
    ELSE
        WHILE x <= ABS(shift) DO
            SELECT CONCAT(out_pic, pad_row) INTO out_pic;
            SET x = x + 1;
        END WHILE;
        SELECT SUBSTRING(pic, 1, width*(height-ABS(shift))) INTO pic_;
        SELECT CONCAT(out_pic, pic_) INTO out_pic;
        SELECT SUBSTRING(out_pic, 2, width*height) INTO out_pic;
    END IF;
    RETURN out_pic;
END
"""

corp_fn = """
CREATE FUNCTION corp(pic BLOB, width INT, height INT, corp_x INT, corp_y INT, corp_w INT, corp_h INT)
RETURNS BLOB

BEGIN
    DECLARE pad BINARY DEFAULT 0x00;
    DECLARE pad_row VARBINARY(100) DEFAULT 0x00;
    DECLARE pad_row_l VARBINARY(100) DEFAULT 0x00;
    DECLARE pad_row_r VARBINARY(100) DEFAULT 0x00;
    DECLARE pic_ BLOB;
    DECLARE out_pic BLOB DEFAULT 0x00;
    DECLARE x INT;

    SET x = 1;
    WHILE x <= width-1 DO
        SELECT CONCAT(pad_row, pad) INTO pad_row;
        SET x = x+1;
    END WHILE;
    SET x = 1;
    WHILE x <= corp_x-2 DO
        SELECT CONCAT(pad_row_l, pad) INTO pad_row_l;
        SET x = x+1;
    END WHILE;
    SET x = 1;
    WHILE x <= width-(corp_x+corp_w) DO
        SELECT CONCAT(pad_row_r, pad) INTO pad_row_r;
        SET x = x+1;
    END WHILE;
    SET x = 1;
    WHILE x <= corp_y-1 DO
        SELECT CONCAT(out_pic, pad_row) INTO out_pic;
        SET x = x + 1;
    END WHILE;
    WHILE x <= corp_y+corp_h-1 DO
        SELECT SUBSTRING(pic, width*(x-1)+corp_x+1, corp_w) INTO pic_;
        SELECT CONCAT(out_pic, pad_row_l, pic_, pad_row_r) INTO out_pic;
        SET x = x + 1;
    END WHILE;
    WHILE x <= height DO
        SELECT CONCAT(out_pic, pad_row) INTO out_pic;
        SET x = x + 1;
    END WHILE;
    SELECT SUBSTRING(out_pic, 2, width*height) INTO out_pic;
    RETURN out_pic;
END
"""

h_flip_fn = """
CREATE FUNCTION h_flip(pic BLOB, width INT, height INT)
RETURNS BLOB

BEGIN
    DECLARE pic_ BINARY DEFAULT 0x00;
    DECLARE out_pic BLOB DEFAULT 0x00;
    DECLARE x INT;
    DECLARE y INT;
    SET y = 1;
    WHILE y <= height DO
        SET x = 1;
        WHILE x <= width DO
            SELECT SUBSTRING(pic, width*y-x+1, 1) INTO pic_;
            SELECT CONCAT(out_pic, pic_) INTO out_pic;
            SET x = x + 1;
        END WHILE;
        SET y = y + 1;
    END WHILE;
    SELECT SUBSTRING(out_pic, 2, width*height) INTO out_pic;
    RETURN out_pic;
END
"""

v_flip_fn = """
CREATE FUNCTION v_flip(pic BLOB, width INT, height INT)
RETURNS BLOB

BEGIN
    DECLARE pic_ VARBINARY(100) DEFAULT 0x00;
    DECLARE out_pic BLOB DEFAULT 0x00;
    DECLARE x INT;
    SET x = 1;
    WHILE x <= height DO
        SELECT SUBSTRING(pic, width*(height-x)+1, width) INTO pic_;
        SELECT CONCAT(out_pic, pic_) INTO out_pic;
        SET x = x + 1;
    END WHILE;
    SELECT SUBSTRING(out_pic, 2, width*height) INTO out_pic;
    RETURN out_pic;
END
"""