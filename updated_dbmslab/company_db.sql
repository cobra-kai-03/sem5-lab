create database comp6;
use comp6;

create table department(
dno int primary key,
dname varchar(255),
mgrssn int,
mgrstartdate date
);

create table employee(
ssn int primary key,
name varchar(255),
address varchar(255),
sex varchar(255),
salary int,
superssn int,
dno int,
foreign key(dno) references department(dno)
);

create table dloca(
dno int,
dloc varchar(255)
);

create table project(
pno int primary key,
pname varchar(255),
ploc varchar(255),
dno int,
foreign key(dno) references department(dno)
);

create table workson(
ssn int,
pno int,
hours int,
foreign key(ssn) references employee(ssn),
foreign key(pno) references project(pno)
);

insert into department values(101,'Accounts',1,'2000-2-2'),(102,'HR',2,'2001-1-1'),(103,'Tech',3,'1999-9-9');

insert into employee values(1,'Scott','Goa','M',2000000,1,101),
(2,'Smith','Delhi','M',2500000,2,102),(3,'Kailee','Bombay','F',10000000,3,103)
,(4,'Fred','Pondi','M',200000,3,103),(5,'Archie','Ooty','M',100000,1,101);

insert into dloca values(101,'Panjim'),(102,'Anjuna'),(103,'Varkala');

insert into project values(21,'Hedron','Goa',101),(22,'Eclipse','Hyd',102),(23,'Hello','Nyc',101);

insert into workson values(1,21,3),(2,21,4),(3,22,5),(4,23,9);

insert into workson values(5,23,3),(5,22,6);

select   p.pno
from workson p,employee e
where p.ssn=e.ssn and (e.name='Scott' or e.ssn in (select ssn from employee where superssn in (select ssn from employee where name='Scott')));

select e.name,1.1*e.salary as hiked_salary
from employee e,workson w,project p
where p.pno=w.pno and e.ssn=w.ssn and p.pname='Hedron';

select sum(e.salary),max(e.salary),min(e.salary),avg(e.salary)
from employee e,department d
where e.dno=d.dno and d.dname='Accounts';

select name from employee where not exists(select * from project where dno=101 and not exists
(select * from workson where project.pno=workson.pno and employee.ssn=workson.ssn));

select dno,count(dno)
from employee
where salary>0 and dno in
(select dno from employee group by dno having count(*)>=1)
group by dno;

create view employee_info as
select e.name,d.dname,p.pname
from employee e,department d,project p,workson w
where e.dno=d.dno and e.ssn=w.ssn and p.pno=w.pno;

select*from employee_info;

delimiter $$
create trigger prevent_deletion
before delete on project
for each row
begin 
if (select count(pno) from workson where pno=old.pno)>0
then
signal sqlstate '45000'
set message_text='Cannot delete';
end if;
end;
$$

delimiter ;
delete from project where pno=21;
