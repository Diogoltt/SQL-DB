create table usuario (
    idUsuario int not null primary key,
    senha varchar(50),
    nomeUsuario varchar(50),
    ramal int,
    especialidade varchar(50)
)

create table maquina (
	idMaquina int not null,
	tipo varchar(50),
	velocidade int,
    harddisk int,
    placarede int,
    memoriaram int,
	primary key(idMaquina)
)

create table software (
    idSoftware int not null,
    produto varchar(50),
    harddisk int,
    memoriaram int,
    primary key (idSoftware)
)

create table possuem (
    idUsuario int not null,
    idMaquina int not null,
    primary key (idUsuario, idMaquina),
    foreign key (idUsuario) references usuario(idUsuario),
    foreign key (idMaquina) references maquina(idMaquina)
)

create table contem (
    idMaquina int not null,
    idSoftware int not null,
    primary key (idMaquina, idSoftware),
    foreign key (idMaquina) references maquina(idMaquina),
    foreign key (idSoftware) references software(idSoftware)
)

-- Inserindo usuários
INSERT INTO usuario (idUsuario, senha, nomeUsuario, ramal, especialidade) 
VALUES 
(1, 'senha123', 'Carlos Silva', 101, 'Redes'),
(2, 'senha456', 'Mariana Souza', 102, 'Desenvolvimento'),
(3, 'senha789', 'João Pereira', 103, 'Técnico'),
(4, 'senha321', 'Ana Oliveira', 104, 'Banco de Dados'),
(5, 'senha654', 'Roberto Lima', 105, 'Técnico');

-- Inserindo máquinas
INSERT INTO maquina (idMaquina, tipo, velocidade, harddisk, placarede, memoriaram) 
VALUES 
(1, 'Core II', 3200, 500, 1, 16),
(2, 'Pentium', 2800, 256, 1, 8),
(3, 'Core III', 4000, 2000, 2, 32),
(4, 'Core V', 3500, 1000, 1, 16),
(5, 'Dual Core', 1500, 64, 1, 4);

drop table maquina cascade;

-- Inserindo softwares
INSERT INTO software (idSoftware, produto, harddisk, memoriaram) 
VALUES 
(1, 'Windows 10', 20, 4),
(2, 'Ubuntu 22.04', 15, 2),
(3, 'MySQL Server', 50, 8),
(4, 'Visual Studio Code', 1, 1),
(5, 'Docker', 30, 6);

-- Associando usuários às máquinas (possuem)
INSERT INTO possuem (idUsuario, idMaquina) 
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Associando softwares às máquinas (contem)
INSERT INTO contem (idMaquina, idSoftware) 
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- 1. Atributos da tabela usuário com especialidade igual a técnico
select * from usuario where especialidade = 'Técnico';

-- 2. Todas combinações de tipo e velocidade das máquinas
select distinct m.tipo, m.velocidade from maquina m;

-- 3. Tipo e velocidade dos computadores dos tipos Core II e Pentium
select m.tipo, m.velocidade from maquina m where m.tipo = 'Core II' or m.tipo = 'Pentium';

-- 4. Identificação, tipo e taxa de transmissão da placa menor que 10mb
select m.idMaquina, m.tipo, m.placarede from maquina m where placarede < 10;

-- 5. Nomes dos usuários que utilizam computadores do tipo Core III ou core V
select u.nomeUsuario from usuario u
join possuem p on u.idUsuario = p.idUsuario
join maquina m on p.idMaquina = m.idMaquina
where m.tipo = 'Core III' or m.tipo = 'Core V'

-- 6. A identificação das maquinas com Docker instalado
select m.idMaquina from maquina M
join contem c on m.idMaquina = c.idMaquina
join software s on s.idSoftware = c.idSoftware
where s.produto = 'Docker';

-- 7.


-- 8. O nome dos usuários e a velocidade de suas máquinas
select u.nomeUsuario, m.velocidade 
from usuario u
join possuem p on u.idUsuario = p.idUsuario
join maquina m on m.idMaquina = p.idMaquina;

-- 9. Nome e identificação de usuários que tenham ID menor que Ana Oliveira
select u.nomeUsuario, u.idUsuario
from usuario u
where u.idUsuario < (select idUsuario from usuario where nomeUsuario = 'Ana Oliveira');


-- 10. Número de maquinas com velocidade maior que 3000
select count(*)
from maquina m
where m.velocidade > 3000;

-- 11. Número de usuários das máquinas
select count(distinct idUsuario)
from possuem;

-- 12. Número de usuários agrupados por tipo de máquinas
select m.tipo, count(distinct p.idUsuario)
from maquina m
join possuem p on m.idMaquina = p.idMaquina
group by m.tipo;

-- 13. Número de usuários de maquinas do tipo dual core
select count(distinct p.idUsuario)
from maquina m
join possuem p on m.idMaquina = p.idMaquina
where m.tipo = 'Dual Core';

-- 14. Quantidade de disco rígido necessária para instalar 
-- Docker e Visual Studio Code juntos na mesma máquina
select sum(s.harddisk)
from software s
where s.produto in ('Docker', 'Visual Studio Code');

-- 15. Quantidade de disco rígido utlizada em cada máquina
-- para os produtos instalados em cada uma delas
select c.idMaquina, sum(s.harddisk)
from contem c
join software s on c.idSoftware = s.idSoftware
group by c.idMaquina;

-- 16. A quantidade média de disco rígido necessária por produto.
select avg(harddisk)
from software;

-- 17. Número total de máquinas de cada tipo
select tipo, count(idMaquina)
from maquina
group by tipo;

-- 18. Número de produtos cuja instalação consuma entre 20 e 50 de disco rígido
select count(*)
from software
where software.harddisk >= 20 and software.harddisk <= 50;

-- 19. Identificação e respectivo produto, cujo nome tenha a letra O em sua composição
select s.idSoftware, s.produto
from software s
where s.produto like '%o%';

-- 20. O produto e a capacidade do disco rígido para máquinas com capacidade de instação
-- de qualquer produto invidualmente
select maquina.idMaquina, maquina.harddisk
from maquina
where harddisk > all(select harddisk from software);


-- 21. A relação dos produtos instalados em pelo menos uma máquina