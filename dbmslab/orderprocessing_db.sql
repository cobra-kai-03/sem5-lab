-- -----
-- Order processing database
-- -----
CREATE DATABASE IF NOT EXISTS order_processing;

USE order_processing;

CREATE TABLE IF NOT EXISTS Customers (
    cust_id INT PRIMARY KEY,
    cname VARCHAR(35),
    city VARCHAR(35)
);

CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY,
    odate DATE,
    cust_id INT,
    order_amt INT,
    FOREIGN KEY (cust_id)
        REFERENCES Customers (cust_id)
);

CREATE TABLE IF NOT EXISTS Items (
    item_id INT PRIMARY KEY,
    unitprice INT
);

CREATE TABLE IF NOT EXISTS OrderItems (
    order_id INT,
    item_id INT,
    qty INT,
    FOREIGN KEY (order_id)
        REFERENCES Orders (order_id),
    FOREIGN KEY (item_id)
        REFERENCES Items (item_id)
);

CREATE TABLE IF NOT EXISTS Warehouses (
    warehouse_id INT PRIMARY KEY,
    city VARCHAR(35)
);

CREATE TABLE IF NOT EXISTS Shipments (
    order_id INT,
    warehouse_id INT,
    ship_date DATE,
    FOREIGN KEY (order_id)
        REFERENCES Orders (order_id),
    FOREIGN KEY (warehouse_id)
        REFERENCES Warehouses (warehouse_id)
);

INSERT INTO Customers VALUES
(0001, "Customer_1", "Mysuru"),
(0002, "Customer_2", "Bengaluru"),
(0003, "Kumar", "Mumbai"),
(0004, "Customer_4", "Dehli"),
(0005, "Customer_5", "Bengaluru");

Select*From Customers;

INSERT INTO Orders VALUES
(001, "2020-01-14", 0001, 2000),
(002, "2021-04-13", 0002, 500),
(003, "2019-10-02", 0005, 2500),
(004, "2019-05-12", 0003, 1000),
(005, "2020-12-23", 0004, 1200);

Select*From Orders;

INSERT INTO Items VALUES
(0001, 400),
(0002, 200),
(0003, 1000),
(0004, 100),
(0005, 500);

Select*From Items;

INSERT INTO Warehouses VALUES
(0001, "Mysuru"),
(0002, "Bengaluru"),
(0003, "Mumbai"),
(0004, "Dehli"),
(0005, "Chennai");

Select*From Warehouses;

INSERT INTO OrderItems VALUES 
(001, 0001, 5),
(002, 0005, 1),
(003, 0005, 5),
(004, 0003, 1),
(005, 0004, 12);

Select*From OrderItems;

INSERT INTO Shipments VALUES
(001, 0002, "2020-01-16"),
(002, 0001, "2021-04-14"),
(003, 0004, "2019-10-07"),
(004, 0003, "2019-05-16"),
(005, 0005, "2020-12-23");

Select*From Shipments;

-- ------
-- Queries
-- ------
-- List the order_id and shipment data for all order shipped from warehouse_no=1
SELECT 
    order_id, ship_date
FROM
    Shipments
WHERE
    warehouse_id = 1;
    
-- List the warehouse information from which the customer named 'Kumar' was supplied his order
SELECT 
    order_id, warehouse_id
FROM
    Warehouses
        NATURAL JOIN
    Shipments
WHERE
    order_id = (SELECT 
            order_id
        FROM
            Orders
        WHERE
            cust_id = (SELECT 
                    cust_id
                FROM
                    Customers
                WHERE
                    cname LIKE '%Kumar%');

-- Produce a listing cname,order_id of order, average order_amt where middle column is total number of order by customer
SELECT 
    c.cname, COUNT(o.order_id), AVG(order_amt)
FROM
    Customers c,
    Orders o
WHERE
    c.cust_id = o.cust_id;
    
-- Delete all orders from customer named 'Kumar'
DELETE FROM Orders 
WHERE
    cust_id = (SELECT 
        cust_id
    FROM
        Customers
    
    WHERE
        cname LIKE '%Kumar%');

-- Find the items with maximum unit price
SELECT 
    item_id, MAX(unitprice) AS Maximum_unit_price_item
FROM
    Items;
    
-- -------
-- Views
-- -------
-- A view to list orders and ship date for all orders shipped from warehouse 2
CREATE VIEW shipped_from_warehouse2 AS
    SELECT 
        order_id, ship_date
    FROM
        Shipments
    WHERE
        warehouse_id = 2;

Select*From shipped_from_warehouse2;
