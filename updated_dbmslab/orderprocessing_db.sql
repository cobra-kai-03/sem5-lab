create database o_p;
use o_p;

create table customer(
cid int primary key,
cname varchar(255),
city varchar(255)
);

create table orders(
oid int primary key,
odate date,
cid int,
oamt int,
foreign key(cid) references customer(cid)
);

create table item(
id int primary key,
unitprice int
);

create table order_item(
oid int,
id int,
qty int,
foreign key(oid) references orders(oid) on delete cascade,
foreign key(id) references item(id) on delete cascade
);

create table warehouse(
wid int primary key,
city varchar(255)
);

create table shipment(
oid int,
wid int,
shipdate date,
foreign key(oid) references orders(oid) on delete cascade,
foreign key(wid) references warehouse(wid) on delete cascade
);

insert into customer values (1,'Smith','Goa'),(2,'Ann','Delhi'),(3,'Albert','Bombay'),(4,'Archie','Blr'),(5,'Betty','Kolkata');

insert into orders values(101,'2022-2-2',1,2000),(102,'2020-2-2',1,3000),(103,'2021-1-1',2,1000);

insert into item values(21,200),(22,300),(23,500),(24,700),(25,1100);

insert into order_item values(101,21,10),(102,22,10),(103,23,2);

insert into warehouse values(401,'Panjim'),(402,'Pune'),(403,'Delhi'),(404,'Lucknow');

insert into shipment values(101,401,'2022-3-3'),(102,402,'2020-3-3'),(103,403,'2021-2-2');

select wid,shipdate
from shipment
where wid=401;

select wid,o.oid
from shipment s,orders o,customer c
where s.oid=o.oid and c.cid=o.cid and c.cname='Smith';

select c.cname,count(*),avg(o.oamt)
from customer c,orders o
where c.cid=o.cid
group by c.cname;

delete from order_item
where oid in(select o.oid from orders o,customer c where c.cid=o.cid and c.cname='Smith');

select id from item where unitprice in(select max(unitprice) from item);
delimiter $$
create trigger updation_price
after update on order_item
for each row
begin
update orders o set o.oamt=(select sum(oi.qty*i.unitprice) from order_item oi,item i where oi.id=i.id)
where o.oid=new.oid;
end;
$$
delimiter ;
update order_item set qty=3 where oid=103;

select*from customer;
select*from orders;
select*from item;
select*from order_item;
select*from warehouse;
select*from shipment;
