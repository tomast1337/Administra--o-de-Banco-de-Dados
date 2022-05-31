# Esquema

```sql
create schema projetos;

set search_path to 'projetos';

CREATE DOMAIN TIPO_CPF CHAR(11);

CREATE TABLE DEPARTAMENTO (
   DNOME VARCHAR(30),
   DNUMERO INT NOT NULL,
   GERCPF TIPO_CPF,
   GERDATAINICIO TIMESTAMP,
   PRIMARY KEY (DNUMERO)
);

CREATE TABLE EMPREGADO (
   PNOME VARCHAR(30),
   MINICIAL VARCHAR(1),
   UNOME VARCHAR(30),
   CPF TIPO_CPF NOT NULL,
   DATANASC TIMESTAMP,
   ENDERECO TEXT,
   SEXO VARCHAR(1),
   SALARIO FLOAT,
   GERENTE_CPF TIPO_CPF,
   DNO INT,
   PRIMARY KEY (CPF),
   FOREIGN KEY (GERENTE_CPF) REFERENCES EMPREGADO (CPF),
   FOREIGN KEY (DNO) REFERENCES DEPARTAMENTO (DNUMERO)
);

ALTER TABLE DEPARTAMENTO ADD CONSTRAINT DEP_GER_FK FOREIGN KEY (GERCPF) REFERENCES EMPREGADO(CPF);

CREATE TABLE DEPT_LOCALIZACOES (
   DNUMERO INT NOT NULL,
   DLOCALIZACAO VARCHAR(30),
   PRIMARY KEY (DNUMERO,DLOCALIZACAO),
   FOREIGN KEY (DNUMERO) REFERENCES DEPARTAMENTO (DNUMERO)
);

CREATE TABLE PROJETO (
   PJNOME VARCHAR(30),
   PNUMERO INT NOT NULL,
   PLOCALIZACAO VARCHAR(30),
   DNUM INT,
   PRIMARY KEY (PNUMERO),
   UNIQUE(PJNOME),
   FOREIGN KEY (DNUM) REFERENCES DEPARTAMENTO (DNUMERO)
);

CREATE TABLE TRABALHA_EM (
   ECPF TIPO_CPF NOT NULL,
   PNO INT NOT NULL,
   HORAS FLOAT,
   PRIMARY KEY (ECPF,PNO),
   FOREIGN KEY (ECPF) REFERENCES EMPREGADO (CPF),
   FOREIGN KEY (PNO) REFERENCES PROJETO (PNUMERO)
);

CREATE TABLE DEPENDENTE (
   ECPF TIPO_CPF NOT NULL,
   NOME_DEPENDENTE VARCHAR(30) NOT NULL,
   SEXO VARCHAR(1),
   DATANASC TIMESTAMP,
   PARENTESCO VARCHAR(30),
   PRIMARY KEY (ECPF, NOME_DEPENDENTE),
   FOREIGN KEY (ECPF) REFERENCES EMPREGADO (CPF)
);
```

# Inserindo dados

