-- Lista all database 
show databases;
use trabalho_;
-- Lista all tables
show tables;
-- Tests
SELECT *
FROM PART
LIMIT 10;
SELECT *
FROM REGION
LIMIT 10;
SELECT *
FROM NATION
LIMIT 10;
SELECT *
FROM CUSTOMER
LIMIT 10;
SELECT *
FROM ORDERS
LIMIT 10;
SELECT *
FROM SUPPLIER
LIMIT 10;
SELECT *
FROM PARTSUPP
LIMIT 10;
SELECT *
FROM LINEITEM
LIMIT 10;
-- tpch2.6.1 benchmark
-- Business Question
-- The Pricing Summary Report Query provides a summary pricing report for all lineitems shipped as of a given date.
-- The date is within 60 - 120 days of the greatest ship date contained in the database. The query lists totals for
-- extended price, discounted extended price, discounted extended price plus tax, average quantity, average extended
-- price, and average discount. These aggregates are grouped by RETURNFLAG and LINESTATUS, and listed in
-- ascending order of RETURNFLAG and LINESTATUS. A count of the number of lineitems in each group is
-- included.
SELECT S_ACCTBAL,
    S_NAME,
    N_NAME,
    P_PARTKEY,
    P_MFGR,
    S_ADDRESS,
    S_PHONE,
    S_COMMENT
FROM PART,
    SUPPLIER,
    PARTSUPP,
    NATION,
    REGION
WHERE P_PARTKEY = PS_PARTKEY
    AND S_SUPPKEY = PS_SUPPKEY
    AND P_SIZE = 15 -- !!
    AND P_TYPE LIKE '%[TYPE]'
    AND S_NATIONKEY = N_NATIONKEY
    AND N_REGIONKEY = R_REGIONKEY
    AND R_NAME = '[REGION]'
    AND PS_SUPPLYCOST = (
        SELECT MIN(PS_SUPPLYCOST)
        FROM PARTSUPP,
            SUPPLIER,
            NATION,
            REGION
        WHERE P_PARTKEY = PS_PARTKEY
            AND S_SUPPKEY = PS_SUPPKEY
            AND S_NATIONKEY = N_NATIONKEY
            AND N_REGIONKEY = R_REGIONKEY
            AND R_NAME = '[REGION]'
    )
ORDER BY S_ACCTBAL DESC,
    N_NAME,
    S_NAME,
    P_PARTKEY;
-- Business Question
-- The Pricing Summary Report Query provides a summary pricing report for all lineitems shipped as of a given date.
-- The date is within 60 - 120 days of the greatest ship date contained in the database. The query lists totals for
-- extended price, discounted extended price, discounted extended price plus tax, average quantity, average extended
-- price, and average discount. These aggregates are grouped by RETURNFLAG and LINESTATUS, and listed in
-- ascending order of RETURNFLAG and LINESTATUS. A count of the number of lineitems in each group is
-- included.
SELECT L_RETURNFLAG,
    L_LINESTATUS,
    SUM(L_QUANTITY) AS SUM_QTY,
    SUM(L_EXTENDEDPRICE) AS SUM_BASE_PRICE,
    SUM(L_EXTENDEDPRICE *(1 - L_DISCOUNT)) AS SUM_DISC_PRICE,
    SUM(L_EXTENDEDPRICE *(1 - L_DISCOUNT) *(1 + L_TAX)) AS SUM_CHARGE,
    AVG(L_QUANTITY) AS AVG_QTY,
    AVG(L_EXTENDEDPRICE) AS AVG_PRICE,
    AVG(L_DISCOUNT) AS AVG_DISC,
    COUNT(*) AS COUNT_ORDER
FROM LINEITEM
WHERE L_SHIPDATE <= DATE '1998-12-01' + INTERVAL '120' DAY
GROUP BY L_RETURNFLAG,
    L_LINESTATUS
ORDER BY L_RETURNFLAG,
    L_LINESTATUS;
-- Business Question
-- The Minimum Cost Supplier Query finds, in a given region, for each part of a certain type and size, the supplier
-- who can supply it at minimum cost. If several suppliers in that region offer the desired part type and size at the same
-- (minimum) cost, the query lists the parts from suppliers with the 100 highest account balances. For each supplier,
-- the query lists the supplier's account balance, name and nation; the part's number and manufacturer; the supplier's
-- address, phone number and comment information.
SELECT S_ACCTBAL,
    S_NAME,
    N_NAME,
    P_PARTKEY,
    P_MFGR,
    S_ADDRESS,
    S_PHONE,
    S_COMMENT
FROM PART,
    SUPPLIER,
    PARTSUPP,
    NATION,
    REGION
WHERE P_PARTKEY = PS_PARTKEY
    AND S_SUPPKEY = PS_SUPPKEY
    AND P_SIZE = '[P_SIZE]'
    AND P_TYPE LIKE '%[TYPE]'
    AND S_NATIONKEY = N_NATIONKEY
    AND N_REGIONKEY = R_REGIONKEY
    AND R_NAME = '[REGION]'
    AND PS_SUPPLYCOST = (
        SELECT MIN(PS_SUPPLYCOST)
        FROM PARTSUPP,
            SUPPLIER,
            NATION,
            REGION
        WHERE P_PARTKEY = PS_PARTKEY
            AND S_SUPPKEY = PS_SUPPKEY
            AND S_NATIONKEY = N_NATIONKEY
            AND N_REGIONKEY = R_REGIONKEY
            AND R_NAME = '[REGION]'
    )
ORDER BY S_ACCTBAL DESC,
    N_NAME,
    S_NAME,
    P_PARTKEY;

SELECT S_ACCTBAL,
    S_NAME,
    N_NAME,
    P_PARTKEY,
    P_MFGR,
    S_ADDRESS,
    S_PHONE,
    S_COMMENT
FROM PART,
    SUPPLIER,
    PARTSUPP,
    NATION,
    REGION
WHERE P_PARTKEY = PS_PARTKEY
    AND S_SUPPKEY = PS_SUPPKEY
    AND P_SIZE = 15 -- !!
    AND P_TYPE LIKE '%STEEL'
    AND S_NATIONKEY = N_NATIONKEY
    AND N_REGIONKEY = R_REGIONKEY
    AND R_NAME = 'AMERICA'
    AND PS_SUPPLYCOST = (
        SELECT MIN(PS_SUPPLYCOST)
        FROM PARTSUPP,
            SUPPLIER,
            NATION,
            REGION
        WHERE P_PARTKEY = PS_PARTKEY
            AND S_SUPPKEY = PS_SUPPKEY
            AND S_NATIONKEY = N_NATIONKEY
            AND N_REGIONKEY = R_REGIONKEY
            AND R_NAME = 'AMERICA'
    )
ORDER BY S_ACCTBAL DESC,
    N_NAME,
    S_NAME,
    P_PARTKEY;
    
-- Business Question
-- The Shipping Priority Query retrieves the shipping priority and potential revenue, defined as the sum of
-- l_extendedprice * (1-l_discount), of the orders having the largest revenue among those that had not been shipped as
-- of a given date. Orders are listed in decreasing order of revenue. If more than 10 unshipped orders exist, only the 10
-- orders with the largest revenue are listed.
SELECT L_ORDERKEY,
    SUM(L_EXTENDEDPRICE *(1 - L_DISCOUNT)) AS REVENUE,
    O_ORDERDATE,
    O_SHIPPRIORITY
FROM CUSTOMER,
    ORDERS,
    LINEITEM
WHERE C_MKTSEGMENT = '[SEGMENT]'
    AND C_CUSTKEY = O_CUSTKEY
    AND L_ORDERKEY = O_ORDERKEY
    AND O_ORDERDATE < DATE '1998-12-01' + INTERVAL '120' DAY
    AND L_SHIPDATE > DATE '1998-12-01' + INTERVAL '120' DAY
GROUP BY L_ORDERKEY,
    O_ORDERDATE,
    O_SHIPPRIORITY
ORDER BY REVENUE DESC,
    O_ORDERDATE;
