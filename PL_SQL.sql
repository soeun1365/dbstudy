-- HR 계정의 EMPLOYEES 테이블을 복사하기
-- 테이블을 복사하면 PK, FK는 복사되지 않는다.
CREATE TABLE EMPLOYEES
    AS SELECT * FROM HR.EMPLOYEES;  -- HR계정의 EMPLOYEES싹다 복사
    
DESC USER_CONSTRAINTS;  -- 제약조건을 저장하고 있는 데이터사전
  
SELECT *
  FROM USER_CONSTRAINTS
 WHERE TABLE_NAME = 'EMPLOYEES';
 
-- 복사한 테이블에 기본키(PK) 지정하기
ALTER TABLE EMPLOYEES ADD CONSTRAINT EMPLOYEES_PK PRIMARY KEY(EMPLOYEE_ID);

--------------------------------------------------------------------------------
-- PL/SQL

-- 접속마다 최초 1회만 하면 된다.
-- 결과를 화면에 듸우기
SET SERVEROUTPUT ON;    -- 디폴트 SET SERVEROUTPUT OFF; 

-- 기본구성
/*  
변수선언 할 거 없으면 DECLARE부 생략가능

    DEDLARE
        변수선언;
    BEGIN
        작업
    END;
*/

-- 화면출력
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO PL/SQL');
END;

-- 변수선언 (스칼라 변수)
DECLARE
    MY_NAME VARCHAR2(20);
    MY_AGE NUMBER(3);
BEGIN
    -- 변수에 값을 대입 (대입연산자가 := 이렇게 생김)
    MY_NAME := '에밀리';
    MY_AGE := 30;
    DBMS_OUTPUT.PUT_LINE('내 이름은' || MY_NAME || '입니다.');
    DBMS_OUTPUT.PUT_LINE('내 나이는' || MY_AGE || '입니다.');
END;

-- 변수선언 (참조 변수)
-- 기존 칼럼의 타입을 그대로 가져와서 사용한다.

--계정명.테이블.칼럼%TYPE
DECLARE
    V_FIRST_NAME EMPLOYEES.FIRST_NAME%TYPE;  --V_LAST_NAME VARCHE2(20);
    V_LAST_NAME EMPLOYEES.LAST_NAME%TYPE;   --V_LAST_NAME VARCHE2(25);
BEGIN
    -- 테이블의 데이터를 변수에 저장하기
    -- SELECT 칼럼 INTO변수 FROM 테이블;
    -- 칼럼의 데이터를 변수에 저장
/*
    SELECT FIRST_NAME INTO V_FIRST_NAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;
    SELECT LAST_NAME INTO V_LAST_NAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;
*/    
    SELECT FIRST_NAME, LAST_NAME
      INTO V_FIRST_NAME, V_LAST_NAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;
     DBMS_OUTPUT.PUT_LINE(V_FIRST_NAME || ' ' || V_LAST_NAME);
END;


-- IF문
DECLARE
    SCORE NUMBER(3);
    GRADE CHAR(1);
BEGIN
    SCORE := 50;
    IF SCORE >= 90 THEN
        GRADE := 'A';
    ELSIF SCORE >= 80 THEN
        GRADE := 'B';
    ELSIF SCORE >= 70 THEN
        GRADE := 'C';
    ELSIF SCORE >= 60 THEN
        GRADE := 'D';
    ELSE
        GRADE := 'F';
    END IF;
    DBMS_OUTPUT.PUT_LINE('점수는' || SCORE || '점이고, 학점은' || GRADE || '학점입니다.');
END;

-- CASE문
DECLARE
    SCORE NUMBER(3);
    GRADE CHAR(1);
BEGIN
    SCORE := 90;
    CASE
        WHEN SCORE >= 90 THEN
            GRADE := 'A';
        WHEN SCORE >= 80 THEN
            GRADE := 'B';
        WHEN SCORE >= 70 THEN
            GRADE := 'C';
        WHEN SCORE >= 60 THEN
            GRADE := 'D';
        ELSE
            GRADE := 'F';
    END CASE;
    DBMS_OUTPUT.PUT_LINE('점수는' || SCORE || '점이고, 학점은' || GRADE || '학점입니다.');
