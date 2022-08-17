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
1. `[DATE]` 1993|1994-[01-12]-01

### Tempo Médio não Optimizado

**mysql/mariaDB**: 0.359 + 0.516 + 0.255 + 0.307 + 0.261: AVG = 0.3396s

**postgresql**: 0.290 + 0.200 + 0.215 + 0.198 + 0.249: AVG = 0.2304s

### My SQL/ Maria DB Explain Graph não Optimizado

![1](https://user-images.githubusercontent.com/15125899/185228002-eb2e1cd8-f46a-43e2-975a-678c89106127.png)

Existem um full table scan em ORDERS por conta da leitura `O_ORDERDATE`, en~tao uma possível optimização e criar um índice com `O_ORDERDATE`

## Postgresql Explain Graph não Optimizado

## 2ª

```sql
-- 2.17 Business Question
-- The Promotion Effect Query determines what percentage of the revenue in a given year and month was derived
-- from promotional parts. The query considers only parts actually shipped in that month and gives the percentage.
-- Revenue is defined as (l_extendedprice * (1-l_discount)).
SELECT 100.00 * SUM(
        CASE
            WHEN P_TYPE LIKE 'PROMO%' THEN L_EXTENDEDPRICE *(1 - L_DISCOUNT)
            ELSE 0
        END
    ) / SUM(L_EXTENDEDPRICE * (1 - L_DISCOUNT)) AS PROMO_REVENUE
FROM LINEITEM,
    PART
WHERE L_PARTKEY = P_PARTKEY
    AND L_SHIPDATE >= DATE '[DATE]'
    AND L_SHIPDATE < DATE '[DATE]' + INTERVAL '1' MONTH;
```
1. `[DATE]` [1993-1997]-[01-12]-01

### Tempo Médio não Optimizado

**mysql/mariaDB**: 1.193 + 1.103 + 1.074 + 1.202 + 1.129: AVG = 1.1402s

**postgresql**: 0.103 + 0.091 + 0.155 + 0.145 + 0.171: AVG = 0.133s

### My SQL/ Maria DB Explain Graph não Optimizado

![2](https://user-images.githubusercontent.com/15125899/185228013-fba3d211-b178-441a-a046-180e97ef321c.png)

Existem um full table scan em PART

## Postgresql Explain Graph não Optimizado

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

-   `[P_SIZE]`: [1, 50]
-   `[TYPE]`: [TIN, NICKEL, BRASS, STEEL, COPPER]
-   `[REGION]`: [AFRICA, AMERICA, ASIA, EUROPE, MIDDLE EAST]

### Tempo Médio não Optimizado

**mysql/mariaDB**: 0.145 + 0.165 + 0.165 + 0.170 + 0.166: AVG = 0.1934 s

**postgresql**: 0.109 + 0.105 + 0.124 + 0.141 + 0.140s : AVG = 0.1238 s

### My SQL/ Maria DB Explain Graph não Optimizado

![3](https://user-images.githubusercontent.com/15125899/185228026-aeaba3e6-963e-4481-91e0-a1a9b9287d16.png)

Existem 3 full table scans nas tabelas REGION PART

## Postgresql Explain Graph não Optimizado

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

### Tempo Médio não Optimizado

**mysql/mariaDB**: 0.565 + 0.466 + 0.475 + 0.473 + 0.469: AVG = 0.4896 s

**postgresql**: 0.291 + 0.158 + 0.169 + 0.156 + 0.221: AVG = 0.199 s

### My SQL/ Maria DB Explain Graph não Optimizado

![4](https://user-images.githubusercontent.com/15125899/185228041-dc6842f2-e242-4d0c-8f99-48ef8a17f377.png)

## Postgresql Explain Graph não Optimizado

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

### Tempo Médio não Optimizado

**mysql/mariaDB**: 0.089 + 0.087 + 0.088 + 0.086 + 0.088: AVG = 0.0876 s

**postgresql**: 0.160 + 0.152 + 0.134 + 0.131 + 0.144: AVG = 0.1442 s

### My SQL/ Maria DB Explain Graph não Optimizado

![5](https://user-images.githubusercontent.com/15125899/185228055-086350f2-82de-45d7-b2be-0e048ebb560d.png)

## Postgresql Explain Graph não Optimizado
