create table funcionario (
    idfuncionario int,
    nome varchar(45),
    carteiraTrabalho int,
    dataContratacao date,
    salario float,
    primary key (idfuncionario)
)

create table funcao (
    idfuncao int,
    nome varchar(45),
    primary key (idfuncao)
)

create table horario (
    idhorario int,
    horario time,
    primary key (idhorario)
)

create table horario_trabalho_funcionario (
    idfuncionario int,
    idfuncao int,
    idhorario int,
    primary key (idfuncionario, idfuncao, idhorario),
    foreign key (idfuncionario) references funcionario(idfuncionario),
    foreign key (idfuncao) references funcao(idfuncao),
    foreign key (idhorario) references horario(idhorario)
)

create table filme (
    idfilme int,
    nomeBR varchar(45),
    nomeEN varchar(45),
    anoLancamento int,
    diretor_idDiretor int,
    sinopse text,
    genero_idgenero int,
    primary key (idfilme, diretor_idDiretor, genero_idgenero),
    foreign key (diretor_idDiretor) references diretor(idDiretor),
    foreign key (genero_idgenero) references genero(idgenero)
)

ALTER TABLE filme DROP CONSTRAINT filme_diretor_idDiretor_fkey;
ALTER TABLE filme DROP CONSTRAINT filme_genero_idgenero_fkey;

ALTER TABLE filme DROP CONSTRAINT filme_pkey;

ALTER TABLE filme ADD PRIMARY KEY (idfilme);

ALTER TABLE filme ADD CONSTRAINT fk_filme_diretor FOREIGN KEY (diretor_idDiretor) REFERENCES diretor(idDiretor);
ALTER TABLE filme ADD CONSTRAINT fk_filme_genero FOREIGN KEY (genero_idgenero) REFERENCES genero(idgenero);


create table diretor (
    idDiretor int,
    nome varchar(45),
    primary key (idDiretor)
)

create table genero (
    idgenero int,
    nome varchar(45),
    primary key (idgenero)
)

create table premiacao (
    idpremiacao int,
    nome varchar(45),
    ano int,
    primary key (idpremiacao)
)

create table filme_has_premiacao (
    filme_idfilme int,
    premiacao_idpremiacao int,
    ganhou boolean,
    primary key (filme_idfilme, premiacao_idpremiacao),
    foreign key (filme_idfilme) references filme(idfilme),
    foreign key (premiacao_idpremiacao) references premiacao(idpremiacao)
)

create table sala (
    idSala int,
    nome varchar(45),
    capacidade int,
    primary key (idSala)
)

create table filme_exibido_sala (
    filme_idfilme int,
    sala_idSala int,
    horario_idhorario int,
    primary key (filme_idfilme, sala_idSala, horario_idhorario),
    foreign key (filme_idfilme) references filme(idfilme),
    foreign key (sala_idSala) references sala(idSala),
    foreign key (horario_idhorario) references horario(idhorario)
)

--------------------- Inserts ---------------------

INSERT INTO funcionario (idfuncionario, nome, carteiraTrabalho, dataContratacao, salario)
VALUES 
(1, 'João Silva', 123456, '2020-01-15', 3000.00),
(2, 'Maria Oliveira', 654321, '2019-05-20', 3500.00),
(3, 'Carlos Santos', 789012, '2021-03-10', 2800.00),
(4, 'Ana Costa', 345678, '2018-09-25', 4000.00),
(5, 'Pedro Lima', 901234, '2022-07-01', 3200.00);

INSERT INTO funcao (idfuncao, nome)
VALUES 
(1, 'Gerente'),
(2, 'Atendente'),
(3, 'Caixa'),
(4, 'Segurança'),
(5, 'Limpeza');

INSERT INTO horario (idhorario, horario)
VALUES 
(1, '08:00:00'),
(2, '12:00:00'),
(3, '16:00:00'),
(4, '20:00:00'),
(5, '22:00:00');

INSERT INTO horario_trabalho_funcionario (idfuncionario, idfuncao, idhorario)
VALUES 
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

INSERT INTO diretor (idDiretor, nome)
VALUES 
(1, 'Steven Spielberg'),
(2, 'Christopher Nolan'),
(3, 'Martin Scorsese'),
(4, 'Quentin Tarantino'),
(5, 'Greta Gerwig');

INSERT INTO genero (idgenero, nome)
VALUES 
(1, 'Ação'),
(2, 'Drama'),
(3, 'Comédia'),
(4, 'Terror'),
(5, 'Ficção Científica');

INSERT INTO filme (idfilme, nomeBR, nomeEN, anoLancamento, diretor_idDiretor, sinopse, genero_idgenero)
VALUES 
(1, 'O Resgate', 'The Rescue', 2020, 1, 'Um grupo de pessoas tenta sobreviver.', 1),
(2, 'A Origem', 'Inception', 2010, 2, 'Um ladrão invade sonhos para roubar segredos.', 5),
(3, 'O Lobo de Wall Street', 'The Wolf of Wall Street', 2013, 3, 'A história de um corretor de ações.', 2),
(4, 'Pulp Fiction', 'Pulp Fiction' ,1994 ,4,'Enredos conectados de crime!', 3)


-- Inserindo salas
INSERT INTO sala (idSala, nome, capacidade)
VALUES 
(1, 'Sala IMAX', 200),
(2, 'Sala 3D', 150),
(3, 'Sala VIP', 100),
(4, 'Sala Tradicional', 120),
(5, 'Sala Premium', 180);