END;

-- 문제) 사원번호가 200인 사원의 연봉(SALARY)를 가져와서,
-- 5000 이상이면 '고액연봉자', 아니면 공백출력하시오.
DECLARE
     V_SALARY EMPLOYEES.SALARY%TYPE;
     V_RESULT VARCHAR2(20);
BEGIN
    
    SELECT SALARY INTO V_SALARY
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;

    IF V_SALARY >= 5000 THEN
        V_RESULT := '고액연봉자';
    ELSE
        V_RESULT := ' ';
    END IF;
    DBMS_OUTPUT.PUT_LINE('결과: ' || V_RESULT);
END;

--WHILE문
--1부터 100까지 모두 더하기
DECLARE
    N NUMBER(3);
    TOTAL NUMBER(4);
BEGIN
    TOTAL := 0;
    N := 1;
    WHILE N <= 100 LOOP
        TOTAL := TOTAL + N;
        N := N + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('합계: ' || TOTAL);
END;

--FOR문
DECLARE
    N NUMBER(3);
    TOTAL NUMBER(4);
BEGIN
    TOTAL := 0;
    FOR N IN 1 .. 100 LOOP  --1부터 100까지 LOOP
        TOTAL := TOTAL + N;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('합계: ' || TOTAL);
END;

-- EXIT문 (자바의 BREAK문-반복문 끝낼때)
-- 1부터 누적합계를 구하다가 최초 누적합계가 3000 이상인 경우 반복문을 종료하고
-- 해당 누적합계를 출력

-- 첫번째 버전
DECLARE
    N NUMBER(3);
    TOTAL NUMBER(4);
BEGIN
    TOTAL := 0;
    N := 1;
    WHILE TRUE LOOP     -- 무한루프
        TOTAL := TOTAL + N;
        IF TOTAL >= 3000 THEN
            EXIT;
        END IF;
        N := N + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('합계: ' || TOTAL);
END;

-- 두번째 버전

DECLARE
    N NUMBER(3);
    TOTAL NUMBER(4);
BEGIN
    TOTAL := 0;
    N := 1;
    WHILE TRUE LOOP     
        TOTAL := TOTAL + N;
        EXIT WHEN TOTAL >= 3000;    -- EXIT WHEN 사용
        N := N + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('합계: ' || TOTAL);
END;

-- CONTINUE문
-- 1에서 100 사이 모든 짝수의 합계 구하기
DECLARE
    N NUMBER(3);
    TOTAL NUMBER(4);
BEGIN
    TOTAL := 0;
    N := 0;
    WHILE N < 100 LOOP
        N := N + 1;
        IF MOD(N, 2) =1 THEN    --2로 나눈 나머지가 1이면 --> 홀수면
            CONTINUE;   -- WHILE문으로 이동
        END IF;
        TOTAL := TOTAL + N;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('짝수합계: ' || TOTAL);
END;


-- 테이블타입
-- 테이블에 여러개의 데이터를 가져와서 배열처럼 사용하는 타입
DECLARE
    I NUMBER;   --INDEX
    --FIRST_NAME_TYPE : EMPLOYEES테이블의 FIRST_NAME칼럼값을 배열처럼 사용할 수 있는 타입
    TYPE FIRST_NAME_TYPE IS TABLE OF EMPLOYEES.FIRST_NAME%TYPE INDEX BY BINARY_INTEGER;
    --FIRST_NAMES : EMPLOYEES테이블의 FIRS_NAME칼럼값을 실제로 저장하는 변수(배열)
    FIRST_NAMES FIRST_NAME_TYPE;    --명 타입
BEGIN
    I := 0;
    FOR V_ROW IN (SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEES) LOOP
        FIRST_NAMES(I) := V_ROW.FIRST_NAME;
        DBMS_OUTPUT.PUT_LINE(FIRST_NAMES(I) || ' ' || V_ROW.LAST_NAME);
        I := I + 1;
    END LOOP;
END;
    
