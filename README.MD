
# Proyecto Videoclub - Gestión de Películas y Alquileres

Este proyecto se enfoca en la creación de un esquema para gestionar un sistema de videoclub, incluyendo la gestión de películas, copias de películas, socios, direcciones, géneros, directores y alquileres.

## Esquema y Tablas

El esquema del proyecto se denomina `mrivas_entrega` y contiene las siguientes tablas:

- **socios**: Información de los socios del videoclub.
- **direcciones**: Almacena las direcciones de los socios.
- **generos**: Categorías de películas.
- **directores**: Información de los directores de las películas.
- **peliculas**: Detalles de las películas, incluyendo su género y director.
- **copias_pelicula**: Almacena las copias físicas de las películas disponibles en el videoclub.
- **alquiler**: Registra los alquileres realizados por los socios.
- **tmp_videoclub**: Tabla temporal para importar y procesar los datos antes de insertarlos en las tablas finales.

## Estructura de las Tablas

### socios
Almacena la información básica de los socios del videoclub.

```sql
CREATE TABLE if not exists socios (
    socio_id SERIAL PRIMARY KEY,
    identificacion VARCHAR(20) NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellidos VARCHAR(40) NULL,
    fecha_nacimiento DATE NULL,
    telefono VARCHAR(12) NULL,
    direccion_id INT NOT NULL,
    correo VARCHAR(100) NULL
);
```

### direcciones
Guarda las direcciones asociadas a los socios.

```sql
CREATE TABLE if not exists direcciones (
    direccion_id SERIAL PRIMARY KEY,
    calle VARCHAR(50) NOT NULL,
    numero VARCHAR(5) NULL,
    piso VARCHAR(5) NULL,
    ext varchar(10) NULL,
    codigo_postal VARCHAR(5) NULL
);
```

### generos
Almacena los géneros de las películas.

```sql
CREATE TABLE if not exists generos (
    genero_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);
```

### directores
Almacena la información sobre los directores de las películas.

```sql
CREATE TABLE if not exists directores (
    director_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);
```

### peliculas
Almacena información detallada sobre las películas, incluyendo su género y director.

```sql
CREATE TABLE if not exists peliculas (
    pelicula_id SERIAL PRIMARY KEY,
    titulo VARCHAR(60) NOT NULL,
    director_id INT NOT NULL,
    genero_id INT NOT NULL,
    sinopsis TEXT NOT NULL
);
```

### copias_pelicula
Almacena información sobre las copias físicas de las películas.

```sql
CREATE TABLE if not exists copias_pelicula (
    copia_id INT PRIMARY KEY,
    pelicula_id INT NOT NULL,
    activa BOOLEAN
);
```

### alquiler
Registra los alquileres realizados por los socios.

```sql
CREATE TABLE if not exists alquiler (
    alquiler_id SERIAL PRIMARY KEY,
    socio_id INT NOT NULL,
    copia_id INT NOT NULL,
    fecha_alquiler DATE NOT NULL,
    fecha_devolucion DATE
);
```

### tmp_videoclub
Tabla temporal para almacenar los datos antes de procesarlos e insertarlos en las tablas finales.

```sql
CREATE TABLE tmp_videoclub (
	id_copia INT4 NULL,
	fecha_alquiler_texto DATE NULL,
	dni VARCHAR(50) NULL,
	nombre VARCHAR(50) NULL,
	apellido_1 VARCHAR(50) NULL,
	apellido_2 VARCHAR(50) NULL,
	email VARCHAR(50) NULL,
	telefono VARCHAR(50) NULL,
	codigo_postal VARCHAR(5) NULL,
	fecha_nacimiento VARCHAR(50) NULL,
	numero VARCHAR(5) NULL,
	piso VARCHAR(5) NULL,
	letra VARCHAR NULL,
	calle VARCHAR NULL,
	ext VARCHAR(50) NULL,
	titulo VARCHAR(80) NULL,
	genero VARCHAR(50) NULL,
	sinopsis TEXT NULL,
	director VARCHAR(80) NULL,
	fecha_alquiler DATE NULL,
	fecha_devolucion DATE NULL
);
```

## Relaciones y Constraints

- La tabla `socios` tiene una relación con la tabla `direcciones` a través de `direccion_id`.
- La tabla `peliculas` tiene relaciones con las tablas `directores` y `generos`.
- La tabla `copias_pelicula` tiene una relación con la tabla `peliculas`.
- La tabla `alquiler` tiene relaciones con las tablas `socios` y `copias_pelicula`.

## Índices y Restricciones Únicas

- Un índice único se crea para evitar que dos socios tengan la misma identificación:
  
  ```sql
  create unique index index_idenfiticacion_socio on socios(lower(identificacion));
  ```

- Para evitar direcciones duplicadas, se crea una restricción única en la tabla `direcciones`:

  ```sql
  ALTER TABLE direcciones
  ADD CONSTRAINT unique_direccion UNIQUE (calle, numero, piso, ext, codigo_postal);
  ```

## Población de Datos

### Directores

```sql
INSERT INTO directores (nombre)
SELECT DISTINCT director FROM tmp_videoclub;
```

### Géneros

```sql
INSERT INTO generos (nombre)
SELECT DISTINCT genero FROM tmp_videoclub;
```

### Películas

```sql
INSERT INTO peliculas (titulo, director_id, genero_id, sinopsis)
SELECT DISTINCT tv.titulo, d.director_id, g.genero_id, tv.sinopsis
FROM tmp_videoclub tv
LEFT JOIN generos g ON g.nombre = tv.genero
LEFT JOIN directores d ON d.nombre = tv.director;
```

### Copias de Películas

```sql
INSERT INTO copias_pelicula (copia_id, pelicula_id)
SELECT DISTINCT tv.id_copia, p.pelicula_id
FROM tmp_videoclub tv
LEFT JOIN peliculas p ON p.titulo = tv.titulo
ORDER BY tv.id_copia;
```

### Direcciones

```sql
INSERT INTO direcciones (calle, numero, piso, ext, codigo_postal)
SELECT DISTINCT tv.calle, tv.numero, tv.piso, tv.ext, tv.codigo_postal
FROM tmp_videoclub tv
ON CONFLICT (calle, numero, piso, ext, codigo_postal) DO NOTHING;
```

### Socios

```sql
INSERT INTO socios (identificacion, nombre, apellidos, fecha_nacimiento, telefono, direccion_id, correo)
SELECT DISTINCT tv.dni, tv.nombre, CONCAT(tv.apellido_1, ' ', tv.apellido_2), 
CAST(tv.fecha_nacimiento AS DATE), tv.telefono, d.direccion_id, tv.email
FROM tmp_videoclub tv
JOIN direcciones d ON tv.calle = d.calle AND tv.numero = d.numero 
  AND tv.piso = d.piso AND tv.ext = d.ext AND tv.codigo_postal = d.codigo_postal;
```

### Alquiler

```sql
INSERT INTO alquiler (socio_id, copia_id, fecha_alquiler, fecha_devolucion)
SELECT DISTINCT s.socio_id, cp.copia_id, tv.fecha_alquiler, tv.fecha_devolucion
FROM tmp_videoclub tv
JOIN socios s ON tv.dni = s.identificacion
JOIN copias_pelicula cp ON tv.id_copia = cp.copia_id;
```

## Consultas de Películas Disponibles

Para consultar las películas que tienen copias disponibles (no alquiladas), se utiliza la siguiente consulta:

```sql
SELECT p.pelicula_id, p.titulo, d.nombre AS director, g.nombre AS genero, 
COUNT(cp.copia_id) AS copias_disponibles
FROM peliculas p
JOIN copias_pelicula cp ON p.pelicula_id = cp.pelicula_id
LEFT JOIN alquiler a ON cp.copia_id = a.copia_id AND a.fecha_devolucion IS NULL
JOIN directores d ON p.director_id = d.director_id
JOIN generos g ON p.genero_id = g.genero_id
WHERE a.copia_id IS NULL
GROUP BY p.pelicula_id, p.titulo, d.nombre, g.nombre;
```

## Contacto

Para cualquier duda o consulta, puedes ponerte en contacto con el desarrollador del proyecto.

