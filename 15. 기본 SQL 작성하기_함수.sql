-- 오라클 내장 함수
-- 1. 집계 함수
DROP TABLE score;

CREATE TABLE score
(
    kor NUMBER(3),
    eng NUMBER(3),
    mat NUMBER(3)
);

INSERT INTO score (kor, eng, mat) VALUES(10, 10, 10);
INSERT INTO score VALUES(20, 20, 20);
INSERT INTO score VALUES(30, 30, 30);
INSERT INTO score VALUES(90, 90, 90);
INSERT INTO score VALUES(100, 100, 100);

-- 1) 국어(kor) 점수의 합계를 구한다.
    SELECT SUM(kor) FROM score; --칼럼이 1개인 테이블이 생성
--  칼럼의 이름지정
    SELECT SUM(kor) 합계 FROM score; 
    SELECT SUM(kor) AS 국어접수합계 FROM score;
    
-- 2) 모든점수의 합계
    SELECT SUM(kor) + SUM(eng) + SUM(mat) AS 잔체점수합계 FROM score;    --칼럼은 한개만 지정할 수 있다.
    
-- 3) 국어(kor)점수의 평균
    SELECT AVG(kor) AS 국어점수평균 FROM score;
-- 4) 영어(eng)점수의 최대값
    SELECT MAX(eng) AS 영어점수최대값 FROM score;
-- 5) 수학(mat) 점수의 최소값
    SELECT MIN(mat) AS 수학점수최소값 FROM score;
    
-- name칼럼을 추가하고, 적당한 이름을 삽입하시오.
    ALTER TABLE score ADD NAME VARCHAR2(15);
    UPDATE score SET NAME =' James' WHERE kor=10;
    UPDATE score SET NAME ='jjANGGU ' WHERE kor=20;
    UPDATE score SET NAME ='    Smith' WHERE kor=30;
    UPDATE score SET NAME ='Choco' WHERE kor=90;
    UPDATE score SET NAME ='sweet   ' WHERE kor=100;
    
-- 국어점수 중 임의로 2개를 Null로 수정하시오. 
    UPDATE score SET kor = NULL WHERE NAME = 'Smith';
    UPDATE score SET kor = NULL WHERE NAME = 'Choco';
    
-- 이름의개수
     SELECT COUNT(NAME) FROM score;
-- 국어점수의 개수를 구하시오
    SELECT COUNT(kor) FROM score;
-- 학생의 개수를 구하시오
    SELECT COUNT(*) FROM score;  --  * 은 전체 칼럼을 의미한다. 어떤 칼럼이든 하나라도 데이터가 포함되어 있으면 개수를 구한다.
    
--2. 문자 함수
-- 1) 대소문자 관련 함수
    SELECT INITCAP(name) FROM SCORE; --첫글자만 대문자, 나머지 소문자
    SELECT UPPER(name) FROM SCORE;  --모두 대문자
    SELECT LOWER(name) FROM SCORE;  --모두 소문자
    
-- 2) 문자열의 길이 반환 함수
    SELECT LENGTH(name) FROM SCORE;

-- 3) 문자열의 일부 반환 함수
    SELECT SUBSTR(name, 2, 3) FROM SCORE;    --2번째 글자부터 3번째 글짜까지 반환

-- 4) 문자열에서 특정 문자의 포함된 위치 반환 함수
    SELECT INSTR(name, 'J') FROM SCORE;     --str은 대소문자 구분함, 대문자J의 위치가 반환, 있으면 1, 없으면0
    SELECT INSTR(upper(name),'J') FROM score;   --모두 대문자로 변환후 찾기
    
-- 5) 왼쪽패딩
    SELECT Lpad(name,10,'*') From score;
    
-- 6) 오른쪽패딩
    SELECT Rpad(name, 10, '★')FROM score;

-- 모든 name을 오른쪽 맞춤해서 출력
    SELECT LPAD(name, 10, ' ')FROM score;
    
-- 모든 name을 다음과 같이 출력
-- James: Ja**
-- jjANGGU:jj*******
-- Smith:Sm***
-- Choco:Ch***
-- sweet: sw***
    Select RPAD(Substr(name, 1, 2), Length(name), '*')From Score;

-- 7) 문자열 연결 함수
-- 오라클에서 연산자|| 는 OR개념이 아닌 연결연산자이다.
-- James 10 10 10 이렇게 데이터 붙여서 출력
    SELECT name ||' '||kor||' '||eng||' '||mat FROM score;

    SELECT CONCAT(name, ' ')FROM score;
    SELECT CONCAT(CONCAT(name, ' '), kor) FROM score;
    
-- 8) 불필요한 문자열 제거 함수(좌우만 가능하고, 중간에 포함된 건 불가능)
    SELECT LTRIM(name) FROM score;  --왼쪽 공백을 제거 
    SELECT LTRIM(name, ' ') FROM score;  -- 이렇게 ' '로 지정해도 가능
    SELECT LENGTH(LTRIM(name)) FROM score;   --왼쪽 공백을 제거 후 글자수 세기
    SELECT RTRIM(name) FROM score;  --오른쪽 공백을 제거 
    SELECT LENGTH(RTRIM(name)) FROM score;
    SELECT TRIM(name) FROM score;               --그냥 trim이면 양쪽의 공백 제거
    
-- 다음데이터를 삽입한다.
-- 80, 80, 80, james bond
    INSERT INTO score(kor, eng, mat, name) VALUES (80, 80, 80, 'james bond');

-- 아래와 같이 출력한다.
--first_name      last_name
--james            bond

    SELECT substr(name, 1, instr(name, ' ') - 1) AS first_name,
           substr(name, instr(name, ' ') + 1  ) AS last_name        --마지막 ~자리까지인지는 생략해도 됨
    FROM score WHERE kor = 80;
    
    
-- 3. 숫자함수

--테이블을 사용하지 않는 SELECT문에서는 DUAL 테이블을 사용합니다. 실제로 DUAL테이블을 쓰겠다는건 아니고
--테이블의 형태는 갖추고 있는데 테이블을 아니다... 테이블의 뭔가를 빼다 쓰려는게 아니고
--FROM 절을 생략할수 없는 오라클 특성때문에 FROM DUAL을 해준다.
    DESC DUAL;
    SELECT DUMMY FROM DUAL;


--1) 반올림 함수
-- ROUND (값, 자릿수) FROM DUAL;
    SELECT ROUND(123.4567, 1) FROM DUAL;  -- 소수 자릿수 1자리로 반올림하겠다 --> 123.5
    SELECT ROUND(123.4567, 2) FROM DUAL;  -- 소수 자릿수 2자리로 반올림하겠다 --> 123.46
    SELECT ROUND(123.4567, 0) FROM DUAL;  -- 정수로 반올림                    --> 123
    SELECT ROUND(123.4567) FROM DUAL;     -- 정수로 반올림                    --> 123
    SELECT ROUND(123.4567, -1) FROM DUAL; -- 10의 자리로 반올림               --> 120
    SELECT ROUND(123.4567, -2) FROM DUAL; -- 100의 자리로 반올림              --> 100


--2) 올림 함수
-- CEIL(값) : 정수로 올림(ceiling 천장)
-- 자릿수 조정을 계산을 통해서 처리합니다.
    SELECT CEIL(123.4567) FROM DUAL;    --> 124
    --(1)소수 자릿수 2자리로 올림
    --    과정 =>>  100을 곱한다. ---> CEIL()처리한다. ---> 100으로 나눈다.
    SELECT CEIL(123.4567 * 100)/100 FROM DUAL;  --> 123.46
    
    --(2)소수 자릿수 1자리로 올림
    --    과정 =>>  10을 곱한다. ---> CEIL()처리한다. ---> 10으로 나눈다.
    SELECT CEIL(123.4567 * 10)/100 FROM DUAL;  --> 123.46

    --(3)10의 자리로 올림
    --    과정 =>>  10의 -1제곱(0.1) ---> CEIL()처리한다. ---> 10의 -1제곱(0.1)으로 나눈다.
    SELECT CEIL(123.4567 * 0.1)/0.1 FROM DUAL;    -->130
    
    --(4)100의 자리로 올림
    --    과정 =>>  10의 -2제곱(0.01) ---> CEIL()처리한다. ---> 10의 -2제곱(0.01)으로 나눈다.
    SELECT CEIL(123.4567 * .01)/.01 FROM DUAL;  --> 200
    
    
--3) 내림 함수
-- FLOOR(값) : 정수로 내림(floor 바닥)
-- CEIL()와 같은 방식으로 사용합니다.
    SELECT FLOOR(567.8989 * 100)/ 100 FROM DUAL;     --> 567.89
    SELECT FLOOR(567.8989 * 10)/ 10 FROM DUAL;       --> 567.8
    SELECT FLOOR(567.8989 * 1)/ 1 FROM DUAL;         --> 567
    SELECT FLOOR(567.8989 * .1)/.1 FROM DUAL;        --> 560
    SELECT FLOOR(567.8989 * 0.01)/ 0.01 FROM DUAL;   --> 500
    SELECT FLOOR(567.8989 * 0.001)/ 0.001 FROM DUAL; --> 0
    
   
--4) 절사 함수(TRUNCATE)
-- TRUNC (값, 자릿수) FROM DUAL;
    SELECT TRUNC(567.8989, 2)  FROM DUAL; --> 567.89
    SELECT TRUNC(567.8989, 1)  FROM DUAL; --> 567.8
    SELECT TRUNC(567.8989, 0)  FROM DUAL; --> 567
    SELECT TRUNC(567.8989)     FROM DUAL; --> 567
    SELECT TRUNC(567.8989, -1) FROM DUAL; --> 560
    SELECT TRUNC(567.8989, -2) FROM DUAL; --> 500

        -- 내림과 절사의 차이점
        -- 음수에서 차이가 발생한다.
            SELECT FLOOR(-1.5)FROM DUAL;    --1.5보다 작은 정수       --> -2
            SELECT TRUNC(-1.5, 0)FROM DUAL; --1.5에서 정수로 자름     --> -1

-- 4. 날짜 함수




-- 5. 형 변환 함수
    
    
    
    
    
    
    
    