--부서번호(DEPARTMENT_ID)가 50인 부서의 FIRST_NAME, LAST_NAME을 가져와서
-- 새로운 테이블 EMPLOYEES50에 삽입하시오.
CREATE TABLE EMPLOYEES50
        AS (SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEES WHERE 1 = 0);
DECLARE
    V_FIRST_NAME EMPLOYEES.FIRST_NAME%TYPE;
    V_LAST_NAME EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    FOR V_ROW IN (SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEES WHERE DEPARTMENT_ID = 50) LOOP
        V_FIRST_NAME := V_ROW.FIRST_NAME;
        V_LAST_NAME := V_ROW.LAST_NAME;
        INSERT INTO EMPLOYEES50(FIRST_NAME, LAST_NAME) VALUES(V_FIRST_NAME, V_LAST_NAME);
    END LOOP;
    COMMIT;
END;
SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEES50;
    
-- 레코드 타입
-- 여러 칼럼(열)이 모여서 하나의 레코드(행, ROW)가 된다.
-- 여러 데이터를 하나로 모으는 개념: 객체(변수+함수)의 하위개념보다는 -> 구조체(변수)의 의미로 받아들이기
DECLARE
    TYPE PERSON_TYPE IS RECORD
    (
        MY_NAME VARCHAR2(20),
        MY_AGE NUMBER(3)
    );
    MAN PERSON_TYPE;    --PERSON_TYPE의 MAN
    WOMAN PERSON_TYPE;  --PERSON_TYPE의 WOMAN
BEGIN
    MAN.MY_NAME := '제임스';
    MAN.MY_AGE := 20;
    WOMAN.MY_NAME := '앨리스';
    WOMAN.MY_AGE := 30;
    DBMS_OUTPUT.PUT_LINE(MAN.MY_NAME || ' ' ||MAN.MY_AGE);
    DBMS_OUTPUT.PUT_LINE(WOMAN.MY_NAME || ' ' ||WOMAN.MY_AGE);
END;

-- 테이블형 레코드 타입
--부서번호(DEPARTMENT_ID)가 50인 부서의 전체 칼럼을 가져와서
-- 새로운 테이블 EMPLOYEES2에 삽입하시오.

DROP TABLE EMPLOYEES2;
CREATE TABLE EMPLOYEES2
    AS (SELECT * FROM EMPLOYEES WHERE 1 = 0);    --새로운 테이블 구조만 짬

DECLARE
    ROW_DATA SPRING.EMPLOYEES%ROWTYPE; --EMPLOYEES테이블의 행(ROW)전체를 저장 할 수 있는 변수
    EMP_ID NUMBER(3);
BEGIN
    FOR EMP_ID IN 100 .. 206 LOOP
        SELECT * INTO ROW_DATA
          FROM SPRING.EMPLOYEES
         WHERE EMPLOYEE_ID = EMP_ID;
        INSERT INTO EMPLOYEES2 VALUES ROW_DATA;
    END LOOP;
END;

SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEES2;

-- 예외처리
DECLARE
    V_LAST_NAME VARCHAR2(25);    --원래 칼럼의 타입보다 크거나 같으면 된다. 작은것은 안되고
BEGIN
    SELECT LAST_NAME INTO V_LAST_NAME
      FROM EMPLOYEES
        WHERE EMPLOYEE_ID = 100;       -- 있는 사웜
     -- WHERE EMPLOYEE_ID = 1;       -- 없는 사웜
     -- WHERE department_id = 50;      -- 많은 사웜
     DBMS_OUTPUT.PUT_LINE('결과: ' || V_LAST_NAME);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 없다.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 많다.');
END;

-- 예외처리2: 모든 예외 처리하는 방법
DECLARE
    V_LAST_NAME VARCHAR2(25);    --원래 칼럼의 타입보다 크거나 같으면 된다. 작은것은 안되고
BEGIN
    SELECT LAST_NAME INTO V_LAST_NAME
      FROM EMPLOYEES
     -- WHERE EMPLOYEE_ID = 1;       -- 없는 사웜
        WHERE department_id = 50;      -- 많은 사웜
     DBMS_OUTPUT.PUT_LINE('결과: ' || V_LAST_NAME);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외 코드: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('예외 메시지: ' || SQLERRM);
END;