
USE Group_89_OnlineShopping;
GO

-- Step 1: Creating UserInformation Table
CREATE TABLE UserInformation (
    UserID BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    ContactNumber CHAR(10) NOT NULL CHECK (LEN(ContactNumber) = 10),
    ShippingAddress NVARCHAR(255) NOT NULL,
    Password_hash NVARCHAR(255) NOT NULL
);
GO

-- Step 2: Creating ProductDetails Table
CREATE TABLE ProductDetails (
    ProductID BIGINT IDENTITY(1,1) PRIMARY KEY, 
    ProductName NVARCHAR(150) NOT NULL UNIQUE,
    Category NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0),
    StockLevel BIGINT NOT NULL CHECK (StockLevel >= 0),
    Discount DECIMAL(5, 2),
    Promotion NVARCHAR(255),
    Image_url NVARCHAR(255)
);
GO

-- Step 3: Creating OrderDetails Table
CREATE TABLE OrderDetails (
    OrderID BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserID BIGINT NOT NULL,
    ProductID BIGINT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    ShippingAddress NVARCHAR(255) NOT NULL,
    PaymentStatus NVARCHAR(50) NOT NULL,
    ShippingStatus NVARCHAR(50) NOT NULL CHECK (ShippingStatus IN ('Pending', 'Shipped', 'Delivered', 'Canceled')),
    TotalAmount DECIMAL(10, 2) NOT NULL CHECK (TotalAmount >= 0),
    FOREIGN KEY (UserID) REFERENCES UserInformation(UserID),
    FOREIGN KEY (ProductID) REFERENCES ProductDetails(ProductID)
);
GO



-- Step 4: Creating ShoppingCart Table
CREATE TABLE ShoppingCart (
    CartID BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserID BIGINT NOT NULL,
    ProductID BIGINT NOT NULL,
    Quantity BIGINT NOT NULL DEFAULT 1,
    LastUpdate NVARCHAR(MAX) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES UserInformation(UserID),
    FOREIGN KEY (ProductID) REFERENCES ProductDetails(ProductID)
);
GO

-- Step 5: Creating WishlistItem Table
CREATE TABLE WishlistItem (
    WishlistID BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserID BIGINT NOT NULL,
    ProductID BIGINT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES UserInformation(UserID),
    FOREIGN KEY (ProductID) REFERENCES ProductDetails(ProductID)
);
GO

-- Step 6: Creating ModeOfPayment Table
CREATE TABLE ModeOfPayment (
    PaymentModeID BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserID BIGINT NOT NULL,
    PaymentModeType NVARCHAR(50) NOT NULL,
    AccountDetails NVARCHAR(255),
    PaymentLimit DECIMAL(10, 2),
    PaymentDate DATETIME NOT NULL,
    PaymentModeTypeDetails NVARCHAR(MAX),
    IsDefault BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (UserID) REFERENCES UserInformation(UserID)
);
GO

-- Step 7: Creating Payment Table
CREATE TABLE Payment (
    PaymentID BIGINT IDENTITY(1,1) PRIMARY KEY,
    OrderID BIGINT NOT NULL,
    UserID BIGINT NOT NULL,
    PaymentModeID BIGINT NOT NULL, -- Foreign key for ModeOfPayment
    TransactionDate DATETIME DEFAULT GETDATE(),
    PaymentAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES OrderDetails(OrderID),
    FOREIGN KEY (UserID) REFERENCES UserInformation(UserID),
    FOREIGN KEY (PaymentModeID) REFERENCES ModeOfPayment(PaymentModeID) -- Added foreign key constraint
);
GO

