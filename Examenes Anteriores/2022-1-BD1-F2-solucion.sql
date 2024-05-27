/*
ASIGNATURA: BASE DE DATOS I
ASUNTO: SCRIPT DE SOLUCION. SEGUNDO EXAMEN FINAL
FECHA: 22/12/2022
*/


/* A.1.  Despliegue una lista que contenga el nombre del chofer, la fecha de salida, la fecha de
llegada, la duraci�n del viaje, el cliente de origen y el cliente destino de los 5 viajes con
mayor duraci�n realizadas durante el a�o 2019.
 */
SELECT choferes.nombre as Chofer, viajes.fechasalida, viajes.fechallegada, viajes.fechallegada  - viajes.fechasalida as duracion, 
clientesorigen.nombre as ClienteOrigen, clientesdestino.nombre as ClientDestino
FROM viajes JOIN clientes clientesorigen
ON viajes.idclienteorigen = clientesorigen.id
JOIN clientes clientesdestino 
ON viajes.idclientedestino = clientesdestino.id
JOIN choferes 
ON viajes.idchofer = choferes.id
WHERE date_part('year', viajes.fechallegada) = 2019
ORDER BY duracion desc
LIMIT 5;


/* A.1. Analice la funci�n llamada DiferenciasPeso() que calcula el total de las diferencias entre el peso bruto de origen y el peso bruto 
de destino para cada chofer en todos los viajes ya realizados
 */
CREATE OR REPLACE FUNCTION DiferenciasPeso(Chofer bigint) 
  RETURNS bigint AS
$BODY$
DECLARE
   vDiferencia bigint;
BEGIN

   SELECT sum(pesobrutoorigen) - sum(pesobrutodestino) INTO vDiferencia 
   FROM viajes WHERE idChofer = Chofer;

   RETURN vDiferencia;
END;
$BODY$
  LANGUAGE plpgsql;


/* Demuestre el funcionamiento de la funci�n desplegando solamente el nombre del chofer 
--y la diferencia total detectada, en el caso de que exista diferencia. 
*/
SELECT choferes.nombre as Chofer, DiferenciasPeso(id) as DiferenciasPeso 
FROM choferes 
WHERE DiferenciasPeso(id) > 50000
ORDER BY 2 desc;


/*
B. Modifique el dise�o la BD actual para que permita Almacenar los datos de los fabricantes
de los art�culos. Usted debe considerar que:
* Un art�culo puede ser fabricado por m�s de un fabricante.
* Un fabricante no se limita a fabricar un solo producto.
* Es necesario almacenar el precio de costo del art�culo por cada fabricante.
* Se debe poder obtener el nombre del fabricante e identificar el pa�s de origen del mismo.
* Para entregar debe incluir solamente las sentencias de creaci�n de los nuevos objetos: tablas, PK y FK.
*/

CREATE TABLE Pais 
(
	  codigoPais SERIAL
	, nombrePais VARCHAR(255) NOT NULL
);
ALTER TABLE Pais ADD PRIMARY KEY (codigoPais);

CREATE TABLE Fabricantes 
(
	  idFabricante SERIAL
	, nombreFabricante VARCHAR(255) NOT NULL
	, ruc VARCHAR(255) NOT NULL
	, direccion VARCHAR(255) NOT NULL
	, telefono VARCHAR(255) NOT NULL
	, codigoPais INTEGER NOT NULL
);
ALTER TABLE Fabricantes ADD PRIMARY KEY (idFabricante);
ALTER TABLE Fabricantes ADD FOREIGN KEY (codigoPais) REFERENCES Pais (codigoPais);

CREATE TABLE FabricantesArticulos 
(
	 idArticulo BIGINT NOT NULL
	, idFabricante INTEGER NOT NULL
	, precioCosto FLOAT NOT NULL
);
ALTER TABLE FabricantesArticulos ADD PRIMARY KEY (idArticulo, idFabricante);
ALTER TABLE FabricantesArticulos ADD FOREIGN KEY (idArticulo) REFERENCES articulos (id);
ALTER TABLE FabricantesArticulos ADD FOREIGN KEY (idFabricante) REFERENCES Fabricantes (idFabricante);

/*
C. Modifique el dise�o para que se pueda registrar las distancias entre los
dep�sitos y los fabricantes para detectar cual es el m�s cercano y establezca las relaciones
necesarias. 
*/
CREATE TABLE FabricantesDepositos
(
	 idDeposito BIGINT NOT NULL
	, idFabricante INTEGER NOT NULL
	, Distancia FLOAT NOT NULL
);
ALTER TABLE FabricantesDepositos ADD PRIMARY KEY (idDeposito, idFabricante );
ALTER TABLE FabricantesDepositos ADD FOREIGN KEY (idDeposito) REFERENCES depositos (id);
ALTER TABLE FabricantesDepositos ADD FOREIGN KEY (idFabricante) REFERENCES Fabricantes (idFabricante);








