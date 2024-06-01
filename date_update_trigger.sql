CREATE TRIGGER before_update_objects
BEFORE UPDATE ON objects
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'objects'
        AND column_name = 'date_update'
      ) THEN
        ALTER TABLE objects ADD date_update DATETIME;
    END IF;
    SET NEW.date_update = NOW();
END;