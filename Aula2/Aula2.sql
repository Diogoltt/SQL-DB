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

alter table cargo add column salario decimal(10,2);
alter table cargo alter column nome type varchar(100);

insert into usuario values (1, 'Joao', 'joao@gmail.com');
insert into usuario values (2, 'maria', 'maria@gmail.com');
insert into usuario values (3, 'teste', 'teste@gmail.com');

insert into cargo values (1, 'Analista de sistemas', 1, 5000.00);
insert into cargo values (2, 'Analista de banco de dados', 1, 6000.00);
insert into cargo values (3, 'Analista de redes', 2, 7000.00)

select * from cargo;
select * from usuario;

select cargo.nome from cargo;
select cargo.id from cargo;

select c.nome from cargo c;
select c.nome, u.nome from cargo c, usuario u;

select c.nome from cargo c where id = 1;
select u.nome from usuario u where u.nome = 'Joao';

select u.nome from usuario u where u.id = 1 or u.id = 2;


select u.id from usuario u where nome between 'João' and 'José';

select u.id, u.nome from usuario u where nome like 'Jo%';

select u.id, u.nome from usuario u where nome like '%ao';

select u.id, u.nome from usuario u where id > 1;
select u.id, u.nome from usuario u where id >= 1;

select u.id, u.nome from usuario u where id > 1 and id < 3;

select u.id, u.nome from usuario u order by id desc;
select u.id, u.nome from usuario u order by id asc;
select u.id, u.nome from usuario u order by nome;

select * from usuario limit 2;

select c.nome, u.nome, count(c.id) from usuario u, cargo c
where u.id = c.fk_usuario group by c.nome, u.id;

drop TABLE usuario cascade;
drop TABLE cargo cascade;
