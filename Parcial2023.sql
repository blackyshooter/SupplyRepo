SELECT * FROM comercio_exterior ce ;
SELECT * FROM paises p ;
SELECT * FROM productos p;
--1
SELECT p1.nombre AS "Pais Destino", 
       p2.nombre AS "Pais Origen",
       CONCAT(p3.codigo, ' - ', p3.descripcion) AS "Producto",
       monto_importacion AS "Monto Importado"
FROM comercio_exterior ce 
JOIN paises p1 ON ce.pais_analizado = p1.codigo
JOIN paises p2 ON ce.pais_origen_destino = p2.codigo
JOIN productos p3 ON ce.codigo = p3.codigo
WHERE p3.codigo LIKE '2204%'AND anio ='2022'
ORDER BY monto_importacion DESC;

--2
CREATE VIEW vBalanceComercial AS
SELECT anio, 
