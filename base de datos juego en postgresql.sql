-- Universidad de la sierra sur.
-- Autor: Belisario Nazario Anselmo.
-- Descripción: Script base de datos juego en postgresql.
-- Fecha: 07/11/2018.


USE master;  
   

IF EXISTS(select * from sys.databases where name = 'juego')  
THEN  
    DROP DATABASE juego;  
END IF; 

create database juego;

USE juego;
   
-- Creando tabla jugadores
CREATE SEQUENCE jugadores_seq;

CREATE TABLE jugadores(
    idJugador INT NOT NULL DEFAULT NEXTVAL ('jugadores_seq'),
    nombreJugador VARCHAR(45) NOT NULL,
    nivel INT NULL,
    fecha DATE NOT NULL,
    edad INT NOT NULL,
    CONSTRAINT jugadores_pk PRIMARY KEY(idJugador));
-- Creando tabla campeones
CREATE SEQUENCE campeones_seq;

CREATE TABLE campeones(
    idCampeon INT NOT NULL DEFAULT NEXTVAL ('campeones_seq'),
    nombreCampeon VARCHAR(45) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    precio DECIMAL(8,2) NULL,
    fecha DATE NOT NULL,
    edad INT NOT NULL,
    CONSTRAINT campeones_clave_alt UNIQUE (nombreCampeon),
    CONSTRAINT campeones_pk PRIMARY KEY(idCampeon));
-- Creando  tabla batallas
CREATE TABLE batallas(
    jugadorId INT NOT NULL,
    campeonId INT NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT batallas_jugadores FOREIGN KEY (jugadorId)
        REFERENCES jugadores (idJugador)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT batallas_campeones FOREIGN KEY (campeonId)
        REFERENCES campeones (idCampeon)
        ON DELETE CASCADE
        ON UPDATE CASCADE, 
        CONSTRAINT batallas_pk PRIMARY KEY  (jugadorId, campeonId));

-- 1. sp que crea un registro jugador
CREATE OR REPLACE FUNCTION spCrearRegistroJugador (
 p__nombreJugador VARCHAR (45),
    p__nivel INT,
    p__fecha DATE,
    p__edad INT
) RETURNS VOID
AS $$
BEGIN
	INSERT INTO jugadores (
		nombreJugador, 
        nivel, 
        fecha,
        edad
	)
	VALUES(
		p__nombreJugador,
        p__nivel,
        p__fecha,
        p__edad
    );
END; 
 GO
$$ LANGUAGE plpgsql;

-- 2. sp que crea un registro campeon
CREATE OR REPLACE FUNCTION spCrearRegistroCampeon (
 p__nombreCampeon VARCHAR (45),
    p__tipo VARCHAR(20),
    p__precio DECIMAL(8,2),
    p__fecha DATE,
    p__edad INT
) RETURNS VOID
AS $$
BEGIN
	INSERT INTO campeones (
		nombreCampeon, 
        tipo, 
        precio,
        fecha,
        edad
	)
	VALUES(
		p__nombreCampeon,
        p__tipo,
        p__precio,
        p__fecha,
        p__edad
    );
END; 
 GO
$$ LANGUAGE plpgsql;

-- 3. sp que crea un registro batalla
CREATE OR REPLACE FUNCTION spCrearRegistroBatallas (
 p__jugadorId INT,
    p__campeonId INT,
    p__cantidad INT
) RETURNS VOID
AS $$
BEGIN
	INSERT INTO batallas (
		jugadorId, 
        campeonId, 
        cantidad
	)
	VALUES(
		p__jugadorId,
        p__campeonId,
        p__cantidad
    );
END; 
 GO
$$ LANGUAGE plpgsql;

