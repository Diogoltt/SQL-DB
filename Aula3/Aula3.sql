CREATE TABLE empregado (
    nome VARCHAR(100),
    endereco VARCHAR(100),
    cpf VARCHAR(11),
    datanasc DATE,
    sexo CHAR(1),
    carttrab INT,
    salario DECIMAL(10,2),
    numdep INT,
    cpfsuper VARCHAR(11)
--    PRIMARY KEY (cpf),
--    FOREIGN KEY (numdep) REFERENCES departamento(numdep),
--    FOREIGN KEY (cpfsuper) REFERENCES empregado(cpf)
);

CREATE TABLE departamento (
    nomedep VARCHAR(50),
    numdep INT,
    cpfger VARCHAR(11),
    datainicioger DATE
--    PRIMARY KEY (numdep),
--    FOREIGN KEY (cpfger) REFERENCES empregado(cpf)
);

CREATE TABLE projeto (
    nomeproj VARCHAR(50),
    numproj INT,
    localizacao VARCHAR(100),
    numd INT
--    PRIMARY KEY (numproj),
--    FOREIGN KEY (numd) REFERENCES departamento(numdep)
);

CREATE TABLE dependente (
    dependenteid INT,
    cpfe VARCHAR(11),
    nomedep VARCHAR(50),
    sexo CHAR(1),
    parentesco VARCHAR(50)
--    PRIMARY KEY (dependenteid),
--    FOREIGN KEY (cpfe) REFERENCES empregado(cpf)
);

CREATE TABLE trabalha_em (
    cpfe VARCHAR(11),
    numproj INT,
    horas INT
--    PRIMARY KEY (cpfe, numproj),
--    FOREIGN KEY (cpfe) REFERENCES empregado(cpf),
--    FOREIGN KEY (numproj) REFERENCES projeto(numproj)
);

ALTER TABLE empregado
ADD CONSTRAINT pk_empregado PRIMARY KEY (cpf);

ALTER TABLE empregado
ADD CONSTRAINT fk_empregado_departamento FOREIGN KEY (numdep) REFERENCES departamento(numdep);

ALTER TABLE empregado
ADD CONSTRAINT fk_empregado_supervisor FOREIGN KEY (cpfsuper) REFERENCES empregado(cpf);

ALTER TABLE departamento
ADD CONSTRAINT pk_departamento PRIMARY KEY (numdep);

ALTER TABLE departamento
ADD CONSTRAINT fk_departamento_empregado FOREIGN KEY (cpfger) REFERENCES empregado(cpf);

ALTER TABLE projeto
ADD CONSTRAINT pk_projeto PRIMARY KEY (numproj);

ALTER TABLE projeto
ADD CONSTRAINT fk_projeto_departamento FOREIGN KEY (numd) REFERENCES departamento(numdep);

ALTER TABLE dependente
ADD CONSTRAINT pk_dependente PRIMARY KEY (dependenteid);

ALTER TABLE dependente
ADD CONSTRAINT fk_dependente_empregado FOREIGN KEY (cpfe) REFERENCES empregado(cpf);

ALTER TABLE trabalha_em
ADD CONSTRAINT pk_trabalha_em PRIMARY KEY (cpfe, numproj);

ALTER TABLE trabalha_em
ADD CONSTRAINT fk_trabalha_em_empregado FOREIGN KEY (cpfe) REFERENCES empregado(cpf);

ALTER TABLE trabalha_em
ADD CONSTRAINT fk_trabalha_em_projeto FOREIGN KEY (numproj) REFERENCES projeto(numproj);

---------------------------
INSERT INTO departamento VALUES ('Dep1', 1, null, '1990-01-01');
INSERT INTO departamento VALUES ('Dep2', 2, null, '1990-01-01');
INSERT INTO departamento VALUES ('Dep3', 3, null, '1990-01-01');

