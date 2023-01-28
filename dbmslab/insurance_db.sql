-- Insurance database
CREATE DATABASE insurance;
USE insurance;

CREATE TABLE person (
    driverid VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    address VARCHAR(255)
);

CREATE TABLE car (
    regno VARCHAR(255) PRIMARY KEY,
    year INT,
    model VARCHAR(255)
);

CREATE TABLE owns (
    driverid VARCHAR(255),
    regno VARCHAR(255),
     PRIMARY KEY (driverid , regno),
    FOREIGN KEY (driverid)
        REFERENCES person (driverid),
    FOREIGN KEY (regno)
        REFERENCES car (regno)
);

CREATE TABLE accident (
    reportno INT PRIMARY KEY,
    acc_date DATE,
    location VARCHAR(255)
);

CREATE TABLE participated (
    pid VARCHAR(255),
    cid VARCHAR(255),
    aid INT,
    damage_amt DECIMAL(10 , 2 ),
    PRIMARY KEY (pid , cid , aid),
    FOREIGN KEY (pid)
        REFERENCES person (driverid),
    FOREIGN KEY (cid)
        REFERENCES car (regno),
    FOREIGN KEY (aid)
        REFERENCES accident (reportno)
); 

Insert Into person values('1','P1','C1'),('2','P2','C2'),('3','P3','C3'),('4','P4','C4'),('5','P5','C5');

Insert into car values ('r1',2020,'cr1'),('r2',2020,'cr2'),('r3',2019,'cr3'),('r4',2018,'cr4');

Insert into owns values ('1','r1'),('5','r2'),('1','r4'),('3','r3');

Insert into accident values (21,'2022-10-10','L1'),(22,'2021-11-12','L2'),(23,'2020-10-10','L3'),(24,'2019-10-10','L4'),(25,'2018-10-10','L5');

Insert into participated values ('1','r1',21,12000),('3','r3',22,10000),('2','r4',23,15000),('4','r2',24,10000),('5','r3',25,15000);

-- ----------------------

-- Queries

-- -----------------------

-- Find the total number of people who owned cars that were involved in accidents in 2021
SELECT 
    COUNT(pid) AS count_of_owners
FROM
    participated p,
    accident a
WHERE
    p.aid = a.reportno
        AND a.acc_date LIKE '2021%';

-- Find the number of accidents in which cars belonging to 'P2'
SELECT 
    COUNT(DISTINCT a.reportno) AS accidents_P2
FROM
    accident a
WHERE
    EXISTS( SELECT 
            *
        FROM
            person p,
            participated ptd
        WHERE
            p.driverid = ptd.pid AND p.name = 'P2'
                AND a.reportno = ptd.aid);

-- Add a new accident to the database
insert into accident values (10,'2000-2-2','c2');

-- Delete the cr1 belonging to 'P1'
DELETE FROM car 
WHERE
    model = 'cr1'
    AND regno IN (SELECT 
        car.regno
    FROM
        person p,
        owns o
    
    WHERE
        p.driverid = o.driverid
        AND o.regno = car.regno
        AND p.name = 'P2');


-- Update the damage amount for the car with licanse number 'r1' on the accident with report number 21
UPDATE participated 
SET 
    damage_amt = 2000000
WHERE
    aid = 21 AND cid = 'r1';

-- ------------    
-- Views
-- ------------
-- A view that creates and shoows names and address of drivers who own a car
CREATE VIEW drivers_with_cars_info AS
    SELECT 
        name, address
    FROM
        owns o,
        person p
    WHERE
        p.driverid = o.driverid;

Select*From drivers_with_cars_info;

-- A view that shows models and years of cars that were involved in accident
CREATE VIEW accident_cars AS
    SELECT 
        model, year
    FROM
        car c,
        participated p
    WHERE
        c.regno = p.cid;

Select*From accident_cars;

-- A view that shows names of driver who participated in an accident in a specific place
CREATE VIEW driver_locations AS
    SELECT 
        name
    FROM
        person p,
        participated pa,
        accident a
    WHERE
        p.driverid = pa.pid
            AND pa.aid = a.reportno
            AND location = 'C1';
Select*From driver_locations;

-- A view that shows total damage amount for each driver
CREATE VIEW total_damage_amount AS
    SELECT 
        pid, SUM(damage_amt) AS total_amt
    FROM
        participated
    GROUP BY pid;
Select*From total_damage_amount;

-- ---------
-- Triggers
-- ---------
-- A trigger that prevents driver with total damage amount>500000 from owning a car
delimiter $$
create  trigger high_damage_drivers
before insert on owns 
for each row
begin
	if new.driverid in (select pid from participated group by pid
having sum(damage_amount) >= 50000) 
then
	signal sqlstate '45000' 
    set message_text = 'Damage Greater than Rs.50,000';
	end if;
end;
$$

-- A trigger that prevents driver from participated in more than 3 accidents in a given year
delimiter $$
CREATE TRIGGER limit_accidents
BEFORE INSERT ON participated
FOR EACH ROW
BEGIN
	IF(Select count(*) From participated where pid=new.pid and year(acc_date)=year(current_date())) > 3
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Driver cannot participate in more than 3 accidents in one year';
     END IF;
END;
$$
