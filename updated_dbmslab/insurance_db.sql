create database insu60;
use insu60;

create table person(
pid int primary key,
name varchar(255),
address varchar(255)
);

create table car(
cid int primary key,
model varchar(255),
year int
);

create table owns(
pid int,
cid int,
foreign key(pid) references person(pid),
foreign key(cid) references car(cid)
);

create table accident(
aid int primary key,
acc_date date,
loc varchar(255)
);

create table participated(
pid int,
cid int,
aid int,
damage_amt int,
foreign key(pid) references person(pid),
foreign key(cid) references car(cid),
foreign key(aid) references accident(aid)
);

insert into person values(1,'Smith','Mysore'),(2,'Archie','Blr'),(3,'Juggy','Mumbai'),(4,'Ann','Goa'),(5,'Chris','Chennai');

insert into car values(101,'Gwagon',2020),(102,'Mazda',2021),(103,'Mustang',1984),(104,'Gpower',2014);

insert into owns values(1,101),(1,102),(2,103),(3,104);

insert into accident values(21,'2020-10-10','Goa'),(22,'2021-11-11','Ravka'),(23,'2022-11-11','Hogwarts');

insert into participated values(1,101,21,20000),(2,103,22,3000),(3,104,23,4000);

select count(p.pid)
from person p,owns o,accident a,car c,participated pa
where p.pid=o.pid and c.cid=o.cid and a.aid=pa.aid and pa.pid=o.pid and pa.cid=o.cid and year(a.acc_date)=2021;

select count(a.aid)
from person p,owns o,accident a,car c,participated pa
where p.pid=o.pid and c.cid=o.cid and a.aid=pa.aid and pa.pid=o.pid and pa.cid=o.cid and p.name='Smith';

insert into accident values(24,'2011-11-11','Delhi');

delete from owns where pid in(select pid from person where name='Smith') and cid in(select cid from car where model='Mazda');

update participated set damage_amt=2000 where aid=21;

create view cars_accidents as
select c.model,c.year
from car c,accident a,participated pa
where c.cid=pa.cid and a.aid=pa.aid;

select*from cars_accidents;

delimiter $$
create trigger not_more_than_1_accident
before insert on participated
for each row
begin
if(select count(pid) from participated)>1
then
signal sqlstate'45000'
set message_text="Prevent driver from participating in accident";
end if;
end;
delimiter ;
insert into participated values(1,103,21,2000);
