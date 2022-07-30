Create Database if not exists trabalho;
use trabalho;

CREATE TABLE PART(
	P_PARTKEY	BIGINT UNSIGNED PRIMARY KEY,
	P_NAME		VARCHAR(55),
	P_MFGR		VARCHAR(25),
	P_BRAND		CHAR(10),
	P_TYPE		VARCHAR(25),
	P_SIZE		INT,
	P_CONATINER	CHAR(10),
	P_REATILPRICE	FLOAT,
	P_COMMENT	VARCHAR(23)
);

CREATE TABLE REGION(
	R_REGIONKEY	BIGINT UNSIGNED PRIMARY KEY,
	R_NAME		CHAR(25),
	R_COMMENT	VARCHAR(152)
);

CREATE TABLE NATION(
	N_NATIONKEY	BIGINT UNSIGNED PRIMARY KEY,
	N_NAME		CHAR(25),
	N_REGIONKEY	BIGINT UNSIGNED,
	N_COMMENT	VARCHAR(152)
);

CREATE TABLE CUSTOMER(
	C_CUSTKEY	BIGINT UNSIGNED PRIMARY KEY,
	C_NAME		VARCHAR(25),
	C_ADDRESS	VARCHAR(40),
	C_NATIONKEY	BIGINT UNSIGNED,
	C_PHONE		CHAR(15),
	C_ACCTBAL	FLOAT,
	C_MKTSEGMENT	CHAR(10),
	C_COMMENT	VARCHAR(230)
);

CREATE TABLE ORDERS(
	O_ORDERKEY	BIGINT UNSIGNED PRIMARY KEY,
	O_CUSTKEY	BIGINT UNSIGNED,
	O_ORDERSTATUS	CHAR(1),
	O_TOTALPRICE	FLOAT,
	O_ORDERDATE	DATE,
	O_ORDERPRIORITY	CHAR(15),
	O_CLERK		CHAR(15),
	O_SHIPPRIORITY	INT,
	O_COMMENT	VARCHAR(79)
);

CREATE TABLE SUPPLIER(
	S_SUPPKEY	BIGINT UNSIGNED PRIMARY KEY,
	S_NAME		CHAR(25),
	S_ADDRESS	VARCHAR(40),
	S_NATIONKEY	BIGINT UNSIGNED,
	S_PHONE		CHAR(15),
	S_ACCTBAL	FLOAT,
	S_COMMENT	VARCHAR(101)
);

CREATE TABLE PARTSUPP(
	PS_PARTKEY	BIGINT UNSIGNED,
	PS_SUPPKEY	BIGINT UNSIGNED,
	PS_AVAILQTY	INT,
	PS_SUPPLYCOST	FLOAT,
	PS_COMMENT	VARCHAR(199),
	CONSTRAINT PARTSUPP_PK PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY)
);

CREATE TABLE LINEITEM(
	L_ORDERKEY	BIGINT UNSIGNED,
	L_PARTKEY	BIGINT UNSIGNED,
	L_SUPPKEY	BIGINT UNSIGNED,
	L_LINENUMBER	INT,
	L_QUANTITY	FLOAT,
	L_EXTENDEDPRICE	FLOAT,
	L_DISCOUNT	FLOAT,
	L_TAX		FLOAT,
	L_RETURNFLAG	CHAR(1),
	L_LINESTATUS	CHAR(1),
	L_SHIPDATE	DATE,
	L_COMMITDATE	DATE,
	L_RECEIPTDATE	DATE,
	L_SHIPINSTRUCT	CHAR(25),
	L_SHIPMODE	CHAR(10),
	L_COMMENT	VARCHAR(44),
	CONSTRAINT LINEITEM_PK PRIMARY KEY (L_ORDERKEY, L_LINENUMBER)	
);