```sql
--
-- DEPARTAMENTO
--

INSERT INTO DEPARTAMENTO (DNOME, DNUMERO, GERCPF, GERDATAINICIO)
VALUES ('Sede administrativa', 1, null, null);

INSERT INTO DEPARTAMENTO (DNOME, DNUMERO)
VALUES ('Administração', 4),
('Pesquisa', 5);

--
-- EMPREGADO
--

INSERT INTO EMPREGADO (PNOME, MINICIAL, UNOME, CPF,
					   DATANASC, ENDERECO, SEXO,
					   SALARIO, GERENTE_CPF, DNO)
VALUES ('James', 'E', 'Borg', 888665555,
		'1937-11-10', '450 Stone, Houston, TX',
		'M', 55000, null, 1);

INSERT INTO EMPREGADO (PNOME, MINICIAL, UNOME, CPF, DATANASC, ENDERECO, SEXO, SALARIO, GERENTE_CPF, DNO)
VALUES ('Franklin', 'T', 'Wong', 333445555, '1955-12-08', '638 Voss, Houston, TX', 'M', 40000, 888665555, 5),
('Ramesh', 'K', 'Narayan', 666884444, '1962-09-15', '975 Fire Oak, Humble, TX', 'M', 38000, 333445555, 5),
('John', 'B', 'Smith', 123456789, '1965-01-09', '731  Fondren, Houston, TX', 'M', 30000, 333445555, 5),
('Jennifer', 'S', 'Wallace', 987654321, '1941-06-20', '291 Berry, Bellaire, TX', 'F', 43000, 888665555, 4),
('Alicia', 'J', 'Zelaya', 999887777, '1968-01-19', '3321 Castle, Spring, TX', 'F', 25000, 987654321, 4),
('Ahmad', 'V', 'Jabbar', 987987987, '1969-03-29', '980 Dallas, Houston, TX', 'M', 25000, 987654321, 4),
('Joyce', 'A', 'English', 453453453, '1972-07-31', '5631 Rice, Houston, TX', 'F', 25000, 333445555, 5);

--
-- DEPT_LOCALIZACOES
--

INSERT INTO DEPT_LOCALIZACOES (DNUMERO, DLOCALIZACAO)
VALUES (1, 'Houston'),
(4, 'Staffor'),
(5, 'Bellaire'),
(5, 'Sugarland');

--
-- PROJETO
--

INSERT INTO PROJETO (PJNOME, PNUMERO, PLOCALIZACAO, DNUM)
VALUES ('ProdutoX', 1, 'Bellaire', 5),
('ProdutoY', 2, 'Sugarland', 5),
('ProdutoZ', 3, 'Houston', 5),
('Automatização', 10, 'Stafford', 4),
('Reorganização', 20, 'Houston', 1),
('Novos Benefícios', 30, 'Stafford', 4);

--
-- TRABALHA_EM
--

INSERT INTO TRABALHA_EM (ECPF, PNO, HORAS)
VALUES (123456789, 1, 32.5),
(123456789, 2, 7.5),
(666884444, 3, 40.0),
(453453453, 1, 20.0),
(453453453, 2, 20.0),
(333445555, 2, 10.0),
(333445555, 3, 10.0),
(333445555, 10, 10.0),
(333445555, 20, 10.0),
(999887777, 30, 30.0),
(999887777, 10, 10.0),
(987987987, 10, 35.0),
(987987987, 30, 5.0),
(987654321, 30, 20.0),
(987654321, 20, 15.0),
(888665555, 20, null);

--
-- DEPENDENTE
--

INSERT INTO DEPENDENTE (ECPF, NOME_DEPENDENTE, SEXO, DATANASC, PARENTESCO)
VALUES (333445555, 'Alice', 'F', '1986-04-05', 'FILHA'),
(333445555, 'Theodore', 'M', '1983-10-25', 'FILHO'),
(333445555, 'Joy', 'F', '1958-05-03', 'CÔNJUGE'),
(987654321, 'Abner', 'M', '1942-02-28', 'CÔNJUGE'),
(123456789, 'Michael', 'M', '1988-01-04', 'FILHO'),
(123456789, 'Alice', 'F', '1988-12-30', 'FILHA'),
(123456789, 'Elizabeth', 'F', '1967-05-05', 'CÔNJUGE');

-- LIGAR DEPARTAMENTO A SEU GERENTE
--

UPDATE DEPARTAMENTO SET
GERCPF=888665555,
GERDATAINICIO='1981-06-19'
WHERE DNUMERO=1;

UPDATE DEPARTAMENTO SET
GERCPF=333445555,
GERDATAINICIO='1988-05-22'
WHERE DNUMERO=5;

UPDATE DEPARTAMENTO SET
GERCPF=987654321,
GERDATAINICIO='1995-01-01'
WHERE DNUMERO=4;
```

# 1)

## SQL

```sql
SELECT *
FROM departamento
WHERE dnome = 'Pesquisa'
```

## Algebra Relacional

```
σ dnome = "Pesquisa" departamento
```

# 2)

## SQL

```sql
SELECT CPF FROM EMPREGADO
```

## Algebra Relacional

```
π cpf empregado
```

# 3)

## SQL

```sql
SELECT PNOME
FROM EMPREGADO
WHERE SALARIO BETWEEN 1000 AND 2000
```

## Algebra Relacional

```
π pnome
 σ 1000 <= salario AND salario <= 2000 empregado
```

# 4)

## SQL

```sql
SELECT CPF, DNOME
FROM EMPREGADO, DEPARTAMENTO
```

## Algebra Relacional

```
π cpf, dnome (empregado × departamento)
```

# 5)

## SQL

```sql
SELECT E.PNOME, E.UNOME, E.CPF, E.ENDERECO, E.DNO
FROM EMPREGADO E
WHERE E.DNO = 5
```

## Algebra Relacional

```
π PNOME, UNOME, CPF, ENDERECO, DNO (empregado × departamento)
σ dno = 5
ρ empregado
```

# 6)

## SQL

```sql
SELECT PNOME, UNOME, ENDERECO
FROM EMPREGADO E, DEPARTAMENTO D
WHERE D.DNOME = 'Pesquisa' AND D.DNUMERO = E.DNO
```

## Algebra Relacional

```
π PNOME, UNOME, ENDERECO
σ DNOME = "Pesquisa" departamento and DNUMERO = DNO (empregado × departamento)
```

# 7)

## SQL

```sql
SELECT P.PNUMERO, P.PLOCALIZACAO, P.DNUM, D.DNOME
FROM PROJETO P JOIN DEPARTAMENTO D ON (P.DNUM = D.DNUMERO)
```

