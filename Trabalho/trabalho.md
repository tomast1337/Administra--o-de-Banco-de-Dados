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
```

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
```

## tempo médio
mysql/mariaDB:
postgresql: