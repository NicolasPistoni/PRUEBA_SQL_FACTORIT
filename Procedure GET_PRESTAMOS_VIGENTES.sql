USE [prueba]
GO
/****** Object:  StoredProcedure [dbo].[GET_PRESTAMOS_VIGENTES]    Script Date: 3/2/2023 09:20:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GET_PRESTAMOS_VIGENTES] (@fecha datetime)

AS

BEGIN

select p.nroPrestamo,p.nroCliente,m.nombre,a.descripcion,p.vin,p.fechaCancelacion,
p.capital + ( (p.capital * (p.tasa/100) / DATEDIFF(DAY, p.fechaAlta, p.fechaVencimiento) )  * DATEDIFF(DAY, p.fechaAlta, @fecha) * (1.21) ) as 'valor de cancelacion'
from Prestamos p
join Autos a on a.modeloCod = p.modeloCod
join Marcas m on m.id = a.marcaCod
where p.fechaVencimiento >= @fecha
AND p.fechaCancelacion is NULL
order by p.nroPrestamo
	
END 
