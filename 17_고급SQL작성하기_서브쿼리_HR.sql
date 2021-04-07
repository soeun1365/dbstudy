-- 1. 모든 사원의 LAST_NAME, SALARY, 본인이 근무하는 부서의 평균연봉(SALARY)을 조회하시오.
-- 스칼라 서브쿼리
-- T: 전체테이블의 데이터
-- D: 같은 부서의 데이터
SELECT
       LAST_NAME
     , SALARY
     , (SELECT
             ROUND(AVG(D.SALARY))  -- 반올림
        FROM EMPLOYEES D 
       WHERE D.DEPARTMENT_ID = T.DEPARTMENT_ID) AS 평균연봉  -- 부서가 같은지 점검하는 코드 
  FROM EMPLOYEES T;
    
-- 2. 부서(DEPARTMENT_ID)별로 DEPARTMENT_ID, DEPARTMENT_NAME, 평균연봉을 조회하시오.
SELECT
       D.DEPARTMENT_ID
     , D.DEPARTMENT_NAME
     , (SELECT
               ROUND(AVG(E.SALARY))
          FROM EMPLOYEES E
         WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID) AS 평균연봉
  FROM DEPARTMENTS D;
  
-- ※동일한 문제라면 서브쿼리보다 조인이 좋을것으로 예상됨

-- 3. 모든 사원들의 EMPLOYEE_ID, LAST_NAME, DEPARTMENT_NAME 을 조회하시오.
-- 1)스칼라서브쿼리
SELECT
       E.EMPLOYEE_ID
     , E.LAST_NAME
     , (SELECT D.DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) AS 부서명
  FROM EMPLOYEES E;

-- 2)내부조인
SELECT
       EMPLOYEE_ID
     , LAST_NAME
     , DEPARTMENT_NAME
  FROM EMPLOYEES E INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;
-- 4. 평균연봉 이상의 연봉을 받는 사원들의 정보를 조회하시오.
SELECT
       LAST_NAME
     , SALARY
  FROM EMPLOYEES
 WHERE SALARY >= (SELECT AVG(SALARY)
                    FROM EMPLOYEES);

-- 5. Patrick Sully 와 같은 부서에 근무하는 모든 사원정보를 조회하시오.
-- FIRST_NAME = Patrick
-- LAST_NAME = Sully
-- 서브쿼리: Patrick Sully의 부서(다중행 서브쿼리 - 동명이인)
SELECT
       FIRST_NAME
     , LAST_NAME
     , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                           FROM EMPLOYEES
                          WHERE FIRST_NAME = 'Patrick'
                            AND LAST_NAME = 'Sully');
-- 6. 부서번호가 20인 사원들 중에서 평균연봉 이상의 연봉을 받는 사원정보를 조회하시오.
SELECT
       LAST_NAME
     , SALARY
     , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID =20
   AND SALARY >= (SELECT AVG(SALARY)
                    FROM EMPLOYEES);

-- 7. 직업이(Job_Id)이'PU_MAN'의 최대연봉보다 더 많은 연봉을 받은 사원들의 정보를 조회하시오.
-- 1) 다중 행 서브쿼리
SELECT
       LAST_NAME
     , SALARY
     , JOB_ID
  FROM EMPLOYEES
 WHERE SALARY > ALL (SELECT SALARY
                       FROM EMPLOYEES
                      WHERE JOB_ID = 'PU_MAN');

-- 2) 단일 행 서브쿼리
SELECT
       LAST_NAME
     , SALARY
     , JOB_ID
  FROM EMPLOYEES
 WHERE SALARY > (SELECT MAX(SALARY)
                   FROM EMPLOYEES
                  WHERE JOB_ID = 'PU_MAN');
-- 8. 사원번호가 131인 사원의 JOB_ID와 SALARY가 모두 일치하는 사원들의 정보를 조회하시오.
SELECT
       LAST_NAME
     , JOB_ID
     , SALARY
  FROM EMPLOYEES
 WHERE JOB_ID = (SELECT JOB_ID
                   FROM EMPLOYEES
                  WHERE EMPLOYEE_ID = 131)      -- EMPLOYEE_ID는 PK이므로 단일행
   AND SALARY = (SELECT SALARY
                   FROM EMPLOYEES
                  WHERE EMPLOYEE_ID = 131);
     
 -- 위와 같은 쿼리                   
