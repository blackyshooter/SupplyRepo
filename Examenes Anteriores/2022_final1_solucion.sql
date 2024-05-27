/*
* ASIGNATURA: Base de datos I
* FECHA: 01/12/2022
* AUTOR: jmeza@pol.una.py
* TEMA: Solución SQL del primer examen final. 
* PERIDO: 2022-1
*/

/*
Tema 1: Ver solución DER

Tema 2: Ver solución DER
*/

/*
Tema 3: Los proveedores que fueron adjudicados mas de 50 veces entre los años 2020 y 2021. 
*/
select date_part('year', fecha_adjudicacion) as "Año", p.descripcion as "Proveedor", e.descripcion as "Estado", 
count(distinct a.id_llamado) "Cantidad", sum(a.monto) as "Monto Total"
from adjudicaciones a join estados e 
on a.id_estado = e.id 
join proveedores p 
on a.id_proveedor = p.id 
where date_part('year', fecha_adjudicacion) in (2020,2021) 
group by date_part('year', fecha_adjudicacion), p.descripcion, e.descripcion 
having count(distinct a.id_llamado) >= 50
order by 4 desc;

-- Tema 4: Considere las  15 instituciones que mayores montos han adjudicado en la categoria Pasajes y Transportes. 
-- No incluya las adjudicaciones Canceladas.
select i.descripcion as "Instituciones", c.descripcion as "Categoria" , sum(a.monto) as "Monto Total"
from adjudicaciones a 
join llamados ll
on a.id_llamado = ll.id 
join instituciones i 
on ll.id_institucion = i.id
join categorias c 
on ll.id_categoria = c.id 
where c.descripcion ilike '%Pasaje%'
and a.id_estado not in (5) -- canceladas no
group by i.descripcion , c.descripcion 
order by 3 desc 
limit 15;

-- Tema 5: Obtenga la cantidad de llamados según los métodos: Contratación Directa, Concurso de Ofertas y Contrato por Excepción, exclusivamente para las instituciones que son Ministerios del Poder Ejecutivo. 
-- Para concretar este requerimiento puede usar la función existente denominada contar_metodos_institucion(). 
select distinct i.descripcion as "Institución", 
contar_metodos_institucion(22, id) as "Contratación Directa",
contar_metodos_institucion(7, id) as "Concurso de Ofertas", 
contar_metodos_institucion(3, id) as "Contrato por Excepción"
from instituciones i 
where i.descripcion ilike 'Ministerio%'
and i.id not in (251, 83)
order by 2 desc ;




