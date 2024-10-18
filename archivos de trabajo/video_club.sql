create schema if not exists  mrivas_entrega;

set schema 'mrivas_entrega';

drop table if exists alquiler cascade;

drop table if exists copias_pelicula cascade;

drop table if exists direcciones cascade;

drop table if exists directores cascade;

drop table if exists generos cascade;

drop table if exists peliculas cascade;

drop table if exists socios cascade;



CREATE TABLE if not exists socios (
    socio_id SERIAL PRIMARY KEY,
    identificacion VARCHAR(20) NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellidos VARCHAR(40) NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono VARCHAR(12) NOT null,
    direccion_id INT not null
);


CREATE TABLE if not exists direcciones (
    direccion_id SERIAL PRIMARY KEY,
    codigo_postal INT NULL,
    calle VARCHAR(50) NOT NULL,
    numero VARCHAR(5) NULL,
    piso VARCHAR(3) NULL
);


CREATE TABLE if not exists generos (
    genero_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE if not exists directores (
    director_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE if not exists peliculas (
    pelicula_id SERIAL PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    director_id INT NOT NULL,
    genero_id INT NOT NULL,
    sinopsis TEXT NOT NULL
);

CREATE TABLE if not exists copias_pelicula (
    copia_id SERIAL PRIMARY KEY,
    pelicula_id INT not NULL,
    activa BOOLEAN
);

CREATE TABLE if not exists alquiler (
    alquiler_id SERIAL PRIMARY KEY,
    socio_id INT NOT NULL ,
    copia_id INT NOT NULL,
    fecha_alquiler DATE NOT NULL,
    fecha_devolucion DATE
);


-- Unico para identificacion en Persona
alter table socios
add constraint direccion_socio_fk 
foreign key (direccion_id) 
references direcciones(direccion_id);

alter table peliculas
add constraint director_pelicula_fk 
foreign key (director_id) references 
directores(director_id);

alter table peliculas
add constraint genero_pelicula_fk 
foreign key (genero_id) references 
generos(genero_id);

alter table copias_pelicula 
add constraint pelicula_copia_fk 
foreign key (pelicula_id) references 
peliculas(pelicula_id);


alter table alquiler 
add constraint copia_alquiler_fk 
foreign key (copia_id) references 
copias_pelicula(copia_id);

alter table alquiler 
add constraint socio_alquiler_fk 
foreign key (socio_id) references 
socios(socio_id);

create unique index index_idenfiticacion_socio on socios(lower(identificacion)); 
-- Inserción de registros en la tabla direccion (30 registros)

INSERT INTO direcciones (codigo_postal, calle, numero, piso) VALUES
(12345, 'Calle 1', '10', '1A'),
(23456, 'Calle 2', '20', '2B'),
(34567, 'Calle 3', '30', '3C'),
(45678, 'Calle 4', '40', '4D'),
(56789, 'Calle 5', '50', '5E'),
(67890, 'Calle 6', '60', '6F'),
(78901, 'Calle 7', '70', '7G'),
(89012, 'Calle 8', '80', '8H'),
(90123, 'Calle 9', '90', '9I'),
(11234, 'Calle 10', '100', '10J'),
(22345, 'Calle 11', '110', '11K'),
(33456, 'Calle 12', '120', '12L'),
(44567, 'Calle 13', '130', '13M'),
(55678, 'Calle 14', '140', '14N'),
(66789, 'Calle 15', '150', '15O'),
(77890, 'Calle 16', '160', '16P'),
(88901, 'Calle 17', '170', '17Q'),
(99012, 'Calle 18', '180', '18R'),
(10123, 'Calle 19', '190', '19S'),
(21234, 'Calle 20', '200', '20T'),
(32345, 'Calle 21', '210', '21U'),
(43456, 'Calle 22', '220', '22V'),
(54567, 'Calle 23', '230', '23W'),
(65678, 'Calle 24', '240', '24X'),
(76789, 'Calle 25', '250', '25Y'),
(87890, 'Calle 26', '260', '26Z'),
(98901, 'Calle 27', '270', '27A'),
(10112, 'Calle 28', '280', '28B'),
(20234, 'Calle 29', '290', '29C'),
(30345, 'Calle 30', '300', '30D');

select * from direcciones d ;


-- Inserción de registros en la tabla socios (30 registros)
INSERT INTO socios (identificacion, nombre, apellidos, fecha_nacimiento, telefono, direccion_id) VALUES
(1001, 'Juan', 'Pérez', '1980-01-01', '555123456', 1),
(1002, 'María', 'González', '1985-02-02', '555234567', 2),
(1003, 'Luis', 'López', '1990-03-03', '555345678', 3),
(1004, 'Ana', 'Martínez', '1995-04-04', '555456789', 4),
(1005, 'Pedro', 'Rodríguez', '2000-05-05', '555567890', 5),
(1006, 'Carmen', 'Fernández', '1981-06-06', '555678901', 6),
(1007, 'Carlos', 'Gómez', '1982-07-07', '555789012', 7),
(1008, 'Elena', 'Ruiz', '1983-08-08', '555890123', 8),
(1009, 'Laura', 'García', '1984-09-09', '555901234', 9),
(1010, 'Pablo', 'Vega', '1986-10-10', '555012345', 10),
(1011, 'Antonio', 'Ramos', '1987-11-11', '555123456', 11),
(1012, 'Marta', 'Torres', '1988-12-12', '555234567', 12),
(1013, 'Ricardo', 'Díaz', '1989-01-13', '555345678', 13),
(1014, 'Ángela', 'Navarro', '1991-02-14', '555456789', 14),
(1015, 'Julio', 'Ortiz', '1992-03-15', '555567890', 15),
(1016, 'Sara', 'Sánchez', '1993-04-16', '555678901', 16),
(1017, 'Adrián', 'Castro', '1994-05-17', '555789012', 17),
(1018, 'Sofía', 'Alonso', '1995-06-18', '555890123', 18),
(1019, 'Diego', 'Moreno', '1996-07-19', '555901234', 19),
(1020, 'Isabel', 'Vargas', '1997-08-20', '555012345', 20),
(1021, 'Víctor', 'Reyes', '1998-09-21', '555123456', 21),
(1022, 'Alejandra', 'Herrera', '1999-10-22', '555234567', 22),
(1023, 'Daniel', 'Jiménez', '2000-11-23', '555345678', 23),
(1024, 'Raúl', 'Iglesias', '1981-12-24', '555456789', 24),
(1025, 'Teresa', 'Serrano', '1982-01-25', '555567890', 25),
(1026, 'Héctor', 'Vera', '1983-02-26', '555678901', 26),
(1027, 'Victoria', 'Domínguez', '1984-03-27', '555789012', 27),
(1028, 'Óscar', 'Márquez', '1985-04-28', '555890123', 28),
(1029, 'Lucía', 'Guerrero', '1986-05-29', '555901234', 29),
(1030, 'Alberto', 'Mendoza', '1987-06-30', '555012345', 30);


select * from socios;

-- Inserción de géneros
INSERT INTO generos (nombre) VALUES 
('Acción'), 
('Drama'), 
('Comedia'), 
('Terror'), 
('Ciencia Ficción');

select * from generos;

-- Inserción de directores
INSERT INTO directores (nombre) VALUES 
('Steven Spielberg'), 
('Quentin Tarantino'), 
('Christopher Nolan'), 
('Martin Scorsese'), 
('Ridley Scott');

select * from directores;

-- Inserción de 50 registros en la tabla pelicula
INSERT INTO peliculas (titulo, director_id, genero_id, sinopsis) VALUES
('Película 1', 1, 1, 'Sinopsis de Película 1'),
('Película 2', 2, 2, 'Sinopsis de Película 2'),
('Película 3', 3, 3, 'Sinopsis de Película 3'),
('Película 4', 4, 4, 'Sinopsis de Película 4'),
('Película 5', 5, 5, 'Sinopsis de Película 5'),
('Película 6', 1, 1, 'Sinopsis de Película 6'),
('Película 7', 2, 2, 'Sinopsis de Película 7'),
('Película 8', 3, 3, 'Sinopsis de Película 8'),
('Película 9', 4, 4, 'Sinopsis de Película 9'),
('Película 10', 5, 5, 'Sinopsis de Película 10'),
('Película 11', 1, 1, 'Sinopsis de Película 11'),
('Película 12', 2, 2, 'Sinopsis de Película 12'),
('Película 13', 3, 3, 'Sinopsis de Película 13'),
('Película 14', 4, 4, 'Sinopsis de Película 14'),
('Película 15', 5, 5, 'Sinopsis de Película 15'),
('Película 16', 1, 1, 'Sinopsis de Película 16'),
('Película 17', 2, 2, 'Sinopsis de Película 17'),
('Película 18', 3, 3, 'Sinopsis de Película 18'),
('Película 19', 4, 4, 'Sinopsis de Película 19'),
('Película 20', 5, 5, 'Sinopsis de Película 20'),
('Película 21', 1, 1, 'Sinopsis de Película 21'),
('Película 22', 2, 2, 'Sinopsis de Película 22'),
('Película 23', 3, 3, 'Sinopsis de Película 23'),
('Película 24', 4, 4, 'Sinopsis de Película 24'),
('Película 25', 5, 5, 'Sinopsis de Película 25'),
('Película 26', 1, 1, 'Sinopsis de Película 26'),
('Película 27', 2, 2, 'Sinopsis de Película 27'),
('Película 28', 3, 3, 'Sinopsis de Película 28'),
('Película 29', 4, 4, 'Sinopsis de Película 29'),
('Película 30', 5, 5, 'Sinopsis de Película 30'),
('Película 31', 1, 1, 'Sinopsis de Película 31'),
('Película 32', 2, 2, 'Sinopsis de Película 32'),
('Película 33', 3, 3, 'Sinopsis de Película 33'),
('Película 34', 4, 4, 'Sinopsis de Película 34'),
('Película 35', 5, 5, 'Sinopsis de Película 35'),
('Película 36', 1, 1, 'Sinopsis de Película 36'),
('Película 37', 2, 2, 'Sinopsis de Película 37'),
('Película 38', 3, 3, 'Sinopsis de Película 38'),
('Película 39', 4, 4, 'Sinopsis de Película 39'),
('Película 40', 5, 5, 'Sinopsis de Película 40'),
('Película 41', 1, 1, 'Sinopsis de Película 41'),
('Película 42', 2, 2, 'Sinopsis de Película 42'),
('Película 43', 3, 3, 'Sinopsis de Película 43'),
('Película 44', 4, 4, 'Sinopsis de Película 44'),
('Película 45', 5, 5, 'Sinopsis de Película 45'),
('Película 46', 1, 1, 'Sinopsis de Película 46'),
('Película 47', 2, 2, 'Sinopsis de Película 47'),
('Película 48', 3, 3, 'Sinopsis de Película 48'),
('Película 49', 4, 4, 'Sinopsis de Película 49'),
('Película 50', 5, 5, 'Sinopsis de Película 50');

select * from peliculas p ;

-- Inserción de 5 copias por cada película
DO $$ 
DECLARE
    pelicula_id INT;
BEGIN
    FOR pelicula_id IN 1..50 LOOP
        INSERT INTO copias_pelicula (pelicula_id, activa) 
        VALUES (pelicula_id, TRUE),
               (pelicula_id, TRUE),
               (pelicula_id, TRUE),
               (pelicula_id, TRUE),
               (pelicula_id, TRUE);
    END LOOP;
END $$;

select * from copias_pelicula cp ;


-- Selección de los socios para alquiler (80% de 30 = 24 socios)
WITH socios_para_alquiler AS (
    SELECT socio_id FROM socios
    ORDER BY random()
    LIMIT 24
),
copias_para_alquiler AS (
    SELECT copia_id FROM copias_pelicula
    ORDER BY random()
    LIMIT 120 -- 5 copias de 24 películas
)
-- Insertar alquileres según los porcentajes
INSERT INTO alquiler (socio_id, copia_id, fecha_alquiler, fecha_devolucion)
SELECT sp.socio_id, cp.copia_id, 
       NOW() - INTERVAL '5 days', 
       CASE 
           WHEN RANDOM() < 0.8 THEN NOW()
           ELSE NULL 
       END 
FROM socios_para_alquiler sp, copias_para_alquiler cp
LIMIT 120; -- Control de duplicados

select * from alquiler a ;

-- peliculas no rentadas
SELECT cp.copia_id,
    p.pelicula_id, 
    p.titulo, 
    d.nombre AS director, 
    g.nombre AS genero
FROM 
    peliculas p
JOIN 
    copias_pelicula cp ON p.pelicula_id = cp.pelicula_id
LEFT JOIN 
    alquiler a ON cp.copia_id = a.copia_id
JOIN 
    directores d ON p.director_id = d.director_id
JOIN 
    generos g ON p.genero_id = g.genero_id
WHERE 
    a.copia_id IS NULL; -- Solo selecciona copias que no están en alquiler

-- peliculas rentadas
    
    SELECT cp.copia_id,
    p.pelicula_id, 
    p.titulo, 
    d.nombre AS director, 
    g.nombre AS genero
FROM 
    peliculas p
JOIN 
    copias_pelicula cp ON p.pelicula_id = cp.pelicula_id
LEFT JOIN 
    alquiler a ON cp.copia_id = a.copia_id
JOIN 
    directores d ON p.director_id = d.director_id
JOIN 
    generos g ON p.genero_id = g.genero_id
WHERE 
    a.copia_id IS not NULL; -- Solo selecciona copias que no están en alquiler
    
    
    select * 
    from copias_pelicula cp
    inner join peliculas p on p.pelicula_id = cp.pelicula_id 