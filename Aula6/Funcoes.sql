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


-- Tabela Temporária: armazenam dados temporários, e que são de única sessão de bd
create temporary table temp_time as select * from time;



drop table temp_Jogo cascade

select * from temp_time;

truncate table temp_time;


-- Operações nas funções
-- 1. Criar variáveis dentro da função e imprimir
create or replace function operacao_funcao() returns void as $$
declare -- declare é para declarar 
    v_id integer;
    v_nome varchar(50);
begin
    -- Atribuir valores nas variáveis
    /* v_id := 1;
    v_nome := 'CORINTHIANS';
    raise notice 'ID: %, Nome: %', v_id, v_nome;
 */
    v_id := v_id + 1;
    raise notice 'Soma: %', 1 + 1;
    raise notice 'Subtração %', 1 - 1;
    raise notice 'Multiplicação: %', 1 * 1;
    raise notice 'Divisão: %', 1 / 1;

    raise notice 'Maior: %', 1 > 1;
    raise notice 'Menor: %', 1 < 1;
    raise notice 'Maior ou igual: %', 1 >= 1;
    raise notice 'Menor ou igual: %', 1 <= 1;
    raise notice 'Igual: %', 1 = 1;
    raise notice 'Diferente: %', 1 <> 1;

    raise notice 'Concatenação: %', 'Teste' || 'Aula';

    raise notice 'E: %', true and true;
    raise notice 'Ou: %', true or false;
    raise notice 'Não: %', not true;

    raise notice 'Tamanho da String: %', length('Aula Teste');
    raise notice 'Substituir: %', replace('Aula Teste', 'Teste', 'Postgres');
    raise notice 'Posição: %', position('Teste' in 'Aula Teste');
    raise notice 'Sub string: %', substring('Aula Teste', 6, 5);
    raise notice 'Maiuscula: %', upper('Aula Teste');
    raise notice 'Minuscula: %', lower('Aula Teste');

    raise notice 'Data Atual: %', now();
    raise notice 'Data Atual: %', current_date;
    raise notice 'Hora Atual: %', current_time;

    raise notice 'Array: %', Array[1,2,3,4,5];
    raise notice 'Array: %', Array['Aula', 'Teste'];
    raise notice 'Matriz: %', Array[[1,2,3],[4,5,6]];

    raise notice 'JSON: %', '{"nome"; "Aula Teste"}';
end;
$$ language plpgsql;

select operacao_funcao();


create or replace function obter_nome_time(p_id integer) returns varchar as $$
declare
    v_nome varchar(50);
begin
    select nome into v_nome from time where id = p_id;
    return v_nome;
end;
$$ language plpgsql;

select obter_nome_time(1);


create or replace function obter_times() returns setof time as $$
declare
    i int := 1;
begin
    /* Loop -- Equivale ao while
        exit when i > 5; -- Condição de saída do loop
        raise notice 'Valor de i: %', i;
        i := i + 1;
    end Loop; */
    
    for i in 1..5 loop -- Equivale ao for, íntervalo de 1 a 5
        raise notice 'Valor de i: %', i;
        i := i + 1;
    end loop;
end;
$$ language plpgsql;

select obter_times();


create or replace function obter_times_dados() returns setof time as $$
declare
    v_time time%rowtype; -- %rowtype para pegar o tipo da variavel da tabela
begin
    for v_time in select * from time loop -- Percorrer todos os registros da tabela
        return next v_time;
    end loop;
end;
$$ language plpgsql;

select obter_times_dados();


create or replace function gols() returns setof time as $$
declare
    v_gols integer;
    begin
        select time_1_gols into v_gols from partida where id = 1;
        if v_gols > 2 then
            raise notice 'Time marcou mais de 2 gols';
        else
            raise notice 'Time marcou menos de 2 gols';
        end if;
    end;
$$ language plpgsql;


create or replace function gols() returns setof time as $$
declare
    v_gols integer;
    begin
        select time_1_gols into v_gols from partida where id = 1;
        case
            when v_gols > 2 then
                raise notice 'Time marcou mais de 2 gols';
            else
                raise notice 'Time marcous menos de 2 gols';
        end case;
    end;
$$ language plpgsql;

select gols();


create or replace function obter_nome_time_excecao(id_time_nome integer) returns varchar as $$
declare
    v_nome varchar(50);
begin
    select nome into v_nome from time where id = id_time_nome;
    return v_nome;
    exception
    when No_Data_Found then
        raise notice 'Nenhum registro encontrado';
end;
$$ language plpgsql;

select obter_nome_time_excecao(2);