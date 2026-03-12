----Step1 : creating a sequence
--CREATE SEQUENCE seq_moviecopyid
--START WITH 500
--INCREMENT BY 1
--NOCACHE
--NOCYCLE;

----Step 2: Procedure to add a new copy of a movie 
--CREATE OR REPLACE PROCEDURE SP_NewMovieCopy(
--     p_movie_id IN VARCHAR2
--)
--IS
--    v_copy_id   VARCHAR2(10);
--    v_count     NUMBER;
--    max_copies_exception EXCEPTION;  -- Custom exception
--BEGIN
--        -- 1) Validate Movie ID : Movie should exists in BB_MOVIES
--        SELECT COUNT(*)
--        INTO v_count
--        FROM bb_movies
--        WHERE movie_id = p_movie_id;
--         
--        IF v_count = 0 THEN
--            DBMS_OUTPUT.PUT_LINE('ERROR: Invalid Movie ID. Cannot create copy.');
--            RETURN;
--        END IF;
--        
--        --2) Check number of non-damaged copies
--        SELECT COUNT(*)
--        INTO v_count
--        FROM bb_movie_copies
--        WHERE movie_id=p_movie_id
--        AND status = 'Available'; --available copies/non damages
--        
--        --There can only be 10 non-damaged copies for any movie
--        IF v_count>=10 THEN
--                RAISE max_copies_exception;
--        END IF;
--        
--        --3) Generate Copy ID (Instead of using MCP, My copy_id is like C001 
--        v_copy_id:= 'C' || TO_CHAR(SEQ_MovieCopyID.NEXTVAL, 'FM000');--FM000 pads with leading zeros
--        
--        --4)Insert new copy
--        INSERT INTO bb_movie_copies(copy_id, movie_id, status)
--        VALUES (v_copy_id, p_movie_id, 'Available');
--        
--    -- 5) Success message
--        DBMS_OUTPUT.PUT_LINE('SUCCESS: New movie copy added with Copy_ID = ' || v_copy_id);
--    EXCEPTION
--        WHEN max_copies_exception THEN
--            DBMS_OUTPUT.PUT_LINE('ERROR: Cannot create more than 10 available copies for this movie.');
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
--END;
--/
----------------------Calling----------------------------------------------------
--eg: Normal Insertion 
BEGIN
    SP_NewMovieCopy('M003');  
END;
/
--eg:Error :Max Copies Reached
BEGIN
    SP_NewMovieCopy('M001');  -- M001 currently has 2 available copy
    SP_NewMovieCopy('M001'); -- M001 currently has 3 available copy
    SP_NewMovieCopy('M001'); -- M001 currently has 4 available copy
    SP_NewMovieCopy('M001'); -- M001 currently has 5 available copy
    SP_NewMovieCopy('M001'); -- M001 currently has 6 available copy
    SP_NewMovieCopy('M001'); -- M001 currently has 7 available copy
    SP_NewMovieCopy('M001');-- M001 currently has 8 available copy
    SP_NewMovieCopy('M001');-- M001 currently has 9 available copy
    SP_NewMovieCopy('M001');-- M001 currently has 10 available copy
    SP_NewMovieCopy('M001');--error here 
END;
/
--eg:Error: Invalid Movie ID
BEGIN
    SP_NewMovieCopy('F001');  -- Invalid Movie ID
END;
/
-------------------------------end of examples-------------------------------------------------
--rollback;
--DROP SEQUENCE seq_moviecopyid;
--select * from BB_MOVIE_COPIES;
--select * from BB_MOVIES;--M001,M002,M003,M004,M005