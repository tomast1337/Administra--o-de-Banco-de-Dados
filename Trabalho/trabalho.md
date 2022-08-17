# Processo de criação da base a carga dos dados:

# Consultas:

## 1ª

```sql
```

## tempo médio
mysql/mariaDB:
postgresql:

## 2ª

```sql

```

## tempo médio
mysql/mariaDB: 1.517s +
postgresql:

## 3ª

```sql
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
```

## tempo médio
mysql/mariaDB:
postgresql:

## 5ª

```sql
-- Business Question
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

1. NATION1 is randomly selected within the list of values defined for N_NAME in Clause 4.2.3;
2. NATION2 is randomly selected within the list of values defined for N_NAME in Clause 4.2.3 and must be different from the value selected for NATION1 in item 1 above.

## tempo médio
mysql/mariaDB: 0.177s +
postgresql: