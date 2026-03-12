--before 8:00 A.M. or after 10:00 P.M. from Sunday to Friday, 
--and before 8:00 A.M. or after 12:00 P.M. on Saturday.

CREATE OR REPLACE TRIGGER trg_businesshours BEFORE
    INSERT OR UPDATE OR DELETE ON bb_movies
DECLARE
    v_day  VARCHAR2(10) := to_char(sysdate, 'DAY');
    v_hour NUMBER := TO_NUMBER ( to_char(sysdate, 'HH24') );
BEGIN
    IF (
        v_day IN ( 'SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY',
                   'FRIDAY' )
        AND ( v_hour < 8
        OR v_hour > 22 )
    )
    OR (
        v_day = 'SATURDAY'
        AND ( v_hour < 8
        OR v_hour > 12 )
    ) THEN
        raise_application_error(-20010, 'Modifications allowed only during business hours.');
    END IF;
END;
/