SELECT
       LAST_NAME
     , JOB_ID
     , SALARY
  FROM EMPLOYEES
 WHERE (JOB_ID, SALARY) = (SELECT JOB_ID, SALARY        -- 합쳐서 가능
                             FROM EMPLOYEES
                            WHERE EMPLOYEE_ID = 131);

-- 9. LOCATION_ID가 1000~1900인 국가들의 COUNTRY_ID와 COUNTRY_NAME을 조회하시오.
--다중행 만들 때 WHERE절에 들어가는 SELECT문 먼저 만들고 진행하는법 추천
SELECT
       COUNTRY_ID
     , COUNTRY_NAME
  FROM COUNTRIES
 WHERE COUNTRY_ID IN (SELECT DISTINCT COUNTRY_ID     --DISTINCT로 중복제거
                        FROM LOCATIONS
                       WHERE LOCATION_ID BETWEEN 1000 AND 1900); 

-- 10. 부서가 'Executive'인 모든 사원들의 정보를 조회하시오.
-- 서브쿼리의 WHERE 절에서 사용한 DEPARTMENT_NAME은 PK, UQ가 아니므로 서브쿼리의 결과는 여러 개이다.
DESC DEPARTMENTS;
SELECT LAST_NAME
     , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                           FROM DEPARTMENTS
                          WHERE DEPARTMENT_NAME = 'Executive');

-- 11. 부서번호가 30인 사원들 중에서 부서번호가 50인 사원들의 최대연봉보다 더 많은 연봉을 받는 사원들을 조회하시오.
SELECT
       LAST_NAME
     , SALARY
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 30
   AND SALARY > (SELECT MAX(SALARY)
                   FROM EMPLOYEES
                  WHERE DEPARTMENT_ID = 50);
                
 -- 위와 같은 쿼리                                 
SELECT
       LAST_NAME
     , SALARY
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 30
   AND SALARY > ALL (SELECT SALARY
                       FROM EMPLOYEES
                      WHERE DEPARTMENT_ID = 50);
              
-- 12. MANAGER가 아닌 사원들의 정보를 조회하시오.
-- MANAGER는 MANAGER_ID를 가지고 있다.

SELECT EMPLOYEE_ID
     , LAST_NAME
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID NOT IN (SELECT
                                  DISTINCT MANAGER_ID
                             FROM EMPLOYEES
                            WHERE MANAGER_ID IS NOT NULL);   --서브쿼리의 결과는 NULL값을 가질 수 없다.

-- 13. 근무지가 'Southlake'인 사원들의 정보를 조회하시오.

-- 1) 서브쿼리
-- 서브쿼리1: 근무지가 (city)가 'southlake'인 location_id를 LOCATIONS 테이블에서 조회
-- 서브쿼리2: 모든 사원들의 LOCAION_ID(EMPLOYEES와 DEPARTMENTS의 조인)
SELECT
       EMPLOYEE_ID
     , LAST_NAME
  FROM EMPLOYEES E
 WHERE (SELECT
               LOCATION_ID
          FROM DEPARTMENTS D 
         WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) IN (SELECT
                                                             LOCATION_ID
                                                        FROM LOCATIONS
                                                       WHERE CITY = 'Southlake');
--2) 내부조인
SELECT
       EMPLOYEE_ID
        , LAST_NAME
  FROM LOCATIONS L, DEPARTMENTS D, EMPLOYEES E
 WHERE L.LOCATION_ID = D.LOCATION_ID
   AND D.DEPARTMENT_ID = E.DEPARTMENT_ID
   AND L.CITY = 'Southlake';

-- 14. 부서명의 가나다순으로 모든 사원의 정보를 조회하시오.
-- 가나다순 --> 오름차순
SELECT
       E.EMPLOYEE_ID
     , E.LAST_NAME
  FROM EMPLOYEES E
 ORDER BY (SELECT
                  D.DEPARTMENT_NAME
             FROM DEPARTMENTS D
            WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID);

-- 15. 가장 많은 사원들이 근무하고 있는 부서의 번호와 근무하는 인원수를 조회하시오.
-- 근무 중인 부서의 사원수
-- 최대 인원이 근무하는 부서의 사원수
SELECT
       DEPARTMENT_ID
     , COUNT(*) AS 부서별사원수
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IS NOT NULL
 GROUP BY DEPARTMENT_ID
HAVING COUNT(*) = (SELECT MAX(COUNT (*))
                     FROM EMPLOYEES
                    GROUP BY DEPARTMENT_ID);
  



