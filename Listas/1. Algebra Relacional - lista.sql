-- Criar tabela Fornecedores
use `tests`;
create table if not exists `Fornecedores` (
    `fid` int not null,
    `fnome` varchar(25),
    `end` varchar(50),
    primary key(fid)
);
-- Criar tabela Peças
create table if not exists `Pecas`(
    `pid` int not null,
    `pnome` varchar(50),
    `cor` varchar(50),
    primary key(pid)
);
-- Criar tabela de Catalogo
create table if not exists `Catalogo`(
    `fid` int,
    `pid` int,
    `preco` decimal,
    foreign key (`fid`) references `Fornecedores`(`fid`),
    foreign key (`pid`) references `Pecas`(`pid`)
);
-- Pupular tabela Fornecedores
insert into `Fornecedores`
values (1, 'Fornecedor 1', 'Rua 1'),
    (2, 'Fornecedor 2', 'Rua 2'),
    (3, 'Fornecedor 3', 'Rua 3'),
    (4, 'Fornecedor 4', 'Rua 4'),
    (5, 'Fornecedor 5', 'Rua 5'),
    (6, 'Fornecedor 6', 'Rua 6'),
    (7, 'Fornecedor 7', 'Rua 7'),
    (8, 'Fornecedor 8', 'Rua 8'),
    (9, 'Fornecedor 9', 'Rua 9'),
    (10, 'Fornecedor 10', 'Rua 10'),
    (11, 'Sempre Alerta', 'Rua 10');
-- Pupular tabela Pecas
insert into `Pecas`
values (1, 'Peça 1', 'vermelho'),
    (2, 'Peça 2', 'verde'),
    (3, 'Peça 3', 'azul'),
    (4, 'Peça 4', 'amarelo'),
    (5, 'Peça 5', 'preto'),
    (6, 'Peça 6', 'vermelho'),
    (7, 'Peça 7', 'verde'),
    (8, 'Peça 8', 'azul'),
    (9, 'Peça 9', 'amarelo'),
    (10, 'Peça 10', 'preto');
-- Pupular tabela Catalogo
insert into `Catalogo`
values (1, 1, 10.31413),
    (1, 2, 20.31413),
    (1, 3, 30.31413),
    (1, 4, 40.31413),
    (1, 5, 50.31413),
    (1, 6, 60.31413),
    (1, 7, 70.31413),
    (1, 8, 80.31413),
    (1, 9, 90.31413),
    (1, 10, 100.31413),
    (2, 1, 20.31413),
    (2, 2, 30.31413),
    (2, 9, 100.31413),
    (2, 10, 110.31413),
    (3, 1, 30.31413),
    (3, 2, 40.31413),
    (3, 3, 50.31413),
    (3, 4, 60.31413),
    (3, 5, 70.31413),
    (3, 6, 80.31413),
    (3, 7, 90.31413),
    (3, 8, 100.31413),
    (3, 9, 110.31413),
    (3, 10, 120.31413),
    (4, 1, 40.31413),
    (4, 2, 50.31413),
    (4, 3, 60.31413),
    (4, 4, 70.31413),
    (4, 5, 80.31413),
    (4, 6, 90.31413),
    (5, 6, 100.31413),
    (5, 7, 110.31413),
    (5, 8, 120.31413),
    (5, 9, 130.31413),
    (5, 10, 140.31413),
    (6, 1, 60.31413),
    (6, 2, 70.31413),
    (6, 3, 80.31413),
    (6, 4, 90.31413),
    (6, 5, 100.31413),
    (6, 7, 120.31413),
    (6, 8, 130.31413),
    (6, 9, 140.31413),
    (6, 10, 150.31413),
    (7, 1, 70.31413),
    (7, 2, 80.31413);
-- ### Exercício #1. Obtenha o nome dos fornecedores que fornecem alguma peça vermelha.
select distinct `fnome`
from `Fornecedores`
    join `Catalogo` on `Catalogo`.`fid` = `Fornecedores`.`fid`
    join `Pecas` on `Catalogo`.`pid` = `Pecas`.`pid`
where `Pecas`.`cor` = 'vermelho';
-- ### Exercício #3. Obtenha o fid dos fornecedores que fornecem alguma peça vermelha ou que custe 150.
select distinct `Fornecedores`.`fid`
from `Fornecedores`
    join `Catalogo` on `Catalogo`.`fid` = `Fornecedores`.`fid`
    join `Pecas` on `Catalogo`.`pid` = `Pecas`.`pid`
where `Pecas`.`cor` = 'vermelho'
    or `Catalogo`.`preco` = 150;
-- ### Exercício #4. Obtenha o fid dos fornecedores que fornecem alguma peça vermelha e alguma peça verde
select distinct `Fornecedores`.`fid`
from `Fornecedores`
    join `Catalogo` on `Catalogo`.`fid` = `Fornecedores`.`fid`
    join `Pecas` on `Catalogo`.`pid` = `Pecas`.`pid`
where `Pecas`.`cor` = 'vermelho'
    or `Pecas`.`cor` = 'verde';
-- ### Exercício #5. Obtenha o nome dos fornecedores que fornecem alguma peça vermelha que tenha preço abaixo de 100.
select `fnome`
from `Fornecedores`
    join `Catalogo` on `Catalogo`.`fid` = `Fornecedores`.`fid`
    join `Pecas` on `Catalogo`.`pid` = `Pecas`.`pid`
where `Pecas`.`cor` = 'vermelho'
    and `Catalogo`.`preco` < 100;
-- ### Exercício #6. Obtenha o nome das peças que possuem algum fornecedor.
select distinct `pnome`
from `Pecas`
    join `Catalogo` on `Catalogo`.`pid` = `Pecas`.`pid`
    join `Fornecedores` on `Catalogo`.`fid` = `Fornecedores`.`fid`;
-- ### Exercício #7. Obtenha o nome dos fornecedores que fornecem todas as peças.
select `fnome`
from `Fornecedores`
    join `Catalogo` on `Catalogo`.`fid` = `Fornecedores`.`fid`
    join `Pecas` on `Catalogo`.`pid` = `Pecas`.`pid`
where `Catalogo`.`pid` not in (
        select `Catalogo`.`pid`
        from `Catalogo`
            join `Pecas` on `Catalogo`.`pid` = `Pecas`.`pid`
    );
-- ### Exercício #8. Obtenha o nome das peças que são fornecidas pelo fornecedor "Sempre Alerta" e não são fornecidas por nenhum outro fornecedor.
select `pnome`
from (
        select `Fornecedores`.`fid`
        from `Fornecedores`
            left join `Catalogo` on `Catalogo`.`fid` = `Fornecedores`.`fid`
        where `Fornecedores`.`fnome` = 'Sempre Alerta'
    ) as `SempreAlerta`
    left join `Catalogo` on `Catalogo`.`fid` = `SempreAlerta`.`fid`
    left join `Pecas` on `Catalogo`.`pid` = `Pecas`.`pid`;