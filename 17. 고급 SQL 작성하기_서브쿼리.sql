-- 서브쿼리
-- 쿼리문 내부에 다른 쿼리문을 포함하는 것

-- 단일 행 서브쿼리
-- 1. 서브쿼리의 결과가 1개인 쿼리
-- 2. 단일 행 서브쿼리 연산자 : =, !=, >, >=, <, <=

-- 문제1. 평균급여보다 더 높은 급여를 받는 사원들의 정보를 조회하시오.
SELECT
       NAME
     , POSITION
     , SALARY
  FROM EMPLOYEE
 WHERE SALARY > (SELECT
                        AVG(SALARY)
                   FROM EMPLOYEE);
 
-- 문제2. 사원번호가 1001인 사원과 같은 직급을 가진 사원들의 정보를 조회하시오.
SELECT
       NAME
     , POSITION
     , SALARY
  FROM EMPLOYEE
 WHERE POSITION = (SELECT                       -- WHERE절에서 비교가되도록 맞춰주기
                          POSITION
                     FROM EMPLOYEE
                    WHERE EMP_NO = 1001);
       
-- 문제3. 가장 급여가 높은 사원과 가장 급여가 낮은 사원을 조회하시오.
SELECT
       NAME
     , POSITION
     , SALARY
  FROM EMPLOYEE
 WHERE SALARY = (SELECT
                        MAX(SALARY)
                   FROM EMPLOYEE)
    OR SALARY = (SELECT
                        MIN(SALARY)
                   FROM EMPLOYEE);
-- 위와 같은 쿼리               
SELECT
       NAME
     , POSITION
     , SALARY
  FROM EMPLOYEE
 WHERE SALARY IN( (SELECT MAX(SALARY)FROM EMPLOYEE), (SELECT MIN(SALARY) FROM EMPLOYEE) );
 
-- 다중행 서브쿼리
-- 1. 서브쿼리의 결과가 여러개인 쿼리
-- 2.다중 행 서브쿼리 연산자 : IN, ANY, ALL, EXISTS

-- 문제1. 부서번호가 1인 부서에 존재하는 직급과 같은 직급을 가지고있는 모든 사원을 조회하시오.
SELECT
       NAME
     , DEPART
     , POSITION
  FROM EMPLOYEE
 WHERE POSITION IN (SELECT                      
                           POSITION
                      FROM EMPLOYEE
                    WHERE DEPART = 1);  -- PK도 아니고 UNIQUE도 아닌 DEPART 이므로 IN을 써준다

-- 문제2. 구창민과 같은 부서에서 근무하는 사원을 조회하시오.
SELECT
       NAME
     , DEPART
     , POSITION
  FROM EMPLOYEE
 WHERE DEPART IN (SELECT
                         DEPART
                    FROM EMPLOYEE
                   WHERE NAME = '구창민');  -- PK도 아니고 UNIQUE도 아닌 NAME 이므로 IN을 써준다

-- 문제3. 부서번호가 1인 부서에서 근무하는 사원들의 모든 급여보다 큰 급여를 받는 사원들을 조회하시오.
SELECT
       NAME
     , DEPART
     , SALARY
  FROM EMPLOYEE
 WHERE SALARY > ALL(SELECT
                           SALARY
                      FROM EMPLOYEE
                     WHERE DEPART = 1);
      
-- 위와 같은 쿼리               
-- 단일행 서브쿼리로도 가능
SELECT
       NAME
     , DEPART
     , SALARY
  FROM EMPLOYEE
 WHERE SALARY > (SELECT MAX(SALARY)
                      FROM EMPLOYEE
                     WHERE DEPART = 1);

-- 스칼라 서브쿼리 (SCALA SUBQUIERY)
-- 1. SELECT절에서 사용하는 서브쿼리이다.
-- 2. 단일 행 서브쿼리여야 한다.

-- 문제1. 모든 사원들의 평균연봉과 부서수를 조회하시오.
SELECT
       (SELECT (AVG(E.SALARY))
         FROM EMPLOYEE E) AS 평균연봉
     , (SELECT COUNT (D.DEPT_NO)
          FROM DEPARTMENT D) AS 부서수
  FROM DUAL;


-- 인라인뷰 (INLINE VIEW)
-- 1. FROM절에서 사용하는 서브쿼리이다.  -- 실행순서1등인 FROM절의 특성 사용/ ORDER BY를 먼저하려고
-- 2. 일종의 임시테이블이다. 뷰
-- 3. 인라인 뷰에서 SELECT한 칼럼만 메인쿼리에서 사용할 수 있다.

/*
    실행순서
    1. FROM
    2. WHERE
    3. GROUP BY
    4. HAVING
    5. SELECT
    6. ORDER BY
*/

-- 문제. 부서번호가 1인 사원을 조회하시오. 이름순으로 정렬
-- 일반적 풀이(조건->정렬)
SELECT DEPART
     , NAME
  FROM EMPLOYEE
 WHERE DEPART = 1
 ORDER BY NAME;
 
-- 인라인 뷰(정렬->조건)    --게시판에서 주로 쓰임
SELECT E.DEPART     -- 이 두개 칼럼 제외한 다른 칼럼은 쓸 수 X
     , E.NAME       -- FROM절에서 만든 E테이블의 칼럼만 가능
  FROM (SELECT
               DEPART
             , NAME
          FROM EMPLOYEE
         ORDER BY NAME) E  --서브쿼리 별명을 지정 (정렬된 임시 테이블 E)
 WHERE E.DEPART = 1;

-- CREATE문과 서브쿼리
-- 1. 서브쿼리의 결과를 이요해서 새로운 테이블을 생성할 수 있다. (테이블 복사)
-- 2. 데이터를 포함할 수도 있고, 제외할 수도 있다.
-- 3. PK, FK 같은 제약조건ㅇ느 복사되지 않는다.

DESC EMPLOYEE; --디스크 라고 읽음

-- 문제. EMPLOYEE테이블의 구조와 데이터를 모두 복사해서 새로운 EMPLOYEE2 테이블을 생성하시오.
CREATE TABLE EMPLOYEE2
    AS (SELECT EMP_NO
              ,NAME
              ,DEPART
              ,POSITION
              ,GENDER
              ,HIRE_DATE
              ,SALARY
         FROM EMPLOYEE);
         
DESC EMPLOYEE2;

-- 문제. EMPLOYEE테이블의 데이터를 제외하고 구조만 복사해서 EMPLOYEE3 테이블을 생성하시오.
CREATE TABLE EMPLOYEE3
    AS (SELECT EMP_NO
              ,NAME
              ,DEPART
              ,POSITION
              ,GENDER
              ,HIRE_DATE
              ,SALARY
         FROM EMPLOYEE
        WHERE 1 = 2);         --평생 이루어질 수 없는 조건부여해서 데이터는 복사 되지않음
           
DESC EMPLOYEE3;


    