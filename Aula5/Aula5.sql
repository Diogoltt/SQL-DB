create table instrutor (
    idinstrutor int primary key,
    RG int,
    nome varchar(45),
    nascimento date,
    titulacao int
)

create table telefone_instrutor (
    idtelefone int primary key,
    numero int,
    tipo varchar(45),
    instrutor_idinstrutor int,
    foreign key (instrutor_idinstrutor) references instrutor(idinstrutor)
)

create table atividade (
    idatividade int primary key,
    nome varchar(100)
)

create table turma (
    idturma int primary key,
    horario time,
    duracao int,
    dataInicio date,
    dataFim date,
    atividade_idatividade int,
    instrutor_idinstrutor int,
    foreign key (atividade_idatividade) references atividade(idatividade),
    foreign key (instrutor_idinstrutor) references instrutor(idinstrutor)
)

create table aluno (
    codMatricula int primary key,
    turma_idturma int,
    dataMatricula date,
    nome varchar(45),
    endereco text,
    telefone int,
    dataNascimento date,
    altura float,
    peso int,
    foreign key (turma_idturma) references turma(idturma)
)

create table matricula (
    aluno_codMatricula int,
    turma_idturma int,
    primary key (aluno_codMatricula, turma_idturma),
    foreign key (aluno_codMatricula) references aluno(codMatricula),
    foreign key (turma_idturma) references turma(idturma),
    unique (aluno_codMatricula, turma_idturma)
)

CREATE TABLE chamada (
    idchamada INT PRIMARY KEY,
    data DATE,
    presente BOOLEAN,
    aluno_codMatricula INT,
    turma_idturma INT,
    FOREIGN KEY (aluno_codMatricula, turma_idturma) REFERENCES matricula(aluno_codMatricula, turma_idturma) ON DELETE CASCADE
);


------------------- Inserts -------------------

-- Inserindo dados na tabela instrutor
INSERT INTO instrutor (idinstrutor, RG, nome, nascimento, titulacao) VALUES
(1, 12345678, 'Carlos Silva', '1980-05-10', 3),
(2, 87654321, 'Mariana Souza', '1985-08-20', 4),
(3, 11223344, 'Roberto Lima', '1990-02-15', 2),
(4, 55667788, 'Ana Paula', '1975-11-30', 5),
(5, 99887766, 'Fernanda Costa', '1982-07-22', 3);


-- Inserindo dados na tabela telefone_instrutor
INSERT INTO telefone_instrutor (idtelefone, numero, tipo, instrutor_idinstrutor) VALUES
(1, 999111222, 'Celular', 1),
(2, 888333444, 'Residencial', 2),
(3, 777555666, 'Comercial', 3),
(4, 666222111, 'Celular', 4),
(5, 555888999, 'Residencial', 5);

-- Inserindo dados na tabela atividade
INSERT INTO atividade (idatividade, nome) VALUES
(1, 'Crossfit'),
(2, 'Yoga'),
(3, 'Pilates'),
(4, 'Musculação'),
(5, 'Spinning');

-- Inserindo dados na tabela turma
INSERT INTO turma (idturma, horario, duracao, dataInicio, dataFim, atividade_idatividade, instrutor_idinstrutor) VALUES
(1, '07:00:00', 60, '2025-01-10', '2025-06-10', 1, 1),
(2, '08:30:00', 45, '2025-02-15', '2025-07-15', 2, 2),
(3, '10:00:00', 50, '2025-03-05', '2025-08-05', 3, 3),
(4, '18:00:00', 40, '2025-04-01', '2025-09-01', 4, 4),
(5, '19:30:00', 55, '2025-05-10', '2025-10-10', 5, 5);

