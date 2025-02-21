CREATE TABLE Maquina (
 Id_Maquina INT PRIMARY KEY NOT NULL,
 Tipo VARCHAR(255),
 Velocidade INT,
 HardDisk INT,
 Placa_Rede INT,
 Memoria_Ram INT,
 Fk_Usuario INT,
 FOREIGN KEY(Fk_Usuario) REFERENCES Usuarios(ID_Usuario)
);
CREATE TABLE Usuarios (
 ID_Usuario INT PRIMARY KEY NOT NULL,
 Password VARCHAR(255),
 Nome_Usuario VARCHAR(255),
 Ramal INT,
 Especialidade VARCHAR(255)
);
CREATE TABLE Software (
 Id_Software INT PRIMARY KEY NOT NULL,
 Produto VARCHAR(255),
 HardDisk INT,
 Memoria_Ram INT,
 Fk_Maquina INT,
 FOREIGN KEY(Fk_Maquina) REFERENCES Maquina(Id_Maquina)
);
create table Log_Exclusao_Maquina (
    Id_Log serial primary key,
    Id_Maquina int,
    Acao varchar(20),
    Data timestamp default current_timestamp
);

insert into Maquina values (1, 'Desktop', 2, 500, 1, 4, 1);
insert into Maquina values (2, 'Notebook', 1, 250, 1, 2, 2);
insert into Maquina values (3, 'Desktop', 3, 1000, 1, 8, 3);
insert into Maquina values (4, 'Notebook', 2, 500, 1, 4, 4);
insert into Usuarios values (1, '123', 'Joao', 123, 'TI');
insert into Usuarios values (2, '456', 'Maria', 456, 'RH');
insert into Usuarios values (3, '789', 'Jose', 789, 'Financeiro');
insert into Usuarios values (4, '101', 'Ana', 101, 'TI');
insert into Software values (1, 'Windows', 100, 2, 1);
insert into Software values (2, 'Linux', 50, 1, 2);
insert into Software values (3, 'Windows', 200, 4, 3);
insert into Software values (4, 'Linux', 100, 2, 4);

select * from usuarios;
-- 1. Criar um Trigger para Auditoria de Exclusão de Máquinas: Criar um trigger que registre
-- quando um registro da tabela Maquina for excluído.
create or replace function log_exclusao_maquina()
returns trigger as $$
begin
    insert into Log_Exclusao_Maquina(Id_Maquina, Acao)
    values (old.Id_Maquina, 'DELETE');
    return old;
end;
$$ language plpgsql;

create or replace trigger log_exclusao_maquina
after delete on Maquina
for each row
execute function log_exclusao_maquina();

delete from Software where Fk_Maquina = 2;
delete from Maquina where Id_Maquina = 2;

select * from log_exclusao_maquina;


-- 2. Criar um Trigger para evitar senhas fracas: Criar um BEFORE INSERT trigger para impedir
-- que um usuário seja cadastrado com uma senha menor que 6 caracteres.
create or replace function senha_fraca()
returns trigger as $$
begin
    if length(NEW.Password) < 6 then
        raise exception 'A senha deve ter mais que 6 caracteres.';
    end if;
    return NEW;
end;
$$ language plpgsql;

create or replace trigger trg_senha_fraca
before insert on Usuarios
for each row
execute function senha_fraca();

insert into Usuarios values (5, '12345', 'Diogo', 102, 'TI');

SELECT * from usuarios;


-- 3. Criar um Trigger para atualizar contagem de softwares em cada máquina: Criar um after
-- insert trigger que atualiza uma tabela auxiliar Maquina_Software_Count que armazena a quantidade
-- de softwares instalados em cada máquina.
CREATE TABLE Maquina_Software_Count (
    Id_Maquina INT PRIMARY KEY,
    Contagem_Softwares INT DEFAULT 0,
    FOREIGN KEY(Id_Maquina) REFERENCES Maquina(Id_Maquina)
);

