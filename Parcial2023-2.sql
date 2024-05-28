SELECT * FROM comercio_exterior ce ;
SELECT * FROM paises p;
SELECT * FROM productos pro;

--1
SELECT p1.nombre AS "Pais Destino",p2.nombre AS "Pais Origen",CONCAT(pro.codigo,' ',pro.descripcion) AS "Descripcion",SUM(monto_importacion)FROM comercio_exterior ce
JOIN paises p1 ON p1.codigo = ce.pais_analizado
JOIN paises p2 ON p2.codigo = ce.pais_origen_destino
JOIN productos pro ON pro.codigo = ce.codigo
WHERE pro.codigo LIKE '2204%' AND anio = '2022'
GROUP BY p1.nombre, p2.nombre, CONCAT(pro.codigo,' ',pro.descripcion),monto_importacion 
ORDER BY monto_importacion DESC;

--2

CREATE VIEW vBalanzaComercial AS
SELECT ce.anio,p1.nombre AS "Pais Analizado",p2.nombre AS "Pais Destino",SUM(volumen_exportacion) AS "Total Exportaciones",SUM(volumen_importacion) AS "Total Imortaciones"
FROM comercio_exterior ce 
JOIN paises p1 ON p1.codigo = ce.pais_analizado
JOIN paises p2 ON p2.codigo = ce.pais_origen_destino
WHERE ce.anio>= '2020' AND ce.anio<='2023'
GROUP BY ce.anio,p1.nombre,p2.nombre
ORDER BY ce.anio ASC;

SELECT * FROM vBalanzaComercial;


