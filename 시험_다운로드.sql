DROP TABLE BUYS;
DROP TABLE USERS;

-- 사용자 테이블
-- 칼럼 : 사용자번호, 아이디, 이름, 태어난년도, 주소, 연락처1, 연락처2, 가입일
-- 기본키 : 사용자번호
CREATE TABLE USERS (
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) NOT NULL UNIQUE,
    USER_NAME VARCHAR2(20),
    USER_YEAR NUMBER(4),
    USER_ADDR VARCHAR2(100),
    USER_MOBILE1 VARCHAR2(3),  -- 010, 011 등
    USER_MOBILE2 VARCHAR2(8),  -- 12345678, 11111111 등
    USER_REGDATE DATE
);


-- 구매 테이블
-- 칼럼 : 구매번호, 아이디, 제품명, 제품카테고리, 제품가격, 구매개수
-- 기본키 : 구매번호
-- 외래키 : 아이디 (사용자 테이블의 아이디 칼럼을 참조하는 키)
CREATE TABLE BUYS (
    BUY_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) REFERENCES USERS(USER_ID),
    PROD_NAME VARCHAR2(20),
    PROD_CATEGORY VARCHAR2(20),
    PROD_PRICE NUMBER,
    BUY_AMOUNT NUMBER
);


-- USERS 테이블에 레코드(행, ROW) 삽입하기
INSERT INTO USERS VALUES (1, 'YJS', '유재석', 1972, '서울', '010', '11111111', '08/08/08');
INSERT INTO USERS VALUES (2, 'KHD', '강호동', 1970, '경북', '011', '22222222', '07/07/07');
INSERT INTO USERS VALUES (3, 'KKJ', '김국진', 1965, '서울', '019', '33333333', '09/09/09');
INSERT INTO USERS VALUES (4, 'KYM', '김용만', 1967, '서울', '010', '44444444', '15/05/05');
INSERT INTO USERS VALUES (5, 'KJD', '김제동', 1974, '경남', NULL, NULL, '13/03/03');
INSERT INTO USERS VALUES (6, 'NHS', '남희석', 1971, '충남', '016', '55555555', '14/04/04');
INSERT INTO USERS VALUES (7, 'SDY', '신동엽', 1971, '경기', NULL, NULL, '08/10/10');
INSERT INTO USERS VALUES (8, 'LHJ', '이휘재', 1972, '경기', '011', '66666666', '06/04/04');
INSERT INTO USERS VALUES (9, 'LKK', '이경규', 1960, '경남', '018', '77777777', '04/12/12');
INSERT INTO USERS VALUES (10, 'PSH', '박수홍', 1970, '서울', '010', '88888888', '12/05/05');

-- BUYS 테이블에 레코드(행, ROW) 삽입하기
INSERT INTO BUYS VALUES (1001, 'KHD', '운동화', NULL, 30, 2);
INSERT INTO BUYS VALUES (1002, 'KHD', '노트북', '전자', 1000, 1);
INSERT INTO BUYS VALUES (1003, 'KYM', '모니터', '전자', 200, 1);
INSERT INTO BUYS VALUES (1004, 'PSH', '모니터', '전자', 200, 5);
INSERT INTO BUYS VALUES (1005, 'KHD', '청바지', '의류', 50, 3);
INSERT INTO BUYS VALUES (1006, 'PSH', '메모리', '전자', 80, 10);
INSERT INTO BUYS VALUES (1007, 'KJD', '책', '서적', 15, 5);
INSERT INTO BUYS VALUES (1008, 'LHJ', '책', '서적', 15, 2);
INSERT INTO BUYS VALUES (1009, 'LHJ', '청바지', '의류', 50, 1);
INSERT INTO BUYS VALUES (1010, 'PSH', '운동화', NULL, 30, 2);

COMMIT;

------------------------------------------------------------------------------------------------
--2
SELECT 
       U.USER_ID AS 아이디
     , COUNT(B.BUY_NO) AS 구매횟수
  FROM USERS U, BUYS B
 WHERE U.USER_ID = B.USER_ID
 GROUP BY U.USER_ID;
--3
SELECT
       U.USER_NAME AS 고객명
     , B.PROD_NAME AS 구매제품
  FROM USERS U RIGHT OUTER JOIN BUYS B
    ON U.USER_ID = B.USER_ID;
--4
SELECT U.USER_NAME AS 고객명
     , SUM(B.PROD_PRICE * B.BUY_AMOUNT) AS 총구매액
  FROM USERS U RIGHT OUTER JOIN BUYS B
    ON U.USER_ID = B.USER_ID
 GROUP BY U.USER_NAME;
--5
SELECT U.USER_NAME AS 고객명
     , NVL(SUM(B.PROD_PRICE * B.BUY_AMOUNT),0) AS 총구매액
  FROM USERS U LEFT OUTER JOIN BUYS B
    ON U.USER_ID = B.USER_ID
 GROUP BY U.USER_NAME;
 --6
CREATE OR REPLACE PROCEDURE update_procedure
AS
    OUTPUT NUMBER;
BEGIN
    DELETE FROM BUYS WHERE USER_ID = 
                           (SELECT B.USER_ID
                              FROM USERS U, BUYS B
                             WHERE U.USER_ID = B.USER_ID
                               AND U.USER_NO = 5);
    DELETE FROM USERS WHERE USER_NO = 5;
    SELECT COUNT(*) INTO OUTPUT FROM USERS;
END update_procedure;

DECLARE

            output NUMBER;

        BEGIN

            update_procedure(output);

            DBMS_OUTPUT.PUT_LINE('사용자 수 : ' || output);

        END;

--7
CREATE OR REPLACE FUNCTION fn_total (TOTAL NUMBER)
RETURN NUMBER
IS 
    ID VARCHAR2(20);  
    TOTAL NUMBER := PROD_PRICE * BUY_AMOUNT;
BEGIN
    TOTAL := 0;
    SELECT PROD_PRICE , BUY_AMOUNT
      FROM BUYS
     WHERE USER_ID = ID;
    RETURN TOTAL;
END fn_total;

-- 함수의확인 EXECUTE로 하지않음
SELECT fn_total('KHD') FROM BUYS;


CREATE OR REPLACE TRIGGER USER_TRIG

    AFTER UPDATE OR DELETE

    ON MEMBERS

    FOR EACH ROW

BEGIN

    DBMS_OUTPUT.PUT_LINE('트리거가 동작하였습니다');

END;


 --필
CREATE OR REPLACE PROCEDURE USER_PROC 
AS
    OUTPUT NUMBER;
BEGIN
    DELETE FROM BUYS WHERE USER_ID = 
                           (SELECT B.USER_ID
                              FROM USERS U, BUYS B
                             WHERE U.USER_ID = B.USER_ID
                               AND U.USER_NO = 5);
    DELETE FROM USERS WHERE USER_NO = 5;
    SELECT COUNT(*) INTO OUTPUT FROM USERS;
END USER_PROC ;
