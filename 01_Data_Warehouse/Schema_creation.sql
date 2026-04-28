CREATE DATABASE gravity_books_dwh;
GO

USE gravity_books_dwh;
GO

/* =======================
   DROP TABLES (SAFE ORDER)
======================= */
IF OBJECT_ID('Fact_order_status', 'U') IS NOT NULL DROP TABLE Fact_order_status;
IF OBJECT_ID('Fact_book_sales', 'U') IS NOT NULL DROP TABLE Fact_book_sales;

IF OBJECT_ID('Bridge_customer_address', 'U') IS NOT NULL DROP TABLE Bridge_customer_address;
IF OBJECT_ID('Bridge_Book_author', 'U') IS NOT NULL DROP TABLE Bridge_Book_author;

IF OBJECT_ID('Dim_status', 'U') IS NOT NULL DROP TABLE Dim_status;
IF OBJECT_ID('Dim_Customer', 'U') IS NOT NULL DROP TABLE Dim_Customer;
IF OBJECT_ID('Dim_Address', 'U') IS NOT NULL DROP TABLE Dim_Address;
IF OBJECT_ID('DIM_shipping_method', 'U') IS NOT NULL DROP TABLE DIM_shipping_method;
IF OBJECT_ID('Dim_Author', 'U') IS NOT NULL DROP TABLE Dim_Author;
IF OBJECT_ID('Dim_Book', 'U') IS NOT NULL DROP TABLE Dim_Book;
GO

/* =======================
   DIMENSIONS
======================= */

CREATE TABLE Dim_Book (
    book_id_sk        INT IDENTITY PRIMARY KEY,
    book_id_bk        INT,
    title             VARCHAR(400) NOT NULL,
    isbn13            VARCHAR(13),
    language_id       INT,
    language_code     VARCHAR(8),
    language_name     VARCHAR(50),
    publisher_id      INT,
    publisher_name    NVARCHAR(1000),
    num_pages         INT,
    publication_date  DATE, 
    ssc            TINYINT
);

CREATE TABLE Dim_Author(
    author_id_sk   INT IDENTITY PRIMARY KEY,
    author_id_bk   INT,
    author_name    VARCHAR(400) NOT NULL, 
    ssc            TINYINT 
);

CREATE TABLE DIM_shipping_method(
    shipping_method_sk    INT IDENTITY PRIMARY KEY,
    shipping_method_bk    INT,
    shipping_method_name  VARCHAR(100) NOT NULL,
    shipping_cost         DECIMAL(10,2), 
    ssc            TINYINT
);

CREATE TABLE Dim_Address(
    address_id_sk   INT IDENTITY PRIMARY KEY,
    address_id_bk   INT,
    street_number   VARCHAR(10),
    street_name     VARCHAR(200),
    city            VARCHAR(100),
    country_id      INT,
    country_name    VARCHAR(200), 
    ssc            TINYINT
);

CREATE TABLE Dim_Customer(
    customer_id_sk   INT IDENTITY PRIMARY KEY,
    customer_id_bk   INT,
    first_name       VARCHAR(200) NOT NULL,
    last_name        VARCHAR(200) NOT NULL,
    email            VARCHAR(350), 
    ssc              TINYINT,
    start_date       DATE,
    end_date         DATE,
    is_current        TINYINT
);

CREATE TABLE Dim_status(
    status_sk     INT IDENTITY PRIMARY KEY,
    status_id     INT,
    status_value  VARCHAR(20) NOT NULL,
    ssc           TINYINT
);



/* =======================
   BRIDGE TABLES
======================= */

CREATE TABLE Bridge_Book_author(
    book_id_sk   INT NOT NULL,
    author_id_sk INT NOT NULL,
    PRIMARY KEY (book_id_sk, author_id_sk),
    CONSTRAINT FK_bridge_book
        FOREIGN KEY (book_id_sk) REFERENCES Dim_Book(book_id_sk),
    CONSTRAINT FK_bridge_author
        FOREIGN KEY (author_id_sk) REFERENCES Dim_Author(author_id_sk)
);

CREATE TABLE Bridge_customer_address(
    customer_id_sk INT NOT NULL,
    address_id_sk  INT NOT NULL,
    status_id      INT,
    address_status VARCHAR(30),
    PRIMARY KEY (customer_id_sk, address_id_sk),
    CONSTRAINT FK_bridge_customer
        FOREIGN KEY (customer_id_sk) REFERENCES Dim_Customer(customer_id_sk),
    CONSTRAINT FK_bridge_address
        FOREIGN KEY (address_id_sk) REFERENCES Dim_Address(address_id_sk)
);

/* =======================
   FACT TABLES
======================= */

CREATE TABLE Fact_book_sales(
    sale_order_sk        INT IDENTITY PRIMARY KEY,
    order_bk             INT,  -- Degenerate dimension

    book_id_sk           INT NOT NULL,
    customer_id_sk       INT NOT NULL,
    shipping_method_sk   INT NOT NULL,
    order_date_sk        INT NOT NULL,
    order_time_sk        INT,
    address_id_sk        INT NOT NULL,
    price                DECIMAL(10,2) NOT NULL,
    quantity             INT NOT NULL,
    total_amount         DECIMAL(10,2) NOT NULL,
    ssc                  TINYINT,

    CONSTRAINT FK_sales_book
        FOREIGN KEY (book_id_sk) REFERENCES Dim_Book(book_id_sk),

    CONSTRAINT FK_sales_customer
        FOREIGN KEY (customer_id_sk) REFERENCES Dim_Customer(customer_id_sk),

    CONSTRAINT FK_sales_shipping
        FOREIGN KEY (shipping_method_sk) REFERENCES DIM_shipping_method(shipping_method_sk),

    CONSTRAINT FK_sales_date
        FOREIGN KEY (order_date_sk) REFERENCES DimDate(DateSK),

    CONSTRAINT FK_sales_time
        FOREIGN KEY (order_time_sk) REFERENCES DimTime(TimeSk),

    CONSTRAINT FK_sales_address
        FOREIGN KEY (address_id_sk) REFERENCES Dim_Address(address_id_sk)
);

CREATE TABLE Fact_order_status(
    order_bk        INT NOT NULL,   
    history_bk      INT NOT NULL,
    status_sk       INT NOT NULL,
    status_date_sk  INT NOT NULL,
    status_time_sk  INT NOT NULL,



    CONSTRAINT FK_order_status_status
        FOREIGN KEY (status_sk) REFERENCES Dim_status(status_sk),

    CONSTRAINT FK_order_status_date
        FOREIGN KEY (status_date_sk) REFERENCES DimDate(DateSK),
    
    CONSTRAINT FK_order_status_time
        FOREIGN KEY (status_time_sk) REFERENCES DimTime(TimeSK)
);
GO
