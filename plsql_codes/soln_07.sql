-- SEQUENCE for Transaction IDs
CREATE SEQUENCE seq_transid
  START WITH 10000
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
/
-- PACKAGE SPECIFICATION
CREATE OR REPLACE PACKAGE PKG_BBReqs AS

    --Rent a movie by Movie ID and Member ID
    PROCEDURE NewMovieTrns(
        p_movie_id  IN BB_MOVIES.MOVIE_ID%TYPE,
        p_member_id IN BB_MEMBERS.MEMBER_ID%TYPE
    );

    --Rent a movie by Movie ID and Member Last Name
    PROCEDURE NewMovieTrns(
        p_movie_id  IN BB_MOVIES.MOVIE_ID%TYPE,
        p_last_name IN BB_MEMBERS.LAST_NAME%TYPE
    );

    -- Return a movie copy
    PROCEDURE ReturnMovie(
        p_transaction_id IN VARCHAR2,
        p_copy_id        IN VARCHAR2,
        p_status         IN VARCHAR2 DEFAULT NULL
    );

END PKG_BBReqs;
/

-- PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY PKG_BBReqs AS
    -- Rent a Movie by Movie ID and Member-----------------------------------------Procedure 1
    PROCEDURE NewMovieTrns(
        p_movie_id  IN BB_MOVIES.MOVIE_ID%TYPE,
        p_member_id IN BB_MEMBERS.MEMBER_ID%TYPE
    )
    IS
        v_copy_id  BB_MOVIE_COPIES.COPY_ID%TYPE;
        v_trans_id VARCHAR2(10);
        v_due_date DATE;
    BEGIN
        -- Find one available copy
        SELECT COPY_ID
        INTO v_copy_id
        FROM BB_MOVIE_COPIES
        WHERE MOVIE_ID = p_movie_id
          AND STATUS = 'Available'
          AND ROWNUM = 1;

        -- Mark the copy as rented
        UPDATE BB_MOVIE_COPIES
        SET STATUS = 'Rented'
        WHERE COPY_ID = v_copy_id;

        -- Generate transaction ID
        v_trans_id := 'T' || seq_transid.NEXTVAL;
        v_due_date := SYSDATE + 5;

        -- Insert into transactions table
        INSERT INTO BB_TRANSACTIONS(
            TRANSACTION_ID,
            COPY_ID,
            MOVIE_ID,
            MEMBERID,
            RENTED_DATE,
            RETURNED_DATE,
            STATUS
        )
        VALUES (
            v_trans_id,
            v_copy_id,
            p_movie_id,
            p_member_id,
            SYSDATE,
            NULL,
            'Rented'
        );

        -- Output invoice details
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        DBMS_OUTPUT.PUT_LINE('           RENTAL INVOICE');
        DBMS_OUTPUT.PUT_LINE('Transaction ID : ' || v_trans_id);
        DBMS_OUTPUT.PUT_LINE('Movie ID       : ' || p_movie_id);
        DBMS_OUTPUT.PUT_LINE('Copy ID        : ' || v_copy_id);
        DBMS_OUTPUT.PUT_LINE('Member ID      : ' || p_member_id);
        DBMS_OUTPUT.PUT_LINE('Due Date       : ' || TO_CHAR(v_due_date,'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('---------------------------------');

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No available copies for rent.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
    END;


    --Rent a Movie by Movie ID and Member Last Name-----------------------------------Procedure 2
    PROCEDURE NewMovieTrns(
        p_movie_id  IN BB_MOVIES.MOVIE_ID%TYPE,
        p_last_name IN BB_MEMBERS.LAST_NAME%TYPE
    )
    IS
        v_member_id BB_MEMBERS.MEMBER_ID%TYPE;
    BEGIN
        -- Find the member ID using last name
        SELECT MEMBER_ID
        INTO v_member_id
        FROM BB_MEMBERS
        WHERE LAST_NAME = p_last_name
          AND ROWNUM = 1;

        -- Call the other version (by member ID)
        PKG_BBReqs.NewMovieTrns(p_movie_id, v_member_id);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No member found with that last name.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
    END;
    
    --Return a Movie Copy-----------------------------------------------------------------Procedure 3
    PROCEDURE ReturnMovie(
        p_transaction_id IN VARCHAR2,
        p_copy_id        IN VARCHAR2,
        p_status         IN VARCHAR2 DEFAULT NULL
    )
    IS
    BEGIN
        -- Update the copy status
        IF p_status = 'Damaged' THEN
            UPDATE BB_MOVIE_COPIES
            SET STATUS = 'Damaged'
            WHERE COPY_ID = p_copy_id;
        ELSE
            UPDATE BB_MOVIE_COPIES
            SET STATUS = 'Available'
            WHERE COPY_ID = p_copy_id;
        END IF;

        -- Update transaction details
        UPDATE BB_TRANSACTIONS
        SET RETURNED_DATE = SYSDATE,
            STATUS = CASE
                       WHEN p_status = 'Damaged' THEN 'Damaged'
                       ELSE 'Returned'
                     END
        WHERE TRANSACTION_ID = p_transaction_id;

        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        DBMS_OUTPUT.PUT_LINE('     MOVIE RETURN SUCCESSFUL');
        DBMS_OUTPUT.PUT_LINE('Transaction ID : ' || p_transaction_id);
        DBMS_OUTPUT.PUT_LINE('Copy ID        : ' || p_copy_id);
        DBMS_OUTPUT.PUT_LINE('Status         : ' || NVL(p_status, 'Returned'));
        DBMS_OUTPUT.PUT_LINE('Return Date    : ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('---------------------------------');

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Invalid transaction or copy ID.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
    END;

END PKG_BBReqs;
/
----------------------Calling----------------------------------------------------
SET SERVEROUTPUT ON;

-- Rent movie by Movie ID & Member ID
BEGIN
    PKG_BBReqs.NewMovieTrns('M001', 101);
END;
/

-- Rent movie by Movie ID & Member Last Name
BEGIN
    PKG_BBReqs.NewMovieTrns('M005', 'Smith');
END;
/

-- Return a movie
BEGIN
    PKG_BBReqs.ReturnMovie('T10000', 'C002', 'Damaged');
END;
/
-------------------------------end of examples-------------------------------------------------
--drop sequence seq_transid;
--select * from BB_MEMBERS;
--rollback;
--SELECT * 
--FROM BB_MOVIE_COPIES

--SELECT * 
--FROM BB_MOVIE_COPIES
--WHERE STATUS = 'Available';
--rollback;
