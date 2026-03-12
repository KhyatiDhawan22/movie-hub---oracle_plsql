----Step1 : creating a sequence
--CREATE SEQUENCE seq_memberid 
--START WITH 100 
--INCREMENT BY 1 
--NOCACHE;

---- Step 2:Creating  PROCEDURE: SP_NewMember
--CREATE OR REPLACE PROCEDURE SP_NewMember(
--    p_first_name IN VARCHAR2,
--    p_last_name IN VARCHAR2,
--    p_address IN VARCHAR2,
--    p_ssn IN VARCHAR2
--)
--IS
--    v_member_id NUMBER;
--    v_count NUMBER;
--    v_col_length number;
--BEGIN
--    -- 1) Validate First Name!=Last Name
--    IF p_first_name = p_last_name THEN
--        DBMS_OUTPUT.PUT_LINE('ERROR: First Name and Last Name cannot be the same.');
--        RETURN;
--    END IF;
--
--    -- 2) Validate Address != null or '  '
--    IF TRIM(p_address) IS NULL THEN
--        DBMS_OUTPUT.PUT_LINE('ERROR: Address cannot be empty.');
--        RETURN;
--    END IF;
--
--    -- 3) Validate SSN length
--    --Step3: using Data Dictionary Views USER_TAB_COLUMNS
--    SELECT DATA_LENGTH
--    INTO v_col_length
--    FROM USER_TAB_COLUMNS
--    WHERE TABLE_NAME = 'BB_MEMBERS'
--    AND COLUMN_NAME = 'SSN';
--    
--    IF LENGTH(p_ssn) != v_col_length THEN
--        DBMS_OUTPUT.PUT_LINE('ERROR: SSN must be '|| v_col_length ||' characters long.');
--        RETURN;
--    END IF;
--
--    -- 4) Check SSN uniqueness
--    SELECT COUNT(*)
--    INTO v_count
--    FROM BB_MEMBERS
--    WHERE SSN = p_ssn;
--
--    IF v_count > 0 THEN
--        DBMS_OUTPUT.PUT_LINE('ERROR: SSN already exists. Enter a unique SSN.');
--        RETURN;
--    END IF;
--
--    -- 5) Generate MEMBER_ID using sequence
--    v_member_id := SEQ_MemberID.NEXTVAL;
--
--    -- 6) Insert the new member
--    INSERT INTO BB_MEMBERS (MEMBER_ID, FIRST_NAME, LAST_NAME, ADDRESS, SSN)
--    VALUES (v_member_id, p_first_name, p_last_name, p_address, p_ssn);
--
--    -- 7) Success message
--    DBMS_OUTPUT.PUT_LINE('SUCCESS: New member added with MEMBER_ID = ' || v_member_id);
--
--EXCEPTION
--    WHEN OTHERS THEN
--        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
--END;
--/

----------------------Calling----------------------------------------------------
--eg: Normal add 
BEGIN
    SP_NewMember('Alice', 'Smith', '123 Elm st ', '678-90-1234');
END;
/

-- eg error : first name = last name
BEGIN
    SP_NewMember('John', 'John', '123 Elm St', '111-22-3333');
END;
/

-- eg error : Address empty
BEGIN
    SP_NewMember('Alice', 'Smith', NULL, '112-22-3333');
END;
/

-- eg error : Address ' ' 
BEGIN
    SP_NewMember('Alice', 'Smith', '   ', '113-22-3333');
END;
/

--eg: error: SSN length is not 11 characters
BEGIN
    SP_NewMember('Bob', 'Johnson', '456 Oak St', '123-45-67'); -- only 7 characters
END;
/

--eg: errro:SSN is not unique (already exists)
BEGIN
    SP_NewMember('Mary', 'Williams', '789 Pine St', '123-45-6789');
END;
/
-------------------------------end of examples-------------------------------------------------
--rollback;
--DROP SEQUENCE SEQ_MemberID;
--select * from bb_members;