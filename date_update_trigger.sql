CREATE TRIGGER before_update_objects
BEFORE UPDATE ON objects
FOR EACH ROW
BEGIN
    DECLARE column_exists INT DEFAULT 0;

    SELECT COUNT(*)
    INTO column_exists
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'objects'
      AND column_name = 'date_update';

    IF column_exists = 0 THEN
        SET @alter_sql = 'ALTER TABLE objects ADD COLUMN date_update DATETIME';
        PREPARE stmt FROM @alter_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;

    SET NEW.date_update = NOW();
END;
