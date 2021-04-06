-- 1. 부서의 위치(location_id)가 1700 인 사원들의 employee_id, last_name, department_id, salary 를 조회한다.
-- 사용할 테이블 (departments, employees)

-- 좋지않은 쿼리문
-- ON절에서 = 왼쪽이 PK도아니고 INDEX도 아니기 때문
-- 인덱스가 없는 E.DEPARTMENT_ID를 기준으로 검색하므로 좋지않다.
SELECT
       E.EMPLOYEE_ID
     , E.LAST_NAME
     , E.DEPARTMENT_ID
     , E.SALARY
  FROM EMPLOYEES E INNER JOIN DEPARTMENTS D -- EMPLOYEES 테이블이 DRIVING 테이블, DEPARTMENTS 테이블이 DRIVEN 테이블
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
 WHERE D.LOCATION_ID = 1700;
 
SELECT
       E.EMPLOYEE_ID
     , E.LAST_NAME
     , E.DEPARTMENT_ID
     , E.SALARY
  FROM EMPLOYEES E, DEPARTMENTS D
 WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
   AND D.LOCATION_ID = 1700;

-- 2. 부서명(department_name)이 'Executive' 인 부서에 근무하는 모든 사원들의 department_id, last_name, job_id 를 조회한다.
-- 사용할 테이블 (departments, employees)
SELECT
       D.DEPARTMENT_ID
     , E.LAST_NAME
     , E.JOB_ID
  FROM DEPARTMENTS D INNER JOIN EMPLOYEES E     -- DEPARTMENTS 테이블이 DRIVING 테이블 EMPLOYEE 테이블이 DRIVEN 테이블
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID        -- DRIVING테이블이 작고 빠른것이 나음, 먼저 작동되기 때문
 WHERE D.DEPARTMENT_NAME = 'Executive';         -- 조건절의 등호 왼쪽은 PK혹은 INDEX를 가진 칼럼이 좋다
  
SELECT
       D.DEPARTMENT_ID
     , E.LAST_NAME
     , E.JOB_ID
  FROM DEPARTMENTS D, EMPLOYEES E           -- DEPARTMENTS 테이블이 DRIVING 테이블 EMPLOYEE 테이블이 DRIVEN 테이블
 WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID
   AND D.DEPARTMENT_NAME = 'Executive';

-- 3. 기존의 직업(job_id)을 여전히 가지고 있는 사원들의 employee_id, job_id 를 조회한다.
-- 사용할 테이블 (employees, job_history)
SELECT
       E.employee_id
     , E.job_id 
  FROM EMPLOYEES E INNER JOIN JOB_HISTORY J
    ON E.EMPLOYEE_ID = J.EMPLOYEE_ID
    --기존의 직업을 여전히 가지고있다.EMPLOYEES 테이블의 JOB_ID와 JOB_HISTORY 테이블의 JOB_ID가 같다는 이야기
 WHERE E.JOB_ID = J.JOB_ID;
 
SELECT
       E.employee_id
     , E.job_id 
  FROM EMPLOYEES E, JOB_HISTORY J
 WHERE E.EMPLOYEE_ID = J.EMPLOYEE_ID
   AND E.JOB_ID = J.JOB_ID;

-- 4. 각 부서별 사원수와 평균연봉을 department_name, location_id 와 함께 조회한다.
-- 평균연봉은 소수점 2 자리까지 반올림하여 표현하고, 각 부서별 사원수의 오름차순으로 조회한다.
-- 사용할 테이블 (departments, employees)


-- 5. 도시이름(city)이 T 로 시작하는 지역에서 근무하는 사원들의 employee_id, last_name, department_id, city 를 조회한다.
-- 사용할 테이블 (employees, departments, locations)


-- 6. 자신의 상사(manager_id)의 고용일(hire_date)보다 빨리 입사한 사원을 찾아서 last_name, hire_date, manager_id 를 조회한다. 
-- 사용할 테이블 (employees)


-- 7. 같은 소속부서(department_id)에서 나보다 늦게 입사(hire_date)하였으나 나보다 높은 연봉(salary)을 받는 사원이 존재하는 사원들의
-- department_id, full_name(first_name 과 last_name 사이에 공백을 포함하여 연결), salary, hire_date 를 full_name 순으로 정렬하여 조회한다.
-- 사용할 테이블 (employees)


-- 8. 같은 소속부서(department_id)의 다른 사원보다 늦게 입사(hire_date)하였으나 현재 더 높은 연봉(salary)을 받는 사원들의
-- department_id, full_name(first_name 과 last_name 사이에 공백을 포함하여 연결), salary, hire_date 를 full_name 순으로 정렬하여 조회한다.
-- 사용할 테이블 (employees)
