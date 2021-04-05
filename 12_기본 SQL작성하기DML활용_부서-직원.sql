DROP TABLE employee;
DROP TABLE department;

CREATE TABLE department
(
    dept_no NUMBER,
    dept_name VARCHAR2(15),
    LOCATION VARCHAR2(15)
);

CREATE TABLE employee
(
    emp_no NUMBER,
    NAME VARCHAR2(20),
    depart NUMBER,
    POSITION VARCHAR2(20),
    gender CHAR(2),
    hire_date DATE,
    salary NUMBER
    
);

ALTER TABLE department ADD CONSTRAINT department_pk PRIMARY KEY(dept_no);
ALTER TABLE department MODIFY dept_name NOT NULL;
ALTER TABLE department MODIFY LOCATION NOT NULL;

ALTER TABLE employee ADD CONSTRAINT employee_pk PRIMARY KEY(emp_no);
ALTER TABLE employee MODIFY NAME VARCHAR2(20) NOT NULL;
ALTER TABLE employee ADD CONSTRAINT employee_fk FOREIGN KEY (depart) REFERENCES department(dept_no);





--외래키가 있을 경우 데이터 넣을 때도 관계를 생각하면서 insert해야함
--아님 DISABLE, ENABLE사용해서 넣을 수 있긴함
INSERT INTO department (dept_no, dept_name, LOCATION) VALUES (1, '영업부', '대구');
INSERT INTO department (dept_no, dept_name, LOCATION) VALUES (2, '인사부', '서울');
INSERT INTO department (dept_no, dept_name, LOCATION) VALUES (3, '총무부', '대구');
INSERT INTO department (dept_no, dept_name, LOCATION) VALUES (4, '기획부', '서울');

--날짜 타입 작성 방법
--1. '2021-04-02'
--2. '21-04-02'
--3. '2021/04/02'
--4. '21/04/02' --오라클 기본값
INSERT INTO employee VALUES(1001, '구창민', 1, '과장', 'M', '95/05/01', 5000000);
INSERT INTO employee VALUES(1002, '김민서', 1, '사원', 'M', '17/09/01', 2500000);
INSERT INTO employee VALUES(1003, '이은영', 2, '부장', 'F', '90/09/01', 5500000);
INSERT INTO employee VALUES(1004, '한성실', 2, '과장', 'F', '93/04/01', 5000000);



--행 (row)수정
--1. '영업부'의 위치를 '인천'으로 수정하시오
UPDATE department SET LOCATION = '인천' WHERE dept_no = '1'; --추천(기본키는 자동으로 index를 찾기때문에 더 빠름, 가능하면 PK를 쓰자)
-- update department set location = '인천' where department_name = '영업부';

--2. '과장'과 '부장'의 salary를 10%인상하시오.
UPDATE employee SET salary = salary * 1.1 WHERE POSITION IN('과장','부장'); --추천(where절이 한개 일때도 사용가능, 추후확장에 유리)
--update employee set salary = salary * 1.1 where position = '과장' or position = '부장';

--3. '총무부' -> '총괄팀', '대구' -> '광주'로 수정하시오.
UPDATE department SET LOCATION = '광주', dept_name = '총괄팀' WHERE dept_no =3;



--행(row)삭제
--1. 모든 employee를 삭제한다.
DELETE FROM employee;   --ROLLBACK으로 취소가능(DML)
--truncate table employee;    --빠르게 삭제되지만 취소가 불가능하다. (DDL)

--2. department에서 '기획부'를 삭제한다.
DELETE FROM department WHERE dept_no = 4;   --PK사용