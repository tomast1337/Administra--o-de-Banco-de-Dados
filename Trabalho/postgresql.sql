-- 1ª

CREATE INDEX LINEITEM_INDEX ON LINEITEM (L_ORDERKEY, L_RETURNFLAG)
DROP INDEX LINEITEM_INDEX

CREATE INDEX LINEITEM_ORDERKEY ON LINEITEM (L_RETURNFLAG)
DROP INDEX LINEITEM_ORDERKEY

CREATE INDEX ORDER_DATE ON ORDERS (O_ORDERDATE)
DROP INDEX ORDER_DATE


CREATE INDEX LINEITEM_RETURNFLAG ON LINEITEM (L_RETURNFLAG)
DROP INDEX LINEITEM_RETURNFLAG


SELECT
    C_CUSTKEY,
    C_NAME,
    SUM(L_EXTENDEDPRICE * (1 - L_DISCOUNT)) AS REVENUE,
    C_ACCTBAL,
    N_NAME,
    C_ADDRESS,
    C_PHONE,
    C_COMMENT
FROM
    CUSTOMER,
    ORDERS,
    LINEITEM,
    NATION
WHERE
    C_CUSTKEY = O_CUSTKEY
        AND L_ORDERKEY = O_ORDERKEY
        AND O_ORDERDATE >= DATE '1993-11-01'
        AND O_ORDERDATE < DATE '1993-11-01' + INTERVAL '3' MONTH
        AND L_RETURNFLAG = 'R'
        AND C_NATIONKEY = N_NATIONKEY
GROUP BY C_CUSTKEY , C_NAME , C_ACCTBAL , C_PHONE , N_NAME , C_ADDRESS , C_COMMENT
ORDER BY REVENUE DESC;



-- 2ª

CREATE INDEX LINEITEM_INDEX2 ON LINEITEM (L_SHIPDATE) -- 1º

CREATE INDEX PART_INDEX2 ON PART (P_TYPE)
DROP INDEX PART_INDEX2

SELECT 100.00 * SUM(
        CASE
            WHEN P_TYPE LIKE 'PROMO%' THEN L_EXTENDEDPRICE *(1 - L_DISCOUNT)
            ELSE 0
        END
    ) / SUM(L_EXTENDEDPRICE * (1 - L_DISCOUNT)) AS PROMO_REVENUE
FROM LINEITEM,
    PART
WHERE L_PARTKEY = P_PARTKEY
    AND L_SHIPDATE >= DATE '1997-04-01'
    AND L_SHIPDATE < DATE '1997-04-01' + INTERVAL '1' MONTH;



-- 3ª

CREATE INDEX PART_INDEX ON PART (P_SIZE, P_TYPE)
DROP INDEX PART_INDEX

CREATE INDEX PARTSUPP_INDEX ON PARTSUPP (PS_SUPPLYCOST)
DROP INDEX PARTSUPP_INDEX



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
    AND P_SIZE = '25'
    AND P_TYPE LIKE '%COPPER'
    AND S_NATIONKEY = N_NATIONKEY
    AND N_REGIONKEY = R_REGIONKEY
    AND R_NAME = 'AFRICA'
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
            AND R_NAME = 'AFRICA'
    )
ORDER BY S_ACCTBAL DESC,
    N_NAME,
    S_NAME,
    P_PARTKEY;



-- 4ª

CREATE INDEX LINEITEM_INDEX ON LINEITEM (L_SHIPMODE) -- 4º
CREATE INDEX LINEITEM_INDEX ON LINEITEM (L_RECEIPTDATE, L_SHIPMODE) -- 3º
CREATE INDEX LINEITEM_INDEX ON LINEITEM (L_RECEIPT_DATE) -- 2º
CREATE INDEX LINEITEM_INDEX ON LINEITEM (L_SHIPMODE, L_RECEIPTDATE) -- 1º

CREATE INDEX LINEITEM_INDEX ON LINEITEM (L_RECEIPTDATE)
DROP INDEX LINEITEM_INDEX

CREATE INDEX LINEITEM_INDEX ON LINEITEM (L_RECEIPTDATE, L_SHIPMODE)
DROP INDEX LINEITEM_INDEX

SELECT
    L_SHIPMODE,
    SUM(CASE
        WHEN
            O_ORDERPRIORITY = '1-URGENT'
                OR O_ORDERPRIORITY = '2-HIGH'
        THEN
            1
        ELSE 0
    END) AS HIGH_LINE_COUNT,
    SUM(CASE
        WHEN
            O_ORDERPRIORITY <> '1-URGENT'
                AND O_ORDERPRIORITY <> '2-HIGH'
        THEN
            1
        ELSE 0
    END) AS LOW_LINE_COUNT
FROM
    ORDERS,
    LINEITEM
WHERE
    O_ORDERKEY = L_ORDERKEY
        AND L_SHIPMODE IN ('AIR' , 'MAIL')
        AND L_COMMITDATE < L_RECEIPTDATE
        AND L_SHIPDATE < L_COMMITDATE
        AND L_RECEIPTDATE >= DATE '1996-01-31'
        AND L_RECEIPTDATE < DATE '1996-01-31' + INTERVAL '1' YEAR
GROUP BY L_SHIPMODE
ORDER BY L_SHIPMODE;



-- 5ª

CREATE INDEX LINEITEM_INDEX2 ON LINEITEM (L_SHIPMODE) -- 4º
DROP INDEX LINEITEM_INDEX2

SELECT
    SUPP_NATION, CUST_NATION, L_YEAR, SUM(VOLUME) AS REVENUE
FROM
    (SELECT
        N1.N_NAME AS SUPP_NATION,
            N2.N_NAME AS CUST_NATION,
            EXTRACT(YEAR FROM L_SHIPDATE) AS L_YEAR,
            L_EXTENDEDPRICE * (1 - L_DISCOUNT) AS VOLUME
    FROM
        SUPPLIER, LINEITEM, ORDERS, CUSTOMER, NATION N1, NATION N2
    WHERE
        S_SUPPKEY = L_SUPPKEY
            AND O_ORDERKEY = L_ORDERKEY
            AND C_CUSTKEY = O_CUSTKEY
            AND S_NATIONKEY = N1.N_NATIONKEY
            AND C_NATIONKEY = N2.N_NATIONKEY
            AND ((N1.N_NAME = 'GERMANY'
            AND N2.N_NAME = 'ARGENTINA')
            OR (N1.N_NAME = 'ARGENTINA'
            AND N2.N_NAME = 'GERMANY'))
            AND L_SHIPDATE BETWEEN DATE '1995-01-01' AND DATE '1996-12-31') AS SHIPPING
GROUP BY SUPP_NATION , CUST_NATION , L_YEAR
ORDER BY SUPP_NATION , CUST_NATION , L_YEAR;