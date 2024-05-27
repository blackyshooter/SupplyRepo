 /*
 * BASE DE DATOS I. LCIK
 * FECHA: 31/05/2022
 * AUTOR: jmeza@pol.una.py
 * NOTA: Solucion del Segundo Examen Parcial
 */
 
 
 /*
 TEMA 1: Obtenga todas las cuentas de ahorro de los 2 clientes 
 (bajo sospecha de lavado de dinero) indicados abajo. 
 El resultado debe ser idéntico al cuadro:
 */
SELECT c.numero_cuenta, c.anho,
    t.tipo_cuenta,
	c.fecha_apertura,
    l.codigo_cliente,
    l.nombres as Cliente
   FROM cuentas c
     JOIN clientes l ON c.codigo_cliente = l.codigo_cliente
	 JOIN tipos_cuentas t
	 ON c.codigo_tipo = t.codigo_tipo
  WHERE c.codigo_cliente IN (3659553,647848) 
  ORDER BY 1;

 /*
TEMA 2.	Despliegue la cantidad de cuentas que posee cada uno de los 3 
clientes identificados en el cuadro de abajo. 
Véase el resultado esperado a continuación
 */
SELECT l.codigo_cliente,
    l.nombres as Cliente,
    t.tipo_cuenta,	
	count(*) as cantidad
   FROM cuentas c
     JOIN clientes l ON c.codigo_cliente = l.codigo_cliente
	 JOIN tipos_cuentas t
	 ON c.codigo_tipo = t.codigo_tipo
  WHERE c.codigo_cliente IN (1735058,3659553,647848) 
  GROUP BY t.tipo_cuenta,
	    l.codigo_cliente,
    l.nombres
  ORDER BY 2,4 desc;
  
/*
TEMA 3. Visualice el saldo al 31/12/2021 de las cuentas de los 3 clientes 
identificados arriba (tema 2).  Debe usar la función CalcularSaldo() ya disponible en la base de datos. 
El resultado debe idéntico al indicado abajo:
*/
SELECT c.numero_cuenta || '-' || c.anho AS cuenta,
    t.tipo_cuenta as Tipo,
    l.codigo_cliente,
    l.nombres as Cliente,
    calcularsaldo(max(m.codigo_movimiento)) AS saldo
   FROM cuentas c
     JOIN movimiento m ON c.codigo_cuenta = m.codigo_cuenta
     JOIN clientes l ON c.codigo_cliente = l.codigo_cliente
	 JOIN tipos_cuentas t
	 ON c.codigo_tipo = t.codigo_tipo
  WHERE  c.codigo_cliente IN (1735058,3659553,647848) 
  AND m.fecha_operacion <= '31/12/2021'
  GROUP BY t.tipo_cuenta, l.codigo_cliente, l.nombres, c.numero_cuenta, c.anho
  ORDER BY 5 DESC;
  
  /*
 TEMA 4: Cree una función llamada TransferenciaInterna() que permita 
 insertar un movimiento de extracción en la cuenta de origen y un 
 movimiento de depósito en la cuenta destino 
 */

CREATE OR REPLACE FUNCTION TransferenciaInterna(
	numeric, numeric, numeric )
    RETURNS varchar
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
  vOrigen integer;
  vDestino integer;
  vNroMov integer;
BEGIN
  SELECT codigo_cuenta into vOrigen  -- Obtengo el id de la cuenta 
  FROm cuentas where numero_cuenta = $1;
	
  SELECT codigo_cuenta into vDestino  -- Obtengo el id de la cuenta 
  FROm cuentas where numero_cuenta = $2;	
  
  -- Obtengo el siguiente numero de movimiento
  SELECT MAX(codigo_movimiento) + 1 into vNroMov 
  from movimiento where codigo_cuenta = vOrigen;

   -- Inserto la extracción
  INSERT INTO public.movimiento(
	codigo_cuenta, numero_movimiento, fecha_operacion, importe, codigo_tipo_movimiento, comprobante)
	VALUES (vOrigen, vNroMov, now(), $3, 2, $2);
	
  -- Obtengo el siguiente numero de movimiento
  SELECT MAX(codigo_movimiento) + 1 into vNroMov 
  from movimiento where codigo_cuenta = vDestino;
  
  -- Inserto el depósito
  INSERT INTO public.movimiento(
	codigo_cuenta, numero_movimiento, fecha_operacion, importe, codigo_tipo_movimiento, comprobante)
	VALUES (vDestino, vNroMov, now(), $3, 3, $1);
	
  RETURN 'Transferencia Exitosa';
END
$BODY$;

-- Demostración de la función
SELECT TransferenciaInterna(5576, 14004, 5000000)