---------------------------------Populating tables----------------------------
INSERT INTO UserInformation (UserName, Email, ContactNumber, ShippingAddress, Password_hash)
VALUES 
('John Doe', 'john.doe@example.com', '9876543210', '123 Elm Street, NY', 'Password@123'),
('Jane Smith', 'jane.smith@example.com', '9123456789', '456 Oak Avenue, LA', 'Secure@456'),
('Alice Brown', 'alice.brown@example.com', '9823456710', '789 Pine Road, TX', 'Brown!789'),
('Bob Johnson', 'bob.johnson@example.com', '8723456781', '101 Maple Blvd, FL', 'Bob@987'),
('Emily Davis', 'emily.davis@example.com', '9321456782', '234 Cedar St, WA', 'Davis#654'),
('David Wilson', 'david.wilson@example.com', '8412356783', '345 Birch Lane, OR', 'Wilson*321'),
('Sophia Martinez', 'sophia.martinez@example.com', '9213456784', '567 Fir Ave, CA', 'Sophia!876'),
('Michael Garcia', 'michael.garcia@example.com', '8712456785', '678 Palm Way, NV', 'Garcia@432'),
('Olivia Hernandez', 'olivia.hernandez@example.com', '8312456786', '789 Redwood Dr, AZ', 'Hernandez$123'),
('Liam Thompson', 'liam.thompson@example.com', '8712356787', '890 Cypress Rd, CO', 'Thompson!234');

INSERT INTO ProductDetails (ProductName, Category, Description, Price, StockLevel, Discount, Promotion, Image_url)
VALUES 
('Wireless Mouse', 'Electronics', 'Ergonomic wireless mouse', 25.99, 100, 10.00, 'Buy 1 Get 1 Free', 'url1'),
('Keyboard', 'Electronics', 'Mechanical gaming keyboard', 49.99, 50, 5.00, 'Free shipping', 'url2'),
('Bluetooth Speaker', 'Electronics', 'Portable waterproof speaker', 89.99, 30, 15.00, NULL, 'url3'),
('Smartphone', 'Electronics', 'Latest model smartphone', 699.99, 20, 50.00, 'Limited time offer', 'url4'),
('Backpack', 'Accessories', 'Durable hiking backpack', 45.99, 200, 10.00, NULL, 'url5'),
('Notebook', 'Stationery', 'Lined paper notebook', 5.99, 300, NULL, NULL, 'url6'),
('Wrist Watch', 'Accessories', 'Stylish analog wristwatch', 150.99, 80, 20.00, NULL, 'url7'),
('Tablet', 'Electronics', '10-inch tablet for productivity', 299.99, 40, 30.00, 'Bundle offer', 'url8'),
('Sneakers', 'Footwear', 'Comfortable running shoes', 75.99, 120, 15.00, NULL, 'url9'),
('Jacket', 'Clothing', 'Waterproof winter jacket', 120.99, 60, 25.00, NULL, 'url10');

INSERT INTO ModeOfPayment (UserID, PaymentModeType, AccountDetails, PaymentLimit, PaymentDate, PaymentModeTypeDetails, IsDefault)
VALUES 
(1, 'Credit Card', 'Visa ending in 1234', 5000.00, GETDATE(), 'Primary card', 1),
(2, 'Debit Card', 'Mastercard ending in 5678', 2000.00, GETDATE(), 'Secondary card', 0),
(3, 'PayPal', 'alice.paypal@example.com', NULL, GETDATE(), 'Preferred', 1),
(4, 'Credit Card', 'Amex ending in 9012', 7000.00, GETDATE(), 'Backup card', 0),
(5, 'Bank Transfer', 'Account 123456789', NULL, GETDATE(), 'High-limit account', 1),
(6, 'UPI', 'david.upi@bank', 3000.00, GETDATE(), 'Daily use', 0),
(7, 'Google Pay', 'sophia.gpay@phone', 1500.00, GETDATE(), 'Linked to credit card', 1),
(8, 'Apple Pay', 'michael.apple@example.com', NULL, GETDATE(), 'Secure payments', 0),
(9, 'Credit Card', 'Discover ending in 3456', 2500.00, GETDATE(), 'Personal card', 0),
(10, 'Debit Card', 'Visa ending in 7890', 1500.00, GETDATE(), 'Backup debit card', 1);

