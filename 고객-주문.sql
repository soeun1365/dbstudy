-- 고객릴레이션 (부모테이블)
CREATE TABLE 고객
(
고객아이디 VARCHAR2(30) PRIMARY KEY,
고객이름 NVARCHAR2(30),          --30바이트 최대 15자, NVARCHAR2(30)은 최대 한글30글자,영어 60
나이 NUMBER(3),                  --최대3자
등급 CHAR(1),                    --한글자 고정형
직업 VARCHAR2(5),                --코드로 5자
적립금 NUMBER(7)                 --백만원자리까지
);

--주문릴레이션 (자식테이블)
CREATE TABLE 주문
(
주문번호 NUMBER PRIMARY KEY,
주문고객 VARCHAR2(30) REFERENCES 고객(고객아이디),              -- FOREIGN KEY 외래키(고객테이블의 고객아이디 칼럼을 참조) 반드시 타입을 같게 해줘야함, 이름을 달라도됨
주문제품 VARCHAR2(20),
수량 NUMBER,
단가 NUMBER,
주문일자 DATE
);

SELECT * FROM 고객;

DROP TABLE 고객;