drop table lecture;
drop table enroll;
drop table student;

drop table professor;
drop table course;


create table student
(
    student_no number primary key,
    student_name varchar2(15),
    student_address varchar2(50),
    student_grade number,
    student_professor_no number
);

create table professor
(
      professor_no number primary key,
      professor_name varchar2(50),
      professor_major varchar2(20)
);

create table course
(
    course_no number primary key,
    course_name varchar2(20),
    course_score number
);

create table enroll
(
     enroll_no number primary key,
     student_no number,
     course_no number,
     enroll_date Date
);

create table lecture
(
     lecture_no number primary key,
     professor_no number,
     enroll_no number,
     lecture_name varchar2(20),
     lecture_location varchar2(20)
);

alter table student add constraint student_professor_fk foreign key(student_professor_no) references professor(professor_no);
alter table lecture add constraint lecture_professor_fk foreign key(professor_no) references professor(professor_no);
alter table lecture add constraint lecture_enroll_fk foreign key(enroll_no) references enroll(enroll_no);
alter table enroll add constraint enroll_student_fk foreign key(student_no) references student(student_no);
alter table enroll add constraint enroll_course_fk foreign key(course_no) references course(course_no);

insert into course values(01, '철학의 이해', 3);
insert into course values(02, '프로그래밍', 2);
insert into course values(03, '유아 발달', 2);

insert into professor values('1000', '제임스', '컴퓨터공학');
insert into professor values('1001', '스캇', '철학');
insert into professor values('1002', '왓슨', '아동복지');

insert into student values('15100425', '안소은', '인천', 1, 1000);
insert into student values('14100000', '김철수', '대구', 1, 1001);
insert into student values('13100000', '김민지', '원주', 1, 1002);

insert into enroll values(101, 15100425, 02, '21/04/02');
insert into enroll values(102, 14100000, 01, '20/05/29');
insert into enroll values(103, 13100000, 03, '19/10/13');

insert into lecture values(2000, 1000, 101, '자바', '공학1관 101호');
insert into lecture values(2001, 1001, 102, '소크라테스', '인문2관 202호');
insert into lecture values(2002, 1002, 103, '유아실습', '아복관 303호');

commit;