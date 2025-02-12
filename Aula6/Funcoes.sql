-- Função
-- São blocos de código que podem ser chamados para executar uma tarefa especifica
-- Aceitam parametros e podem ser definidas pelo usuário ou ser chamadas funções embutidas
-- Funções embutidas são as que estão disponíveis no bd
-- 3 Tipos: Matemáticas, Datas e String

-- Matemáticas:
select abs(-10); -- Retorna valor absoluto do número
select round(10.5); -- Arredonda para o número inteiro mais próximo
select trunc(12.7);  -- retorna apenas o número inteiro
select power(2,3) -- retorna valor exponencial
select ln(100); -- retorna o logaritmo natural do número

-- Manipulação de String
select concat('conca', 'tenação'); -- Concatenação de strings
select length('teste'); -- retorna o comprimento da string
select lower('TESTE'); -- retorna a string minuscula
select upper('teste'); -- retorna a string maiuscula
select ltrim('   teste'); -- remove o espaço a esquerda da string
select rtrim('teste   '); -- remove o espaço a direita da string
select reverse('teste'); -- inverte a string

-- Data
select current_date; -- Data atual do servidor
select extract(year from current_date); -- Extrai ano da data atual
select extract(month from current_date); -- Mês
select extract(day from current_date); -- Dia
select age('2025-01-01', '2002-02-02'); -- mostra a diferença entre as duas datas

-- Funções definidas por usuário
create function soma(a integer, b integer) returns integer as $$
begin
    return a + b;
end
$$ language plpgsql;

select soma(partida.time_1, partida.time_2) from partida;

-- Operação de insert nas funções
create or replace function insere_partida (id integer, time_1 integer, time_2 integer, time_1_gols integer, time_2_gols integer) returns void as $$
begin
    insert into partida(id, time_1, time_2, time_1_gols, time_2_gols) values (id, time_1, time_2, time_1_gols, time_2_gols);
end;
$$ language plpgsql;

select insere_partida(10,2,1,2,1);

create or replace function consulta_time() 
returns setof time as $$
begin
    return query 
    select * from time;
end;
$$ language plpgsql;

select * from consulta_time();

-- Função com variavel interna
create or replace function consulta_vencedor_por_time(id_time integer) returns varchar(50) as $$
declare
    vencedor varchar(50);
begin
    select case
        when time_1_gols > time_2_gols then (select nome from time where id = time_1)
        when time_1_gols < time_2_gols then (select nome from time where id = time_2)
        else 'Empate'
    end into vencedor
    from partida
    where time_1 = id_time or time_2 = id_time;
    return vencedor;
end;
$$ language plpgsql;