INSERT INTO OrderDetails (UserID, ProductID, ShippingAddress, PaymentStatus, ShippingStatus, TotalAmount)
VALUES
(6, 8, '345 Birch Lane, OR', 'Paid', 'Delivered', 299.99),
(7, 2, '567 Fir Ave, CA', 'Paid', 'Pending', 49.99),
(8, 9, '678 Palm Way, NV', 'Paid', 'Shipped', 75.99),
(9, 3, '789 Redwood Dr, AZ', 'Paid', 'Delivered', 89.99),
(10, 6, '890 Cypress Rd, CO', 'Paid', 'Pending', 5.99),
(1, 10, '123 Elm Street, NY', 'Paid', 'Shipped', 120.99),
(2, 7, '456 Oak Avenue, LA', 'Paid', 'Delivered', 150.99),
(3, 5, '789 Pine Road, TX', 'Paid', 'Delivered', 45.99),
(4, 4, '101 Maple Blvd, FL', 'Paid', 'Shipped', 699.99),
(5, 1, '234 Cedar St, WA', 'Paid', 'Delivered', 25.99),
(6, 6, '345 Birch Lane, OR', 'Paid', 'Pending', 5.99),
(7, 10, '567 Fir Ave, CA', 'Paid', 'Delivered', 120.99),
(8, 4, '678 Palm Way, NV', 'Paid', 'Shipped', 699.99),
(9, 8, '789 Redwood Dr, AZ', 'Paid', 'Delivered', 299.99),
(10, 3, '890 Cypress Rd, CO', 'Paid', 'Pending', 89.99),
(1, 2, '123 Elm Street, NY', 'Paid', 'Delivered', 49.99),
(2, 9, '456 Oak Avenue, LA', 'Paid', 'Shipped', 75.99),
(3, 7, '789 Pine Road, TX', 'Paid', 'Delivered', 150.99),
(4, 5, '101 Maple Blvd, FL', 'Paid', 'Pending', 45.99),
(5, 1, '234 Cedar St, WA', 'Paid', 'Shipped', 25.99),
(6, 10, '345 Birch Lane, OR', 'Paid', 'Delivered', 120.99),
(7, 8, '567 Fir Ave, CA', 'Paid', 'Shipped', 299.99),
(8, 6, '678 Palm Way, NV', 'Paid', 'Pending', 5.99),
(9, 4, '789 Redwood Dr, AZ', 'Paid', 'Delivered', 699.99),
(10, 2, '890 Cypress Rd, CO', 'Paid', 'Shipped', 49.99);

INSERT INTO ShoppingCart (UserID, ProductID, Quantity, LastUpdate)
VALUES
(6, 8, 1, GETDATE()),
(7, 2, 2, GETDATE()),
(8, 9, 1, GETDATE()),
(9, 3, 3, GETDATE()),
(10, 6, 1, GETDATE()),
(1, 10, 2, GETDATE()),
(2, 7, 1, GETDATE()),
(3, 5, 4, GETDATE()),
(4, 4, 1, GETDATE()),
(5, 1, 3, GETDATE()),
(6, 3, 2, GETDATE()),
(7, 10, 1, GETDATE()),
(8, 4, 1, GETDATE()),
(9, 8, 2, GETDATE()),
(10, 7, 1, GETDATE()),
(1, 6, 3, GETDATE()),
(2, 2, 1, GETDATE()),
(3, 9, 2, GETDATE()),
(4, 7, 1, GETDATE()),
(5, 10, 4, GETDATE()),
(6, 5, 2, GETDATE()),
(7, 4, 1, GETDATE()),
(8, 1, 3, GETDATE()),
(9, 3, 2, GETDATE()),
(10, 6, 1, GETDATE());

INSERT INTO WishlistItem (UserID, ProductID)
VALUES
(6, 8),
(7, 2),
(8, 9),
(9, 3),
(10, 6),
(1, 10),
(2, 7),
(3, 5),
(4, 4),
(5, 1),
(6, 3),
(7, 10),
(8, 4),
(9, 8),
(10, 7),
(1, 6),
(2, 2),
(3, 9),
(4, 7),
(5, 10),
(6, 5),
(7, 4),
(8, 1),
(9, 3),
(10, 6);

INSERT INTO Payment (OrderID, UserID, PaymentModeID, PaymentAmount)
VALUES
(1, 1, 1, 25.99),
(2, 1, 1, 49.99),
(3, 2, 2, 699.99),
(4, 3, 3, 45.99),
(5, 4, 4, 89.99),
(6, 5, 5, 150.99),
(7, 6, 6, 5.99),
(8, 7, 7, 299.99),
(9, 8, 8, 75.99),
(10, 9, 9, 120.99),
(11, 10, 10, 25.99),
(12, 2, 2, 699.99),
(13, 3, 3, 45.99),
(14, 4, 4, 89.99),
(15, 5, 5, 150.99),
(16, 6, 6, 5.99),
(17, 7, 7, 299.99),
(18, 8, 8, 75.99),
(19, 9, 9, 120.99),
(20, 10, 10, 25.99),
(21, 1, 1, 49.99),
(22, 2, 2, 699.99),
(23, 3, 3, 45.99),
(24, 4, 4, 89.99),
(25, 5, 5, 150.99);

