-- Criar tabela Fornecedores

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

-- ### Exercício #1. Obtenha o nome dos fornecedores que fornecem alguma peça vermelha.

select `fnome`
from `Fornecedores`
join `Catalogo` on `Catalogo`.`fid` = `Fornecedores`.`fid`
join `Pecas` on `Catalogo`.`pid` = `Pecas`.`pid`
where `Pecas`.`cor` = 'vermelho';

-- ### Exercício #3. Obtenha o fid dos fornecedores que fornecem alguma peça vermelha ou que custe 150.

SELECT `fid`
FROM `Fornecedores`
JOIN `Catalogo` ON `Catalogo`.`fid` = `Fornecedores`.`fid`
JOIN `Pecas` ON `Catalogo`.`pid` = `Pecas`.`pid`
WHERE `Pecas`.`cor` = 'vermelho' OR `Catalogo`.`preco` = 150;

-- ### Exercício #4. Obtenha o fid dos fornecedores que fornecem alguma peça vermelha e alguma peça verde

SELECT `fid`
FROM `Fornecedores`
JOIN `Catalogo` ON `Catalogo`.`fid` = `Fornecedores`.`fid`
JOIN `Pecas` ON `Catalogo`.`pid` = `Pecas`.`pid`
WHERE `Pecas`.`cor` = 'vermelho' AND `Pecas`.`cor` = 'verde';

-- ### Exercício #5. Obtenha o nome dos fornecedores que fornecem alguma peça vermelha que tenha preço abaixo de 100.

SELECT `fnome`
FROM `Fornecedores`
JOIN `Catalogo` ON `Catalogo`.`fid` = `Fornecedores`.`fid`
JOIN `Pecas` ON `Catalogo`.`pid` = `Pecas`.`pid`
WHERE `Pecas`.`cor` = 'vermelho' AND `Catalogo`.`preco` < 100;

-- ### Exercício #6. Obtenha o nome das peças que possuem algum fornecedor.

SELECT `pnome`
FROM `Pecas`
JOIN `Catalogo` ON `Catalogo`.`pid` = `Pecas`.`pid`
JOIN `Fornecedores` ON `Catalogo`.`fid` = `Fornecedores`.`fid`
WHERE `Catalogo`.`fid` IS NOT NULL;

-- ### Exercício #7. Obtenha o nome dos fornecedores que fornecem todas as peças.

SELect `fnome`
FROM `Fornecedores`
JOIN `Catalogo` ON `Catalogo`.`fid` = `Fornecedores`.`fid`
JOIN `Pecas` ON `Catalogo`.`pid` = `Pecas`.`pid`
WHERE `Catalogo`.`fid` IS NOT NULL;


-- ### Exercício #8. Obtenha o nome das peças que são fornecidas pelo fornecedor "Sempre Alerta" e não são fornecidas por nenhum outro fornecedor.

SELECT `pnome`
FROM `Pecas`
JOIN `Catalogo` ON `Catalogo`.`pid` = `Pecas`.`pid`
JOIN `Fornecedores` ON `Catalogo`.`fid` = `Fornecedores`.`fid`
WHERE `Catalogo`.`fid` = 1 AND `Catalogo`.`fid` is not null;

