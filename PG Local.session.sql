create table usuario (
	id int not null,
	nome varchar(50),
	email varchar(100),
	primary key(id)
)

create table cargo (
    id int not null,
    nome varchar(50),
    primary key(id),
    fk_usuario int,
    constraint fk_cargo_usuario foreign key(fk_usuario)
    references usuario(id)
);

-- Alterar tabela
alter table cargo add column salario decimal(10,2);
alter table cargo alter column nome type varchar(100);
alter table cargo drop column salario;

-- Excluir tabela
drop table cargo;
drop table usuario;

-- Inserir dados
insert into usuario values (1, 'Joao', 'joao@gmail.com');
insert into usuario values (2, 'maria', 'maria@gmail.com');
insert into usuario values (3, 'teste', 'teste@gmail.com');

insert into cargo values (1, 'Analista de sistemas', 1, 5000.00);
insert into cargo values (2, 'Analista de banco de dados', 1, 6000.00);
insert into cargo values (3, 'Analista de redes', 2, 7000.00)
-- Atualizar os dados
update cargo set salario = 6500.00 where id = 2;
update usuario set nome = 'Diogo' where id = 1;

-- Excluir dados
delete from usuario where id = 3;

select * from usuario;
select * from cargo;

-- Left join que retorna todos os usuários e seus cargos
-- unindo os registros da tabela da esquerda (usuário) e 
-- os registros da tabela da direita (cargo)
select * from usuario left join cargo on usuario.id = cargo.fk_usuario;


select * from usuario right join cargo on usuario.id = cargo.fk_usuario;

-- Inner join que retorna todos os registros quando houver uma correspondência entre as tabelas
select * from usuario inner join cargo on usuario.id = cargo.fk_usuario;