CREATE TABLE PART
	(	P_PARTKEY	INTEGER		NOT NULL,
		P_NAME		VARCHAR(55),
		P_MFGR		VARCHAR(25),
		P_BRAND		VARCHAR(10),
		P_TYPE		VARCHAR(25),
		P_SIZE		INTEGER,
		P_CONTAINER	VARCHAR(10),
		P_RETAILPRICE	FLOAT,
		P_COMMENT	VARCHAR(150),

	CONSTRAINT PART_PK PRIMARY KEY (P_PARTKEY),
	CONSTRAINT P_PARTKEY_POSITIVE CHECK (P_PARTKEY>=0),
	CONSTRAINT P_SIZE_OPEN_INTERVAL CHECK (P_SIZE>=0),
	CONSTRAINT P_RETAILPRICE_OPEN_INTERVAL CHECK (P_RETAILPRICE>=0)	
	);
GO

CREATE TABLE SUPPLIER
	(	S_SUPPKEY	INTEGER		NOT NULL,
		S_NAME		VARCHAR(25),
		S_ADDRESS	VARCHAR(40),
		S_NATIONKEY	INTEGER,
		S_PHONE		VARCHAR(15),
		S_ACCTBAL	FLOAT,
		S_COMMENT	VARCHAR(150),

	CONSTRAINT SUPPLIER_PK PRIMARY KEY (S_SUPPKEY),
	CONSTRAINT S_SUPPKEY_POSITIVE CHECK (S_SUPPKEY>=0) 
	);
GO

CREATE TABLE PARTSUPP
	(	PS_PARTKEY	INTEGER		NOT NULL,
		PS_SUPPKEY	INTEGER		NOT NULL,
		PS_AVAILQTY	INTEGER,
		PS_SUPPLYCOST	FLOAT,
		PS_COMMENT	VARCHAR(200),

	CONSTRAINT PARTSUPP_PK PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY),
	CONSTRAINT PS_PARTKEY_POSITIVE CHECK (PS_PARTKEY>=0),
	CONSTRAINT PS_AVAILQTY_OPEN_INTERVAL CHECK (PS_AVAILQTY>=0),
	CONSTRAINT PS_SUPPLYCOST_OPEN_INTERVAL CHECK (PS_SUPPLYCOST>=0) 
	);
GO

CREATE TABLE CUSTOMER
	(	C_CUSTKEY	INTEGER	NOT NULL,
		C_NAME		VARCHAR(25),
		C_ADDRESS	VARCHAR(40),
		C_NATIONKEY	INTEGER,
		C_PHONE		VARCHAR(15),
		C_ACCTBAL	FLOAT,
		C_MKTSEGMENT VARCHAR(100),
		C_COMMENT	VARCHAR(150),

	CONSTRAINT CUSTUMER_PK PRIMARY KEY (C_CUSTKEY),
	CONSTRAINT C_CUSTKEY_POSITIVE CHECK (C_CUSTKEY>=0) 
	);
GO

CREATE TABLE ORDERS
	(	O_ORDERKEY		INTEGER		NOT NULL,
		O_CUSTKEY		INTEGER,
		O_ORDERSTATUS		VARCHAR(1),
		O_TOTALPRICE		FLOAT,
		O_ORDERDATE		DATE,       /* tipo DATE no Oracle */
		O_ORDERPRIORITY	VARCHAR(15),
		O_CLERK			VARCHAR(15),
		O_SHIPPRIORITY		INTEGER,
		O_COMMENT		VARCHAR(150),

	CONSTRAINT ORDERS_PK PRIMARY KEY (O_ORDERKEY),
	CONSTRAINT O_TOTALPRICE_OPEN_INTERVAL CHECK (O_TOTALPRICE>=0)	
	);
GO

