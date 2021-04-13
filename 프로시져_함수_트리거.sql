SET SERVEROUTPUT ON;
-- 1. 프로시져
--  1) 한번에 처리할 수 있은 쿼리문의 집합이다.
--  2) 결과(반환값)가 있을 수도 있고, 없을 수도 있다.
--  3) EXECUTE(EXEC)를 통해서 실행한다.

-- 프로시져 정의
CREATE OR REPLACE PROCEDURE PROC1  -- 프로시져명: PROC1
AS  -- 변수선언 하는 곳, IS라고 적어도 됨
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO PROCEDURE');
END PROC1;  --END;도 가능
-- 프로시져 실행 
EXECUTE PROC1();

--  2) 프로시져에서 변수 선언하고 사용하기
CREATE OR REPLACE PROCEDURE PROC2
AS
    MY_AGE NUMBER(3);
BEGIN
    MY_AGE := 20;
    DBMS_OUTPUT.PUT_LINE('나는 ' || MY_AGE ||' 살이다.');
END PROC2;
EXEC PROC2();


-- 3) 입력파라미터
-- 프로시져에 전달하는 값: 인수처리 방법
-- 문제 : IMPLOYEE_ID를 입력 파라미터로 전달하면 해당 사원의 LAST_NAME 출력하기
CREATE OR REPLACE PROCEDURE PROC3(IN_EMPLOYEE_ID IN NUMBER) -- 타입 작성 시 크기 지정 안 함(NUMBER, VARCAHR2 등)
IS  
    V_LAST_NAME EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    SELECT LAST_NAME INTO V_LAST_NAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = IN_EMPLOYEE_ID;
    DBMS_OUTPUT.PUT_LINE('결과: ' || V_LAST_NAME);
END PROC3;
EXEC PROC3(100); --입력 파라미터 100 전달

-- 4) 출력파라미터
-- 프로시저의 실행 결과를 저장하는 파라미터
-- 함수와 비교하면 함수의 반환값(RETURN)
CREATE OR REPLACE PROCEDURE PROC4(OUT_RESULT OUT NUMBER)
IS
BEGIN
    SELECT MAX(SALARY) INTO OUT_RESULT  -- 최고 연봉은 출력 파라미터 OUT_RESULT에 저장
      FROM EMPLOYEES;
END PROC4;

-- 프로시저를 호출 할 때
-- 프로시저의 결과를 저장할 변수를 넘겨준다.
DECLARE
    MAX_SALARY NUMBER;
BEGIN
    PROC4(MAX_SALARY);  -- MAX_SALARY에 최고연봉이 저장되기를 기대
    DBMS_OUTPUT.PUT_LINE('최고연봉: ' || MAX_SALARY);
END;

-- 5) 입출력 파라미터
-- 입력 : 사원번호
-- 출력 : 연봉
CREATE OR REPLACE PROCEDURE PROC5(IN_OUT_PARAM IN OUT NUMBER)
IS
    V_SALARY NUMBER;
BEGIN
    SELECT SALARY INTO V_SALARY
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = IN_OUT_PARAM;  -- 입력된 인수(사원번호)를 조건으로 사용
     IN_OUT_PARAM := V_SALARY;   --결과를 출력파라미터에 저장
