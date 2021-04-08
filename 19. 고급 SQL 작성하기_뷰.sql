-- 뷰
-- 1. 기존 테이블을 이용해서 생성한 가상테이블이다.
-- 3. 디스크 대신 데이터사전에만 등록된다.

CREATE VIEW TEST_VIEW
    AS (SELECT
               EMP_NO
             , NAME
          FROM EMPLOYEE);
          
SELECT /**HINT**/
       EMP_NO
     , NAME
  FROM TEST_VIEW;      
---------------------------------------------------                    
CREATE VIEW TEST_VIEW2
    AS (SELECT
               *
          FROM EMPLOYEE
         WHERE POSITION = '과장');
         
SELECT
       *
  FROM TEST_VIEW2;
---------------------------------------------------
  
CREATE VIEW DEPART_VIEW
  AS (SELECT
           E.EMP_NO
         , E.NAME
         , E.POSITION
         , D.DEPT_NAME
      FROM DEPARTMENT D RIGHT JOIN EMPLOYEE E 
        ON D.DEPT_NO = E.DEPART);

SELECT
       EMP_NO
     , NAME
     , POSITION
     , DEPT_NAME
  FROM DEPART_VIEW;
