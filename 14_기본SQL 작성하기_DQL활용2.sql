/*
    보기좋은 쿼리문
    
    1. SELECT절 바로 직전이나 SELECT절 오른쪽에 테이블 주석을 작성한다.
    2. SELECT절, FROM절, WHERE절, GROUP BY절, ORDER BY절 모두 line을 맞춘다.
    3. 칼럼은 라인당 한 칼럼이거나(한글로 칼럼의 한글이름을 주석을 함께 작성), 한 라인에 모은다.
       케바케임... 영어로 된 칼럼명이 주석이 필요하면 라이당 하나 사용하는편
    4. 칼럼이나 테이블을 대문자로 작성한다. 소문자로 작성한다면 항상 소문자로 작성할것.
       통일하자는 의미, 섞어쓰는게 진짜.. 안좋음... (대소문자 섞어쓰면 동일 쿼리여도 DB에서 실행계획을 다르게 세움)
    
*/

-- 26. 연봉(salary) 총액과 연봉(salary) 평균을 조회한다.
SELECT
       SUM(SALARY) AS 연봉총액
     , ROUND(AVG(SALARY),2) AS 연봉평균
  FROM employees;

-- 27. 최대연봉(salary)과 최소연봉의 차이를 조회한다.
SELECT
       MAX(SALARY) AS 최대연봉
     , MIN(SALARY) AS 최소연봉
  FROM EMPLOYEES;

-- 28. 직업(job_id) 이 ST_CLERK 인 사원들의 전체 수를 조회한다.
SELECT
       COUNT(*) AS 사원수
  FROM EMPLOYEES
 WHERE JOB_ID = 'ST_CLERK';

-- 29. 매니저(manager_id)로 근무하는 사원들의 전체 수를 조회한다.
--누군가의 상사인 사원들의 수 (manager_id에서 중복을 제거한 개수)
SELECT
       MANAGER_ID
  FROM EMPLOYEES
 WHERE MANAGER_ID IS NOT NULL
 GROUP BY MANAGER_ID;
  
--COUNT()
SELECT
       COUNT (DISTINCT MANAGER_ID)
  FROM EMPLOYEES;

-- 30. 회사 내에 총 몇 개의 부서가 있는지 조회한다.
--department에서 중복을 제거한 개수
SELECT
       COUNT(DISTINCT department_id)
  FROM EMPLOYEES;

-- 그룹화 연습

-- << departments 테이블 >>

-- 31. 같은 지역(location_id) 끼리 모아서 조회한다.
SELECT DISTINCT LOCATION_ID
  FROM DEPARTMENTS;
  
SELECT LOCATION_ID  --SELECT절에서 LOCATION_ID를 사용하려면,
  FROM DEPARTMENTS
 GROUP BY LOCATION_ID;  --반드시 GFOUP BY절에서 LOCATION_ID를 사용해야 한다.
-- 32. 같은 지역(location_id) 끼리 모아서 각 지역(location_id) 마다 총 몇 개의 부서가 있는지 개수를 함께 조회한다.
SELECT
       LOCATION_ID
     , count(*) AS 부서수
  FROM DEPARTMENTS
 GROUP BY LOCATION_ID;

-- 33. 같은 지역(location_id) 끼리 모아서 해당 지역(location_id) 에 어떤 부서(department_name) 가 있는지 조회한다.
-- 쿼리로 짜기에 부적절함, 쓸데없는 쿼리문, 억지로 실행을 만든 쿼리, 문제 자체가 그룹핑을 위한 문제가 아님
SELECT
       LOCATION_ID
     , DEPARTMENT_NAME
  FROM DEPARTMENTS
 GROUP BY LOCATION_ID, DEPARTMENT_NAME;

-- << employees 테이블 >>

-- 34. 각 부서(department_id)별로 그룹화하여 department_id 와 부서별 사원의 수를 출력한다.
SELECT DEPARTMENT_ID
     , COUNT(*) AS 사원수
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID;

-- 35. 부서(department_id)별로 집계하여 department_id 와 급여평균을 department_id 순으로 오름차순 정렬해서 출력한다.
SELECT
       DEPARTMENT_ID
     , AVG(SALARY) AS 급여평균
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID
 ORDER BY DEPARTMENT_ID;

-- 36. 동일한 직업(job_id)을 가진 사원들의 job_id 와 인원수와 급여평균을 급여평균의 오름차순 정렬하여 출력한다.
SELECT
       JOB_ID
     , COUNT(*) AS 인원수
     , AVG(SALARY) AS 급여의평균 
  FROM EMPLOYEES
 GROUP BY JOB_ID
 ORDER BY 급여의평균;        --AVG(SALARY);  이것도 가능
 
-- 불가능한 쿼리문
SELECT
       JOB_ID AS 직업
     , COUNT(*) AS 인원수  
     , AVG(SALARY) AS 급여평균
  FROM EMPLOYEES
 GROUP BY 직업;             -- JOB_ID부분을 직업 으로 바꿀 경우, 오류 남!! 실행 순서와 관련있음
                            -- ==== FROM -> GROUP BY -> SELECT -> ORDERBY ====
                            -- 순으로 처리되기 때문에
                            -- SELECT에서 지정한 별명을 ORDER BY에서는 사용 할 수 있지만
                            -- SELECT에서 지정한 별명을 GROUP BY에서는 사용 할 수 없다.
 
-- 37. 직업(job_id)이 SH_CLERK 인 직원들의 인원수와 최대급여 및 최소급여를 출력한다.
SELECT
       JOB_ID
     , COUNT(*) AS 인원수
     , MAX(SALARY) AS 최대급여
     , MIN(SALARY) AS 최소급여
  FROM EMPLOYEES
 WHERE JOB_ID = 'SH_CLERK'
 GROUP BY JOB_ID;
-- 38. 근무 중인 사원수가 5명 이상인 부서의 department_id 와 해당 부서의 사원수를 department_id 의 오름차순으로 정렬하여 출력한다.
    -- 근무 중인 사원수가 5명 이상인 부서 : 이것은 GROUP BY 이후에 알 수 있기 때문에
    -- WHERE절로 처리 X   HAVING절로 처리 O
SELECT
       DEPARTMENT_ID
     , COUNT(*) AS 사원수
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID
HAVING COUNT(*) >= 5
 ORDER BY DEPARTMENT_ID;
-- 39. 평균급여가 10000 이상인 부서의 department_id 와 급여평균을 출력한다.
SELECT
       DEPARTMENT_ID
     , AVG(SALARY) AS 평균급여
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 10000;        --HAVIN절에 별명(평균급여) 적을 수 없음 - 순서상의 이유

-- 40. 부서(department_id)마다 같은 직업(job_id)을 가진 사원수를 department_id 순으로 정렬하여 출력한다.
-- 단, department_id 가 없는 사원은 출력하지 않는다.
SELECT
       DEPARTMENT_ID
     , COUNT(*) AS 사원수
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IS NOT NULL
 GROUP BY DEPARTMENT_ID
 ORDER BY DEPARTMENT_ID;