-- 시퀀스
-- 1. 일렬번호 생성 객체이다.
-- 2. 주로 기본키(인공키)에서 사용한다.
-- 3. CURRVAL : 시퀀스가 생성해서 사용한 현재 번호
-- 4. NEXTVAL : 시퀀스가 생성해야 할 다음 번호

CREATE SEQUENCE EMPLOYEE_SEQ
INCREMENT BY 1      -- 번호가 1씩 증가
START WITH 1000     -- 번호 시작이 1000
NOMAXVALUE          -- 최대값 없음
NOMINVALUE          -- 최소값 없음
NOCYCLE             -- 번호 순환 없음
NOCACHE;            -- 메모리에 캐시하지 않는다. 항상 유지하기

-- EMPLOYEE3 테이블에 행 삽입
-- EMP_NO는 시퀀스로 입력
INSERT INTO
       EMPLOYEE3(EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY)
       VALUES(EMPLOYEE_SEQ.NEXTVAL,'구창민', 1, '과장', 'M','95/05/01', 5000000 );

-- 시퀀스 값 확인
SELECT EMPLOYEE_SEQ.CURRVAL
FROM DUAL;

-- 시퀀스 목록 확인
SELECT * FROM USER_SEQUENCES;
--------------------------------------------------------------------------------------------------------
-- ROWNUM : 가상 행 번호
-- ROWID : 데이터가 저장된 물리적 위치 정보

SELECT 
       ROWNUM
     , ROWID
     , EMP_NO
     , NAME
  FROM EMPLOYEE;
  
-- ROWID를 이용한 검색이 최고 빠른 검색이다.(오라클의 검색방식)
SELECT
       EMP_NO
     , NAME
  FROM EMPLOYEE
 WHERE ROWID = 'AAAFEVAABAAALC5AAA';    --ROWID는 문자열이다 ''로 싸주기
 
-- 그 다음 빠른 검색 : INDEX를 이용한 검색 (휴먼의 검색 방식)
SELECT
       EMP_NO
     , NAME
  FROM EMPLOYEE
 WHERE EMP_NO = 1001;
 
--ROWNUM의 WHERE절 사용
-- 주의
-- 1. 1을 포함하는 검색만 가능하다.
-- 2. 순서대로 몇 건을 추출하기 위한 목적이다.
-- 3. 특정 위치를 지정한 검색은 불가능하다.


SELECT
       EMP_NO
     , NAME
  FROM EMPLOYEE
 WHERE ROWNUM = 1;  -- 1이 포함되어있어서 검색 가능
 

 SELECT
       EMP_NO
     , NAME
  FROM EMPLOYEE
 WHERE ROWNUM = 2;  -- 1이 불포함 되어있어서 검색 불가능

SELECT
      EMP_NO
    , NAME
 FROM EMPLOYEE
WHERE ROWNUM BETWEEN 1 AND 3;  -- 1이 포함되어있어서 검색 가능
 
 SELECT
       EMP_NO
     , NAME
  FROM EMPLOYEE
 WHERE ROWNUM BETWEEN 2 AND 4;  -- 1이 불포함되어있어서 검색 불가능
 
-- 1 이외의 번호로 시작하는 모든 ROWNUM을 사용하기 위해서는
-- ROWNUM 별명을 주고 별명을 사용한다.

-- 실행순서때문에 처리 안되는 쿼리문
SELECT                 --실행순서3
       ROWNUM AS RN
     , EMP_NO
     , NAME
  FROM EMPLOYEE        --실행순서1
 WHERE RN = 2;         --실행순서2

-- FROM 절에 SELECT추가해서 실행순서를 고려한 쿼리문
SELECT                                  -- 실행순서3
       E.EMP_NO
     , E.NAME
  FROM (SELECT ROWNUM AS RN
             , EMP_NO
             , NAME
          FROM EMPLOYEE) E             -- 실행순서1
 WHERE E.RN = 2;                       -- 실행순서2
 
-- 위 방식을 사용한 ROWNUM은
-- 게시판에서 1페이지누르면 게시글 1~10번
-- 2페이지 누르면 게시글 11~20 이런식으로
-- 조회할 때 사용됨
----------------------------------------------------------------------------------------------------

