----Step1 : creating a sequence
--CREATE SEQUENCE seq_movieid
--START WITH 100 
--INCREMENT BY 1 
--NOCACHE
--NOCYCLE;

---- Step 2: Procedure to add a new movie
--CREATE OR REPLACE PROCEDURE SP_NewMovie(
--    p_title     IN VARCHAR2,
--    p_prodh_id  IN NUMBER,
--    p_dir_id    IN NUMBER,
--    p_price     IN NUMBER
--)
--IS 
--     v_movie_id varchar(10);
--     v_count number;
--BEGIN
--    -- 1) Validate Production House ID (if not in bb_prodhouse print error)
--    SELECT COUNT(*)
--    INTO v_count
--    FROM bb_prodhouse
--    where prodhouse_id=p_prodh_id;
--    
--    IF v_count=0 THEN
--          DBMS_OUTPUT.PUT_LINE('ERROR: Invalid Production House ID.');
--          return;
--    END IF;
--    
--    --2) Validate Director ID
--    SELECT COUNT(*)
--    INTO v_count
--    FROM BB_DIRECTOR
--    WHERE DIRECTOR_ID = p_dir_id;
--    
--    IF v_count = 0 THEN
--         DBMS_OUTPUT.PUT_LINE('ERROR: Invalid Director ID.');
--          return;
--    END IF;
--    
--    --3)Validate Price
--    IF p_price < 500 THEN
--         DBMS_OUTPUT.PUT_LINE('ERROR: Invalid Price. Price cannot be less than 500.');
--          return;
--    END IF;
--    
--    --4)Generate Movie ID
--    v_movie_id := 'M' || TO_CHAR(seq_movieid.NEXTVAL, 'FM000'); --FM000 pads with leading zeros
--    
--    --5) Insert into BB_MOVIES
--    insert into bb_movies(movie_id,title,prodhouse_id,director_id,price)
--    values(v_movie_id, p_title, p_prodh_id, p_dir_id, p_price);
--    
--    --6)Success Message
--    DBMS_OUTPUT.PUT_LINE('SUCCESS: Movie added with Movie_ID = ' || v_movie_id);
--
--EXCEPTION
--    WHEN OTHERS THEN
--        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
--END;
--/
----------------------Calling----------------------------------------------------
--eg: Normal Insertion
BEGIN
    SP_NewMovie('Titanic', 302, 201, 1000);
END;
/
--eg:Error : Invalid Production House ID
BEGIN
    SP_NewMovie('Interstellar', 999, 201, 1000);
END;
/

--eg: Error : Invalid Director ID
BEGIN
    SP_NewMovie('Titanic', 302, 999, 1000);
END;
/

--eg: Error : Invalid Price (< 500)
BEGIN
    SP_NewMovie('The Matrix', 303, 203, 300);
END;
/
-------------------------------end of examples-------------------------------------------------
--rollback;
--DROP SEQUENCE seq_movieid;
--select * from BB_PRODHOUSE; --301,302,303,304,305
--select * from BB_DIRECTOR;--201,202,203,204, 205
--select * from BB_MOVIES;