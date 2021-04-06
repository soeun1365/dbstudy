-- << employees 테이블 >>

DESC employees;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1. 전체 사원의 모든 칼럼을 조회한다.
SELECT employee_id, first_name, last_name, email, phone_number  -- 이렇게 하나하나 다 적어준는게 젤 좋은 방법
  FROM employees;
      
SELECT *
  FROM employees;   --성능에 안좋다.

SELECT employees.employee_id, employees.first_name, employees.last_name, employees.email, employees.phone_number   -- 칼럼명 앞에 OWNER명시 (테이블명. 을 붙여주는 방법)
  FROM employees;                                                                                                  -- 나중에 여러테이블 조인할때 필수적으로 사용할 문법
       
SELECT e.employee_id, e.first_name, e.last_name, e.email, e.phone_number   --위 방식보다는 이것처럼 별명지정방식이 낫다(나중에 많이 사용)
  FROM employees e;                                                        --employees테이블의 별명(alias)을 e로 지정
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. 전체 사원의 first_name, last_name, job_id 를 조회한다.
SELECT first_name, last_name, hob_id
  FROM emlployees;
      
SELECT emp.first_name, emp.last_name, emp.hob_id  
  FROM emlployees emp;  -- 별명사용 ( 개발자 마음대로 지정)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. 연봉(salary)이 12000 이상되는 사원들의 last_name, salary 를 조회한다.
SELECT last_name, salary
  FROM employees 
 WHERE salary >= 12000;
    
SELECT e.last_name, e.salary     -- 별명사용
  FROM employees e 
 WHERE e.salary >= 12000;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--                    실행순서
--  SELECT 칼럼          3
--  FROM 테이블명        1
--  WHERE 조건식         2

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4. 사원번호(employee_id)가 150 인 사원의 last_name, department_id 를 조회한다.
-- ★★★★사실 이문제를 보고 employee_id가 어떤 타입인지 먼저 확인해야한다.(보통 NUMBER, VARCHAR2 둘다 사용하기때문)★★★★★
-- 사원번호의 타입이 NUMBER 이면      조건식: employee_id = 150
-- 사원번호의 타입이 VARCHAR2 이면    조건식: emplotee_id = '150'

--  ※※※※※만약 사원번호 employee_id가 NUMBER 타입이면※※※※※
SELECT last_name, department_id     --> 정상적 (이렇게 타입 맞추는게 장땡)
  FROM employees
 WHERE employee_id = 150;
     
SELECT last_name, department_id
  FROM employees
 WHERE employee_id = '150';       --> 실무에서는 전혀 문제 없는 쿼리문이다, 둘다 실행 되긴하고 성능차이가 크지도 않아
                                      -- e.employee_id = (TO_NUMBER('150')) 오라클에서 이렇게 실행됨, 하지만 오라클에서 숫자로 비교하는게 원칙
                                      
--  ※※※※※만약 사원번호 employee_id가 VARCHAR2 타입이면※※※※※
SELECT last_name, department_id     
  FROM employees
 WHERE employee_id = 150;           --> 동작은 하나, 성능이 떨어짐 
                                        -- 오라클에서 자동으로 WHERE TO_NUMBER(employee_id) = 150 
                                        -- employee_id가 PK라서 인덱스가 있는데, 함수를 씌우면 인덱스 사용이 안되어 풀스캔하게 되어 속도저하 성능감소
                                        -- 약간 실무적인 내용임

SELECT last_name, department_id     --> 정상적 (이렇게 타입 맞추는게 장땡)
  FROM employees
 WHERE employee_id = '150'; 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5. 커미션(commission_pct)을 받는 모든 사원들의 last_name, salary, commission_pct 를 조회한다.
-- NULL조건 : IS NULL
-- NOT NULL 조건 : IS NOT NULL
SELECT last_name, salary, commission_pct
  FROM employees
 WHERE commission_pct IS NOT NULL;
     