INSERT INTO empregado VALUES ('Joao', 'Rua do Joao', 123, '1990-01-01', 'M', 123, 1000, 1, null);
INSERT INTO empregado VALUES ('Maria', 'Rua da Maria', 456, '1990-01-01', 'F', 456, 2000, 2, null);
INSERT INTO empregado VALUES ('Jose', 'Rua de Jose', 789, '1990-01-01', 'M', 789, 3000, 3, null);

UPDATE departamento SET cpfger = 123 WHERE numdep = 1;
UPDATE departamento SET cpfger = 456 WHERE numdep = 2;
UPDATE departamento SET cpfger = 789 WHERE numdep = 3;

INSERT INTO projeto VALUES ('Proj1', 1, 'Local1', 1);
INSERT INTO projeto VALUES ('Proj2', 2, 'Local2', 2);
INSERT INTO projeto VALUES ('Proj3', 3, 'Local3', 3);

INSERT INTO dependente VALUES (1, 123, 'Dep1', 'M', 'Filho');
INSERT INTO dependente VALUES (2, 456, 'Dep2', 'F', 'Filha');
INSERT INTO dependente VALUES (3, 789, 'Dep3', 'M', 'Filho');

INSERT INTO trabalha_em VALUES (123, 1, 40);
INSERT INTO trabalha_em VALUES (456, 2, 40);
INSERT INTO trabalha_em VALUES (789, 3, 40);

SELECT * FROM empregado;

-- Substrings, com posições específicas de caracteres
SELECT nomeproj FROM projeto WHERE nomeproj LIKE 'P____';

-- Diferença de Aspas Simples e Duplas
-- Simples pegam Strings
-- Duplas identificam nome da tabela/coluna
select e.nome from empregado e where e.nome like 'J%';
SELECT "nome" from empregado where "nome" like 'J%';

-- Select com aumento de 10% no salario do funcionário
select e.nome, e.salario * 1.1 from empregado e;

-- Colocar nome referencia na operação usando As
select e.nome, e.salario * 1.1 as SalarioAtualizado from empregado e;

SELECT DISTINCT e.nome, e.cpf FROM empregado e, trabalha_em t WHERE e.cpf = t.cpfe;

-- Union
-- Listar os números de projetos nos quais esteja envolvido o empregado
-- Joao como empregado ou gerente responsável pelo departamento
-- que controla o projeto

(SELECT DISTINCT numproj 
FROM projeto p, departamento d, empregado e
where p.numproj = d.numdep and d.cpfger = e.cpf and e.nome = 'Joao'
) 
UNION 
(select p.numproj from 
projeto p, empregado e, trabalha_em t
where p.numproj = t.numproj and t.cpfe = e.cpf and e.nome = 'Joao');


-- Intersect
-- Listar os nomes dos empregados que também são gerentes de departamento
select e.nome from empregado e
Intersect
select e.nome from empregado e, departamento d where d.cpfger = e.cpf;

-- Utilizar o Is Null para imprimir registros que possuem nulo na coluna
select e.cpfsuper from empregado e;
select e.nome from empregado e where e.cpfsuper is null;
select e.nome from empregado e where e.cpfsuper is not null;

-- Funções nativas
-- Média dos salarios dos empregados
select avg(salario) from empregado;

-- Salário máximo
select max(salario) from empregado;

-- Menor salário
select min(salario) from empregado;

-- Soma total de todos os salários
select sum(salario) from empregado

-- Selecionar o CPF de todos os empregados que trabalham no mesmo projeto
-- e com a mesma quantidade de horas que o empregado cujo cpf é 123.
select e.cpf from empregado e
join trabalha_em t on e.cpf = t.cpfe
where t.numproj = (select t2.numproj from trabalha_em t2 where t2.cpfe = '123') and t.horas = (select t3.horas from trabalha_em t3 where t3.cpfe = '123');

-- Solução alternativa
select distinct cpfe
from trabalha_em 
where (numproj, horas) in -- in verifica resultado na subconsulta
(select numproj, horas from trabalha_em where cpfe = 123);


-- Selecionar o nome de todos os empregados que possuem salário maior
-- do que todos os salários dos empregados do departamento 2

select nome from empregado
where salario > all (select salario from empregado where numdep = 2);