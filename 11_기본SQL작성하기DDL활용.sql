DROP TABLE customer;
DROP TABLE BANK;

CREATE TABLE bank
(
    bank_code VARCHAR2(20),
    bank_name VARCHAR2(30)
);

--CREATE TABLE bank
--(
   -- bank_code VARCHAR2(20),
    --bank_name VARCHAR2(30),
    --CONSTRAINT bank_pk PRIMARY KEY (bank_code)
--);

CREATE TABLE customer
(
    no NUMBER,
    name VARCHAR2(30) Not Null,
    phone VARCHAR2(30),
    age NUMBER,
    bank_code VARCHAR2(20)
);


--CREATE TABLE customer
--(
    --no NUMBER,
    --name VARCHAR2(30) Not Null,
    --phone VARCHAR2(30),
    --age NUMBER,
    --bank_code VARCHAR2(20)
    --CONSTRAINT customer_pk PRIMARY KEY (no),
    --CONSTRAINT customer_phone_uq UNIQUE (phone),
    --CONSTRAINT customer_age_ck CHECK(age BETWEEN 0 AND 100),
    --CONSTRAINT customer_bank_fk FOREIGN KEY(bank_code) REFERENCES bank(bank_code)
--);



--테이블 구조확인
DESC bank;
DESC customer;

--테이블변경

--칼럼의 추가
--ALTER TABLE 테이블 ADD 칼럼명 칼럼타입 [제약조건];   --제약조건 생략가능;
--1.bank테이블에 연락처(bank_phone) 추가
ALTER TABLE bank ADD bank_phone VARCHAR2(15);

--칼럼의 수정
--ALTER TABLE 테이블 MODIFY 칼럼명 칼럼타입 [제약조건];   --제약조건 생략가능

--1. bank 테이블의 bank_name 칼럼을 varchar2(15)로변경
ALTER TABLE bank MODIFY bank_name VARCHAR2(15);

--2. customer테이블의 age 칼럼을 number(3)으로 변경
ALTER TABLE customer MODIFY age NUMBER(3);

--3. customer 테이블의 phone칼럼을 not null로 수정
ALTER TABLE customer MODIFY phone VARCHAR2(30) NOT NULL;

--4. customer 테이블의 phone칼럼을 null로 수정
ALTER TABLE customer MODIFY phone VARCHAR2(30) NULL;

--칼럼의 삭제
--ALTER TABLE 테이블 DROP COLUMN 칼럼명;

--1. bank테이블의 bank_phone 칼럼을 삭제한다.
ALTER TABLE bank DROP COLUMN bank_phone;

--칼럼의 이름변경
--ALTER TABLE 테이블 RENAME COLUMN 기존칼럼명 TO 신규칼럼명;

--1. customer테이블의 phone칼럼명을 contact으로 수정한다.
ALTER TABLE customer RENAME COLUMN phone TO contact;


--제약조건의 추가
ALTER TABLE bank ADD CONSTRAINT bank_pk PRIMARY KEY(bank_code);
ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY(no);
ALTER TABLE customer ADD CONSTRAINT customer_phone_uq UNIQUE(phone);
ALTER TABLE customer ADD CONSTRAINT customer_age_check CHECK(age BETWEEN 0 AND 100);
ALTER TABLE customer ADD CONSTRAINT customer_bank_fk FOREIGN KEY(bank_code) REFERENCES bank(bank_code);