-- 연습문제
-- 1. 다음 테이블을 생성한다.
-- 게시판 (글번호, 글제목, 글내용, 글작성자, 작성일자)
-- 회원 (회원번호, 회원아이디, 회원이름, 가입일자)
DROP TABLE BOARD;
DROP TABLE MEMBERS;

CREATE TABLE BOARD
(
    BOARD_NO NUMBER,
    BOARD_TITLE VARCHAR2(1000),
    BOARD_CONTENT VARCHAR2(4000),
    MEMBER_ID VARCHAR2(30),------------------- FK
    BOARD_DATE DATE
);

CREATE TABLE MEMBERS
(
    MEMBER_NO NUMBER,
    MEMBER_ID VARCHAR2(30) NOT NULL UNIQUE,---- 1:N 관계로 외래키를 만들려고 NOTNULL, UNIQUE 해줌
    MEMBER_NAME VARCHAR2(30),
    MEMBER_DATE DATE
);


-- 2. 각 테이블에서 사용할 시퀀스를 생성한다.
-- 게시판시퀀스(1~무제한)
-- 회원시퀀스(100000~999999)
DROP SEQUENCE BOARD_SEQ;
DROP SEQUENCE MEMBER_SEQ;
CREATE SEQUENCE BOARD_SEQ INCREMENT BY 1 START WITH 1 NOMAXVALUE NOCYCLE NOCACHE;
CREATE SEQUENCE MEMBER_SEQ INCREMENT BY 1 START WITH 100000 MAXVALUE 999999 NOCYCLE NOCACHE;

-- 3. 각 테이블에 적절한 기본키, 외래키, 데이터(5개)를 추가한다.
ALTER TABLE MEMBERS ADD CONSTRAINT MEMBERS_PK PRIMARY KEY(MEMBER_NO);
ALTER TABLE BOARD ADD CONSTRAINT BOARD_PK PRIMARY KEY(BOARD_NO);
ALTER TABLE BOARD ADD CONSTRAINT BOARD_MEMBER_FK FOREIGN KEY(MEMBER_ID) REFERENCES MEMBERS(MEMBER_ID);

INSERT INTO MEMBERS(MEMBER_NO, MEMBER_ID, MEMBER_NAME, MEMBER_DATE) VALUES
    (MEMBER_SEQ.NEXTVAL, 'admin', '관리자', '21/04/01');
INSERT INTO MEMBERS(MEMBER_NO, MEMBER_ID, MEMBER_NAME, MEMBER_DATE) VALUES
    (MEMBER_SEQ.NEXTVAL, 'tokyo', '도쿄', '21/04/02');
INSERT INTO MEMBERS(MEMBER_NO, MEMBER_ID, MEMBER_NAME, MEMBER_DATE) VALUES
    (MEMBER_SEQ.NEXTVAL, 'toronto', '토론토', '21/04/03');
INSERT INTO MEMBERS(MEMBER_NO, MEMBER_ID, MEMBER_NAME, MEMBER_DATE) VALUES
    (MEMBER_SEQ.NEXTVAL, 'tomato', '토마토', '21/04/04');
INSERT INTO MEMBERS(MEMBER_NO, MEMBER_ID, MEMBER_NAME, MEMBER_DATE) VALUES
    (MEMBER_SEQ.NEXTVAL, 'racer', '레이서', '21/04/05');
INSERT INTO MEMBERS(MEMBER_NO, MEMBER_ID, MEMBER_NAME, MEMBER_DATE) VALUES
    (MEMBER_SEQ.NEXTVAL, 'bayaba', '바야바', '21/04/06');

INSERT INTO BOARD(BOARD_NO, BOARD_TITLE, BOARD_CONTENT, MEMBER_ID, BOARD_DATE) VALUES
    (BOARD_SEQ.NEXTVAL, '공지사항', '공지입니다.', 'admin', SYSDATE);
INSERT INTO BOARD(BOARD_NO, BOARD_TITLE, BOARD_CONTENT, MEMBER_ID, BOARD_DATE) VALUES
    (BOARD_SEQ.NEXTVAL, '출석', '출석입니다.', 'bayaba', '21/04/05');
