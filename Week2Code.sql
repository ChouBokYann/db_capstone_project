-- Admin --
Alter Table Orders
ADD COLUMN MenuID INT 

ALTER TABLE Orders
ADD CONSTRAINT fk_menu
FOREIGN KEY (MenuID)
REFERENCES Menu(MenuID);


-- Task 1 --
CREATE VIEW OrdersView AS
SELECT OrderID, Quantity, ShippingCost
FROM Orders
WHERE Quantity > 2;

-- Task 2 -- 
SELECT customers.CustomerID, customers.CustomerName, orders.OrderID, orders.ShippingCost, menu.Cuisine, menu.Courses, menu.Starters
FROM Customers
INNER JOIN Orders ON customers.CustomerID = orders.Customers_CustomerID
INNER JOIN Menu  ON orders.MenuID = menu.MenuID
WHERE orders.ShippingCost > 150
ORDER BY orders.ShippingCost ASC;

-- Task 3 --
SELECT Cuisine
FROM Menu
WHERE MenuID = ANY (
  SELECT MenuID
  FROM Orders
  WHERE Quantity > 2
  GROUP BY MenuID
  HAVING COUNT(*) > 2
);

-- Task 4 -- 
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
  SELECT MAX(Quantity) AS MaxQuantity
  FROM Orders;
END //
DELIMITER ;

-- Task 5 --
PREPARE GetOrderDetail FROM 
  'SELECT OrderID, Quantity, ShippingCost
  FROM Orders
  WHERE Customers_CustomerID = ?';
  
-- Task 6 --
DELIMITER //
CREATE PROCEDURE CancelOrder(IN orderId INT)
BEGIN
  DELETE FROM Orders WHERE OrderID = orderId;
  SELECT CONCAT('Order ', orderId, ' has been cancelled.') AS Result;
END
DELIMITER ;

  