SELECT * FROM UserInformation;
SELECT * FROM ProductDetails;
SELECT * FROM ModeOfPayment;
SELECT * FROM OrderDetails;
SELECT * FROM ShoppingCart;
SELECT * FROM WishlistItem;
SELECT * FROM Payment;

-------------------- Creating UserOrderSummary view-------------------
GO
CREATE VIEW UserOrderSummary AS
SELECT 
    UI.UserID,
    UI.UserName,
    OD.OrderID,
    PD.ProductName,
    OD.OrderDate,
    OD.ShippingStatus,
    OD.TotalAmount
FROM 
    UserInformation UI
INNER JOIN 
    OrderDetails OD ON UI.UserID = OD.UserID
INNER JOIN 
    ProductDetails PD ON OD.ProductID = PD.ProductID
WHERE 
    OD.ShippingStatus IN ('Pending', 'Shipped', 'Delivered'); 
GO


-------------------- Creating ProductStockStatus view-------------------
GO
CREATE VIEW ProductStockStatus AS
SELECT 
    PD.ProductID,
    PD.ProductName,
    PD.Category,
    PD.StockLevel,
    PD.Price,
    PD.Discount,
    SC.Quantity AS InCartQuantity,
    SC.UserID AS CartUserID
FROM 
    ProductDetails PD
INNER JOIN 
    ShoppingCart SC ON PD.ProductID = SC.ProductID
WHERE 
    PD.StockLevel < 100; 
GO

-------------------- Creating UserPaymentHistory view-------------------
GO
CREATE VIEW UserPaymentHistory AS
SELECT 
    UI.UserID,
    UI.UserName,
    P.PaymentID,
    P.PaymentAmount,
    P.TransactionDate,
    MOP.PaymentModeType
FROM 
    Payment P
INNER JOIN 
    UserInformation UI ON P.UserID = UI.UserID
INNER JOIN 
    ModeOfPayment MOP ON P.PaymentModeID = MOP.PaymentModeID
WHERE 
    P.TransactionDate >= DATEADD(MONTH, -6, GETDATE()); -- Payments made in the last 6 months
GO

--------------- Creating Audit Table--------------
CREATE TABLE ProductDetailsAudit (
    AuditID BIGINT IDENTITY(1,1) PRIMARY KEY,
    Operation NVARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
    OperationDate DATETIME DEFAULT GETDATE() NOT NULL,
    ProductID BIGINT, -- Original ProductID
    ProductName NVARCHAR(150),
    Category NVARCHAR(100),
    Description NVARCHAR(500),
    Price DECIMAL(10, 2),
    StockLevel BIGINT,
    Discount DECIMAL(5, 2),
    Promotion NVARCHAR(255),
    Image_url NVARCHAR(255)
);

---------Testing before insert operation-----------
SELECT * FROM ProductDetailsAudit;
GO


--Trigger for insert operation
CREATE TRIGGER trg_ProductDetails_Insert
ON ProductDetails
AFTER INSERT
AS
BEGIN
    INSERT INTO ProductDetailsAudit (
        Operation, ProductID, ProductName, Category, Description, Price, StockLevel, Discount, Promotion, Image_url
    )
    SELECT
        'INSERT', ProductID, ProductName, Category, Description, Price, StockLevel, Discount, Promotion, Image_url
    FROM INSERTED;
END;

-- Insert a new product
INSERT INTO ProductDetails (ProductName, Category, Description, Price, StockLevel, Discount, Promotion, Image_url)
VALUES ('Aesythetic Gaming Chair', 'Furniture', 'Ergonomic chair for gaming', 199.99, 50, 20.00, 'Limited time offer', 'url11');

-- Check the audit table
SELECT * FROM ProductDetailsAudit;
GO