EXCEPTION WHEN OTHERS THEN  -- 예외처리
    DBMS_OUTPUT.PUT_LINE('예외코드: ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('예외메시지: ' || SQLERRM);
END PROC5;

-- 변수를 전달할 때는 사워넌호를 저장해서 보내고,
-- 프로시져 실행 후에는 해당 변수의 연봉이 저장되어 있다.
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 100;  -- 사원번호100 의미
    PROC5(RESULT);  --EXECUTE없이 실행
    DBMS_OUTPUT.PUT_LINE('실행 후 결과: ' || RESULT);
END;
    
--문제셋팅
--BOOK, CUSTOMER, ORDERS 테이블 사용 (DQL 연습문제 참조)

ALTER TABLE BOOK ADD STOCK NUMBER;
ALTER TABLE CUSTOMER ADD POINT NUMBER;
ALTER TABLE ORDERS ADD AMOUNT NUMBER;

UPDATE BOOK SET STOCK = 10;
UPDATE CUSTOMER SET POINT = 1000;
UPDATE ORDERS SET AMOUNT = 1;
 
COMMIT;


-- EXEC PROC_ORDER(회원번호, 책번호, 구매수량);
DROP SEQUENCE ORDERS_SEQ;
CREATE SEQUENCE ORDERS_SEQ INCREMENT BY 1 START WITH 11 NOMAXVALUE NOMINVALUE NOCYCLE NOCACHE;

-- 1. ORDERS 테이블에 주문 기록이 삽입된다.(ORDER_NO는 시퀀스 처리, SALES_PRICE는 BOOK 테이블의 PRICE의 90%)
-- 2. CUSTOMER 테이블에 주문 총액(구매수량 * 판매 가격)의 10%를 POINT에 더해 준다.
-- 3. BOOK 테이블에 재고를 구매수량만큼 조절한다.

CREATE OR REPLACE PROCEDURE PROC_ORDER
(
    IN_CUSTOMER_ID IN NUMBER,
    IN_BOOK_ID IN NUMBER,
    IN_AMOUNT IN NUMBER
)
IS
BEGIN
    INSERT INTO ORDERS
        (ORDER_ID, CUSTOMER_ID, BOOK_ID, SALES_PRICE, ORDER_DATE, AMOUNT)
    VALUES
        (ORDERS_SEQ.NEXTVAL, IN_CUSTOMER_ID, IN_BOOK_ID, (SELECT FLOOR(PRICE * 0.9)FROM BOOK WHERE BOOK_ID = IN_BOOK_ID), SYSDATE, IN_AMOUNT);
    UPDATE CUSTOMER
       SET POINT = POINT + FLOOR(IN_AMOUNT * (SELECT SALES_PRICE FROM ORDERS WHERE ORDER_ID = (SELECT MAX(ORDER_ID) FROM ORDERS)) * 0.1)
     WHERE CUSTOMER_ID = IN_CUSTOMER_ID;
    UPDATE BOOK
       SET STOCK = STOCK - IN_AMOUNT
     WHERE BOOK_ID = IN_BOOK_ID;
    COMMIT;  -- 작업의 성공
EXCEPTION
 WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('예외코드: ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('예외메시지: ' || SQLERRM);
    ROLLBACK;   -- 수행된 작업의 취소
END PROC_ORDER;

EXEC PROC_ORDER(1,1,2);     -- 1번 구매자가 1번 책을 2권 구매한다.
    
    
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. 사용자 함수
--  1) 하나의 결과갑이 있다.(RETURN이 있다.)
--  2) 주로 쿼리문에 포함된다.
CREATE OR REPLACE FUNCTION GET_TOTAL(N NUMBER)  -- 1부터 N까지의 합계를 반환하는 함수
RETURN NUMBER   -- 반환 값이 NUMBER타입이다.
IS     --변수 선언하는 곳
    I NUMBER;   --1에서 N까지 사이의 숫자
    TOTAL NUMBER;
BEGIN
    TOTAL := 0;
    FOR I IN 1 .. N LOOP    -- 최소 1부터 최대 N까지
    TOTAL := TOTAL + I;
    END LOOP;
    RETURN TOTAL;  --반환값
END GET_TOTAL;

-- 함수의확인 EXECUTE로 하지않음
SELECT GET_TOTAL(100) FROM DUAL;


--문제
CREATE OR REPLACE FUNCTION GET_GRADE(SCORE NUMBER)
RETURN CHAR
IS
    GRADE CHAR(1);
BEGIN
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
    RETURN GRADE;
END GET_GRADE;

