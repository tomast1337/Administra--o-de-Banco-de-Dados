CREATE TABLE PART
	(	P_PARTKEY	INTEGER		NOT NULL,
		P_NAME		VARCHAR(55),
		P_MFGR		CHAR(25),
		P_BRAND		CHAR(10),
		P_TYPE		VARCHAR(25),
		P_SIZE		INTEGER,
		P_CONTAINER	CHAR(10),
		P_RETAILPRICE	DECIMAL(12,2),
		P_COMMENT	VARCHAR(23),
	CONSTRAINT PART_PK PRIMARY KEY (P_PARTKEY),
	CONSTRAINT P_PARTKEY_POSITIVE CHECK (P_PARTKEY>=0),
	CONSTRAINT P_SIZE_OPEN_INTERVAL CHECK (P_SIZE>=0),
	CONSTRAINT P_RETAILPRICE_OPEN_INTERVAL CHECK (P_RETAILPRICE>=0)	
	);

CREATE TABLE SUPPLIER
	(	S_SUPPKEY	INTEGER		NOT NULL,
		S_NAME		CHAR(25),
		S_ADDRESS	VARCHAR(40),
		S_NATIONKEY	INTEGER,
		S_PHONE		CHAR(15),
		S_ACCTBAL	DECIMAL(12,2),
		S_COMMENT	VARCHAR(101),
	CONSTRAINT SUPPLIER_PK PRIMARY KEY (S_SUPPKEY),
	CONSTRAINT S_SUPPKEY_POSITIVE CHECK (S_SUPPKEY>=0) 
	);

CREATE TABLE PARTSUPP
	(	PS_PARTKEY	INTEGER		NOT NULL,
		PS_SUPPKEY	INTEGER		NOT NULL,
		PS_AVAILQTY	INTEGER,
		PS_SUPPLYCOST	DECIMAL(12,2),
		PS_COMMENT	VARCHAR(199),
	CONSTRAINT PARTSUPP_PK PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY),
	CONSTRAINT PS_PARTKEY_POSITIVE CHECK (PS_PARTKEY>=0),
	CONSTRAINT PS_AVAILQTY_OPEN_INTERVAL CHECK (PS_AVAILQTY>=0),
	CONSTRAINT PS_SUPPLYCOST_OPEN_INTERVAL CHECK (PS_SUPPLYCOST>=0) 
	);

CREATE TABLE CUSTOMER
	(	C_CUSTKEY	INTEGER		NOT NULL,
		C_NAME		CHAR(25),
		C_ADDRESS	VARCHAR(40),
		C_NATIONKEY	INTEGER,
		C_PHONE		CHAR(15),
		C_ACCTBAL	DECIMAL(12,2),
		C_MKTSEGMENT	VARCHAR(10),
		C_COMMENT	text,
	CONSTRAINT CUSTUMER_PK PRIMARY KEY (C_CUSTKEY),
	CONSTRAINT C_CUSTKEY_POSITIVE CHECK (C_CUSTKEY>=0) 
	);

CREATE TABLE ORDERS
	(	O_ORDERKEY		INTEGER		NOT NULL,
		O_CUSTKEY		INTEGER,
		O_ORDERSTATUS		CHAR(1),
		O_TOTALPRICE		DECIMAL(12,2),
		O_ORDERDATE		TIMESTAMP,       /* tipo DATE no Oracle */
		O_ORDERPRIORITY	CHAR(15),
		O_CLERK			CHAR(15),
		O_SHIPPRIORITY		INTEGER,
		O_COMMENT		text,
	CONSTRAINT ORDERS_PK PRIMARY KEY (O_ORDERKEY),
	CONSTRAINT O_TOTALPRICE_OPEN_INTERVAL CHECK (O_TOTALPRICE>=0)	
	);

