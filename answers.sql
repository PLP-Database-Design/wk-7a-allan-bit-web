-- 🛠️ Question 1: Achieving 1NF (First Normal Form)
-- The Products column contains multiple values in a single row.
-- To achieve 1NF, we need to split the Products into individual rows for each order.

-- SQL Query to transform the table into 1NF:
-- We will use a method to "unnest" the Products column into separate rows.

-- The approach will require some method like `UNPIVOT` in SQL Server or `WITH` clauses or simple joins based on a delimiter in MySQL.

-- For example, in MySQL, we could create a new row for each product per order.
-- Let's assume the splitting logic is handled either with a function or manually.

-- Here's an approach using `JOIN` and `SUBSTRING_INDEX` for MySQL:

SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
FROM 
    ProductDetail,
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) AS numbers
WHERE 
    n <= LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) + 1
ORDER BY 
    OrderID, n;

-- This will create a new row for each product associated with each order.
-- Each row will now represent a single product for a given order, ensuring 1NF.

-- --------------------------------------------------------------

-- 🧩 Question 2: Achieving 2NF (Second Normal Form)
-- The table `OrderDetails` is in 1NF but has partial dependencies.
-- The `CustomerName` depends only on the `OrderID`, which is a partial dependency, violating 2NF.


-- In order to achieve 2NF, we need to remove the partial dependency where `CustomerName` depends only on `OrderID`.
-- We will create two separate tables:
-- 1. One for the `Order` details with `OrderID` and `CustomerName`.
-- 2. Another for the `OrderItems` details with `OrderID`, `Product`, and `Quantity`.

-- SQL Query to achieve 2NF:

-- 1. Create an `Orders` table for customer and order information:
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- 2. Insert the data into the `Orders` table (no partial dependency here):
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- 3. Create an `OrderItems` table for product and quantity details:
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- 4. Insert the data into the `OrderItems` table:
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Now, the `Orders` table contains only information about the orders (OrderID and CustomerName),
-- while the `OrderItems` table contains the product and quantity details related to each order.
-- This ensures that all non-key attributes in the `OrderItems` table fully depend on the entire primary key (OrderID, Product), thus achieving 2NF.