SELECT last_name, salary, commission_pct
  FROM employees
 WHERE NVL(commission_pct, 0)!= 0;      --  != 와 <>는 같은 의미
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 6. 모든 사원들의 last_name, commission_pct 를 조회하되 커미션(commission_pct)이 없는 사원은 0으로 처리하여 조회한다.
SELECT last_name, NVL(commission_pct, 0) AS commission_pct
  FROM employees;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 7. 커미션(commission_pct)이 없는 사원들은 0으로 처리하고, 커미션이 있는 사원들은 기존 커미션보다 10% 인상된 상태로 조회한다.
SELECT last_name, NVL2(commission_pct, commission_pct * 1.1 , 0) AS new_commission_pct
  FROM employees;
      
SELECT last_name, commission_pct * 1.1 AS new_commission_pct
  FROM employees
 WHERE commission_pct IS NOT NULL;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 8. 연봉(salary)이 5000 에서 12000 인 범위의 사원들의 first_name, last_name, salary 를 조회한다.
SELECT first_name, last_name, salary
  FROM employees
 WHERE salary BETWEEN 5000 AND 12000;
     
SELECT first_name, last_name, salary
  FROM employees
 WHERE salary >= 5000 AND salary < 12000;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 9. 연봉(salary)이 5000 에서 12000 사이의 범위가 아닌 사원들의 first_name, last_name, salary 를 조회한다.
SELECT first_name, last_name, salary
  FROM employees
 WHERE (salary < 5000 OR salary >= 12000);
    
 SELECT first_name, last_name, salary
  FROM employees
 WHERE salary NOT BETWEEN 5000 AND 12000;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 10. 직업(job_id)이 SA_REP 이나 ST_CLERK 인 사원들의 전체 칼럼을 조회한다.
SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id
  FROM employees
 WHERE job_id = 'SA_REP' OR job_id ='ST_CLERK';
     
SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id
  FROM employees
 WHERE job_id IN ('SA_REP','ST_CLERK');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 11. 연봉(salary)이 2500, 3500, 7000 이 아니며 직업(job_id) 이 SA_REP 이나 ST_CLERK 인 사람들을 조회한다.   
SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id
 FROM employees
WHERE (salary NOT IN(2500, 3500, 7000))
  AND (job_id IN('SA_REP', 'ST_CLERK'));    
       
SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id
  FROM employees
 WHERE (salary != 2500 AND salary != 3500 AND salary!= 7000)
   AND (job_id = 'SA_REP' OR job_id = 'ST_CLERK' );
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 12. 상사(manager_id)가 없는 사람들의 last_name, job_id 를 조회한다.
SELECT last_name, job_id
  FROM employees
 WHERE manager_id IS NULL;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 13. 성(last_name)에 u 가 포함되는 사원들의 employee_id, last_name 을 조회한다.
/*
    와일드카드(wild card)
    1. 모든 문자를 대체할 수 있는 만능문자
    2. 종류
         1) 글자 수 상관 없는 만능문자 : %
         2) 한 글자를 대체하는 만능문자 : _
    3. 와일드 카드 연산자 : LIKE (등호(=) 대신 사용)
    4. 예시
        1) 마동석, 마요네즈 : 마%
        2) 백설공주, 평강공주, 칠공주 : %공주
        3) 아이언맨, 맨드라미, 슈퍼맨대배트맨 : %맨%
*/
SELECT employee_id, last_name
  FROM employees
 WHERE last_name LIKE '%u%';    -- 소문자u만 포함되는 경우
 
SELECT employee_id, last_name
  FROM employees
 WHERE last_name LIKE '%u%' OR last_name LIKE '%U%'; -- 대소문자 U, u 모두 포함
     
    --SELECT employee_id, last_name
      --FROM employees
     --WHERE last_name LIKE IN('%u%', '%U%');     --안되는 쿼리(Wild card와 IN())
     
SELECT employee_id, last_name
  FROM employees
 WHERE UPPER(last_name) LIKE '%U%';     --싹 대문자로 바꾼 뒤 'U' 들어간것 찾기
     
SELECT employee_id, last_name
  FROM employees
 WHERE LOWER(last_name) LIKE '%u%';     --싹 소문자로 바꾼 뒤 'u' 들어간것 찾기
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 14. 전화번호(phone_number)가 650 으로 시작하는 사원들의 last_name, phone_number 를 조회한다.
SELECT last_name, phone_number
  FROM employees
 WHERE phone_number LIKE '650%';
     