-- 4.sp que actualiza un registro jugador
CREATE OR REPLACE FUNCTION spActualizarRegistroJugador (
 p__idJugador INT,
 p__nombreJugador VARCHAR (45),
    p__nivel INT,
    p__fecha DATE,
    p__edad INT
) RETURNS VOID
AS $$
BEGIN
	UPDATE jugadores 
    SET nombreJugador=p__nombreJugador,
		nivel=p__nivel,
		fecha=p__fecha,
        edad=p__edad
        WHERE idJugador=p__idJugador;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 5.sp que actualiza un registro campeon
CREATE OR REPLACE FUNCTION spActualizarRegistroCampeon (
 p__idCampeon INT,
 p__nombreCampeon VARCHAR (45),
    p__tipo VARCHAR(20),
    p__precio DECIMAL(8,2),
    p__fecha DATE,
    p__edad INT
) RETURNS VOID
AS $$
BEGIN
	UPDATE campeones
    SET nombreCampeon=p__nombreCampeon,
        tipo=p__tipo,
        precio=p__precio,
        fecha=p__fecha,
        edad=p__edad
        WHERE idCampeon=p__idCampeon;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 6.sp que actualiza un registro batalla
CREATE OR REPLACE FUNCTION spActualizarRegistroBatallas (
 p__jugadorId INT,
    p__campeonId INT,
    p__cantidad INT
) RETURNS VOID
AS $$
BEGIN
	UPDATE batallas
    SET jugadorId=p__jugadorId,
        campeonId=p__campeonId,
        cantidad=p__cantidad
        WHERE campeonId=p__campeonId and jugadorId=p__jugadorId;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 7.sp que elimina un registro jugador
CREATE OR REPLACE FUNCTION spEliminarRegistroJugador (
 p__idJugador INT
) RETURNS VOID
AS $$
BEGIN
	DELETE FROM jugadores
    WHERE idJugador=p__idJugador;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 8.sp que elimina un registro campeon
CREATE OR REPLACE FUNCTION spEliminarRegistroCampeon (
 p__idCampeon INT
) RETURNS VOID
AS $$
BEGIN
	DELETE FROM campeones
    WHERE idCampeon=p__idCampeon;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 9.sp que elimina un registro batalla
CREATE OR REPLACE FUNCTION spEliminarRegistroBatallas (
 p__jugadorId INT,
    p__campeonId INT
) RETURNS VOID
AS $$
BEGIN
	DELETE FROM batallas 
    WHERE campeonId =p__campeonId
    AND jugadorId=p__jugadorId;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 10.sp que muestra los registros de la tabla jugador
CREATE OR REPLACE FUNCTION spObtenerRegistroJugador RETURNS VOID 
AS $$
BEGIN
	SELECT * FROM jugadores;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 11.sp que muestra los registros de la tabla campeon
CREATE OR REPLACE FUNCTION spObtenerRegistroCampeon RETURNS VOID 
AS $$
BEGIN
	SELECT * FROM campeones;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 12.sp que muestra los registros de la tabla batallas
CREATE OR REPLACE FUNCTION spObtenerRegistroBatallas RETURNS VOID 
AS $$
BEGIN
	SELECT c.nombreCampeon,c.precio,b.cantidad FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador=b.jugadorId
    INNER JOIN campeones c
    ON b.campeonId=c.idCampeon;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 13.sp que devuelve un jugador en especifico
CREATE OR REPLACE FUNCTION spObtenerUnRegistroJugador (
 p__idJugador int) RETURNS VOID
AS $$
BEGIN
	SELECT * FROM jugadores j where j.idJugador=p__idJugador;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 14.sp que devuelve un campeon en especifico
CREATE OR REPLACE FUNCTION spObtenerUnRegistroCampeon (
 p__idCampeon int) RETURNS VOID
AS $$
BEGIN
	SELECT * FROM campeones c where c.idCampeon=p__idCampeon;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 15.sp que muestra los jugadores, que han combatido o no, y campeones 