-- 1. LOAD DATA INFILE is a SQL statement that loads data from a file into a table.
-- 2. '/var/lib/mysql/db.gen/customer.tbl' is the path to the file.
-- 3. IGNORE INTO TABLE CUSTOMER FIELDS TERMINATED BY '|' is the syntax for loading data into a table.
-- 4. The fields in the table are separated by '|'.
LOAD DATA INFILE '/var/lib/mysql/db.gen/customer.tbl' IGNORE INTO TABLE CUSTOMER FIELDS TERMINATED BY '|';
LOAD DATA INFILE '/var/lib/mysql/db.gen/lineitem.tbl' IGNORE INTO TABLE LINEITEM FIELDS TERMINATED BY '|';
LOAD DATA INFILE '/var/lib/mysql/db.gen/nation.tbl' IGNORE INTO TABLE NATION FIELDS TERMINATED BY '|';
LOAD DATA INFILE '/var/lib/mysql/db.gen/orders.tbl' IGNORE INTO TABLE ORDERS FIELDS TERMINATED BY '|';
LOAD DATA INFILE '/var/lib/mysql/db.gen/part.tbl' IGNORE INTO TABLE PART FIELDS TERMINATED BY '|';
LOAD DATA INFILE '/var/lib/mysql/db.gen/partsupp.tbl' IGNORE INTO TABLE PARTSUPP FIELDS TERMINATED BY '|';
LOAD DATA INFILE '/var/lib/mysql/db.gen/region.tbl' IGNORE INTO TABLE REGION FIELDS TERMINATED BY '|';
LOAD DATA INFILE '/var/lib/mysql/db.gen/supplier.tbl' IGNORE INTO TABLE SUPPLIER FIELDS TERMINATED BY '|';

-- Add a foreign key constraint to the SUPPLIER table.
ALTER TABLE SUPPLIER ADD CONSTRAINT SUPPLIER_FK FOREIGN KEY (S_NATIONKEY) REFERENCES NATION(N_NATIONKEY);

-- Add a foreign key constraint to the PARTSUPP table.
ALTER TABLE PARTSUPP ADD CONSTRAINT PARTSUPP_FK1 FOREIGN KEY (PS_PARTKEY) REFERENCES PART (P_PARTKEY);
ALTER TABLE PARTSUPP ADD CONSTRAINT PARTSUPP_FK2 FOREIGN KEY (PS_SUPPKEY) REFERENCES SUPPLIER (S_SUPPKEY);

-- Add a foreign key constraint to the CUSTOMER table.
ALTER TABLE CUSTOMER ADD CONSTRAINT CUSTUMER_FK FOREIGN KEY (C_NATIONKEY) REFERENCES NATION (N_NATIONKEY);

-- Add a foreign key constraint to the ORDERS table.
ALTER TABLE ORDERS ADD CONSTRAINT ORDERS_FK FOREIGN KEY (O_CUSTKEY) REFERENCES CUSTOMER (C_CUSTKEY);

-- Add a foreign key constraint to the LINEITEM table.
ALTER TABLE LINEITEM ADD CONSTRAINT LINEITEM_FK1 FOREIGN KEY (L_PARTKEY, L_SUPPKEY) REFERENCES PARTSUPP (PS_PARTKEY, PS_SUPPKEY);
ALTER TABLE LINEITEM ADD CONSTRAINT LINEITEM_FK2 FOREIGN KEY (L_ORDERKEY) REFERENCES ORDERS (O_ORDERKEY);
ALTER TABLE LINEITEM ADD CONSTRAINT LINEITEM_FK3 FOREIGN KEY (L_PARTKEY) REFERENCES PART (P_PARTKEY);
ALTER TABLE LINEITEM ADD CONSTRAINT LINEITEM_FK4 FOREIGN KEY (L_SUPPKEY) REFERENCES SUPPLIER (S_SUPPKEY);

-- Add a foreign key constraint to the NATION table. 
ALTER TABLE NATION ADD CONSTRAINT NATION_FK FOREIGN KEY (N_REGIONKEY) REFERENCES REGION (R_REGIONKEY);

-- Create 5 TPC-H query that returns the number of customers in each nation.

-- 1

-- 2

-- 3

-- 4

-- 5