## Algebra Relacional

```
π pnumero, plocalizacao, dnum, dnome (projeto ⋈ dnum = dnumero departamento)
```

# 8)

## SQL

```sql
SELECT P.PNUMERO, P.PLOCALIZACAO, P.DNUM, D.DNOME
FROM PROJETO P, DEPARTAMENTO D
WHERE P.DNUM = D.DNUMERO
```

## Algebra Relacional

```
π pnumero, plocalizacao, dnum, dnome (projeto ⋈ dnum = dnumero departamento)
```

# 9)

## SQL

```sql
SELECT E.PNOME, E.UNOME, S.PNOME, S.UNOME
FROM EMPREGADO E, EMPREGADO S
WHERE E.GERENTE_CPF = S.CPF
```

## Algebra Relacional

```
π pnome, unome, pnome, unome (empregado × empregado)
σ gerente_cpf = cpf (empregado)
```

# 10)

## SQL

```sql
SELECT P.PNUMERO, P.DNUM, E.UNOME, E.DATANASC, E.ENDERECO
FROM PROJETO P, DEPARTAMENTO D, EMPREGADO E
WHERE P.DNUM = D.DNUMERO AND D.GERCPF = E.CPF AND P.PLOCALIZACAO = 'Stafford';
```

## Algebra Relacional

```
π pnumero, dnum, unome, datanasc, endereco (projeto ⋈ dnum = dnumero departamento ⋈ gercpf = cpf (empregado))
σ plocalizacao = "Stafford" (projeto)
```

# 11)

## SQL

```sql
SELECT PJNOME FROM PROJETO P, DEPARTAMENTO D, EMPREGADO E WHERE DNUM = DNUMERO AND GERCPF = CPF AND UNOME='Smith'
UNION
SELECT PJNOME FROM PROJETO P, TRABALHA_EM T, EMPREGADO E WHERE PNUMERO=PNO AND ECPF=CPF AND UNOME ='Smith'
```

## Algebra Relacional

```
π pjnome
 σ dnum = dnumero AND gercpf = cpf AND unome = "Smith"
  (ρ p projeto ×
   ρ d departamento ×
    ρ e (empregado))

    ∪

     π pjnome
      σ pnumero = pno AND ecpf = cpf AND unome = "Smith"
       (ρ p projeto ×
        ρ t trabalha_em ×
         ρ e (empregado))
```

# 12)

## SQL

```sql
SELECT E.PNOME, E.UNOME, E.SALARIO
FROM EMPREGADO E
ORDER BY E.SALARIO
```

## Algebra Relacional

```
π pnome, unome, salario (empregado)
ρ empregado
```

# 13)

## SQL

```sql
SELECT E.PNOME, E.UNOME, E.SALARIO
FROM EMPREGADO E
WHERE E.UNOME LIKE '%r%'
```

## Algebra Relacional

```
π pnome, unome, salario (empregado)
σ unome LIKE '%r%' (empregado)
ρ empregado
```

# 14)

## SQL

```sql
SELECT COUNT(*)
FROM EMPREGADO E
```

## Algebra Relacional

```
π count (*)
γ count (*) (empregado)
```

# 15)

## SQL

```sql
SELECT AVG(E.SALARIO)
FROM EMPREGADO E WHERE E.DNO = 5
GROUP BY E.DNO
```

## Algebra Relacional

```
π dno, avg (salario)
γ dno (salario)
σ dno = 5 (empregado)
```

# 16)

## SQL

```sql
select e.dno, avg (e.salario)
from empregado e
group by e.dno
```

## Algebra Relacional

```
π dno, avg (salario)
ρ empregado

```

# 17)

## SQL

```sql
SELECT E.PNOME, E.UNOME, E.ENDERECO
FROM EMPREGADO E
WHERE DNO IN (SELECT D.DNUMERO FROM DEPARTAMENTO D WHERE D.DNOME='Pesquisa')
```

## Algebra Relacional

```

```

# 18)

## SQL

```sql
SELECT DISTINCT ECPF
FROM TRABALHA_EM
WHERE PNO IN (1, 2, 3)
```

## Algebra Relacional

```
δ
 π ecpf
  σ pno = 1 OR pno = 2 OR pno = 3 trabalha_em
```

# 19)

## SQL

```sql
SELECT PNOME, UNOME
FROM EMPREGADO
WHERE EXISTS (SELECT * FROM DEPENDENTE D WHERE ECPF=CPF AND PNOME=NOME_DEPENDENTE)
```

## Algebra Relacional

```

σ ecpf = cpf AND pnome = nome_dependente dependente

```

# 20)

## SQL

```sql
SELECT E.PNOME, E.UNOME
FROM EMPREGADO E
WHERE NOT EXISTS (SELECT * FROM DEPENDENTE D WHERE D.ECPF=E.CPF )
```

## Algebra Relacional

```


```