CREATE OR REPLACE FUNCTION spObtenerJugadoresConOSinBatallas RETURNS VOID
as $$
begin
	SELECT 
		j.nombreJugador, 
		c.nombreCampeon,
        b.cantidad
	FROM jugadores j
    LEFT JOIN batallas b
    ON j.idJugador = b.jugadorId
    LEFT JOIN campeones c
    ON b.campeonId = c.idCampeon
    ORDER BY j.nombreJugador;
end; 
 GO
$$ LANGUAGE plpgsql;

-- 16.sp que muestra los jugadores y campeones que han combatido 
CREATE OR REPLACE FUNCTION spObtenerJugadoresConBatallas RETURNS VOID
as $$
begin
	SELECT 
		j.nombreJugador, 
		c.nombreCampeon,
        b.cantidad
	FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    INNER JOIN campeones c
    ON b.campeonId = c.idCampeon
    ORDER BY j.nombreJugador;
end; 
 GO
$$ LANGUAGE plpgsql;

-- 17.sp que devuelve el campeon mas contratado
CREATE OR REPLACE FUNCTION spObtenerRegistroCampeonMasContratado RETURNS VOID 
AS $$
BEGIN
	SELECT c.nombreCampeon, sum(b.cantidad) as total_batallas
    FROM campeones c 
    INNER JOIN batallas b
    ON c.idCampeon = b.campeonId
    group by c.nombreCampeon
    having sum(b.cantidad)>= all
	(SELECT; sum(b.cantidad) FROM campeones c 
    INNER JOIN batallas b
    ON c.idCampeon = b.campeonId
    group by c.idCampeon);
END; 
 GO
$$ LANGUAGE plpgsql;

-- 18.sp que devuelve el campeon menos contratado
CREATE OR REPLACE FUNCTION spObtenerRegistroCampeonMenosContratado RETURNS VOID 
AS $$
BEGIN
	SELECT c.nombreCampeon, sum(b.cantidad) as total_batallas
    FROM campeones c 
    INNER JOIN batallas b
    ON c.idCampeon = b.campeonId
    group by c.nombreCampeon
    having sum(b.cantidad)<= all
	(SELECT; sum(b.cantidad) FROM campeones c 
    INNER JOIN batallas b
    ON c.idCampeon = b.campeonId
    group by c.idCampeon);
END; 
 GO
$$ LANGUAGE plpgsql;

-- 19.sp que devuelve el jugador que mas ha gastado
CREATE OR REPLACE FUNCTION spObtenerRegistroJugadorMasGasto RETURNS VOID 
AS $$
BEGIN
	SELECT j.nombreJugador, sum(b.cantidad*c.precio) as total
    FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    INNER JOIN campeones c
    ON b.campeonId = c.idCampeon
    group by j.nombreJugador
    having sum(b.cantidad*c.precio)>= all
	(SELECT; sum(b.cantidad*c.precio) FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    INNER JOIN campeones c
    ON b.campeonId = c.idCampeon
    group by j.idJugador);
END; 
 GO
$$ LANGUAGE plpgsql;

-- 20.sp que devuelve el jugador que menos ha contratado
CREATE OR REPLACE FUNCTION spObtenerRegistroJugadorMenosContrata RETURNS VOID 
AS $$
BEGIN
	SELECT j.nombreJugador, sum(b.cantidad) as total
    FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    group by j.nombreJugador
    having sum(b.cantidad)<= all
	(SELECT; sum(b.cantidad) FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    group by j.idJugador);
END; 
 GO
$$ LANGUAGE plpgsql;

-- 21.sp que devuelve a los jugadores jovenes
CREATE OR REPLACE FUNCTION spObtenerRegistroJugadorJoven RETURNS VOID 
AS $$
BEGIN
	SELECT nombreJugador,edad FROM jugadores
    WHERE edad<18 ;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 22.sp que devuelve a los jugadores adultos
CREATE OR REPLACE FUNCTION spObtenerRegistroJugadorAdulto RETURNS VOID 
AS $$
BEGIN
	SELECT nombreJugador,edad FROM jugadores
    WHERE edad>=18 ;