INSERT INTO BOARD(BOARD_NO, BOARD_TITLE, BOARD_CONTENT, MEMBER_ID, BOARD_DATE) VALUES
    (BOARD_SEQ.NEXTVAL, '질문입니다', '여기가 차붐의 나라입니까?', 'tomato', '21/04/06');
INSERT INTO BOARD(BOARD_NO, BOARD_TITLE, BOARD_CONTENT, MEMBER_ID, BOARD_DATE) VALUES
    (BOARD_SEQ.NEXTVAL, '협조', '재활용은 화목일입니다.', 'admin', SYSDATE);
INSERT INTO BOARD(BOARD_NO, BOARD_TITLE, BOARD_CONTENT, MEMBER_ID, BOARD_DATE) VALUES
    (BOARD_SEQ.NEXTVAL, '[필독]건의', '매일 아침마다 차가 너무 밀립니다.', 'racer', '21/04/07');

COMMIT;

SELECT * FROM BOARD;
SELECT * FROM MEMBERS;

-- 4. 게시판을 글제목의 가나다순으로 정렬하고 첫 번째 글을 조회한다.
SELECT b.board_no
     , b.board_title
     , b.board_content
     , b.member_id
     , b.board_date
  FROM (SELECT board_no
             , board_title
             , board_content
             , member_id
             , board_date
          FROM board
         ORDER BY board_title) b
 WHERE ROWNUM = 1;

-- 5. 게시판을 글번호의 가나다순으로 정렬하고 1 ~ 3번째 글을 조회한다.
SELECT b.board_no
     , b.board_title
     , b.board_content
     , b.member_id
     , b.board_date
  FROM (SELECT board_no
             , board_title
             , board_content
             , member_id
             , board_date
          FROM board
         ORDER BY board_no) b
 WHERE ROWNUM <= 3;

-- 6. 게시판을 최근 작성일자순으로 정렬하고 3 ~ 5번째 글을 조회한다.
SELECT a.*
  FROM (SELECT b.board_no
             , b.board_title
             , b.board_content
             , b.member_id
             , b.board_date
             , ROWNUM AS rn
          FROM (SELECT board_no
                     , board_title
                     , board_content
                     , member_id
                     , board_date
                  FROM board
                 ORDER BY board_date DESC) b) a
 WHERE a.rn BETWEEN 3 AND 5;


-- 7. 가장 먼저 가입한 회원을 조회한다.
-- 가입일을 기준으로 오른차순 정렬하고 첫번째 항목을 조회한다.
SELECT M.MEMBER_NO
     , M.MEMBER_ID
     , M.MEMBER_NAME
     , M.MEMBER_DATE
  FROM (SELECT MEMBER_NO
             , MEMBER_ID
             , MEMBER_NAME
             , MEMBER_DATE
          FROM MEMBERS
         ORDER BY MEMBER_DATE)M
 WHERE ROWNUM = 1;
 
-- 8. 3번째로 가입한 회원을 조회한다.
-- 오름차순으로 정렬 후 세번째 것 선택
SELECT M2.MEMBER_NO
     , M2.MEMBER_ID
     , M2.MEMBER_NAME
     , M2.MEMBER_DATE
  FROM (SELECT
               M1.MEMBER_NO
             , M1.MEMBER_ID
             , M1.MEMBER_NAME
             , M1.MEMBER_DATE
             , ROWNUM AS RN
          FROM (SELECT
                       MEMBER_NO
                     , MEMBER_ID
                     , MEMBER_NAME
                     , MEMBER_DATE
                FROM MEMBERS
                ORDER BY MEMBER_DATE)M1)M2
 WHERE M2.RN = 3;
         
-- 9. 가장 나중에 가입한 회원을 조회한다.
SELECT M.MEMBER_NO
     , M.MEMBER_ID
     , M.MEMBER_NAME
     , M.MEMBER_DATE
  FROM (SELECT MEMBER_NO
             , MEMBER_ID
             , MEMBER_NAME
             , MEMBER_DATE
          FROM MEMBERS
         ORDER BY MEMBER_DATE DESC)M    -- 7번 문제랑 똑같은데 DESC만 추가해줌(정렬기준만 바꿔줌)
 WHERE ROWNUM = 1;