CREATE TABLE LINEITEM
	(	L_ORDERKEY		INTEGER		NOT NULL,	
		L_PARTKEY		INTEGER,
		L_SUPPKEY		INTEGER,
		L_LINENUMBER		INTEGER		NOT NULL,
		L_QUANTITY		DECIMAL(12,2),
		L_EXTENDEDPRICE		DECIMAL(12,2),
		L_DISCOUNT		DECIMAL(12,2),
		L_TAX			DECIMAL(12,2),
		L_RETURNFLAG		CHAR(1),
		L_LINESTATUS		CHAR(1),
		L_SHIPDATE		TIMESTAMP,    /* tipo DATE no Oracle */
		L_COMMITDATE		TIMESTAMP,    /* tipo DATE no Oracle */
		L_RECEIPTDATE		TIMESTAMP,    /* tipo DATE no Oracle */
		L_SHIPINSTRUCT		CHAR(25),
		L_SHIPMODE		CHAR(10),
		L_COMMENT		text,
	CONSTRAINT LINEITEM_PK PRIMARY KEY (L_ORDERKEY, L_LINENUMBER),
	CONSTRAINT L_QUANTITY_OPEN_INTERVAL CHECK (L_QUANTITY>=0),
	CONSTRAINT L_EXTENDEDPRICE_OPEN_INTERVAL CHECK (L_EXTENDEDPRICE>=0),
	CONSTRAINT L_TAX_OPEN_INTERVAL CHECK (L_TAX>=0),
	CONSTRAINT L_DISCOUNT_CLOSED_INTERVAL CHECK (L_DISCOUNT BETWEEN 0.00 AND 1.00),
	CONSTRAINT L_SHIPDATE_RECEIPTDATE CHECK (L_SHIPDATE<=L_RECEIPTDATE) 
	);

CREATE TABLE NATION
	(	N_NATIONKEY	INTEGER		NOT NULL,
		N_NAME		CHAR(25),
		N_REGIONKEY	INTEGER,
		N_COMMENT	VARCHAR(152),
	CONSTRAINT NATION_PK PRIMARY KEY (N_NATIONKEY),
	CONSTRAINT N_NATIONKEY_POSITIVE CHECK (N_NATIONKEY>=0) 
	);

CREATE TABLE REGION
	(	R_REGIONKEY INTEGER		NOT NULL,
		R_NAME      CHAR(25),
		R_COMMENT   VARCHAR(152),
	CONSTRAINT REGION_PK PRIMARY KEY (R_REGIONKEY),
	CONSTRAINT R_REGIONKEY_POSITIVE CHECK (R_REGIONKEY>=0)
	);
	
alter table customer add stub char(1);
COPY customer FROM '/data/tpch/customer.tbl' USING DELIMITERS '|' WITH NULL AS 'NULL';
alter table customer drop column stub;

alter table lineitem add stub char(1);
COPY lineitem FROM '/data/tpch/lineitem.tbl' USING DELIMITERS '|' WITH NULL AS 'NULL';	
alter table lineitem drop column stub;

alter table nation add stub char(1);
COPY nation FROM '/data/tpch/nation.tbl' USING DELIMITERS '|' WITH NULL AS 'NULL';	
alter table nation drop column stub;

alter table orders add stub char(1);
COPY orders FROM '/data/tpch/orders.tbl' USING DELIMITERS '|' WITH NULL AS 'NULL';	
alter table orders drop column stub;

alter table part add stub char(1);
COPY part FROM '/data/tpch/part.tbl' USING DELIMITERS '|' WITH NULL AS 'NULL';	
alter table part drop column stub;

alter table partsupp add stub char(1);
COPY partsupp FROM '/data/tpch/partsupp.tbl' USING DELIMITERS '|' WITH NULL AS 'NULL';	
alter table partsupp drop column stub;

alter table region add stub char(1);
COPY region FROM '/data/tpch/region.tbl' USING DELIMITERS '|' WITH NULL AS 'NULL';	
alter table region drop column stub;

alter table supplier add stub char(1);
COPY supplier FROM '/data/tpch/supplier.tbl' USING DELIMITERS '|' WITH NULL AS 'NULL';	
alter table supplier drop column stub;

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