-- Inserindo dados na tabela aluno
INSERT INTO aluno (codMatricula, turma_idturma, dataMatricula, nome, endereco, telefone, dataNascimento, altura, peso) VALUES
(1, 1, '2025-01-12', 'João Pedro', 'Rua A, 123', 911223344, '2000-05-14', 1.75, 72),
(2, 1, '2025-01-15', 'Lucas Mendes', 'Rua B, 456', 922334455, '1998-10-20', 1.80, 78),
(3, 2, '2025-02-18', 'Carla Souza', 'Rua C, 789', 933445566, '2002-03-25', 1.65, 60),
(4, 3, '2025-03-10', 'Mariana Lima', 'Rua D, 321', 944556677, '1997-12-30', 1.70, 65),
(5, 4, '2025-04-05', 'Fernando Alves', 'Rua E, 654', 955667788, '1995-07-10', 1.85, 85);

-- Inserindo dados na tabela matricula
INSERT INTO matricula (aluno_codMatricula, turma_idturma) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4);

-- Inserindo dados na tabela chamada
INSERT INTO chamada (idchamada, data, presente, aluno_codMatricula, turma_idturma) VALUES
(1, '2025-01-12', TRUE, 1, 1),
(2, '2025-01-15', TRUE, 2, 1),
(3, '2025-02-18', FALSE, 3, 2),
(4, '2025-03-10', TRUE, 4, 3),
(5, '2025-04-05', TRUE, 5, 4);

INSERT INTO aluno (codMatricula, turma_idturma, dataMatricula, nome, endereco, telefone, dataNascimento, altura, peso) VALUES
(6, 1, '2025-01-18', 'Gabriel Santos', 'Rua F, 111', 966778899, '2001-06-22', 1.78, 74),
(7, 2, '2025-02-20', 'Ana Clara', 'Rua G, 222', 977889900, '1999-09-15', 1.62, 58),
(8, 3, '2025-03-12', 'Rodrigo Alves', 'Rua H, 333', 988990011, '1996-11-30', 1.85, 90),
(9, 4, '2025-04-08', 'Juliana Martins', 'Rua I, 444', 999001122, '1993-03-10', 1.70, 64),
(10, 5, '2025-05-15', 'Thiago Oliveira', 'Rua J, 555', 910112233, '2000-08-25', 1.80, 77),
(11, 1, '2025-01-20', 'Vanessa Rocha', 'Rua K, 666', 921223344, '1997-05-14', 1.68, 62),
(12, 2, '2025-02-22', 'Felipe Costa', 'Rua L, 777', 932334455, '1998-12-20', 1.75, 79),
(13, 3, '2025-03-15', 'Isabela Nunes', 'Rua M, 888', 943445566, '2003-07-25', 1.64, 55),
(14, 4, '2025-04-10', 'Bruno Ferreira', 'Rua N, 999', 954556677, '1996-10-30', 1.83, 82),
(15, 5, '2025-05-20', 'Renata Lima', 'Rua O, 101', 965667788, '1994-02-10', 1.72, 68),
(16, 1, '2025-01-22', 'Pedro Henrique', 'Rua P, 202', 976778899, '1995-04-15', 1.79, 76),
(17, 2, '2025-02-24', 'Camila Ribeiro', 'Rua Q, 303', 987889900, '2002-09-05', 1.67, 59),
(18, 3, '2025-03-18', 'Gustavo Souza', 'Rua R, 404', 998990011, '1997-06-20', 1.82, 84),
(19, 4, '2025-04-12', 'Larissa Mendes', 'Rua S, 505', 909001122, '1993-01-18', 1.71, 63),
(20, 5, '2025-05-25', 'Eduardo Moreira', 'Rua T, 606', 911112233, '1999-12-07', 1.74, 70);

-- Inserindo os novos alunos na tabela matricula
INSERT INTO matricula (aluno_codMatricula, turma_idturma) VALUES
(6, 1), (7, 2), (8, 3), (9, 4), (10, 5),
(11, 1), (12, 2), (13, 3), (14, 4), (15, 5),
(16, 1), (17, 2), (18, 3), (19, 4), (20, 5);

