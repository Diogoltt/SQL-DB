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

-- C2.1 - Crie uma view vpartida que retorne a tabela de partida adicionando as colunas
-- nome_time_1 e nome_time_2 com o nome dos times.
create or replace view vpartida as
select partida.id, partida.time_1 as id_time_1, partida.time_2 as id_time_2, partida.time_1_gols, partida.time_2_gols, time1.nome as nome_time_1, time2.nome as nome_time_2
from partida
join time time1 on partida.time_1 = time1.id
join time time2 on partida.time_2 = time2.id
order by id asc;

-- C2.2 Realize uma consulta em vpartida que retorne somente os jogos de times que possuem nome que começam com A ou C participaram.
select nome_time_1, nome_time_2, time_1_gols, time_2_gols
from vpartida
where nome_time_1 like 'C%' or nome_time_1 like 'A%' and nome_time_2 like 'C%' or nome_time_2 like 'A%'
order by nome_time_1, nome_time_2 asc

select * from vpartida

-- C2.3 Crie uma view, utilizando a view vpartida que retorne uma coluna de classificação
-- com o nome do ganhador da partida, ou 'Empate'.
create or replace view vclassificacao as
select id as id_partida, nome_time_1, nome_time_2,
case
    when time_1_gols > time_2_gols then nome_time_1
    when time_2_gols > time_1_gols then nome_time_2
    else 'EMPATE'
end as classificacao_vencedor
from vpartida
order by classificacao_vencedor desc;

-- C2.4 - Crie uma view vtime que retorne a tabela de time adicionando as colunas
-- partidas, vitorias, derrotas, empates e pontos.
create or replace view vtime as
select time.id, time.nome,
(select count(time_1) from partida where time_1 = time.id) + (select count(time_2) from partida where time_2 = time.id) as partidas,
(select sum(case when time_2_gols > time_1_gols then 1 else 0 end) from partida where time_2 = time.id) + (select sum(case when time_1_gols > time_2_gols then 1 else 0 end) from partida where time_1 = time.id) as vitorias,
(select sum(case when time_2_gols < time_1_gols then 1 else 0 end) from partida where time_2 = time.id) + (select sum(case when time_1_gols < time_2_gols then 1 else 0 end) from partida where time_1 = time.id) as derrotas,
(select sum(case when time_2_gols = time_1_gols then 1 else 0 end) from partida where time_2 = time.id) + (select sum(case when time_1_gols = time_2_gols then 1 else 0 end) from partida where time_1 = time.id) as empates,
(select sum(case when time_2_gols > time_1_gols then 3 when time_2_gols = time_1_gols then 1 else 0 end) from partida where time_2 = time.id) + (select sum(case when time_2_gols < time_1_gols then 3 when time_2_gols = time_1_gols then 1 else 0 end) from partida where time_1 = time.id) as pontos
from time
order by pontos desc;