-- Associando filmes a salas e horários
INSERT INTO filme_exibido_sala (filme_idfilme, sala_idSala, horario_idhorario)
VALUES 
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4);

--------------------- Selects ---------------------

-- 1. Retornar a média dos salários dos funcionários
select avg(salario) from funcionario;

-- 2. Listar os funcionários e suas funções, incluindo aqueles sem função definida.
SELECT f.nome AS funcionario, coalesce(func.nome, 'Sem Função') AS func
FROM funcionario f
LEFT JOIN horario_trabalho_funcionario htf ON f.idfuncionario = htf.idfuncionario
LEFT JOIN funcao func ON htf.idfuncao = func.idfuncao;

-- 3. Retornar o nome de todos os funcionários que possuem o mesmo horário de trabalho que algum outro funcionario
select distinct f1.nome from funcionario f1
join horario_trabalho_funcionario htf1 on f1.idfuncionario = htf1.idfuncionario
join horario h1 on htf1.idhorario = h1.idhorario
where exists (
    select 1
    from funcionario f2
    join horario_trabalho_funcionario htf2 on f2.idfuncionario = htf2.idfuncionario
    join horario h2 on htf2.idhorario = h2.idhorario
    where f1.idfuncionario <> f2.idfuncionario and h1.idhorario = h2.idhorario
);

-- 4. Encontrar filmes que foram exibidos em pelo menos duas salas diferentes
SELECT f.nomeBR 
FROM filme f
JOIN filme_exibido_sala fes1 ON f.idfilme = fes1.filme_idfilme
GROUP BY f.idfilme, f.nomeBR
HAVING COUNT(DISTINCT fes1.sala_idSala) >= 2;

-- 5. Listar os filmes e seus respectivos gêneros, garantindo que não haja duplicatas.
select distinct f.nomeBR, g.nome as genero
from filme f
join genero g on f.genero_idgenero = g.idgenero;

-- 6. Encontrar os filmes que receberam prêmios e que tiveram exibição em pelo menos uma sala
SELECT DISTINCT f.nomeBR
FROM filme f
JOIN filme_has_premiacao fhp ON f.idfilme = fhp.filme_idfilme
JOIN filme_exibido_sala fes ON f.idfilme = fes.filme_idfilme
WHERE fhp.ganhou = true;

-- 7. Listar os filmes que não receberam nenhum premio
select fl.nomeBR from filme fl
left join filme_has_premiacao fhp on fhp.filme_idfilme = fl.idfilme
where fhp.ganhou is null or fhp.ganhou = false;

-- 8. Exibir os diretores que dirigiram pelo menos dois filmes
SELECT d.nome, COUNT(f.idfilme) as total_filmes
FROM diretor d
JOIN filme f ON d.idDiretor = f.diretor_idDiretor
GROUP BY d.idDiretor, d.nome
HAVING COUNT(f.idfilme) >= 2;

-- 9 Listar os funcionários e os horários que trabalham, ordenados pelo horário mais cedo.
select func.nome, h.horario from funcionario func
left join horario_trabalho_funcionario htf on htf.idfuncionario = func.idfuncionario
left join horario h on h.idhorario = htf.idhorario
order by h.horario;

-- 10. Listar os filmes que foram exibidos na mesma sala em horários diferentes.
select distinct f1.nomeBR, s.nome as sala
from filme f1
join filme_exibido_sala fes1 on f1.idfilme = fes1.filme_idfilme
join sala s on fes1.sala_idsala = s.idSala
where exists (
    SELECT 1
    from filme_exibido_sala fes2
    where fes1.sala_idsala = fes2.sala_idsala and fes1.horario_idhorario != fes2.horario_idhorario and fes1.filme_idfilme = fes2.filme_idfilme
);

-- 11. Unir os diretores e os funcionários em uma única lista de pessoas
SELECT nome, 'Diretor' as tipo FROM diretor
UNION
SELECT nome, 'Funcionário' as tipo FROM funcionario
ORDER BY nome;

-- 12. Exibir todas as funções diferentes que os funcionários exercem e a quantidade de funcionários em cada uma
SELECT f.nome as funcao, COUNT(htf.idfuncionario) as quantidade
FROM funcao f
LEFT JOIN horario_trabalho_funcionario htf ON f.idfuncao = htf.idfuncao
GROUP BY f.idfuncao, f.nome;

-- 13. Encontrar os filmes que foram exibidos em salas com capacidade superior à média de todas as salas
select f.nomeBR, s.nome as sala, s.capacidade
from filme_exibido_sala fs
join sala s on fs.sala_idSala = s.idSala
join filme f on fs.filme_idfilme = f.idfilme
where s.capacidade > (select avg(capacidade) from sala);

-- 14. Calcular o salário anual dos funcionários (considerando 12 meses)
SELECT nome, salario as salario_mensal, (salario * 12) as salario_anual
FROM funcionario;

-- 15. Exibir a relação entre a capacidade da sala e o número total de filmes exibidos nela
select s.nome as sala, s.capacidade, count (fs.filme_idfilme) as total_filmes,
(count(fs.filme_idfilme) / nullif(s.capacidade, 0)) as filmes_por_assento
from sala s
left join filme_exibido_sala fs on s.idSala = fs.sala_idSala
group by s.idsala, s.capacidade;