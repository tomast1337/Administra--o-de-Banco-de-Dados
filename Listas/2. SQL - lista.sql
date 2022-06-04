-- agencia (nome_agencia, cidade_agencia, ativo)
create table if not exists agencia (
    nome_agencia varchar(50),
    cidade_agencia varchar(50),
    ativo boolean,
    primary key (nome_agencia)
);

-- cliente (nome_cliente, rua_cliente, cidade_cliente)
create table if not exists cliente (
    nome_cliente varchar(50),
    rua_cliente varchar(50),
    cidade_cliente varchar(50),
    primary key (nome_cliente)
);

-- conta (numero_conta, nome_agencia, saldo)
create table if not exists conta (
    numero_conta int,
    nome_agencia varchar(50),
    saldo float,
    primary key (numero_conta)
);

-- emprestimo (numero_emprestimo, nome_agencia, quantia)
create table if not exists emprestimo (
    numero_emprestimo int,
    nome_agencia varchar(50),
    quantia float,
    primary key (numero_emprestimo) foreign key (nome_agencia) references agencia(nome_agencia)
);

-- depositante (nome_cliente, numero_conta)
create table if not exists depositante (
    nome_cliente varchar(50),
    numero_conta int,
    primary key (nome_cliente) foreign key (numero_conta) references conta(numero_conta)
);

-- tomador (nome_cliente, numero_emprestimo)
create table if not exists tomador (
    nome_cliente varchar(50),
    numero_emprestimo int,
    primary key (nome_cliente) foreign key (numero_emprestimo) references emprestimo(numero_emprestimo)
);