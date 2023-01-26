CREATE DATABASE sailors;

USE sailors;

CREATE TABLE sailor (
    sid INT PRIMARY KEY,
    sname VARCHAR(255),
    rating INT,
    age INT
);

CREATE TABLE boats (
    bid INT PRIMARY KEY,
    bname VARCHAR(255),
    color VARCHAR(255)
);

CREATE TABLE reserves (
    sid INT,
    bid INT,
    rdate DATE,
    PRIMARY KEY (sid , bid),
    FOREIGN KEY (sid)
        REFERENCES sailor (sid),
    FOREIGN KEY (bid)
        REFERENCES boats (bid)
);

INSERT INTO sailor VALUES (1,'S1',8,40),(2,'S2',9,30),(3,'S3',2,56),(4,'S4',10,60),(5,'S5',5,21);
SELECT *FROM sailor;

Insert into boats values (101,'B1','C1'),(102,'B2','C2'),(103,'B3','C3'),(104,'B4','C4'),(105,'B5','C5');
select*from boats;

INSERT INTO reserves VALUES (1,101,'2022-10-12'),(1,102,'2022-11-13'),(1,103,'2022-6-6'),(1,104,'2022-7-7'),(2,103,'2022-12-12'),(2,102,'2021-8-8'),(3,103,'2022-12-11'),(4,104,'2022-11-11'),(5,105,'2022-10-30'),(4,103,'2022-10-5');
SELECT*FROM reserves;
INSERT INTO reserves VALUES (1,105,'2022-10-2');

-- Find the colors of boats reserved by sailor S1.
SELECT 
    color
FROM
    sailor s,
    boats b,
    reserves r
WHERE
    s.sid = r.sid AND r.bid = b.bid AND s.sname = 'S1';
    
-- Find all sailor ids of sailors who have rating of at least 8 or reserved boat 103.
SELECT sid FROM sailor WHERE rating>8
UNION
SELECT sid FROM reserves WHERE bid=103;

-- Find the names of sailors who have not reserved a boat whose name contains string '2'
-- order the names in ascending order.
SELECT 
    sname
FROM
    sailor
WHERE
    sid NOT IN (SELECT 
            sid
        FROM
            reserves
        WHERE
            bid IN (SELECT 
                    bid
                FROM
                    boats
                WHERE
                    sname LIKE '%2%'))
ORDER BY sname;

-- Find the oldest sailor
SELECT sname,max(age) FROM sailor;

-- Find the sailor who has reserved all the boats
SELECT sname
FROM sailor
WHERE NOT EXISTS (  SELECT bid
						FROM boats WHERE NOT EXISTS (SELECT * FROM reserves
                        WHERE reserves.sid=sailor.sid AND reserves.bid=boats.bid));

-- For each boat which was reserved by atleast 2 sailors with age>=40 
-- find the boat id and average age of such sailors.                        
SELECT b.bid,avg(s.age)
FROM boats b, sailor s,reserves r
WHERE s.age>=40 AND b.bid=r.bid AND s.sid=r.sid
GROUP BY bid
HAVING 2<=COUNT(DISTINCT s.sid);

-- A view that shows names and ratings of all sailors sorted by rating in descending order.
CREATE VIEW sailor_by_rating as
SELECT sname,rating
FROM sailor
ORDER BY rating desc;

SELECT*FROM sailor_by_rating;

-- A view that shows names of sailors who have reserved boat on a given date.
CREATE VIEW sailor_with_reservation as
SELECT sname
FROM sailor s,reserves r
WHERE s.sid=r.sid AND r.rdate='2022-10-12';

SELECT*FROM sailor_with_reservation;

-- A view that shows names and colors of boats that have been resreved
-- by a sailor with specific rating
CREATE VIEW reserved_boats_by_rating as
SELECT s.sname,b.color
FROM sailor s,boats b,reserves r
WHERE s.sid=r.sid AND b.bid=r.bid AND s.rating=8;

SELECT*FROM reserved_boats_by_rating;

-- Triggers
-- 1.Trigger that prevents sailors with rating less than 3 from reserving a boat

delimiter $$
CREATE TRIGGER no_low_rating_reserve
BEFORE INSERT on reserves
FOR EACH ROW
BEGIN
	IF (SELECT rating FROM sailor WHERE sid=NEW.sid) < 3
	THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT='sailors with rating lower than 3 cannot reserve boats';
	end if;
end;
$$

delimiter ;
-- Query to check the trigger
INSERT into reserves values(3,102,'2022-10-10');


-- 2.A trigger that prevents boats from being deleted if they have active reservation
delimiter $$
CREATE TRIGGER prevent_deletion_boats
BEFORE DELETE on boats
FOR EACH ROW
BEGIN
	IF (SELECT count(*) FROM reserves WHERE bid=old.bid)>0
    THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='cannot delete boat with active reservations';
	END IF;
END;
$$
delimiter ;
-- Query to check the trigger
delete from boats where bid=103;


-- A trigger that deletes expired reservation
delimiter $$
CREATE TRIGGER delete_expired
AFTER INSERT ON reserves
FOR EACH ROW
BEGIN
	DELETE FROM reserves where rdate<current_date();
END
$$

delimiter ;
-- query to check the trigger
insert into reserves values(4,102,'2020-10-10');
