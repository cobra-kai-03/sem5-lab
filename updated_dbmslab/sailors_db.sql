create database sail1;
use sail1;
create table sailors(
sid int primary key,
sname varchar(255),
rating int,
age int
);
create table boat(
bid int primary key,
bname varchar(255),
color varchar(255)
);
create table reserves(
sid int,
bid int,
date date,
primary key(sid,bid),
foreign key(sid) references sailors(sid),
foreign key(bid) references boat(bid)
);

insert into sailors values (1,'Albert',7,41),(2,'Smith',8,42),(3,'Sam',10,43),(4,'Ann',9,45),(5,'Juggy',3,42);

insert into boat values(101,'Motley Crue','Brown'),(102,'Thunderstorm','Blue'),(103,'Hailstorm','Grey'),(104,'Black Sabbath','Black');

insert into reserves values(1,101,'2022-10-10'),(1,102,'2020-2-2'),(1,103,'2021-1-1'),(1,104,'2020-1-1'),(2,101,'2013-1-1'),(3,101,'2020-10-10'),(4,101,'2022-7-7');

select b.bid,b.color
from boat b,sailors s,reserves r
where s.sid=r.sid and b.bid=r.bid and s.sname='Albert';

select sid from sailors where rating>=8
union
select sid from reserves where bid=103;

select sname from sailors where sid not in(select r.sid from boat b,reserves r where r.bid=b.bid and b.bname like "%storm%") order by sname asc;

select s.sname
from sailors s,reserves r,boat b
where s.sid=r.sid and b.bid=r.bid
group by r.sid
having count(r.sid)=(select count(bid) from boat);

select sname,age
from sailors
where age in(select max(age) from sailors);

select b.bid,avg(age)
from sailors s,boat b,reserves r
where b.bid=r.bid and s.sid=r.sid and s.age>=40
group by r.bid
having count(r.bid)>=2;

create view sailor_with_rating_ as
select b.bname,b.color
from boat b,sailors s,reserves r
where b.bid=r.bid and r.sid=s.sid and s.rating=7;

delimiter $$
create trigger prevent_deletion
before delete on boat
for each row
begin
if (select count(bid) from reserves where bid=old.bid)>0
then
signal sqlstate'45000'
set message_text="Cannot delete boat with active reservation";
end if;
end;
$$
delimiter ;
delete from boat where bid=101;
