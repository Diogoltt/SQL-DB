create table pessoa (
    cpf varchar(14) primary key,
    nome varchar(80)
);

create table engenheiro (
    cpf varchar(14) primary key,
    crea int,
    foreign key (cpf) references pessoa(cpf) on delete cascade
);

create table unidadeResidencial (
    idUnidadeResidencial int primary key,
    metragemUnidade int,
    quartos int,
    banheiros int,
    proprietariocpf varchar(14),
    foreign key (proprietariocpf) references pessoa(cpf)
);

create table edificacao (
    idEdificacao int primary key,
    metragemTotal int,
    endereco varchar(200),
    proprietariocpf varchar(80),
    foreign key (proprietariocpf) references pessoa(cpf)
);

create table predio (
    idPredio int primary key,
    nome varchar(80),
    andares int,
    apPorAndar int,
    foreign key (idPredio) references edificacao(idEdificacao)
);

create table casa (
    idCasa int primary key,
    condominio boolean,
    foreign key (idCasa) references edificacao(idEdificacao)
);

create table casaTerrea (
    idCasaTerrea int primary key,
    foreign key (idCasaTerrea) references casa(idCasa)
);

create table casaSobrado (
    idCasaSobrado int primary key,
    andares int,
    foreign key (idCasaSobrado) references casa(idCasa)
);

--------------- Inserts ---------------

-- Inserir dados na tabela pessoa
INSERT INTO pessoa (cpf, nome) VALUES
('123.456.789-00', 'João Silva'),
('234.567.890-11', 'Maria Oliveira'),
('345.678.901-22', 'Carlos Souza'),
('456.789.012-33', 'Ana Costa');

-- Inserir dados na tabela engenheiro
INSERT INTO engenheiro (cpf, crea) VALUES
('123.456.789-00', 12345),
('234.567.890-11', 67890);

-- Inserir dados na tabela unidadeResidencial
INSERT INTO unidadeResidencial (idUnidadeResidencial, metragemUnidade, quartos, banheiros, proprietariocpf) VALUES
(1, 80, 3, 2, '123.456.789-00'),
(2, 120, 4, 3, '234.567.890-11'),
(3, 65, 2, 1, '345.678.901-22');

-- Inserir dados na tabela edificacao
INSERT INTO edificacao (idEdificacao, metragemTotal, endereco, proprietariocpf) VALUES
(1, 500, 'Rua A, 100', '123.456.789-00'),
(2, 800, 'Rua B, 200', '234.567.890-11');

-- Inserir dados na tabela predio
INSERT INTO predio (idPredio, nome, andares, apPorAndar) VALUES
(1, 'Edifício Alfa', 10, 4),
(2, 'Edifício Beta', 15, 3);

-- Inserir dados na tabela casa
INSERT INTO casa (idCasa, condominio) VALUES
(1, true),
(2, false);

-- Inserir dados na tabela casaTerrea
INSERT INTO casaTerrea (idCasaTerrea) VALUES
(1);

-- Inserir dados na tabela casaSobrado
INSERT INTO casaSobrado (idCasaSobrado, andares) VALUES
(2, 2);

-------------- Selects --------------

-- 1. Listar todas as unidades residenciais com seus proprietários e endereços
select pessoa.nome as proprietario, ed.endereco
from pessoa
join unidaderesidencial ur on ur.proprietariocpf = pessoa.cpf
join edificacao ed on ed.proprietariocpf = pessoa.cpf

-- 2. Listar todas as unidades residenciais com seus proprietários e endereços,
-- ordenando por metragem da unidade
select pessoa.nome as proprietario, ed.endereco, ur.metragemunidade
from pessoa
join unidaderesidencial ur on ur.proprietariocpf = pessoa.cpf
join edificacao ed on ed.proprietariocpf = pessoa.cpf
order by ur.metragemunidade