/*1. Crear un Stored Procedure que tenga como par�metros de entrada una fecha y un c�digo de
marca. El resultado de su ejecuci�n debe ser un listado de autos pertenecientes a las
campa�as vigentes a la fecha pasada por par�metro y debe mostrar s�lo los autos cuya
marca haya sido pasada por par�metro, o todos si no se ingres� ese par�metro.
El listado debe respetar el siguiente formato:
CAMPA�A / MARCA / MODELOCOD / DESCRIPCION MODELO / PRECIO.
Ordenar el listado por CAMPA�A / MARCA / MODELOCOD / DESCRIPCION MODELO.
Notas:
� El precio a mostrar en el listado, es el precio final del auto (es decir, con el descuento
aplicado de la campa�a asociada, si lo hubiere).
� Puede haber dos o m�s campa�as en el listado que tenga asociado el mismo modelo de
auto.*/

/*CREATE procedure [dbo].[GET_CAMPANIA_AUTOS]  (@fecha_desde datetime, @fecha_hasta datetime, @marca INT)

AS

BEGIN

IF  @marca is null
	begin

			SELECT C.Nombre  AS 'Campa�a',M.nombre as 'Marca',A.modeloCod as 'Cod Modelo',A.descripcion as 'Descripcion Modelo',
			A.precio - (A.precio*c.porcDescuento) as 'Precio Final'
			FROM CAMPANIAS C 
			JOIN CAMPANIASAUTOS CA ON C.ID = CA.CAMPANIAID
			JOIN AUTOS A ON A.MODELOCOD = CA.MODELOCOD
			JOIN MARCAS M ON M.id = A.marcaCod
			WHERE C.FECHADESDE >= @fecha_desde 
			and c.fechaHasta <= @fecha_hasta
			order by C.Nombre,M.nombre,A.modeloCod,A.descripcion

    END


ELSE 	
		BEGIN
        
			SELECT C.Nombre  AS 'Campa�a',M.nombre as 'Marca',A.modeloCod as 'Cod Modelo',A.descripcion as 'Descripcion Modelo',
			A.precio - (A.precio*c.porcDescuento) as 'Precio Final'
			FROM CAMPANIAS C 
			JOIN CAMPANIASAUTOS CA ON C.ID = CA.CAMPANIAID
			JOIN AUTOS A ON A.MODELOCOD = CA.MODELOCOD
			JOIN MARCAS M ON M.id = A.marcaCod
			WHERE C.FECHADESDE >= @fecha_desde 
			and c.fechaHasta <= @fecha_hasta
			AND A.marcaCod = @marca
			order by C.Nombre,M.nombre,A.modeloCod,A.descripcion
        
		END


END */


/*si no se pasa el parametro queda null por que ya queda definido el parametro, otra opcion es definirlo con null 
pero eso se hacerlo en pl/sql con p_marca number default null*/

/*consulta de procedure*/
exec GET_CAMPANIA_AUTOS '2021-12-15',1

exec GET_CAMPANIA_AUTOS '2021-12-15',null


SELECT C.Nombre  AS 'Campa�a',M.nombre as 'Marca',A.modeloCod as 'Cod Modelo',A.descripcion as 'Descripcion Modelo',
A.precio - (A.precio*c.porcDescuento) as 'Precio Final',A.precio,c.porcDescuento,C.FECHADESDE,c.fechaHasta
FROM CAMPANIAS C 
JOIN CAMPANIASAUTOS CA ON C.ID = CA.CAMPANIAID
JOIN AUTOS A ON A.MODELOCOD = CA.MODELOCOD
JOIN MARCAS M ON M.id = A.marcaCod
WHERE c.fechaHasta >= '2021-12-15'
AND A.MARCACOD = 1
order by C.Nombre,M.nombre,A.modeloCod,A.descripcion


/*Crear un Stored Procedure que tenga como par�metro de entrada una fecha y liste los
pr�stamos vigentes (no cancelados) junto con su correspondiente valor de cancelaci�n para
esa fecha.

El listado debe respetar el siguiente formato:
NRO PRESTAMO / NRO CLIENTE / MARCA / DESCRIPCION MODELO / VIN / VALOR
DE CANCELACION.*/


/*CREATE PROCEDURE GET_PRESTAMOS_VIGENTES (@fecha datetime)

AS

BEGIN

select p.nroPrestamo,p.nroCliente,m.nombre,a.descripcion,p.vin,p.fechaCancelacion,
p.capital + ( (p.capital * (p.tasa/100) / DATEDIFF(DAY, p.fechaAlta, p.fechaVencimiento) )  * DATEDIFF(DAY, p.fechaAlta, @fecha) * (1.21)  )
from Prestamos p
join Autos a on a.modeloCod = p.modeloCod
join Marcas m on m.id = a.marcaCod
where p.fechaVencimiento >= @fecha
AND p.fechaCancelacion is NULL
order by p.nroPrestamo
	
END */

/*consulta de procedure*/
exec GET_PRESTAMOS_VIGENTES '2021-03-16'


select p.nroPrestamo,p.nroCliente,m.nombre,a.descripcion,p.vin,p.fechaCancelacion,p.fechaVencimiento,
p.capital + 
( (p.capital * (p.tasa/100) / DATEDIFF(DAY, p.fechaAlta, p.fechaVencimiento) )  * DATEDIFF(DAY,p.fechaAlta,'2021-03-16'  ) * (1.21) ) as 'valor de cancelacion',
DATEDIFF(DAY,p.fechaAlta,'2021-03-16' ),DATEDIFF(DAY, p.fechaAlta, p.fechaVencimiento)
from Prestamos p
join Autos a on a.modeloCod = p.modeloCod
join Marcas m on m.id = a.marcaCod
where  p.fechaVencimiento >= '2021-03-16'
AND p.fechaCancelacion is NULL
order by p.nroPrestamo

select * from Prestamos



/*3. La AFIP le ha enviado una interface que se almacen� en la tabla "ImpuestoSolidario" e indica
el incremento de precio en concepto de impuesto en determinados modelos de auto. La
interface est� compuesta de registros, con el siguiente formato:
� XXXXXXXXXX (10 caracteres) --> C�digo de modelo de autom�vil
� YYYY (4 caracteres) --> Al�cuota a aplicar en concepto de impuesto, donde los �ltimos 2
caracteres representan una cifra decimal (la al�cuota est� comprendida entre 0 y 100)*/
/*Realizar un script de actualizaci�n que modifique el valor de los modelos de auto de acuerdo a la
informaci�n enviada, sobre los modelos donde aplique.*/


/*La alicouta al ser un aumento se calcula sobre la base del precio sacando el porcentaje que trae la tabla
de importesolidario y luego sumandolo al precio de lista*/

declare	@var2 table(id varchar(10),alicuota money) --variable temporal para hacer la busqueda ya que la tabla solo trae una columna
 
insert into @var2(id ,alicuota)
select  SUBSTRING ( L�nea ,1 , 10 ), cast(SUBSTRING (L�nea ,11 ,12)as money)/100.00 from ImpuestoSolidario
select * from  @var2 /*consultas de control*/


select (select precio * (alicuota/100) + precio from autos where modeloCod = id),id 
from  @var2
where id in (select modeloCod from autos)

select * from autos
where modeloCod in (select id from @var2)

/*actualizacion de datos*/
update Autos set precio = (select precio * (alicuota/100) + precio  from @var2 where id = modeloCod)
where modeloCod in (select id from @var2)




