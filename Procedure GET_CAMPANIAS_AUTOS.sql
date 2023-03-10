USE [prueba]
GO
/****** Object:  StoredProcedure [dbo].[GET_CAMPANIA_AUTOS]    Script Date: 3/2/2023 09:05:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  procedure [dbo].[GET_CAMPANIA_AUTOS]  (@fecha datetime,@marca INT) 

/*se pasan dos parametros de fecha para definir rango de busqueda mas acorde a la vigencia de cada campaña*/

AS

BEGIN

IF  @marca is null
	begin

			SELECT C.Nombre  AS 'Campaña',M.nombre as 'Marca',A.modeloCod as 'Cod Modelo',A.descripcion as 'Descripcion Modelo',
			A.precio - (A.precio*c.porcDescuento) as 'Precio Final'
			FROM CAMPANIAS C 
			JOIN CAMPANIASAUTOS CA ON C.ID = CA.CAMPANIAID
			JOIN AUTOS A ON A.MODELOCOD = CA.MODELOCOD
			JOIN MARCAS M ON M.id = A.marcaCod
			WHERE c.fechaHasta >= @fecha
			order by C.Nombre,M.nombre,A.modeloCod,A.descripcion

    END


ELSE 	
		BEGIN
        
			SELECT C.Nombre  AS 'Campaña',M.nombre as 'Marca',A.modeloCod as 'Cod Modelo',A.descripcion as 'Descripcion Modelo',
			A.precio - (A.precio*c.porcDescuento) as 'Precio Final'
			FROM CAMPANIAS C 
			JOIN CAMPANIASAUTOS CA ON C.ID = CA.CAMPANIAID
			JOIN AUTOS A ON A.MODELOCOD = CA.MODELOCOD
			JOIN MARCAS M ON M.id = A.marcaCod
			WHERE c.fechaHasta >= @fecha
			AND A.marcaCod = @marca
			order by C.Nombre,M.nombre,A.modeloCod,A.descripcion
        
		END


END 