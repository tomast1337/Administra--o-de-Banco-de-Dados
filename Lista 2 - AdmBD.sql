-- Lista 2 - Administração de Banco de Dados


-- 2
SELECT nome_cliente
FROM cliente
WHERE cidade_cliente = 'RIO DE JANEIRO'


-- 3
SELECT nome_cliente, cidade_cliente
FROM cliente
ORDER BY cidade_cliente ASC, nome_cliente ASC


-- 4
SELECT nome_cliente
FROM cliente
WHERE nome_cliente LIKE '%A%'


-- 5
SELECT nome_cliente
FROM cliente
WHERE nome_cliente like 'A%'


-- 6
SELECT nome_cliente, saldo
FROM cliente JOIN conta ON cliente.cpf = conta.cliente_conta


-- 7
SELECT nome_cliente, SUM(emprestimo.quantia) as total
FROM cliente
JOIN tomador ON tomador.cliente_tomador = cliente.cpf
JOIN emprestimo ON emprestimo.id_emprestimo = tomador.emprestimo_tomador
GROUP BY nome_cliente


-- 8
SELECT DISTINCT nome_cliente
FROM cliente
JOIN conta ON cliente.cpf = conta.cliente_conta
JOIN tomador ON cliente.cpf = tomador.cliente_tomador


-- 9
SELECT cliente.nome_cliente, cliente.cidade_cliente
FROM cliente
JOIN tomador ON cliente.cpf = tomador.cliente_tomador
WHERE cliente.cpf NOT IN
(
    SELECT cliente_conta FROM conta
)

-- 10
SELECT cliente.nome_cliente, conta.agencia_conta, cliente.cidade_cliente
FROM cliente
JOIN conta ON cliente.cpf = conta.cliente_conta
WHERE cliente.cpf NOT IN
(
    SELECT cliente_tomador FROM tomador
)


-- 11
SELECT agencia.nome_agencia, SUM(conta.saldo) AS total_saldos
FROM agencia JOIN conta ON agencia.id_agencia = conta.agencia_conta
GROUP BY agencia.nome_agencia


-- 12
SELECT agencia.nome_agencia, SUM(emprestimo.quantia) AS total_emprestimos
FROM agencia JOIN emprestimo ON agencia.id_agencia = emprestimo.agencia_emprestimo
GROUP BY agencia.nome_agencia


-- 13
SELECT COUNT(*)
FROM conta


-- 14
SELECT agencia.nome_agencia, COUNT(*)
FROM conta JOIN agencia ON conta.agencia_conta = agencia.id_agencia
GROUP BY agencia.nome_agencia


-- 15
SELECT cidade_cliente, COUNT(*)
FROM cliente
GROUP BY cidade_cliente


-- 16
SELECT nome_agencia, string_agg(nome_cliente, ', ') AS clientes
FROM agencia
FULL OUTER JOIN conta ON agencia.id_agencia = conta.agencia_conta
FULL OUTER JOIN cliente ON conta.cliente_conta = cliente.cpf
GROUP BY nome_agencia