END; 
 GO
$$ LANGUAGE plpgsql;

-- 23.sp que muestra los jugadores que no han combatido
CREATE OR REPLACE FUNCTION spObtenerJugadoresSinBatallas RETURNS VOID
as $$
begin
	SELECT 
		j.nombreJugador
	FROM jugadores j
    LEFT JOIN batallas b
    on j.idJugador = b.jugadorId
    where b.campeonId is null;
end; 
 GO
$$ LANGUAGE plpgsql;

-- 24.sp que muestra los campeones que no han combatido
CREATE OR REPLACE FUNCTION spObtenerCampeonesSinBatallas RETURNS VOID
as $$
begin
	SELECT c.nombreCampeon
	FROM campeones c
    LEFT JOIN batallas b
    ON c.idCampeon= b.campeonId
    where b.jugadorId is null;
end; 
 GO
$$ LANGUAGE plpgsql;

-- 25.sp que devuelve el jugador de nivel mas alto
CREATE OR REPLACE FUNCTION spObtenerRegistroJugadorMayorNivel RETURNS VOID 
AS $$
BEGIN
	SELECT nombreJugador, nivel
    FROM jugadores
    where nivel = (SELECT MAX( nivel ) FROM jugadores); 
END; 
 GO
$$ LANGUAGE plpgsql;

-- 26.sp que devuelve los campeones que no cobran
CREATE OR REPLACE FUNCTION spObtenerRegistroCampeonNoCobra RETURNS VOID 
AS $$
BEGIN
	SELECT nombreCampeon
    FROM campeones
    where precio is null;
END; 
 GO
$$ LANGUAGE plpgsql;

 EXECUTE dbo.spCrearRegistroJugador @_nombreJugador = 'Salazar',@_nivel=20,@_fecha='2018-06-29',@_edad=28;
 EXECUTE dbo.spCrearRegistroJugador @_nombreJugador = 'Jalmes',@_nivel=10,@_fecha='2018-07-15',@_edad=16;
 EXECUTE dbo.spCrearRegistroJugador @_nombreJugador = 'Bernal',@_nivel=30,@_fecha='2018-09-24',@_edad=18;
 EXECUTE dbo.spCrearRegistroJugador @_nombreJugador = 'Salazar',@_nivel=null,@_fecha='2018-12-25',@_edad=22;

 EXECUTE dbo.spCrearRegistroCampeon @_nombreCampeon = 'Akali',@_tipo='Aseseino',@_precio=790,@_fecha='2018-05-11',@_edad=12;
 EXECUTE dbo.spCrearRegistroCampeon @_nombreCampeon = 'Brand',@_tipo='Aseseino',@_precio= null ,@_fecha='2018-09-10',@_edad=22;
 EXECUTE dbo.spCrearRegistroCampeon @_nombreCampeon = 'Caitlyn',@_tipo='mago',@_precio=880,@_fecha='2018-01-01',@_edad=32;
 EXECUTE dbo.spCrearRegistroCampeon @_nombreCampeon = 'Karpov',@_tipo='Aseseino',@_precio=1880,@_fecha='2018-01-01',@_edad=17;

 EXECUTE dbo.spCrearRegistroBatallas  @_jugadorId =1, @_campeonId=1, @_cantidad =300;
 EXECUTE dbo.spCrearRegistroBatallas  @_jugadorId =1, @_campeonId=2, @_cantidad =200;
 EXECUTE dbo.spCrearRegistroBatallas  @_jugadorId =1, @_campeonId=3, @_cantidad =400;
 EXECUTE dbo.spCrearRegistroBatallas  @_jugadorId =2, @_campeonId=1, @_cantidad =300;
 EXECUTE dbo.spCrearRegistroBatallas  @_jugadorId =2, @_campeonId=2, @_cantidad =400;
 EXECUTE dbo.spCrearRegistroBatallas  @_jugadorId =3, @_campeonId=1, @_cantidad =200;

