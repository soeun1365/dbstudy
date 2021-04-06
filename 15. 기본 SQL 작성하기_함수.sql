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
    
-- 2. 문자 함수
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
-- first_name      last_name
-- james            bond

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


-- 2) 올림 함수
-- CEIL(값) : 정수로 올림(ceiling 천장)
-- 자릿수 조정을 계산을 통해서 처리합니다.
    SELECT CEIL(123.4567) FROM DUAL;    --> 124
    -- (1)소수 자릿수 2자리로 올림
    --    과정 =>>  100을 곱한다. ---> CEIL()처리한다. ---> 100으로 나눈다.
    SELECT CEIL(123.4567 * 100)/100 FROM DUAL;  --> 123.46
    
    -- (2)소수 자릿수 1자리로 올림
    --    과정 =>>  10을 곱한다. ---> CEIL()처리한다. ---> 10으로 나눈다.
    SELECT CEIL(123.4567 * 10)/100 FROM DUAL;  --> 123.46

    -- (3)10의 자리로 올림
    --    과정 =>>  10의 -1제곱(0.1) ---> CEIL()처리한다. ---> 10의 -1제곱(0.1)으로 나눈다.
    SELECT CEIL(123.4567 * 0.1)/0.1 FROM DUAL;    -->130
    
    -- (4)100의 자리로 올림
    --    과정 =>>  10의 -2제곱(0.01) ---> CEIL()처리한다. ---> 10의 -2제곱(0.01)으로 나눈다.
    SELECT CEIL(123.4567 * .01)/.01 FROM DUAL;  --> 200
    
    
-- 3) 내림 함수
-- FLOOR(값) : 정수로 내림(floor 바닥)
-- CEIL()와 같은 방식으로 사용합니다.
    SELECT FLOOR(567.8989 * 100)/ 100 FROM DUAL;     --> 567.89
    SELECT FLOOR(567.8989 * 10)/ 10 FROM DUAL;       --> 567.8
    SELECT FLOOR(567.8989 * 1)/ 1 FROM DUAL;         --> 567
    SELECT FLOOR(567.8989 * .1)/.1 FROM DUAL;        --> 560
    SELECT FLOOR(567.8989 * 0.01)/ 0.01 FROM DUAL;   --> 500
    SELECT FLOOR(567.8989 * 0.001)/ 0.001 FROM DUAL; --> 0
    
   
-- 4) 절사 함수(TRUNCATE)
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

-- 5) 절대값
-- ABS(값)
    SELECT ABS(-5) fROM DUAL;

-- 6) 부호판별
-- sign(값)
-- 값이 양쉬면 1
-- 값이 음수이면 -1
-- 값이 0이면 0
    SELECT SIGN(5) FROM DUAL;
    SELECT SIGN(-5) FROM DUAL;
    SELECT SIGN(0) FROM DUAL;

-- 7) 나머지
-- MOD(A, B) : A를 B로 나눈 나머지
    SELECT MOD(7,2) FROM DUAL;

-- 8) 제곱
-- POWER(A, B) : A의 B제곱
    SELECT POWER(10, 2) FROM DUAL;      --> 100
    SELECT POWER(10, 1) FROM DUAL;      --> 10
    SELECT POWER(10, 0) FROM DUAL;      --> 1
    SELECT POWER(10, -1) FROM DUAL;     --> 0.1
    SELECT POWER(10, -2) FROM DUAL;     --> 0.01


-- 4. 날짜 함수
-- 1) 현재날짜 (타입이 DATE)
-- SYSDATE
    SELECT SYSDATE FROM DUAL;
    
-- 2) 현재날짜 (타입이 TIMESTAMP)
-- SYSTIMESTAMP
    SELECT SYSTIMESTAMP FROM DUAL;
    
-- 3) 년/월/일/시/분/초 추출
-- EXTRACT(단위 FROM 날짜)
-- SELECT와 FROM 을 오른쪽 맞춤으로 정렬
    SELECT EXTRACT(YEAR FROM SYSDATE) AS 현재년도,
           EXTRACT(MONTH FROM SYSDATE) AS 현재월,
           EXTRACT(DAY FROM SYSDATE) AS 현재일,
           EXTRACT(HOUR FROM SYSTIMESTAMP) AS 현재시간,     -- SYSDATE 에는 시간, 분, 초가 없으므로 SYSTIMESTAMP로 해주기
           EXTRACT(MINUTE FROM SYSTIMESTAMP) AS 현재분,     -- SYSDATE 에는 시간, 분, 초가 없으므로 SYSTIMESTAMP로 해주기
           EXTRACT(SECOND FROM SYSTIMESTAMP) AS 현재초      -- SYSDATE 에는 시간, 분, 초가 없으므로 SYSTIMESTAMP로 해주기
      FROM DUAL;                                           

-- 4) 날짜연산(이전, 이후)
-- 1일 : 숫자1 로 봄
-- 12시간: 숫자 0.5
    SELECT SYSDATE + 1 AS 내일, 
           SYSDATE -1 AS 어제,
           SYSDATE +0.5 AS 열두시간후,
           SYSDATE -0.5 AS 열두시간전,
           SYSTIMESTAMP + 0.5 AS  열두시간후
      FROM DUAL;
 
-- 5) 개월연산
-- ADD_MONTHS(날짜, n) : n개월 후
    SELECT ADD_MONTHS(SYSDATE, -3) AS 삼개월전,
           ADD_MONTHS(SYSDATE, 3) AS 삼개월후
      FROM DUAL; 

