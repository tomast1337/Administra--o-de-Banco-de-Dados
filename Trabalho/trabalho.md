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

Existem um full table scan em ORDERS por conta da leitura `O_ORDERDATE`, então uma possível optimização e criar um índice com `O_ORDERDATE`

Criando o index `CREATE INDEX O_ORDERDATE_Index ON ORDERS (O_ORDERDATE);` a consulta fica da seguinte forma:

![1](https://user-images.githubusercontent.com/15125899/185257913-29fb7d4f-0868-449f-901e-c04b12c8f550.png)

### Postgresql Explain Graph não Optimizado

Tentamos criar um índice simples em L_RETURNFLAG (se o item foi retornado ou não), mas o PostgreSQL não usou o índice, e resolveu fazer a busca sequencial (provavelmente pelo número de itens retornados ser maior que 10% do total de itens, assim fazendo com que o uso do índice seja ineficiente por exigir a leitura de vários blocos do disco.)

Em NATION não vale a pena criar o índice, por serem poucas tuplas.

A estratégia utilizada no MySQL de criar o índice na data do pedido (O_ORDERDATE) funciona, e o Postgres utiliza o índice; porém, a melhoria no tempo de consulta não é muito relevante - da ordem de alguns milissegundos - , pois ela já é bem rápida mesmo sem o uso do índice.

### Tempo Médio Optimizado

**mysql/mariaDB**: 0.152 + 0.171 + 0.130 + 0.154 + 0.157: AVG 0.1528s

**postgresql**: 0.244 + 0.267 + 0.242 + 0.234 + 0.261: AVG 0.249s


------------------------------------------------------------------------------------------------------------------------

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

**mysql/mariaDB**: 0.173 + 0.152 + 0.164 + 0.175 + 0.135: AVG = 0.1598s

**postgresql**: 0.103 + 0.091 + 0.155 + 0.145 + 0.171: AVG = 0.133s

### My SQL/ Maria DB Explain Graph não Optimizado

![2](https://user-images.githubusercontent.com/15125899/185228013-fba3d211-b178-441a-a046-180e97ef321c.png)

Existem um full table scan em LINEITEM para buscar as datas na condição, então criei um indice com a coluna `L_SHIPDATE`:  `CREATE INDEX L_SHIPDATE_Index ON LINEITEM (L_SHIPDATE);` deixando a consulta da seguinte forma.

![2](https://user-images.githubusercontent.com/15125899/185259444-eb1a7997-871b-49e5-8d37-2d866445b7da.png)

### Postgresql Explain Graph não Optimizado

A mesma estratégia aplicada no MySQL, com um índice simples em L_SHIPDATE, funciona muito bem, evitando a busca e filtragem sequencial do período de data informado, e assim reduzindo o tempo total de processamento em mais da metade.


### Tempo Médio Optimizado

**mysql/mariaDB**: 0.064 + 0.052 + 0.047 + 0.058 + 0.055: AVG = 0.0552s

**postgresql**: 0.092 + 0.093 + 0.106 + 0.104 + 0.082 : AVG = 0.095s


------------------------------------------------------------------------------------------------------------------------

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

Existem 3 full table scans nas tabelas REGION, PART os da tabela REGION podem ser ignorados poque é uma tabela so com 5 linhas, em PART nos estão usando como condicional para a seleção as colunas não primarias P_TYPE e P_SIZE, podemos criar um índice composto com as duas da seguinte foma para melhoramos essa parte das busca, da seguinte foma, `CREATE INDEX P_TYPE_x_P_SIZE ON PART (P_SIZE,P_TYPE);` a consulta utilizando o índice fica da seguinte forma:

![3](https://user-images.githubusercontent.com/15125899/185261078-6e72ec75-cbe9-4e6d-8451-52c490b1e1b4.png)

### Postgresql Explain Graph não Optimizado

Não foi possível otimizar mais, pois as consultas iniciais já reduzem bastante o número de tuplas. Assim, a otimização proposta no MySQL não se aplica ao PostgreSQL, pois a filtragem por tamanho e material da peça só é feita ao final, depois que as tabelas passam por vários hash joins. A essa altura, não é possível aproveitar o índice composto de material e tamanho - em vez disso, o Postgres usa o índice de chave primária para encontrar quais valores resultantes dos hash joins anteriores atendem aos critérios definidos.

### Tempo Médio Optimizado

**mysql/mariaDB**:  0.028 +  0.029 +  0.029 +  0.021 +  0.031: AVG = 0.0276s

**postgresql**: N/A


------------------------------------------------------------------------------------------------------------------------

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

Uma possível optimização poderia ser um índice com a tabela `LINEITEM` porem teria que ser um item composto com tantas colunas que seria a mesma coisa que ler a tabela. isso foi experimentado e o mysql sempre tentar fazer toda seleção ao mesmo tempo ignorando a existência do índice. Tentamos reescrever a consulta separando um uma consulta menor que poderia ser utiliza o índice, porem ao colocar as outras condições relacionas a busca dentro de `LINEITEM` o my sql sempre prefere executar todas as condicionais por toda tabela. 

### Postgresql Explain Graph não Optimizado

Já no Postgres, aconteceu o contrário: ao criar um índice simples em um dos atributos, o Postgres acaba preferindo utilizar primeiro o índice para filtrar os itens, e depois efetuar a busca sequencial nos itens restantes. Como vários atributos estão sendo filtrados ao mesmo tempo, exploramos a criação de índices simples e compostos em diferentes atributos, e os resultados foram esses: (slide)

Ao criar o índice composto com L_SHIPMODE como o primeiro item, pode-se evitar muitas buscas, pois ao encontrar o valor de L_SHIPMODE desejado, encontra-se todas as demais entradas com esse valor.

### Tempo Médio Optimizado

**mysql/mariaDB**: Não Aplicável

**postgresql**: 0.142 + 0.158 + 0.151 + 0.138 + 0.147 = 0.147s


------------------------------------------------------------------------------------------------------------------------

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

Essa uma consulta bem rápida com um custo baixo

Como são muitas junções, por mais que se reduza a quantidade de tuplas intermediárias ao máximo, a junção final sempre irá demorar um pouco mais.

O índice só pode ser utilizado na primeira filtragem. Como a primeira operação realizada é a filtragem por REGION (país), que tem pouco menos de 30 linhas, não compensa criar um índice para um número tão pequeno de valores.

### Postgresql Explain Graph não Optimizado


### Tempo Médio Optimizado

**mysql/mariaDB**: N/A

**postgresql**: N/A


------------------------------------------------------------------------------------------------------------------------
