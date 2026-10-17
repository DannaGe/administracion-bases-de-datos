use danna;

create table productos(
	id integer,
    nombre varchar(50),
    primary key(id)
);

insert into productos values(100, 'Naideline');
insert into productos values(200, 'Gabriela');
insert into productos values(300, 'Jaime');
insert into productos values(400, 'Santiago');
insert into productos values(500, 'Alejandro');
insert into productos values(600, 'Julian');
insert into productos values(700, 'Catalana');
insert into productos values(800, 'Jesus');
insert into productos values(900, 'David');


select * from productos;