-- MONTHS_BETWEEN(날짜1, 날짜2) : 두 날짜 사이 경과한 개월수 (날짜1 - 날짜2)
-- MONTHS_BETWEEN(최근날짜, 이전날짜) --> 그래야 양수값 나옴, 반대로 하면 음수값 나옴
-- TRUNC 처리해서 만 개월수 찾기
    SELECT TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE('2021-01-01'))) FROM DUAL;

-- 5. 형 변환 함수
-- 1) 날짜 변환 함수 ★★★★★★ 프로젝트에서 사용확률 높음
-- TO_DATE(문자열, [형식])

-- [ 형식 ]
-- YYYY YY      연
-- MM, M        월
-- DD, D        일
-- HH, H        시간
-- MI           분
-- SS           초

    SELECT TO_DATE('2021-04-01'),
           TO_DATE('2021/04/01'),
           TO_DATE('21-04-01'),
           TO_DATE('21/04/01'),     --기본타입
           
           -- 형식을 주자
           TO_DATE('2021/01/04', 'YYYY/DD/MM'),
           TO_DATE('20210401', 'YYYYMMDD'),
           TO_DATE('0401, 21','MMDD, YY')
      FROM DUAL;
    
-- 2) 숫자 변환 함수  
-- TO_NUMBER(문자열)
    SELECT TO_NUMBER('100')FROM DUAL;
    
    SELECT name, kor
      from SCORE
     WHERE kor >= '50';   -- 내부적으로 WHERE kor >= To_NUMBER('50')으로 처리되서 값을 볼 수 있음, 오라클이 알아서 TO_NUMBER로 해줌
     
-- 3) 문자열 변환 함수
-- (1) 숫자형식
-- TO_CHAR(값, [형식]) --> 주어진 형식의 문자열을 만듦
    SELECT TO_CHAR(123) AS 문자열123,
           TO_CHAR(123, '999999'),       -- '공백,공백,공백123'
           TO_CHAR(123, '000000'),       -- '000123'
           TO_CHAR(1234, '9,999'),       -- '1.234'
           TO_CHAR(12345, '9,999'),      -- '#####'   자릿수 부족으로 오류(5개 자리가 필요한데 형식이 4자리)
           TO_CHAR(12345, '99,999'),     -- '12.345'
           TO_CHAR(3.14, '9.999'),       -- '3.140'
           TO_CHAR(3.14, '9.99'),        -- '3.14'
           TO_CHAR(3.14, '9.9'),         -- '3.1'
           TO_CHAR(3.14, '9'),           -- '3'
           TO_CHAR(3.5, '9')             -- '4'      --> (반올림)
      FROM DUAL;
      
-- (2) 날짜형식
    SELECT TO_CHAR(SYSDATE, 'YYYY.MM.DD'),
           TO_CHAR(SYSDATE, 'YEAR MONTH DAY'),
           TO_CHAR(SYSDATE, 'HH:MI:SS')
      FROM DUAL;     
    
-- 6. 기타함수
    SELECT * FROM score;
    UPDATE score SET kor = NULL WHERE TRIM(name) = 'Smith'; -- Smith 의 점수 (null, 30 30)
    UPDATE score SET eng = 30 WHERE TRIM(name) = 'sweet'; -- sweet 의 점수 (null, 100, 100)

-- 1) NULL 처리 함수
-- (1) NVL(값, 값이 NULL일때 사용할 값)
    SELECT kor,
           NVL(kor, 0)
      FROM score; -- NVL(kor, 0)칼럼에서는 NULL값 대신 0이 나옴
    
-- 집계함수(SUM, AVG, MAX, MIN, COUNT ...) 들은 NULL값을 무시한다.. 계산에 아에 섞어주질 않음, 빼고함
    SELECT AVG(kor) AS 평균1,         -- NULL무시
           AVG(NVL(kor, 0)) AS 평균2  -- NULL값을 0으로 보고 계산
      FROM score;
  
-- (2) NVL2(값, 값이 NULL이 아닐때, 값이 NULL 일때,)     --약간 if같은느낌
    SELECT NVL(kor, 0) + eng + mat AS 총점 FROM score;                            -- 아래와 같은값을 나타낼 수 있음
    SELECT NVL2(kor, kor + eng + mat, eng + mat) AS 총점 FROM score;

-- 2) 분기함수
-- DECODE(표현식, 조건1, 결과1, 조건2, 결과2, ..., 기본값)        --DECODE는 크다작다 비교가 안됨
-- 동등비교만 가능
    SELECT DECODE('여름',                 -- 표현식(칼럼을 이용한 식)
                  '봄', '꽃놀이',       -- 표현식이 '봄'이면 '꽃놀이가 결과이다.
                  '여름', '물놀이',
                  '가을', '단풍놀이',
                  '겨울', '눈싸움') AS 계절별놀이
      FROM DUAL;

-- 3) 분기 표현식
-- CASE 표현식
--   WHEN (비교식 THEN 결과값
--   ... 
--   ELSE 나머지경우
-- END);

-- ex 1 )
--  CASE '봄'
--   WHEN '봄' THEN '꽃놀이'

-- ex 2 )
--  CASE
--   WHEN 평균 >=90 THEN 'A학점'
    SELECT name,
           (NVL(kor, 0) + eng + mat) / 3 AS 평균,
           (CASE  
             WHEN (NVL(kor, 0) + eng + mat) / 3 >= 90 THEN 'A학점'
             WHEN (NVL(kor, 0) + eng + mat) / 3 >= 80 THEN 'B학점'
             WHEN (NVL(kor, 0) + eng + mat) / 3 >= 70 THEN 'C학점'
             WHEN (NVL(kor, 0) + eng + mat) / 3 >= 60 THEN 'D학점'
             ELSE 'F학점'
            END) AS 학점
      FROM score;
      