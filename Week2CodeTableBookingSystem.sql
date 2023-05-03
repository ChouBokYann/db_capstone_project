-- Table Booking System --

-- Admin --
Alter Table bookings
ADD COLUMN CustomerID INT 

Alter Table bookings
ADD Constraint fk_customers
FOREIGN KEY (CustomerID)
REFERENCES customers(CustomerID);

-- Task 1 --
INSERT INTO Bookings (BookingID, BookingDate, BookingTable, CustomerID)
VALUES 
    (1, '2022-10-10', 5, 1),
    (2, '2022-11-12', 3, 3),
    (3, '2022-10-11', 2, 2),
    (4, '2022-10-13', 2, 1);
    
-- Task 2 --
DELIMITER //
CREATE PROCEDURE CheckBooking (IN pBookingDate DATE, IN pTableNumber INT, OUT pStatus VARCHAR(20))
BEGIN
    DECLARE vCount INT;
    SELECT COUNT(*) INTO vCount
    FROM Bookings
    WHERE BookingDate = pBookingDate AND BookingTable = pTableNumber;
    
    IF vCount = 0 THEN
        SET pStatus = 'Available';
    ELSE
        SET pStatus = 'Booked';
    END IF;
    
END //
DELIMITER ;

-- Task 3 --
DELIMITER //
CREATE PROCEDURE AddValidBooking(
    IN bookingDate DATE,
    IN tableNumber INT,
    IN customerName VARCHAR(255)
)
BEGIN
    DECLARE tableStatus VARCHAR(50);
    
    START TRANSACTION;
    
    SELECT status INTO tableStatus 
    FROM Bookings 
    WHERE BookingTable = tableNumber 
    AND BookingDate = bookingDate 
    FOR UPDATE;

    IF tableStatus IS NULL THEN
        INSERT INTO Bookings (BookingDate, BookingTable)
        VALUES (bookingDate, tableNumber);
        
        COMMIT;
        SELECT 'Booking is successful!' AS Message;
    ELSE
        ROLLBACK;
        SELECT CONCAT('Table ', tableNumber, ' is already booked on ', bookingDate, 
                      ' under the name of ', tableStatus) AS Message;
    END IF;
END //

DELIMITER ;

-- Task 4 --
DELIMITER //
CREATE PROCEDURE AddBooking(IN booking_id INT, IN customer_id INT, IN booking_date DATE, IN table_number INT)
BEGIN
  INSERT INTO bookings (BookingID, CustomerID, BookingDate, BookingTable)
  VALUES (booking_id, customer_id, booking_date, table_number);
END //
DELIMITER ;

-- Task 5 --
DELIMITER //
CREATE PROCEDURE UpdateBooking (IN booking_id INT, IN booking_date DATE)
BEGIN
  UPDATE bookings SET BookingDate = booking_date WHERE BookingID = booking_id;
END //
DELIMITER ;

-- Task 6 --
DELIMITER //
CREATE PROCEDURE CancelBooking(IN booking_id INT)
BEGIN
    DELETE FROM bookings WHERE BookingID = booking_id;
    SELECT CONCAT('Booking with ID ', booking_id, ' has been cancelled.') AS 'Output';
END //
DELIMITER ;




