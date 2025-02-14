CREATE TABLE IF NOT EXISTS Empregado (
    Nome VARCHAR(50),
    Endereco VARCHAR(500),
    CPF INT PRIMARY KEY NOT NULL,
    DataNasc DATE,
    Sexo CHAR(10),
    CartTrab INT,
    Salario FLOAT,
    NumDep INT,
    CPFSup INT
);

CREATE TABLE IF NOT EXISTS Departamento (
    NomeDep VARCHAR(50),
    NumDep INT PRIMARY KEY NOT NULL,
    CPFGer INT,
    DataInicioGer DATE
);

CREATE TABLE IF NOT EXISTS Projeto (
    NomeProj VARCHAR(50),
    NumProj INT PRIMARY KEY NOT NULL,
    Localizacao VARCHAR(50),
    NumDep INT
);

CREATE TABLE IF NOT EXISTS Dependente (
    idDependente INT PRIMARY KEY NOT NULL,
    CPFE INT,
    NomeDep VARCHAR(50),
    Sexo CHAR(10),
    Parentesco VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Trabalha_Em (
    CPF INT,
    NumProj INT,
    HorasSemana INT
);

ALTER TABLE Empregado
ADD FOREIGN KEY (NumDep) REFERENCES Departamento(NumDep);

ALTER TABLE Departamento
ADD FOREIGN KEY (CPFGer) REFERENCES Empregado(CPF);

ALTER TABLE Projeto
ADD FOREIGN KEY (NumDep) REFERENCES Departamento(NumDep);

ALTER TABLE Dependente
ADD FOREIGN KEY (CPFE) REFERENCES Empregado(CPF);

ALTER TABLE Trabalha_Em
ADD FOREIGN KEY (CPF) REFERENCES Empregado(CPF),
ADD FOREIGN KEY (NumProj) REFERENCES Projeto(NumProj);

INSERT INTO Departamento VALUES ('Dep1', 1, NULL, '1990-01-01');
INSERT INTO Departamento VALUES ('Dep2', 2, NULL, '1990-01-01');
INSERT INTO Departamento VALUES ('Dep3', 3, NULL, '1990-01-01');

INSERT INTO Empregado VALUES ('Joao', 'Rua 1', 123, '1990-01-01', 'M', 123, 1000, 1, NULL);
INSERT INTO Empregado VALUES ('Maria', 'Rua 2', 456, '1990-01-01', 'F', 456, 2000, 2, NULL);
INSERT INTO Empregado VALUES ('Jose', 'Rua 3', 789, '1990-01-01', 'M', 789, 3000, 3, NULL);

UPDATE Departamento SET CPFGer = 123 WHERE NumDep = 1;
UPDATE Departamento SET CPFGer = 456 WHERE NumDep = 2;
UPDATE Departamento SET CPFGer = 789 WHERE NumDep = 3;

INSERT INTO Projeto VALUES ('Proj1', 1, 'Local1', 1);
INSERT INTO Projeto VALUES ('Proj2', 2, 'Local2', 2);
INSERT INTO Projeto VALUES ('Proj3', 3, 'Local3', 3);

INSERT INTO Dependente VALUES (1, 123, 'Dep1', 'M', 'Filho');
INSERT INTO Dependente VALUES (2, 456, 'Dep2', 'F', 'Filha');
INSERT INTO Dependente VALUES (3, 789, 'Dep3', 'M', 'Filho');

INSERT INTO Trabalha_Em VALUES (123, 1, 40);
INSERT INTO Trabalha_Em VALUES (456, 2, 40);
INSERT INTO Trabalha_Em VALUES (789, 3, 40);

--------------

-- 1. Função que retorna o salário de um empregado dado o CPF
create or replace function obter_salario(cpf integer) returns float as $$
declare
    v_salario float;
begin
    select Salario into v_salario 
    from Empregado e
    where e.CPF = cpf;
    return v_salario;
end;
$$ language plpgsql;

select obter_salario(456);


-- 2. Função que retorna o nome do departamento de um empregado dado o CPF
create or replace function obter_nome_departamento(cpf integer) returns varchar(50) as $$
declare
    v_nome_departamento varchar(50);
begin
    select dep.NomeDep into v_nome_departamento
    from Departamento dep
    join Empregado e on dep.NumDep = e.NumDep
    where e.CPF = cpf;
    return v_nome_departamento;
end;
$$ language plpgsql;

select obter_nome_departamento(123);


-- 3. Função que retorna o nome do gerente de um departamento dado o NumDep
create or replace function obter_gerente_departamento(numeroDep integer) returns varchar(50) as $$
declare
    v_nome_gerente varchar(50);
begin
    select e.Nome into v_nome_gerente
    from Empregado e
    join Departamento on e.NumDep = Departamento.NumDep
    where Departamento.NumDep = numeroDep;
    return v_nome_gerente;
end;
$$ language plpgsql;

select obter_gerente_departamento(2);


-- 4. Função que retorna o nome do projeto de um empregado dado o CPF
create or replace function obter_projeto(cpfEmpregado integer) returns varchar(50) as $$
declare
    v_nome_projeto varchar(50);
begin
    select proj.NomeProj into v_nome_projeto
    from Projeto proj
    join Trabalha_Em trab on proj.NumProj = trab.NumProj
    join Empregado e on trab.CPF = e.CPF
    where e.CPF = cpfEmpregado;
    return v_nome_projeto;
end;
$$ language plpgsql;

select obter_projeto(789);


-- 5. Função que retorna o nome do dependente de um empregado dado o CPF
create or replace function obter_dependente(cpfEmpregado integer) returns varchar(50) as $$
declare
    v_nome_dependente varchar(50);
begin
    select Dependente.NomeDep into v_nome_dependente
    from Dependente
    join Empregado e on Dependente.CPFE = e.CPF
    where Empregado.CPF = cpfEmpregado;
    return v_nome_dependente;
end;
$$ language plpgsql;

select obter_dependente(123);