-- Inserindo os novos alunos na tabela chamada
INSERT INTO chamada (idchamada, data, presente, aluno_codMatricula, turma_idturma) VALUES
(6, '2025-01-18', TRUE, 6, 1),
(7, '2025-02-20', FALSE, 7, 2),
(8, '2025-03-12', TRUE, 8, 3),
(9, '2025-04-08', TRUE, 9, 4),
(10, '2025-05-15', FALSE, 10, 5),
(11, '2025-01-20', TRUE, 11, 1),
(12, '2025-02-22', TRUE, 12, 2),
(13, '2025-03-15', FALSE, 13, 3),
(14, '2025-04-10', TRUE, 14, 4),
(15, '2025-05-20', TRUE, 15, 5),
(16, '2025-01-22', FALSE, 16, 1),
(17, '2025-02-24', TRUE, 17, 2),
(18, '2025-03-18', TRUE, 18, 3),
(19, '2025-04-12', FALSE, 19, 4),
(20, '2025-05-25', TRUE, 20, 5);

------------------- Selects -------------------

-- 1. Listar todos os alunos e a turma em que estão matriculados
select aluno.nome as nome_aluno, atividade.nome as turma_matriculada
from aluno
join matricula on aluno.codmatricula = matricula.aluno_codmatricula
join turma on matricula.turma_idturma = turma.idturma
join atividade on turma.atividade_idatividade = atividade.idatividade;

-- 2️. Contar quantos alunos estão matriculados em cada turma
select  atividade.nome, count(*) as total_alunos
from aluno
join matricula on aluno.codmatricula = matricula.aluno_codmatricula
join turma on matricula.turma_idturma = turma.idturma
join atividade on turma.atividade_idatividade = atividade.idatividade
GROUP BY atividade.nome;

-- 3. Mostrar a média de idade dos alunos em cada turma
select turma.idturma, round(avg(extract(year from age(aluno.dataNascimento)))) as media_idade
from aluno
join matricula on aluno.codmatricula = matricula.aluno_codmatricula
join turma on matricula.turma_idturma = turma.idturma
group by turma.idturma
order by turma.idturma;

-- 4. Encontrar as turmas com mais de 3 alunos matriculados
select turma.idturma, count(*) as total_alunos
from turma
join matricula on turma.idturma = matricula.turma_idturma
GROUP BY turma.idturma
HAVING count(*) > 3;

-- 5️. Exibir os instrutores que orientam turmas e os que ainda não possuem turmas
select instrutor.nome, turma.idturma
from instrutor
join turma on instrutor.idinstrutor = turma.instrutor_idinstrutor

-- 6. Encontrar os alunos que frequentaram todas as aulas de sua turma
select a.nome as aluno, t.idturma as turma
from aluno a
join chamada c on a.codmatricula = c.aluno_codmatricula
join turma t on c.turma_idturma = t.idturma
group by a.codmatricula, t.idturma
having count(case when c.presente = true then 1 end) =
(select count(*) from chamada c2 where c2.turma_idturma = t.idturma and c2.aluno_codmatricula = a.codmatricula);

-- 7️. Mostrar os instrutores que ministram turmas de "Crossfit" ou "Yoga"
select instrutor.nome as nome_instrutor, atividade.nome as turma_ministrada
from instrutor
join turma on instrutor.idinstrutor = turma.instrutor_idinstrutor
join atividade on turma.atividade_idatividade = atividade.idatividade
where atividade.nome = 'Crossfit' or atividade.nome = 'Yoga';

-- 8. Listar os alunos que estão matriculados em mais de uma turma
select aluno.nome, count(matricula.turma_idturma) as total_turmas
from aluno
join matricula on aluno.codmatricula = matricula.aluno_codmatricula
group by aluno.nome
having count(matricula.turma_idturma) >= 1;

-- 9. Encontrar as turmas que possuem a maior quantidade de alunos
select atividade.nome, count(matricula.aluno_codmatricula) as total_alunos
from atividade
join turma on idatividade = atividade_idatividade
join matricula on idturma = turma_idturma
join aluno on codmatricula = aluno_codmatricula
group by atividade.nome
order by total_alunos desc;

-- 10. Listar os alunos que não compareceram a nenhuma aula
select aluno.nome
from aluno
join matricula on aluno.codmatricula = matricula.aluno_codmatricula
join chamada on matricula.aluno_codmatricula = chamada.aluno_codmatricula
where chamada.presente = false;