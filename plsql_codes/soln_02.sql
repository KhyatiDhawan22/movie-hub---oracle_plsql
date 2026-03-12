---- FUNCTION: SF_ValidateProdHouse
--CREATE OR REPLACE FUNCTION SF_ValidateProdHouse(p_prodh_id IN NUMBER)
--RETURN BOOLEAN
--IS
--    v_count NUMBER;
--BEGIN
--    SELECT COUNT(*)
--    INTO v_count
--    FROM BB_PRODHOUSE
--    WHERE PRODHOUSE_ID = p_prodh_id;
--    
--    IF v_count > 0 THEN
--        RETURN TRUE;
--    ELSE
--        RETURN FALSE;
--    END IF;
--    
--EXCEPTION
--    WHEN OTHERS THEN
--        RETURN FALSE;
--END;
--/

----------------------Calling----------------------------------------------------
--select * from bb_prodhouse;
set serveroutput on
DECLARE
    is_valid BOOLEAN;
BEGIN
    is_valid := SF_ValidateProdHouse(&input_prodhouse_id); --301,302,303,304,305 exists
    IF is_valid THEN
        DBMS_OUTPUT.PUT_LINE('Production House exists!');
    ELSE
        DBMS_OUTPUT.PUT_LINE(q'[Production House doesn't exist!]');
    END IF;
END;
/

