CREATE PROCEDURE select_objects()
BEGIN
    SELECT * FROM objects ORDER BY id ASC;
END;
