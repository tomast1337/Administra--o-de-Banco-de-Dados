# Processo de criação da base a carga dos dados:

# Consultas:

## 1ª

```sql
-- 2.13 Business question
-- The Returned Item Reporting Query finds the top 20 customers, in terms of their effect on lost revenue for a given
-- quarter, who have returned parts. The query considers only parts that were ordered in the specified quarter. The
-- query lists the customer's name, address, nation, phone number, account balance, comment information and revenue
-- lost. The customers are listed in descending order of lost revenue. Revenue lost is defined as
-- sum(l_extendedprice*(1-l_discount)) for all qualifying lineitems.
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
        AND O_ORDERDATE >= DATE '[DATE]'
        AND O_ORDERDATE < DATE '[DATE]' + INTERVAL '3' MONTH
        AND L_RETURNFLAG = 'R'
        AND C_NATIONKEY = N_NATIONKEY
GROUP BY C_CUSTKEY , C_NAME , C_ACCTBAL , C_PHONE , N_NAME , C_ADDRESS , C_COMMENT
ORDER BY REVENUE DESC;
```
1. DATE is the first day of a randomly selected month between the first month of 1993 and the 12th month of 1994.
## tempo médio

mysql/mariaDB: 0.359s +
postgresql:

## 2ª

```sql

```

## tempo médio

mysql/mariaDB: 1.517s +
postgresql:

## 3ª

```sql
-- 2.5 Business Question
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
```

Substituições:

-   [P_SIZE]: [1, 50]
-   [TYPE]: [TIN, NICKEL, BRASS, STEEL, COPPER]
-   [REGION]: [AFRICA, AMERICA, ASIA, EUROPE, MIDDLE EAST]

## tempo médio

mysql/mariaDB: 0.301s +
postgresql:

## 4ª

```sql
-- 2.15 Business Question
-- The Shipping Modes and Order Priority Query counts, by ship mode, for lineitems actually received by customers
-- in a given year, the number of lineitems belonging to orders for which the l_receiptdate exceeds the l_commitdate
-- for two different specified ship modes. Only lineitems that were actually shipped before the l_commitdate are considered. The late lineitems are partitioned into two groups, those with priority URGENT or HIGH, and those with a
-- priority other than URGENT or HIGH.
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
        AND L_SHIPMODE IN ('[SHIPMODE1]' , '[SHIPMODE2]')
        AND L_COMMITDATE < L_RECEIPTDATE
        AND L_SHIPDATE < L_COMMITDATE
        AND L_RECEIPTDATE >= DATE '[DATE]'
        AND L_RECEIPTDATE < DATE '[DATE]' + INTERVAL '1' YEAR
GROUP BY L_SHIPMODE
ORDER BY L_SHIPMODE;
```

Substituições:

1. `[SHIPMODE1]`: [REG AIR, AIR, RAIL, SHIP, TRUCK, MAIL, FOB]
2. `[SHIPMODE2]`: Mesmo que `[SHIPMODE1]` porém com outro valor
3. `[DATE]`: '1993-01-31' com ano entre [1993 .. 1997]

## tempo médio

mysql/mariaDB: 0.565s +
postgresql:

## 5ª

```sql
-- 2.10 Business Question
-- The Volume Shipping Query finds, for two given nations, the gross discounted revenues derived from line items in
-- which parts were shipped from a supplier in either nation to a customer in the other nation during 1995 and 1996.
-- The query lists the supplier nation, the customer nation, the year, and the revenue from shipments that took place in
-- that year. The query orders the answer by Supplier nation, Customer nation, and year (all ascending).
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
            AND ((N1.N_NAME = '[NATION1]'
            AND N2.N_NAME = '[NATION2]')
            OR (N1.N_NAME = '[NATION2]'
            AND N2.N_NAME = '[NATION1]'))
            AND L_SHIPDATE BETWEEN DATE '1995-01-01' AND DATE '1996-12-31') AS SHIPPING
GROUP BY SUPP_NATION , CUST_NATION , L_YEAR
ORDER BY SUPP_NATION , CUST_NATION , L_YEAR;
```

Substituições:

1. `[NATION1]`: [ALGERIA, ARGENTINA, BRAZIL, CANADA, EGYPT, ETHIOPIA, FRANCE, GERMANY, INDIA, INDONESIA, IRAN, IRAQ, JAPAN, JORDAN, KENYA, MOROCCO, MOZAMBIQUE, PERU, CHINA, ROMANIA, SAUDI ARABIA, VIETNAM, RUSSIA, UNITED KINGDOM, UNITED STATES
2. `[NATION2]`: Mesmo que [NATION1], porém com outro valor

## tempo médio

mysql/mariaDB: 0.177s +
postgresql:
