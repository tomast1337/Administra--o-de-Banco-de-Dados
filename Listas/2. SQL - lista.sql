drop database if exists lista2;
create database if not exists `lista2`;
use `lista2`;
-- 1. estude a script de criação das tabelas
-- agencia (nome_agencia, cidade_agencia, ativo)
create table if not exists agencia (
    id int not null,
    nome varchar(30),
    cidade varchar(30),
    ativo float,
    primary key (id)
);
-- cliente (nome_cliente, rua_cliente, cidade_cliente)
create table if not exists cliente (
    cpf char(11) not null,
    nome varchar(30),
    rua varchar(30),
    cidade varchar(30),
    primary key (cpf)
);
-- conta (numero_conta, nome_agencia, saldo)
create table if not exists conta (
    id int not null,
    id_agencia int,
    cpf_cliente char(11),
    saldo float,
    primary key (id),
    foreign key (id_agencia) references agencia (id),
    foreign key (cpf_cliente) references cliente (cpf)
);
-- emprestimo (numero_emprestimo, nome_agencia, quantia)
create table if not exists emprestimo (
    id int not null,
    id_agencia int,
    cpf_cliente char(11),
    valor float,
    primary key (id),
    foreign key (id_agencia) references agencia (id),
    foreign key (cpf_cliente) references cliente (cpf)
);
-- depositante (nome_cliente, numero_conta)
create table if not exists depositante (
    id int not null,
    cpf_cliente char(11),
    conta_destino int,
    valor float,
    primary key (id),
    foreign key (cpf_cliente) references cliente (cpf),
    foreign key (conta_destino) references conta (id)
);
-- tomador (nome_cliente, numero_emprestimo)
create table if not exists tomador (
    emprestimo_tomador int,
    cpf_cliente char(11),
    valor float,
    primary key (emprestimo_tomador),
    foreign key (emprestimo_tomador) references emprestimo (id),
    foreign key (cpf_cliente) references cliente (cpf)
);
-- popular banco de dados
insert into agencia
values (101, 'agencia rosália', 'rio', 300000),
    (102, 'agencia postinho', 'sao paulo', 67000000),
    (
        103,
        'agencia laranjeiras',
        'rio de janeiro',
        90000
    ),
    (104, 'agencia centro', 'sao paulo', 8000000),
    (105, 'agencia ibirapuera', 'sao paulo', 200000),
    (
        106,
        'agencia afonsos',
        'rio de janeiro',
        1000000
    ),
    (107, 'agencia ontario', 'sergipe', 5400000),
    (108, 'agencia noguetal', 'porto alegre', 2000000);
insert into cliente (cpf, nome, cidade, rua)
values (
        '11753559766',
        'norberto souza',
        'rio de janeiro',
        'rua a'
    ),
    (
        '12563258433',
        'paulo silva',
        'sao paulo',
        'rua 24'
    ),
    (
        '45886541255',
        'rogerio colosso',
        'rio de janeiro',
        'avenida cruz divina'
    ),
    (
        '59655584532',
        'antonio lima',
        'sao paulo',
        'alameda trancoso'
    ),
    (
        '55698545211',
        'mauricio santa cruz',
        'sao paulo',
        'rua k'
    ),
    (
        '52698547895',
        'lorena ribas',
        'porto alegre',
        'av da serra'
    ),
    (
        '12365985421',
        'serigo da costa',
        'sao paulo',
        'rua proferrso tito'
    ),
    (
        '11263654847',
        'felipe porto',
        'porto alegre',
        'rua oliverio'
    ),
    (
        '58655214512',
        'norberto cardoso',
        'sergipe',
        'rua a'
    ),
    (
        '14523365871',
        'oswaldo silva',
        'sao paulo',
        'rua 24'
    ),
    (
        '57455374371',
        'sandra colosso',
        'rio de janeiro',
        'avenida cruz divina'
    ),
    (
        '37856374532',
        'maria lima',
        'sao paulo',
        'alameda trancoso'
    ),
    (
        '76378657885',
        'catarina santa cruz',
        'sao paulo',
        'rua k'
    ),
    (
        '65738537886',
        'robson ribas',
        'sergipe',
        'av da serra'
    ),
    (
        '34537837838',
        'serigo da silva',
        'sao paulo',
        'rua proferrso tito'
    ),
    (
        '56796537558',
        'felipe beto',
        'porto alegre',
        'rua oliverio'
    );
insert into conta
values (1, 101, '52698547895', 2000),
    (2, 102, '12365985421', 25412),
    (3, 105, '12563258433', 1235),
    (4, 101, '45886541255', 546),
    (5, 106, '12563258433', 123),
    (6, 108, '11753559766', 52),
    (7, 103, '65738537886', 556),
    (8, 107, '58655214512', 534),
    (9, 102, '52698547895', 644523),
    (10, 102, '59655584532', 58451),
    (11, 108, '55698545211', 125455),
    (12, 103, '45886541255', 12354),
    (13, 101, '45886541255', 12345),
    (14, 107, '65738537886', 114525),
    (15, 106, '55698545211', 124274),
    (16, 105, '76378657885', 3353456);
insert into depositante
values (1, '52698547895', 3, 1541),
    (2, '55698545211', 5, 365),
    (3, '45886541255', 4, 444),
    (4, '52698547895', 8, 106659),
    (5, '45886541255', 3, 10000),
    (6, '11753559766', 16, 56),
    (7, '45886541255', 14, 448),
    (8, '45886541255', 15, 30),
    (9, '76378657885', 5, 6698),
    (10, '11753559766', 13, 2000),
    (11, '76378657885', 12, 2500),
    (12, '12563258433', 5, 300),
    (13, '12563258433', 8, 4000),
    (14, '11753559766', 14, 1566000),
    (15, '12563258433', 15, 2352),
    (16, '11753559766', 2, 12);
insert into emprestimo
values (1, 102, '52698547895', 41452),
    (2, 106, '45886541255', 222),
    (3, 108, '12563258433', 33155),
    (4, 101, '45886541255', 123),
    (5, 104, '12563258433', 55234),
    (6, 106, '45886541255', 2345342),
    (7, 107, '65738537886', 2221),
    (8, 105, '58655214512', 3023),
    (9, 102, '52698547895', 662198),
    (10, 101, '59655584532', 123),
    (11, 103, '58655214512', 55),
    (12, 101, '45886541255', 21345),
    (13, 105, '58655214512', 215),
    (14, 106, '65738537886', 22225453),
    (15, 105, '58655214512', 221522),
    (16, 101, '76378657885', 2123453);
insert into tomador
values (1, '11753559766', 13),
    (2, '12563258433', 13),
    (3, '45886541255', 13),
    (4, '59655584532', 13),
    (5, '55698545211', 13),
    (6, '52698547895', 13),
    (7, '12365985421', 13),
    (8, '11263654847', 13),
    (9, '58655214512', 13),
    (10, '14523365871', 13),
    (11, '57455374371', 13),
    (12, '37856374532', 13),
    (13, '76378657885', 13),
    (14, '65738537886', 13),
    (15, '34537837838', 13),
    (16, '56796537558', 13);
-- 2. selecione o nome dos clientes que moram na cidade rio
select nome
from cliente
where cidade like 'rio%';
-- 3. selecione o nome e suas cidades ordenados por cidade e nome
select nome,
    cidade
from cliente
order by cidade,
    nome;
-- 4. selecione o nome dos clientes que tenham a no nome
select nome
from cliente
where nome like '%a%';
-- 5. selecione o nome dos clientes que começam com a
select nome
from cliente
where nome like 'a%';
-- 6. selecione o nome do cliente e da agencia e saldo dos clientes que tenham conta
select cliente.nome,
    agencia.nome,
    conta.saldo
from cliente,
    agencia,
    conta
where cliente.cpf = conta.cpf_cliente
    and agencia.id = conta.id_agencia;
-- ou
select cliente.nome,
    agencia.nome,
    conta.saldo
from cliente
    join conta on cliente.cpf = conta.cpf_cliente
    join agencia on agencia.id = conta.id_agencia;
-- 7. selecione o nome do cliente e o total de empréstimos de cada um deles
select cliente.nome,
    count(emprestimo.id) as Total
from cliente,
    emprestimo
where cliente.cpf = emprestimo.cpf_cliente
group by cliente.nome;
-- ou
select cliente.nome,
    count(emprestimo.id) as Total
from cliente
    join emprestimo on cliente.cpf = emprestimo.cpf_cliente
group by cliente.nome;
-- 8. selecione o nome do cliente que tenham conta e também tenham feito empréstimo
select distinct cliente.nome
from cliente,
    emprestimo
where cliente.cpf = emprestimo.cpf_cliente;
-- ou
select cliente.nome
from cliente
    join emprestimo on cliente.cpf = emprestimo.cpf_cliente;
-- 9. selecione o nome do cliente, agencia e cidade dos clientes que tenham empréstimo e não tenham conta
select cliente.nome,
    agencia.nome,
    cliente.cidade
from cliente,
    agencia,
    conta,
    emprestimo
where cliente.cpf = conta.cpf_cliente
    and agencia.id = conta.id_agencia
    and cliente.cpf = emprestimo.cpf_cliente
    and cliente.cpf not in (
        select cpf_cliente
        from conta
    );
-- ERRADO ?
--ou
select cliente.nome,
    agencia.nome,
    cliente.cidade
from cliente
    join conta on cliente.cpf = conta.cpf_cliente
    join agencia on agencia.id = conta.id_agencia
    join emprestimo on cliente.cpf = emprestimo.cpf_cliente
where cliente.cpf not in (
        select cpf_cliente
        from conta
    );
-- 10. selecione o nome do cliente, agencia e cidade dos clientes que tenham conta e não tenham empréstimo
select cliente.nome,
    agencia.nome,
    cliente.cidade
from cliente,
    agencia,
    conta
where cliente.cpf = conta.cpf_cliente
    and agencia.id = conta.id_agencia
    and cliente.cpf not in (
        select cpf_cliente
        from conta
    );
-- ou
select cliente.nome,
    agencia.nome,
    cliente.cidade
from cliente
    join conta on cliente.cpf = conta.cpf_cliente
    join agencia on agencia.id = conta.id_agencia
where cliente.cpf not in (
        select cpf_cliente
        from conta
    );
-- 11. selecione o total das contas por agencia
select agencia.nome,
    count(conta.saldo) as total
from agencia,
    conta
where agencia.id = conta.id_agencia
group by agencia.nome;
-- ou
select agencia.nome,
    count(conta.saldo) as total
from agencia
    join conta on agencia.id = conta.id_agencia
group by agencia.nome;
-- 12. selecione o total de empréstimos por agencia
select agencia.nome,
    count(emprestimo.id) as total_emprestimos
from agencia,
    emprestimo
where agencia.id = emprestimo.id_agencia
group by agencia.nome;
-- ou 
select agencia.nome,
    count(emprestimo.id) as total_emprestimos
from agencia
    join emprestimo on agencia.id = emprestimo.id_agencia
group by agencia.nome;
-- 13. selecione a quantidade contas
select count(conta.id) as `quantidade contas`
from conta;
-- 14. selecione a quantidade contas por agencia
select agencia.nome,
    count(conta.id) as `Quantidade Contas`
from agencia,
    conta
where agencia.id = conta.id_agencia
group by agencia.nome;
-- ou
select agencia.nome,
    count(conta.id) as `Quantidade Contas`
from agencia
    join conta on agencia.id = conta.id_agencia
group by agencia.nome;
-- 15. selecione a quantidade de clientes por cidade
select cidade,
    count(cliente.cpf) as total_clientes
from cliente
group by cidade;
-- 16. selecione todas as agencias e seus respectivos clientes
select agencia.nome,
    cliente.nome
from agencia,
    cliente,
    conta
where agencia.id = conta.id_agencia
    and conta.cpf_cliente = cliente.cpf;
-- ou
select agencia.nome,
    cliente.nome
from agencia
    join conta on agencia.id = conta.id_agencia
    join cliente on conta.cpf_cliente = cliente.cpf;
-- ou
select agencia.nome,
    group_concat(cliente.nome, ',') as clientes
from agencia
    join conta on agencia.id = conta.id_agencia
    join cliente on conta.cpf_cliente = cliente.cpf
group by agencia.nome;
-- ou errado
select tablela.nome group_concat(tabela.nome, ',') as clientes (
        select agencia.nome,
            cliente.nome
        from agencia
            left join conta on agencia.id = conta.id_agencia
            left join cliente on conta.cpf_cliente = cliente.cpf
    )
union
(
    select agencia.nome,
        cliente.nome
    from agencia
        right join conta on agencia.id = conta.id_agencia
        right join cliente on conta.cpf_cliente = cliente.cpf
) as tabela
group by tabela.nome;
----------------------------------------------------------------------------------------------------------------------------------------------------------------

drop database if exists `locadora`;
create database if not exists `locadora`;
use `locadora`;

-- Locadora (CodLoc,NomeLoc, UF)
create table `Locadora` (
    `CodLoc` int not null auto_increment,
    `NomeLoc` varchar(50) not null,
    `UF` varchar(2) not null,
    primary key (`CodLoc`)
);

