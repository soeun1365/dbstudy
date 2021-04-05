DROP TABLE event;
DROP TABLE nation;
DROP TABLE player;
DROP TABLE schedule;

--1. 국가(nation)테이블 
CREATE TABLE NATION
(
    NATION_CODE NUMBER(3),
    NATION_NAME VARCHAR2(30),
    NATION_PREV_RANK NUMBER,
    NATION_CURR_RANK NUMBER,
    NATION_PARTI_PERSON NUMBER,
    NATION_PARTI_EVENT NUMBER
);

--2. 종목(event)테이블 
CREATE TABLE event
(
    event_code NUMBER(5),
    event_name VARCHAR2(30),
    event_info VARCHAR2(1000),
    event_first_year NUMBER(4)
);

--3. 선수(player)테이블
CREATE TABLE player
(
    player_code NUMBER(5),
    nation_code NUMBER(3),
    event_code NUMBER(5),
    player_name VARCHAR2(30),
    player_age NUMBER(3),
    player_rank NUMBER
);

--4. 일정(schedule)테이블
CREATE TABLE SCHEDULE
(
    NATION_CODE  NUMBER(3),
    EVENT_CODE NUMBER(5),
    SCHEDULE_INFO VARCHAR2(1000),
    SCHEDULE_BEGIN DATE,
    SCHEDULE_END DATE
);

--각 테이블에 기본키를 추가하기
ALTER TABLE nation ADD CONSTRAINT nation_pk PRIMARY KEY(nation_code);
ALTER TABLE event ADD CONSTRAINT event_pk PRIMARY KEY(event_code);
ALTER TABLE player ADD CONSTRAINT player_pk PRIMARY KEY(player_code);
ALTER TABLE schedule ADD CONSTRAINT schedule_pk PRIMARY KEY(nation_code, event_code);

--선수(player) 테이블에 외래키 추가하기
ALTER TABLE player ADD CONSTRAINT player_nation_fk FOREIGN KEY(nation_code) REFERENCES nation(nation_code);
ALTER TABLE player ADD CONSTRAINT player_event_fk FOREIGN KEY(event_code) REFERENCES event(event_code);

--일정(schedule)테이블에 외래키 추가하기
ALTER TABLE schedule ADD CONSTRAINT schedule_nation_fk FOREIGN KEY(nation_code) REFERENCES nation(nation_code);
ALTER TABLE schedule ADD CONSTRAINT schedule_event_fk FOREIGN KEY(event_code) REFERENCES event(event_code);


--제약조건의 삭제
--ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
ALTER TABLE player DROP CONSTRAINT player_nation_fk;
ALTER TABLE schedule DROP CONSTRAINT schedule_nation_fk;
ALTER TABLE nation DROP CONSTRAINT nation_pk;   -- nation_pk를 참고하는 외래키를 먼저 지웁니다.

ALTER TABLE player DROP CONSTRAINT player_event_fk;
ALTER TABLE schedule DROP CONSTRAINT schedule_event_fk;
ALTER TABLE event DROP CONSTRAINT event_pk;

ALTER TABLE player DROP CONSTRAINT player_pk;
ALTER TABLE schedule DROP CONSTRAINT schedule_pk;


--제약조건의 확인
--제약조건을 저장하고 있는 DD (Data Dictionary) : USER_CONSTRAINTS 테이블
DESC user_constraints;
SELECT constraint_name, table_name FROM user_constraints;

SELECT constraint_name, table_name FROM user_constraints WHERE table_name = 'PLAYER';   --따옴표안에 테이블명은 대문자로 적어줘야함


--제약조건의 비활성화
ALTER TABLE player DISABLE CONSTRAINT player_nation_fk;
--제약조건의 활성화
ALTER TABLE player ENABLE CONSTRAINT player_nation_fk;











