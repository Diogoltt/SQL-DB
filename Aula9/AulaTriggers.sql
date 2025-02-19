CREATE TABLE time (
id INTEGER PRIMARY KEY,
nome VARCHAR(50)
);
CREATE TABLE partida (
id INTEGER PRIMARY KEY,
time_1 INTEGER,
time_2 INTEGER,
time_1_gols INTEGER,
time_2_gols INTEGER,
FOREIGN KEY(time_1) REFERENCES time(id),
FOREIGN KEY(time_2) REFERENCES time(id)
);
INSERT INTO time(id, nome) VALUES
(1,'CORINTHIANS'),
(2,'SÃO PAULO'),
(3,'CRUZEIRO'),
(4,'ATLETICO MINEIRO'),
(5,'PALMEIRAS');
INSERT INTO partida(id, time_1, time_2, time_1_gols, time_2_gols)
VALUES
(1,4,1,0,4),
(2,3,2,0,1),
(3,1,3,3,0),
(4,3,4,0,1),
(5,1,2,0,0),
(6,2,4,2,2),
(7,1,5,1,2),
(8,5,2,1,2);

-- Triggers são gatilhos automáticos que são executados antes ou depois de uma operação como insert, update & delete
-- As triggers são necessárias para garantir a integridade dos dados, consistencia e validar
-- Regras de négocio antes de inserir atualizar ou deletar dados

create table log_partida(
    id serial primary key,
    partida_id integer,
    acao varchar(20),
    data timestamp default current_timestamp
);

create or replace function log_partida_insert() returns trigger as $$
begin
    insert into log_partida(partida_id, acao) values (new.id, 'INSERT');
    return new;
end;
$$ language plpgsql;

create trigger log_partida_insert
after insert on partida
for each row
execute function log_partida_insert();

insert into partida(id, time_1, time_2, time_1_gols, time_2_gols) values (9, 1, 2, 1, 0);

select * from log_partida;


-- Trigger de Restrição
create or replace function insert_partida()
returns trigger as $$
begin
    if new.time_1 = new.time_2 then
        raise exception 'Não é permitido jogos entre o mesmo time';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger insert_partida
before insert on partida
for each row
execute function insert_partida();

insert into partida(id, time_1, time_2, time_1_gols, time_2_gols) values (10, 1, 1, 1, 0);


-- Instead of é utilizado para fazer trigger em visões

create view v_partidas AS
select id, time_1, time_2, time_1_gols, time_2_gols from partida;
-- Para permitir inserções na 
create or replace function insert_v_partida()
returns trigger as $$
begin
    insert into partida(id, time_1, time_2, time_1_gols, time_2_gols) values (new.id, new.time_1, new.time_2, new.time_1_gols, new.time_2_gols);
    return null;
end;
$$ language plpgsql;

create trigger insert_v_partida
instead of insert on v_partidas
for each row
execute function insert_v_partida();

insert into v_partidas(id, time_1, time_2, time_1_gols, time_2_gols) values (11, 1, 2, 1, 0);


create or replace function update_partida()
returns trigger as $$
begin
    insert into log_partida(partida_id, acao) values (new.id, 'UPDATE');
    return new;
end;
$$ language plpgsql;

create trigger update_partida
after update on partida
for each row
execute function update_partida();

update partida set time_1_gols = 2 where id = 11;
select * from log_partida;


-- Trigger que impede de fazer update em partidas que ja foram finalizadas
create or replace function validar_update_partida()
returns trigger as $$
begin
    if old.time_1_gols is not null then
        raise exception 'Não é permitido alterar partidas já finalizadas';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger validar_update_partida
before update on partida
for each row
execute function validar_update_partida();


create or replace function delete_partida()
returns trigger as $$
begin
    raise exception 'Não é permitido deletar partidas';
end;
$$ language plpgsql;

create trigger delete_partida
before delete on partida
for each row
execute function delete_partida();

delete from partida where id = 5;
select * from partida where id = 5;