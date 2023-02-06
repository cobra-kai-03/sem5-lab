create database stu6;
use stu6;

create table student(
sid int primary key,
name varchar(255),
major varchar(255),
bdate date
);

create table course(
cid int primary key,
cname varchar(255),
dept varchar(255)
);

create table enroll(
sid int,
cid int,
sem int,
marks int,
foreign key(sid) references student(sid) on delete cascade,
foreign key(cid) references course(cid)
);

create table textb(
tid int primary key,
tname varchar(255),
publisher varchar(255),
author varchar(255)
);

create table bookadopt(
cid int,
tid int,
sem int,
foreign key(cid) references course(cid),
foreign key(tid) references textb(tid)
);

insert into student values(1,'Ann','2000-2-2'),(2,'Smith','2000-1-1'),(3,'Archie','ECE','1999-9-9'),(4,'Juggy','PHY','2001-1-1'),(5,'Andy','ISE','2002-2-2');

insert into course values(201,'DBMS','CSE'),(202,'DSA','CSE'),(203,'IOT','ECE'),(204,'STT','PHY'),(205,'JAVA','ISE');

insert into enroll values(1,201,2,90),(2,202,3,94),(3,203,3,99),(4,204,3,100),(1,202,2,99),(1,203,2,93);

insert into textb values(401,'DB','Pearson','Auth1'),(402,'DS','Pearson','Auth2'),(403,'IO','Pub','Auth3'),(404,'Phy','Pub1','Auth4'),(405,'Java101','Pub1','Auth5');

insert into bookadopt values(201,401,2),(202,402,3),(203,403,3),(204,404,3),(205,405,3);

insert into enroll values(2,201,2,99);
select c.cid,t.tid,t.tname
from textb t,course c,bookadopt b
where t.tid=b.tid and b.cid=c.cid and c.dept='CSE'
group by(b.cid)
having count(t.tid)>0
order by t.tname;

select c.dept
from course c,textb t,bookadopt b
where c.cid=b.cid and t.tid=b.tid and t.publisher='Pearson';

select s.sid,s.name
from student s,course c,enroll e
where s.sid=e.sid and c.cid=e.cid and c.cname='DBMS' and e.marks in(select max(e.marks) from enroll e,course c where e.cid=c.cid and c.cname='DBMS');

create view student_info as
select s.name,e.cid,c.cname,e.sem,e.marks
from student s,course c,enroll e
where s.sid=e.sid and c.cid=e.cid;

select*from student_info;

delimiter $$
create trigger prevent_enroll1
before insert on enroll
for each row
begin
declare prec int;
declare prem int;
select cid into prec from course where cid=new.cid;
select marks into prem from enroll where cid=prec and sid=new.sid;
if prem<90
then
signal sqlstate '45000'
set message_text='Cannot enroll';
end if;
end;
$$

delimiter ;
insert into enroll values(3,205,3,8);
