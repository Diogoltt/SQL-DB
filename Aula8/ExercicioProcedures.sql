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


-- 1. Função chamada Espaco_Disponivel que recebe o ID da máquina e retorna TRUE se houver espaço suficiente para instalar um software
create or replace function Espaco_Disponivel(f_Id_Maquina int, f_Id_Software int) returns boolean as $$
declare
    espacoSuficiente boolean;
    espacoDisponivel int;
    espacoNecessario int;
begin
    select HardDisk into espacoDisponivel from Maquina where Id_Maquina = f_Id_Maquina;
    select HardDisk into espacoNecessario from Software where Id_Software = f_Id_Software;

    if espacoDisponivel >= espacoNecessario then
        espacoSuficiente := true;
    else
        espacoSuficiente := false;
    end if;
    
    return espacoSuficiente;
end;
$$ language plpgsql;


select Espaco_Disponivel(1, 2);


-- 2. Procedure Instalar_Software que só instala um software se houver espaço disponível.
create or replace procedure Instalar_Software(p_Id_Maquina int, p_Id_Software int) as $$
declare
    espacoSuficiente boolean;
    hardDiskNecessario int;
begin
    select Espaco_Disponivel(p_Id_Maquina, p_Id_Software) into espacoSuficiente;

    if espacoSuficiente then
        select HardDisk into hardDiskNecessario from Software where p_Id_Software = Id_Software;

        update Maquina
        set HardDisk = HardDisk - hardDiskNecessario
        where Id_Maquina = p_Id_Maquina;
        raise notice 'Software instalado com sucesso';
    else
        raise exception 'Não tem espaço disponível';
    end if;
end;
$$ language plpgsql;

call Instalar_Software(1, 3);


-- 3. Função Maquinas_Do_Usuario que retorna uma lista de máquinas associadas a um usuário.
create or replace function Maquinas_Do_Usuario(f_ID_Usuario int) returns table (
    f_Id_Maquina int
) as $$
begin
    return query
    select Id_Maquina
    from Maquina
    where Fk_Usuario = f_ID_Usuario;
end;
$$ language plpgsql;

drop function Maquinas_Do_Usuario;

select Maquinas_Do_Usuario(3);


-- 4. Procedure Atualizar_Recursos_Maquina que aumenta a memoria RAM e o espaço em disco de uma máquinas específica.
create or replace procedure Atualizar_Recursos_Maquina(p_Id_Maquina int, p_HardDisk int, p_Memoria_Ram int) as $$
begin
    update Maquina set HardDisk = p_HardDisk where Id_Maquina = p_Id_Maquina;
    update Maquina set Memoria_Ram = p_Memoria_Ram where Id_Maquina = p_Id_Maquina;

    raise notice 'Recursos atualizados com sucesso';
end;
$$ language plpgsql;

call Atualizar_Recursos_Maquina(1, 400, 24);
select * from Maquina where id_maquina = 1;

-- 5. Procedure Transferir_Software que transfere um software de uma máquina para outra. Antes de transferir, a procedure deve verificar se a máquina de destino

drop procedure Transferir_Software;

create or replace procedure Transferir_Software(Id_Software1 integer, Id_Maquina_Origem1 integer, Id_Maquina_Destino1 integer) as $$
declare
    Possivel boolean;
begin
    -- Verifica se maquina destino tem espaço suficiente
    select Espaco_Disponivel(Id_Maquina_Destino1, Id_Software1) into Possivel;

    if Possivel then
        update Software set Fk_Maquina = Id_Maquina_Destino1 where Id_Software = Id_Software1 and Fk_Maquina = Id_Maquina_Origem1;

        if not found then 
            raise notice 'Software não encontrado na maquinade origem';
        end if;
    else
        raise notice 'Maquina de destino não tem espaço suficiente';
    end if;
end;
$$ language plpgsql;

call Transferir_Software(2, 2, 3);

-- 6. Crie uma função Media_Recursos que retorna a média de Memória RAM e HardDisk de todas as maquinas cadastradas

drop function Media_Recursos();

create or replace function Media_Recursos() returns table(
    media_ram numeric,
    media_hd numeric
) as $$
begin
    return query
    select round(avg(Memoria_Ram), 2) as media_ram, round(avg(HardDisk), 2) as media_hd from Maquina;
end;
$$ language plpgsql;

select * from Media_Recursos();


-- 7. 
create or replace procedure Diagnostico_Maquina(p_Id_Maquina integer) as $$
declare
    Total_Ram_Requerido integer;
    Total_HD_Requerido integer;
    Ram_Atual integer;
    HD_Atual integer;
    Ram_Upgrade integer;
    HD_Upgrade integer;
begin
    -- Obter a soma dos requisitos minimos dos softwares instalados na maquina
    select
        coalesce(sum(Memoria_Ram), 0),
        coalesce(sum(HardDisk), 0)
    into
        Total_Ram_Requerido,
        Total_HD_Requerido
    from
        software
    where
        Fk_Maquina = p_Id_Maquina;
    
    -- Obter a quantidade de ram e hd atuais
    select
        Memoria_Ram,
        HardDisk
    into
        Ram_Atual,
        HD_Atual
    from
        maquina
    WHERE
        Id_Maquina = p_Id_Maquina;

    -- Expcetion para maquina não encontrada
    if not found then
        raise notice 'Maquina não encontrada';
    end if;

    -- Verificar se a maquina tem recursos suficientes
    if Ram_Atual >= Total_Ram_Requerido and HD_Atual >= Total_HD_Requerido then
        raise notice 'Maquina % tem recursos suficientes e não precisa de upgrade', p_Id_Maquina;
    else
        -- Calcula a necessidade de upgrade
        Ram_Upgrade := Greatest(0, Total_Ram_Requerido - Ram_Atual); -- Retorna o maior valor
        HD_Upgrade := Greatest(0, Total_HD_Requerido - HD_Atual); -- Retorna o maior valor

        if Ram_Upgrade > 0 then
            raise notice 'Recomendado upgrade de % GB de Ram', Ram_Upgrade;
        end if;

        if HD_Upgrade > 0 then
            raise notice 'Recomendado upgrade de % GB de Ram', HD_Upgrade;
        end if;
    end if;
end;
$$ language plpgsql;

call Diagnostico_Maquina(3);