SELECT last_name, phone_number
  FROM employees
 WHERE SUBSTR(phone_number, 1, 3) = '650';      --SUBSTR은 문자열 비교이기 때문에 숫자비교여도 '따옴표' 붙여주기
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 15. 성(last_name)의 네 번째 글자가 a 인 사원들의 last_name 을 조회한다.
SELECT last_name
  FROM employees
 WHERE last_name LIKE '___a%';   
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 16. 성(last_name) 에 a 또는 e 가 포함된 사원들의 last_name 을 조회한다.
SELECT last_name
  FROM employees
 WHERE last_name LIKE '%a%' OR last_name LIKE '%e%';
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 17. 성(last_name) 에 a 와 e 가 모두 포함된 사원들의 last_name 을 조회한다.
SELECT last_name
  FROM employees
 WHERE last_name LIKE '%a%' AND last_name LIKE '%e%';
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 18. 2008/02/20 ~ 2008/05/01 사이에 고용된(hire_date) 사원들의 last_name, employee_id, hire_date 를 조회한다.
SELECT last_name, employee_id, hire_date
  FROM employees
 WHERE hire_date BETWEEN '2008/02/20' AND '2008/05/01';
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 19. 2004년도에 고용된(hire_date) 모든 사원들의 last_name, employee_id, hire_date 를 조회한다.
SELECT last_name, employee_id, hire_date
  FROM employees
 WHERE EXTRACT(YEAR FROM hire_date) = 2004;
     
SELECT last_name, employee_id, hire_date
  FROM employees
 WHERE hire_date LIKE '04%';
     
SELECT last_name, employee_id, hire_date
  FROM employees
 WHERE hire_date BETWEEN '2004/01/01' AND '2004/12/31';
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 20. 부서(department_id)를 조회하되 중복을 제거하여 조회한다.
SELECT DISTINCT department_id
  FROM employees;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 21. 직업(job_id)이 ST_CLERK 가 아닌 사원들의 부서번호(department_id)를 조회한다.
-- 단, 부서번호가 NULL인 값은 제외하고 부서번호의 중복을 제거한다.
SELECT DISTINCT department_id
  FROM employees
 WHERE job_id != 'ST_CLERK'          -- 확장성을 고려하면 job_id NOT IN ('ST_CLERK') 이렇게도 가능
   AND department_id IS NOT NULL;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 22. 커미션(commission_pct)을 받는 사원들의 실제 커미션(commission = salary * commission_pct)을 구하고,
-- employee_id, first_name, job_id 와 함께 조회한다.
SELECT employee_id, first_name, job_id, salary * commission_pct AS commission
  FROM employees 
 WHERE commission_pct IS NOT NULL;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 23. 가장 오래 전에 입사(hire_date)한 직원부터 최근에 입사한 직원 순으로 last_name, hire_date 를 조회한다.
/*
    오름차순/내림차순 정렬
    Ascending, Descending, r구문의 마지막에 추가해준다.
    
    - 오름차순: ORDER BY 칼럼 ASC 
                OODER BY 칼럼  (ASC는 생략 가능)
    - 내림차순: ORDER BY 칼럼 DESC   
*/

SELECT last_name, hire_date  
  FROM employees            -- 날짜는 오래된 날짜가 작은 값이고, 최근 날짜가 큰 값이다.
 ORDER BY hire_date ASC;       --ORDER BY hire_date;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 24. 부서번호(department_id)가 20, 50 인 부서에서 근무하는 모든 사원들의 부서번호의 오름차순으로 조회하되,
-- 같은 부서번호 내에서는 last_name 의 알파벳순으로 조회한다.
SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id
  FROM employees
 WHERE department_id IN (20,50)
 ORDER BY department_id, last_name;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 25. 커미션(commission_pct)을 받는 모든 사원들의 last_name, salary, commission_pct 을 조회한다.
-- 연봉이 높은 사원을 먼저 조회하고 같은 연봉의 사원들은 커미션이 높은 사원을 먼저 조회한다.
SELECT last_name, salary, commission_pct
  FROM employees
 WHERE commission_pct is NOT NULl
 ORDER BY salary DESC, commission_pct DESC;
 