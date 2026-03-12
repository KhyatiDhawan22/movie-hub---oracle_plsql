---- PROCEDURE: SP_MovieByDirector
--CREATE OR REPLACE PROCEDURE SP_MovieByDirector(p_director_id IN NUMBER)
--IS
--    -- Cursor to fetch movies of the given director grouped by production house
--    CURSOR c_movies IS
--        SELECT ph.PRODHOUSE_NAME, m.MOVIE_ID, m.TITLE, m.PRICE
--        FROM BB_MOVIES m
--        JOIN BB_PRODHOUSE ph ON m.PRODHOUSE_ID = ph.PRODHOUSE_ID
--        WHERE m.DIRECTOR_ID = p_director_id
--        ORDER BY ph.PRODHOUSE_NAME, m.TITLE;
--    v_current_ph VARCHAR2(30) := ' '; -- to remember old Production House name
--BEGIN
--    -- Validate director ID 
--    IF SF_ValidateDirector(p_director_id) THEN
--        DBMS_OUTPUT.PUT_LINE('Movies of Director ID: ' || p_director_id);
--        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
--
--        -- Loop through the cursor
--        FOR rec IN c_movies LOOP
--        -- When new production house name is loaded make sure it is not same as the current 
--            IF v_current_ph != rec.PRODHOUSE_NAME THEN
--                v_current_ph := rec.PRODHOUSE_NAME;
--                DBMS_OUTPUT.PUT_LINE('Production House: ' || v_current_ph);
--            END IF;
--
--            -- Print movie details
--            DBMS_OUTPUT.PUT_LINE('Movie ID: ' || rec.MOVIE_ID || 
--                                 ', Title: ' || rec.TITLE || 
--                                 ', Price: $' || TO_CHAR(rec.PRICE, '999.99'));
--        END LOOP;
--    ELSE
--        -- Invalid Director_ID
--        DBMS_OUTPUT.PUT_LINE('ERROR: Director ID ' || p_director_id || ' does not exist.');
--    END IF;
--END;
--/

----------------------Calling----------------------------------------------------
BEGIN
    SP_MovieByDirector(&Input_movie_id);
END;
/