--함수의확인
SELECT GET_GRADE(90) AS 학점 FROM DUAL; -- 'A'학점


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. 트리거
--  1) INSERT, UPDATE, DELETE 작업을 수행하면 자동으로 실행되는 작업이다.(기록이 남는것)
--  2) BEFORE, AFTER트리거를 많이 사용한다.

CREATE OR REPLACE TRIGGER TRIG1
    BEFORE  -- 수행 이전에 자동으로 실행된다.
    INSERT OR UPDATE OR DELETE  -- 트리거가 동작할 작업을 고른다.
    ON EMPLOYEES    -- 트리거가 동작할 테이블이다.
    FOR EACH ROW -- 한 행씩 적용된다.
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO TRIGGER!');
END TRIG1;

-- 트리거 동작 확인
UPDATE EMPLOYEES SET SALARY = 25000 WHERE EMPLOYEE_ID = 100;
DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID = 206;

CREATE OR REPLACE TRIGGER TRIG2
    AFTER   -- 수행 이후에 자동으로 실행된다.
    INSERT OR UPDATE OR DELETE
    ON EMPLOYEES
    FOR EACH ROW
BEGIN
    IF INSERTING THEN   -- 삽입작업이었다면,
        DBMS_OUTPUT.PUT_LINE('INSERT 했군요.');
    ELSIF UPDATING THEN -- 갱신하였다면,
         DBMS_OUTPUT.PUT_LINE('UPDATE 했군요.');
    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('DELETE 했군요.');
    END IF;
END TRIG2;

-- 트리거 동작 확인
UPDATE EMPLOYEES SET SALARY = 25000 WHERE EMPLOYEE_ID = 100;

-- 트리거 삭제
DROP TRIGGER TRIG1;
DROP TRIGGER TRIG2;

-- 문제
-- EMPLOYEES 테이블에서 삭제된 데이터는 퇴사자(RETIRE)테이블에 자동으로 저장되는
-- 트리거를 작성하시오.
--         INSERT       UPDATE       DELETE
-- :OLD     NULL       수정전값     삭제전값
-- :NEW   추가된 값    수정후값       NULL

-- 1. 퇴사자 테이블을 생성한다.
-- RETIRE_ID, EMPLOYEE_ID, LAST_NAME, DEPARTMENT_ID, HIRED_DATE, RETIRE_DATE
CREATE TABLE RETIRE
(
    RETIRE_ID NUMBER,
    EMPLOYEE_ID NUMBER,
    LAST_NAME VARCHAR2(25),
    DEPARTMENT_ID NUMBER,
    HIRE_DATE DATE,
    RETIRE_DATE DATE
);

ALTER TABLE RETIRE ADD CONSTRAINT RETIRE_PK PRIMARY KEY(RETIRE_ID);

-- 2. RETIRE_SEQ 시퀀스를 생성한다.
CREATE SEQUENCE RETIRE_SEQ NOCACHE;

-- 3. 트리거를 생성한다.
CREATE OR REPLACE TRIGGER RETIRE_TRIGER
    AFTER   --삭제된 이후에 동작하므로 삭제 이전의 데이터는 :OLD에 있다.
    DELETE
    ON EMPLOYEES
    FOR EACH ROW
BEGIN
    INSERT INTO RETIRE
        (RETIRE_ID, EMPLOYEE_ID, LAST_NAME, DEPARTMENT_ID, HIRE_DATE, RETIRE_DATE)
    VALUES
        (RETIRE_SEQ.NEXTVAL, :OLD.EMPLOYEE_ID, :OLD.LAST_NAME, :OLD.DEPARTMENT_ID, :OLD.HIRE_DATE, SYSDATE);
END RETIRE_TRIGER;

-- 4. 삭제를 통해 트리거 동작을 확인한다.
DELETE FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;
SELECT RETIRE_ID
     , EMPLOYEE_ID
     , LAST_NAME
     , DEPARTMENT_ID
     , HIRE_DATE
     , RETIRE_DATE
  FROM RETIRE;