------------Trigger for update operation----------
CREATE TRIGGER trg_ProductDetails_Update
ON ProductDetails
AFTER UPDATE
AS
BEGIN
    INSERT INTO ProductDetailsAudit (
        Operation, ProductID, ProductName, Category, Description, Price, StockLevel, Discount, Promotion, Image_url
    )
    SELECT
        'UPDATE', ProductID, ProductName, Category, Description, Price, StockLevel, Discount, Promotion, Image_url
    FROM INSERTED;
END;

-- Update the product details
UPDATE ProductDetails
SET Price = 179.99, StockLevel = 40
WHERE ProductName = 'Aesythetic Gaming Chair';

-- Check the audit table
SELECT * FROM ProductDetailsAudit;
GO



-------------Trigger for delete operation---------
CREATE TRIGGER trg_ProductDetails_Delete
ON ProductDetails
AFTER DELETE
AS
BEGIN
    INSERT INTO ProductDetailsAudit (
        Operation, ProductID, ProductName, Category, Description, Price, StockLevel, Discount, Promotion, Image_url
    )
    SELECT
        'DELETE', ProductID, ProductName, Category, Description, Price, StockLevel, Discount, Promotion, Image_url
    FROM DELETED;
END;

-- Delete the product
DELETE FROM ProductDetails
WHERE ProductName = 'Aesythetic Gaming Chair';

-- Check the audit table
SELECT * FROM ProductDetailsAudit;
GO



----Stored Procedure
CREATE PROCEDURE GetOrderDetailsByUserID
    @UserID BIGINT
AS
BEGIN
    SELECT 
        o.OrderID,
        o.OrderDate,
        o.ShippingAddress,
        o.PaymentStatus,
        o.ShippingStatus,
        o.TotalAmount,
        p.ProductName,
        p.Category
    FROM OrderDetails o
    INNER JOIN ProductDetails p
        ON o.ProductID = p.ProductID
    WHERE o.UserID = @UserID
    ORDER BY o.OrderDate DESC;
END;


-- Execute the stored procedure to retrieve orders for a specific user
EXEC GetOrderDetailsByUserID @UserID = 1;

-- Drop the procedure
DROP PROCEDURE GetOrderDetailsByUserID;

-- Testing the procedure after dropping it
EXEC GetOrderDetailsByUserID @UserID = 1;


---------- User Defined Functions---------
GO
CREATE FUNCTION CalculateCartTotal 
(@UserID BIGINT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @Total DECIMAL(10, 2);

    SELECT @Total = SUM(p.Price * sc.Quantity)
    FROM ShoppingCart sc
    INNER JOIN ProductDetails p
        ON sc.ProductID = p.ProductID
    WHERE sc.UserID = @UserID;

    RETURN ISNULL(@Total, 0); -- Return 0 if no items in the cart
END;
GO

-- Use the UDF to calculate the cart total for a specific user
SELECT dbo.CalculateCartTotal(1) AS CartTotal;

-- Dropping the function
DROP FUNCTION CalculateCartTotal;

-- Testing after dropping the function 
SELECT dbo.CalculateCartTotal(1) AS CartTotal;
GO




-------Creating the cursor
DECLARE @OrderID BIGINT, 
        @UserID BIGINT, 
        @TotalAmount DECIMAL(10, 2), 
        @ShippingStatus NVARCHAR(50);

-- Declare the cursor
DECLARE OrderCursor CURSOR FOR
SELECT OrderID, UserID, TotalAmount, ShippingStatus
FROM OrderDetails;

-- Open the cursor
OPEN OrderCursor;

-- Fetch the first row
FETCH NEXT FROM OrderCursor INTO @OrderID, @UserID, @TotalAmount, @ShippingStatus;

-- Loop through the rows
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'OrderID: ' + CAST(@OrderID AS NVARCHAR) +
          ', UserID: ' + CAST(@UserID AS NVARCHAR) +
          ', TotalAmount: ' + CAST(@TotalAmount AS NVARCHAR) +
          ', ShippingStatus: ' + @ShippingStatus;

    -- Fetch the next row
    FETCH NEXT FROM OrderCursor INTO @OrderID, @UserID, @TotalAmount, @ShippingStatus;
END;

-- Close and deallocate the cursor
CLOSE OrderCursor;
DEALLOCATE OrderCursor;