CREATE OR REPLACE FUNCTION atualizar_contagem_softwares()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Maquina_Software_Count
    SET Contagem_Softwares = (SELECT COUNT(*) FROM Software WHERE Fk_Maquina = NEW.Fk_Maquina)
    WHERE Id_Maquina = NEW.Fk_Maquina;
    
    INSERT INTO Maquina_Software_Count (Id_Maquina, Contagem_Softwares)
    SELECT NEW.Fk_Maquina, COUNT(*)
    FROM Software
    WHERE Fk_Maquina = NEW.Fk_Maquina
    ON CONFLICT (Id_Maquina) DO NOTHING;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_contagem_softwares
AFTER INSERT ON Software
FOR EACH ROW
EXECUTE FUNCTION atualizar_contagem_softwares();

INSERT INTO Software (Id_Software, Produto, HardDisk, Memoria_Ram, Fk_Maquina) VALUES (6, 'Ubuntu', 150, 3, 6);

SELECT * FROM Maquina_Software_Count;


-- 4. Criar um Trigger para evitar remoção de usuários do setor de TI:
-- Objetivo: Impedir a remoção de usuários cuja Especialidade seja 'TI'.
create or replace function impedir_remocao_TI()
returns trigger as $$
begin
    if old.especialidade = 'TI' then
        raise exception 'Não é possível remover usuários de TI. :)';
    end if;
    return old;
end;
$$ language plpgsql;

create or replace trigger impedir_remocao_TI
after delete on Usuarios
for each row
execute function impedir_remocao_TI();

select * from usuarios where especialidade = 'TI';

delete from Software where Id_Software = 1;
delete from Maquina where Id_Maquina = 1;
delete from Usuarios where ID_Usuario = 1;


-- 5. Criar um Trigger para calcular o uso total de memória por máquina: Criar um AFTER INSERT
-- trigger e AFTER DELETE trigger que calcula a quantidade total de memória ram ocupada pelos
-- softwares em cada máquina
CREATE OR REPLACE FUNCTION atualizar_memoria_ram()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Maquina
    SET Memoria_Ram = 
        (SELECT COALESCE(SUM(Memoria_Ram), 0) 
        FROM Software 
        WHERE Fk_Maquina = Coalesce(NEW.Fk_Maquina, old.Fk_Maquina))
    where Id_Maquina = Coalesce(new.Fk_Maquina, old.Fk_Maquina);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

create or replace trigger atualizar_memoria_ram
after insert or delete on Software
for each row
execute function atualizar_memoria_ram();

insert into Software values (5, 'Windows', 100, 2, 1);
delete

-- 6. Criar um trigger para registrar alterações de especialidade em usuários: Criar um trigger
-- que registre as mudanças de especialidade dos usuários na tabela Usuarios.
create table log_alteracao_especialidade (
    Id_Log serial primary key,
    ID_Usuario int,
    NovaEspecialidade varchar(20),
    Data timestamp default current_timestamp
);

select * from log_alteracao_especialidade;

create or replace function log_alteracao_especialidade()
returns trigger as $$
begin
    insert into log_alteracao_especialidade(ID_Usuario, NovaEspecialidade)
    values (NEW.ID_Usuario, NEW.Especialidade);
    return NEW;
end;
$$ language plpgsql;

create or replace trigger log_alteracao_especialidade
after update on Usuarios
for each row
execute function log_alteracao_especialidade();

update usuarios set especialidade = 'teste' where especialidade = 'TI'; 

select * from log_alteracao_especialidade;

-- 7. Criar um Trigger para impedir exclusão de softwares essenciais: Criar um BEFORE DELETE
-- Trigger que impeça a exclusão de softwares considerados essenciais (ex: Windows).
create or replace function impedir_remocao_softwares_essenciais()
returns trigger as $$
begin
    if old.Produto = 'Windows' then
        raise exception 'Não é possível remover um software essencial';
    end if;
    return old;
end;
$$ language plpgsql;

create or replace trigger impedir_remocao_softwares_essenciais
before delete on Software
for each row
execute function impedir_remocao_softwares_essenciais();

delete from Software where Id_Software = 3;