CREATE TABLE LINEITEM
	(	L_ORDERKEY		INTEGER		NOT NULL,	
		L_PARTKEY		INTEGER,
		L_SUPPKEY		INTEGER,
		L_LINENUMBER		INTEGER		NOT NULL,
		L_QUANTITY		FLOAT,
		L_EXTENDEDPRICE		FLOAT,
		L_DISCOUNT		FLOAT,
		L_TAX			FLOAT,
		L_RETURNFLAG		VARCHAR(1),
		L_LINESTATUS		VARCHAR(1),
		L_SHIPDATE		date,    /* tipo datetime no Oracle */
		L_COMMITDATE		date,    /* tipo datetime no Oracle */
		L_RECEIPTDATE		date,    /* tipo datetime no Oracle */
		L_SHIPINSTRUCT		VARCHAR(25),
		L_SHIPMODE		VARCHAR(10),
		L_COMMENT		VARCHAR(150),

	CONSTRAINT LINEITEM_PK PRIMARY KEY (L_ORDERKEY, L_LINENUMBER),
	CONSTRAINT L_QUANTITY_OPEN_INTERVAL CHECK (L_QUANTITY>=0),
	CONSTRAINT L_EXTENDEDPRICE_OPEN_INTERVAL CHECK (L_EXTENDEDPRICE>=0),
	CONSTRAINT L_TAX_OPEN_INTERVAL CHECK (L_TAX>=0),
	CONSTRAINT L_DISCOUNT_CLOSED_INTERVAL CHECK (L_DISCOUNT BETWEEN 0.00 AND 1.00),
	CONSTRAINT L_SHIPDATE_RECEIPTDATE_MULTI_COLUMN CHECK (L_SHIPDATE<=L_RECEIPTDATE) 
	);
GO


CREATE TABLE NATION
	(	N_NATIONKEY	INTEGER		NOT NULL,
		N_NAME		VARCHAR(25),
		N_REGIONKEY	INTEGER,
		N_COMMENT	VARCHAR(200),

	CONSTRAINT NATION_PK PRIMARY KEY (N_NATIONKEY),
	CONSTRAINT N_NATIONKEY_POSITIVE CHECK (N_NATIONKEY>=0) 
	);
GO

CREATE TABLE REGION
	(	R_REGIONKEY INTEGER		NOT NULL,
		R_NAME      VARCHAR(25),
		R_COMMENT   VARCHAR(200),

	CONSTRAINT REGION_PK PRIMARY KEY (R_REGIONKEY),
	CONSTRAINT R_REGIONKEY_POSITIVE CHECK (R_REGIONKEY>=0)

	);
GO

BULK INSERT customer FROM '/data/tpch/customer.tbl' WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '\n')
BULK INSERT lineitem FROM '/data/tpch/lineitem.tbl' WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '\n')
BULK INSERT nation FROM '/data/tpch/nation.tbl' WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '\n')
BULK INSERT orders FROM '/data/tpch/orders.tbl' WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '\n')
BULK INSERT part FROM '/data/tpch/part.tbl' WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '\n')
BULK INSERT partsupp FROM '/data/tpch/partsupp.tbl' WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '\n')
BULK INSERT region FROM '/data/tpch/region.tbl' WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '\n')
BULK INSERT supplier FROM '/data/tpch/supplier.tbl' WITH (FIELDTERMINATOR = '|', ROWTERMINATOR = '\n')

ALTER TABLE SUPPLIER ADD CONSTRAINT SUPPLIER_FK FOREIGN KEY (S_NATIONKEY) REFERENCES NATION (N_NATIONKEY);
ALTER TABLE PARTSUPP ADD CONSTRAINT PARTSUPP_FK1 FOREIGN KEY (PS_PARTKEY) REFERENCES PART (P_PARTKEY);
ALTER TABLE PARTSUPP ADD CONSTRAINT PARTSUPP_FK2 FOREIGN KEY (PS_SUPPKEY) REFERENCES SUPPLIER (S_SUPPKEY);
ALTER TABLE CUSTOMER ADD CONSTRAINT CUSTUMER_FK FOREIGN KEY (C_NATIONKEY) REFERENCES NATION (N_NATIONKEY);
ALTER TABLE ORDERS ADD CONSTRAINT ORDERS_FK FOREIGN KEY (O_CUSTKEY) REFERENCES CUSTOMER (C_CUSTKEY);
ALTER TABLE LINEITEM ADD CONSTRAINT LINEITEM_FK1 FOREIGN KEY (L_PARTKEY, L_SUPPKEY) REFERENCES PARTSUPP (PS_PARTKEY, PS_SUPPKEY);
ALTER TABLE LINEITEM ADD CONSTRAINT LINEITEM_FK2 FOREIGN KEY (L_ORDERKEY) REFERENCES ORDERS (O_ORDERKEY);
ALTER TABLE LINEITEM ADD CONSTRAINT LINEITEM_FK3 FOREIGN KEY (L_PARTKEY) REFERENCES PART (P_PARTKEY);
ALTER TABLE LINEITEM ADD CONSTRAINT LINEITEM_FK4 FOREIGN KEY (L_SUPPKEY) REFERENCES SUPPLIER (S_SUPPKEY);
ALTER TABLE NATION ADD CONSTRAINT NATION_FK FOREIGN KEY (N_REGIONKEY) REFERENCES REGION (R_REGIONKEY);
