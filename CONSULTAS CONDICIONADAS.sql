-- se crea la base de datos 
create database datawarehouse;

use datawarehouse;

-- SE CREA LA TABLA FACTURA
     create table factura( 
 id_factura serial primary key,
 id_cliente int,
 id_producto int,
cantidad int,
fecha_factura date);

# SE INSERTAN LOS VALORES A LA TABLA FACTURA 
 INSERT INTO factura (id_factura, id_cliente, id_producto, cantidad, fecha_factura)
VALUES (1, 2, 3, 8, '2025-01-16'),
       (2, 3, 4, 10, '2025-01-18'),
       (3, 4, 5, 12, '2025-02-20'),
       (4, 5, 6, 9, '2025-02-21'),
       (5, 6, 7, 2, '2025-02-23'),
       (6, 7, 8, 52, '2025-02-26'),
       (7, 8, 9, 100, '2025-02-28');
    
    # SE HACE LA CONSULTA DE LA TABLA FACTURA 
       select * from factura;
       
       
# SE CREA LA TABLA VENTAS 
  create table ventas (
id_ventas serial primary key,
id_producto int,
cantidad int,
precio_unitario decimal(10, 2),
total decimal (10, 2),
fecha_venta Date,
id_cliente int
);

#SE INSERTAN LOS VALORES DE LA TABLA VENTAS  
insert into ventas (id_producto,cantidad,precio_unitario,total,fecha_venta,id_cliente)
values 
(1, 5, 10.50, 52.50, '2024-04-01'),
    (2, 3, 8.75, 26.25, '2024-04-02'),
    (1, 2, 11.25, 22.50, '2024-04-03'),
    (3, 1, 15.00, 15.00, '2024-04-04'),
    (4, 12, 8.00, 8.00,   '2024-04-03'),
     (5, 13,9.300, 9.300,  '2024-04-02'),                        
     (6,  8, 10.00,  10.00,   '2024-04-01');
   
   # SE HACE LA CONSULTA DE LA TABLA VENTAS
  select * from ventas;
  
  # SE CREA LA TABLA PRODUCTO
  create table producto (
  id_producto serial primary key,
  nombre varchar(100),
  categoria varchar(50),
  precio numeric(10,2),
  descripcion text,
  marca varchar (50),
  fecha_creacion date );
  
  # SE INSERTAN LOS VALORES EN LA TABLA PRODUCTO 
insert into producto (id_producto,nombre,categoria,precio,descripcion,marca,fecha_creacion)
values 
(1,  'producto A', 'electrodomes','99.99','descripcion del producto A', 'x', '2024-04-26'),
(2,  'producto B', 'ropa',        '88.89', 'descripcion del producto B', 'AA','2024-04-26'),
(3,  'producto C', 'hogar',       '45.45',  'descripcion del producto C', 'xx','2024-04-26'),
(4,  'producto D', 'zapatos',      '29.99',  'descripcion del producto D', 'z',  '2024-04-26'),
(5,  'producto E', 'portatil',      '2858',   'descripcion del producto E', 'zz', '2024-04-26'),
(6,  'producto F',  'lentes',        '72.62',  'descripcion del producto F', 'A',  '2024-04-26');

    # SE HACE CONSULTA DE LA TABLA PRODUCTO 
    select * from producto;
    
    # SE CREA LA TABLA CLIENTES 
    
    create table Clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    edad INT,
    correo_electronico VARCHAR(255),
    fecha_registro DATE);

# SE INSERTAN LOS VALORES EN LA TABLA CLIENTES 

insert into clientes (nombre, apellido, edad, correo_electronico, fecha_registro)
values 
('Juan', 'Pérez', 30, 'juan.perez@example.com', '2024-04-26'),
('María', 'González', 25, 'maria.gonzalez@example.com', '2024-04-26'),
('Pedro', 'Sánchez', 35, 'pedro.sanchez@example.com', '2024-04-26'),
('Ana', 'Martínez', 28, 'ana.martinez@example.com', '2024-04-26'),
('Luis', 'López', 40, 'luis.lopez@example.com', '2024-04-26');

   
    # SE HACE LA CONSULTA DE LA TABLA CLIENTES 
    select * from clientes;
   
   # CONSULTAS CONDICIONADAS 
   
   # LAS VENTAS TOTALES 
SELECT SUM(total) AS ventas_totales FROM ventas v; 

 # LOS CLIENTES ACTIVOS 
SELECT COUNT(DISTINCT id_cliente) AS clientes_activos FROM ventas;

# LAS VENTAS PROMEDIO PROMEDIO POR CLIENTE 
SELECT (SUM(total) / COUNT(DISTINCT id_cliente)) AS promedio_ventas_por_cliente FROM ventas v; 

#El CRECIMIENTO MENSUAL DE VENTAS 
SELECT DATE_FORMAT(fecha_venta, '%Y-%m') AS mes, SUM(total) AS ventas_mensuales
FROM ventas
GROUP BY mes
ORDER BY mes;

 # SEGMENTACION DE CLIENTES POR EDAD Y CIUDAD
SELECT c.edad, c.ciudad, COUNT(0) AS numero_clientes
FROM clientes c
LEFT JOIN factura f ON c.id_cliente = f.id_cliente
GROUP BY c.edad, c.ciudad
ORDER BY c.edad, c.ciudad;

# SE AGREGA LA COLUMNA CIUDAD A LA TABLA CLIENTES  
ALTER TABLE clientes ADD ciudad VARCHAR(100);

# TASA DE C0NVERSION POR SEGMENTO (ASUMIENDO QUE SE TIENE EL DATO DE VISITAS O INTERESADOS)
SELECT segmento, COUNT(id_cliente) AS tasa_conversion, 
       COUNT(id_cliente) AS total_visitas
FROM (
    SELECT CASE
        WHEN edad BETWEEN 18 AND 25 THEN '18-25'
        WHEN edad BETWEEN 26 AND 35 THEN '26-35'
        ELSE '36+'
    END AS segmento, id_cliente
    FROM clientes c 
    JOIN factura f USING (id_cliente)
) AS subquery
GROUP BY segmento;

# FRECUENCIA DE COMPRA POR CLIENTE 
SELECT id_cliente, COUNT(id_factura) AS frecuencia_compra
FROM factura
GROUP BY id_cliente;

# VALOR DE VIDA DEL CLIENTE (CLV)
SELECT id_cliente, SUM(total) AS valor_de_vida
FROM ventas
GROUP BY id_cliente;
   
   # PRODUCTOS MAS VENDIDOS 
     SELECT id_producto, SUM(cantidad) AS cantidad_vendida
FROM ventas v 
GROUP BY id_producto
ORDER BY cantidad_vendida DESC;

# LA DEMANDA MENSUAL POR PRODUCTO 
SELECT id_producto, DATE_FORMAT(fecha_venta, '%Y-%m') AS mes, SUM(cantidad) AS cantidad_vendida
FROM ventas
GROUP BY id_producto, mes
ORDER BY mes;

# DEMANDA POR CIUDAD SI LA CIUDAD ESTA EN LA TABLA DE CLIENTES 
select c. ciudad, v.id_producto, SUM(v.cantidad) AS cantidad_vendida
FROM clientes c 
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE c.ciudad IN (SELECT c.ciudad FROM clientes)
GROUP BY c.ciudad, v.id_producto;

# DEMANDA POR CATEGORIA DE PRODUCTO 
 SELECT p.categoria, SUM(v.cantidad) AS cantidad_vendida
FROM ventas v
left JOIN producto p ON v.id_producto = p.id_producto
left join ventas v2 on v.id_producto = v.id_producto 
GROUP BY p.categoria, v.id_producto;

# ESTO ES PARA VER LA CANTIDAD  DE COMPRAS DEL PRODUCTO DE LA TABLA VENTAS 
SELECT 
    id_producto  , 
    COUNT(0) AS cantidad_compras 
FROM 
    ventas 
GROUP BY 
    id_producto ;
    
 # TOP DE 5 VENTAS CON MAYOR VENTAS REALIZADAS 
    select 
   id_ventas  , -- cliente columna 1 
   count(0) as cantidad_ventas -- cantidad de ventas colimna 2  
   from 
   ventas 
   group by 
   id_ventas -- el numero 1 es para agupar las columnas para agrupar la columna 1 y 2   
   order by 
   2 desc  
   limit 5;
   
   #QUE  CANTIDAD  DE PRODUCTOZ TIENE CADA CATEGORIA  Y CUAL ES SU PRESION PROMEDIO 
   SELECT categoria,  -- columna 1 
   COUNT(*) AS cantidad_producto,   -- columna 2 
   AVG(precio) AS precio_promedio    -- COUNT y AVG son funciones de agregación (agrupación) columna 3
FROM producto p 
GROUP BY categoria;

# CUANTOS PRODUCTOS DISTINTOS NOS VENDE CADA MARCA  
select marca ,
  count(distinct id_producto)
  from 
  producto p 
  group by 1;	

# CUAL ES LA EDAD PROMEDIO  POR CADA NOMBRE DEL CLIENTE Y FECHA REGISTRO  
SELECT 
  nombre,  -- columna 1
  fecha_registro,  -- columna 2
  AVG(edad) AS edad_promedio
FROM 
  clientes c 
GROUP BY 
  nombre,  -- agrupa por nombre
  fecha_registro   -- agrupa por fecha_registro
ORDER BY 
  nombre DESC,  -- ordena por nombre descendente
  fecha_registro DESC;  -- ordena por fecha_registro descendente
  
  # EL LEFT SIRVE PARA ESTAR EN LA CADENA  DE TEXTO SI QUIERES  QUE ESTRAIGA 6 LETRAS  QUE HACE ESTA FUNCION
  select nombre,
left (nombre, 6) as primera_6_letras
from producto p ;

# USAR EL FLOOR   PARA ESTRAER LA PARTE ENTERA DE UN NUMERO  
select 
avg (precio) as precio_promedio,
floor(avg (precio)) as precio_promedio_entero
from producto p; 