-- Genero(CodGen, Nome)
create table `Genero` (
    `CodGen` int not null auto_increment,
    `Nome` varchar(50) not null,
    primary key (`CodGen`)
);
-- Usuario (CodUsu,NomeUsu, CodLoc)
create table `Usuario`(
    `CodUsu` int not null auto_increment,
    `NomeUsu` varchar(50) not null,
    `CodLoc` int not null,
    primary key (`CodUsu`),
    foreign key (CodLoc) references Locadora(CodLoc)
);

-- Filme (CodFilme,Titulo,Ano, CodGen, CodLoc) 
create table `Filme`(
    `CodFilme` int not null auto_increment,
    `Titulo` varchar(50) not null,
    `Ano` int not null,
    `CodGen` int not null,
    `CodLoc` int not null,
    primary key (`CodFilme`),
    foreign key (CodGen) references Genero(CodGen),
    foreign key (CodLoc) references Locadora(CodLoc)
);

-- Emprestimo (CodFilme,CodUsu,DataEmprestada, Vencimento, DataDevol)
create table `Emprestimo`(
    `CodFilme` int not null,
    `CodUsu` int not null,
    `DataEmprestada` date not null,
    `Vencimento` date not null,
    `DataDevol` date,
    primary key (`CodFilme`),
    foreign key (CodFilme) references Filme(CodFilme),
    foreign key (CodUsu) references Usuario(CodUsu)
);

--- População Base de Dados



-- 18. Obtenha as locadoras da UF = RJ

select *
from locadora
where UF = 'RJ';

-- 19. Obtenha os usuários da locadora ‘Divertida’. 

select `NomeUsu`
from usuario
where CodLoc = (
    select CodLoc
    from locadora
    where NomeLoc = 'Divertida'
);

select `NomeUsu`
from usuario
join locadora on usuario.CodLoc = locadora.CodLoc
where locadora.NomeLoc = 'Divertida';

-- 20.  obtenha  os  filmes assistidos pelo usuário ‘Cinéfilo’. 

select `Titulo`
from filme
join emprestimo on filme.CodFilme = emprestimo.CodFilme
join usuario on emprestimo.CodUsu = usuario.CodUsu
where NomeUsu = 'Cinéfilo';

-- 21.  apresente os filmes ainda não devolvidos pelo usuário ‘Cinéfilo’. 

select `Titulo`
from filme
join emprestimo on filme.CodFilme = emprestimo.CodFilme
join usuario on emprestimo.CodUsu = usuario.CodUsu
where NomeUsu = 'Cinéfilo'
and DataEmprestada is null; -- Errado

-- 22. apresente os filmes devolvidos com atraso pelo usuário ‘Cinéfilo’. 

select `Titulo`
from filme
join emprestimo on filme.CodFilme = emprestimo.CodFilme
join usuario on emprestimo.CodUsu = usuario.CodUsu
where NomeUsu = 'Cinéfilo'
and DataDevol is not null

-- 23. quantidade de vezes que o filme ‘Harry Potter e as Relíquias da Morte - Parte 2’ foi assistido. 

select count(*) as `Quantidade de vezes que Harry Potter e as Relíquias da Morte - Parte 2 foi assistido`
from filme
join emprestimo on filme.CodFilme = emprestimo.CodFilme
join usuario on emprestimo.CodUsu = usuario.CodUsu
where Titulo = 'Harry Potter e as Relíquias da Morte - Parte 2';

-- 24. apresente a quantidade filmes por gênero na locadora ‘Divertida’.

select `Genero`.`Nome` as `Gênero`, count(*) as `Quantidade de filmes`
from `Genero`
join `Filme` on `Genero`.`CodGen` = `Filme`.`CodGen`
join `Locadora` on `Filme`.`CodLoc` = `Locadora`.`CodLoc`
where `Locadora`.`NomeLoc` = 'Divertida'
group by `Genero`.`Nome`;

-- 25.  filmes  disponíveis para empréstimo na locadora ‘Divertida’

select `Titulo`
from `Filme`
join `Locadora` on `Filme`.`CodLoc` = `Locadora`.`CodLoc`
where `Locadora`.`NomeLoc` = 'Divertida'
join `Emprestimo` on `Filme`.`CodFilme` = `Emprestimo`.`CodFilme`
where `Emprestimo`.`CodUsu` is null;