---- FUNCTION: SF_ValidateDirector
--CREATE OR REPLACE FUNCTION SF_ValidateDirector(p_director_id IN NUMBER)
--RETURN BOOLEAN
--IS
--    v_count NUMBER;
--BEGIN
--    
--    SELECT COUNT(*) 
--    INTO v_count
--    FROM BB_DIRECTOR
--    WHERE DIRECTOR_ID = p_director_id;
--
--    -- If count > 0 TRUE; else FALSE
--    IF v_count > 0 THEN
--        RETURN TRUE;
--    ELSE
--        RETURN FALSE;
--    END IF;
--EXCEPTION
--    WHEN OTHERS THEN
--        RETURN FALSE;
--END;
--/

----------------------Calling----------------------------------------------------
--select * from bb_director;
set serveroutput on
DECLARE
    is_valid BOOLEAN;
BEGIN
    is_valid := SF_ValidateDirector(&input_director_id); --201,202,203,204,205 exists
    IF is_valid THEN
        DBMS_OUTPUT.PUT_LINE('Director exists!');
    ELSE
        DBMS_OUTPUT.PUT_LINE(q'[Director does'nt exist!]');
    END IF;
END;
/

