CREATE PROCEDURE join_tables(IN table1 VARCHAR(64), IN table2 VARCHAR(64))
BEGIN
    SET @query = CONCAT(
        'SELECT * FROM ', table1, ' t1 ',
        'JOIN ', table2, ' t2 ON t1.id = t2.id'
    );

    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;
