--1.a) Los actores de origen argentino no pueden facturar más de 10.000
-- por una actuación en una película estrenada en un año en el cual también
-- participen en algún capítulo de serie.
SELECT 1
FROM actua a
JOIN pelicula p USING(idcontenido)
WHERE a.pais_origen ILIKE 'argentina' AND a.monto_facturado > 10000 AND --actores de origen argentino q facturan mas de 10000
      (a.id_actor, a.pais_origen) IN
      (SELECT a2.id_actor, a2.pais_origen
       FROM actua a2
       JOIN capitulo cap USING (idcontenido)
       WHERE EXTRACT (YEAR FROM p.fecha_estreno) = EXTRACT (YEAR FROM cap.fecha_aparicion));


INSERT INTO contenido(idcontenido, titulo, tipo) VALUES (1, 'Cars', 'P');

INSERT INTO contenido(idcontenido, titulo, tipo) VALUES (2, 'HarryPotter', 'S');
INSERT INTO pelicula(idcontenido, descripcion, fecha_estreno) VALUES(1,'gran pelicula','2025-10-20'::DATE);
INSERT INTO serie(idcontenido, resumen) VALUES(2, 'boludo con magia');
INSERT INTO temporada(nro_temporada, idcontenido) VALUES (1, 2);
insert into capitulo(nro_temporada, idcontenido, nrocapitulo, titulo, fecha_aparicion)
    VALUES (1,2,1, 'primer capitulo','2025-10-20'::DATE);
Insert into capitulo(nro_temporada, idcontenido, nrocapitulo, titulo, fecha_aparicion)
    VALUES (1,2,2, 'segundo capitulo','2026-10-20'::DATE);


INSERT INTO actor (id_actor, pais_origen, nombre_real, nombre_fantasia, fecha_nacim, ciudad_residencia, pais_residencia)
                    VALUES (1,'Inglaterra', 'Jack Grealish', 'Jaco', '1990-10-25'::date,'Londres','Inglaterra'),
                           (2,'Argentina', 'Sergio Aguero', 'Kuni', '1987-06-20'::date,'Miami','Estados Unidos'),
                           (3,'Argentina', 'Marcelo Tossini', 'Bondage', '1960-03-17'::date,'Tandil','Argentina'),
                           (4,'Argentina', 'Lucas Leiva', 'Leivo', '1972-01-29'::date,'Tandil','Argentina'),
                           (5,'Australia', 'Oscar Piastri', 'Pechon', '2003-07-16'::date,'Madrid','España');

INSERT INTO personaje (id_personaje, nombre_apellido, descripcion) VALUES (1,'Mike Wheeler', 'Un narigon que juega D&D'),
                                                                          (2,'Will Byers','Un boludo que lo rapta el demogorgon'),
                                                                          (3,'Nancy Wheeler','Hermana del boludo raptado');

INSERT INTO actua (id_personaje, id_actor, pais_origen, monto_facturado, idcontenido)
    VALUES (2,2,'Argentina', 8000, 2),
           (1,2,'Argentina', 12000, 1);

INSERT INTO actua (id_personaje, id_actor, pais_origen, monto_facturado, idcontenido)
    VALUES (3,3,'Argentina', 12000, 2),
           (2,3,'Argentina', 9000, 1);
INSERT INTO actua (id_personaje, id_actor, pais_origen, monto_facturado, idcontenido)
    VALUES (2,4,'Argentina', 9000, 2),
           (1,4,'Argentina', 15000, 1);


--1.b) En un mismo contenido (serie o película),
-- un personaje puede ser interpretado por hasta tres actores distintos,
-- pero un mismo actor solo puede interpretar hasta 2 personajes diferentes.
ALTER TABLE actua
ADD CONSTRAINT chk1_b
CHECK (
    NOT EXISTS (
        -- Personaje interpretado por más de 3 actores distintos
        SELECT 1
        FROM actua
        GROUP BY idcontenido, id_personaje
        HAVING COUNT(DISTINCT (id_actor, pais_origen)) > 3
    )
    AND
    NOT EXISTS (
        -- Actor interpretando más de 2 personajes distintos
        SELECT 1
        FROM actua
        GROUP BY idcontenido, id_actor, pais_origen
        HAVING COUNT(DISTINCT id_personaje) > 2
    )
);

--1.c) De los actores menores de 18 años se debe registrar su país y ciudad de residencia.
ALTER TABLE actor
ADD CONSTRAINT CHK1_C
CHECK (EXTRACT (YEAR FROM AGE(fecha_nacim)) > 18 OR
      (ciudad_residencia IS NOT NULL AND pais_residencia IS NOT NULL));

insert into actor (id_actor, pais_origen, nombre_real, nombre_fantasia, fecha_nacim, ciudad_residencia, pais_residencia)
            VALUES (6,'Peru','Jenifer Aliston', 'La Jeny', '2015-08-12'::date, NULL,NULL);
















CREATE OR REPLACE FUNCTION FN_OFIC()
RETURNS TRIGGER AS $$
DECLARE
    suma_actual INTEGER;
    cap_max INTEGER;
BEGIN
        SELECT COALESCE(SUM(capacidad), 0), capacidad_max INTO suma_actual, cap_max
        FROM zona
        JOIN oficina USING(nro_zona)
        WHERE nro_zona = NEW.nro_zona;

    IF tg_op = 'INSERT' then
        IF ((suma_actual+NEW.capacidad) > cap_max) THEN
            RAISE EXCEPTION 'NO PUEDES PORQUE SUPERA LA CAPACIDAD MAXIMA'
        end if;
    end if;

    IF tg_op = 'update' THEN
        IF new.capacidad IS DISTINCT FROM OLD.capacidad THEN
            IF ((suma_actual+NEW.capacidad) > cap_max) THEN
            RAISE EXCEPTION 'NO PUEDES CAMBIAR DE ZONA PORQUE SUPERA LA CAPACIDAD MAXIMA'
            end if;
        end if;
        IF NEW.nro_zona IS DISTINCT FROM OLD.nro_zona  THEN
            IF ((suma_actual) > cap_max) THEN
            RAISE EXCEPTION 'NO PUEDES CAMBIAR DE ZONA PORQUE SUPERA LA CAPACIDAD MAXIMA'
            end if;
        end if;
    end if;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_check_zona_max
BEFORE INSERT OR UPDATE OF nro_zona OR UPDATE OF capacidad ON OFICINA
FOR EACH ROW
EXECUTE FUNCTION FN_OFIC();

ESTA MAL EL DE ARRIBA!!

CREATE TRIGGER tr_check_zona_max
BEFORE INSERT OR UPDATE ON oficina
FOR EACH ROW
WHEN (
    -- Solo ejecutar en estos casos específicos
    OLD.nro_zona IS DISTINCT FROM NEW.nro_zona OR
    OLD.capacidad IS DISTINCT FROM NEW.capacidad
)
EXECUTE FUNCTION FN_OFIC();

Tip de Final: Siempre usa COALESCE al hacer SUM. Si no hay filas, el SUM devuelve NULL, y NULL + número es NULL, lo que rompería tu validación. !!!!



contenido pelicula y serie

contenido join pelicula -> los contenidos q son pelicula
contenido left join pelicula -> todos los contenidos y los q son pelicula
contenido left join pelicula left join serie -> todos los contenidos, sean peliculas o series

COALESCE(duracion, capitulo)

              A
        B          C
    capacidad     valor



set search_path to final_18_12_2025;

--Defina las siguientes vistas sobre el esquema dado, teniendo en cuenta de construirlas de manera que resulten actualizables en PostgreSQL, siempre que sea posible. Justifique este aspecto.
--a) VistaA, con el identificador, título y resumen de las series con al menos una temporada de más de 6 capítulos.
mas de una temporada >1 de mas de 6 capitulos > 6

CREATE VIEW vista_A AS
SELECT c.idContenido, c.titulo, s.resumen
FROM CONTENIDO c
JOIN serie s USING (idcontenido)
WHERE EXISTS
    (SELECT t.nro_temporada, t.idcontenido
     FROM TEMPORADA t
     join capitulo ca USING(nro_temporada, idcontenido)
     WHERE t.idcontenido = c.idcontenido
     GROUP BY (t.nro_temporada, t.idcontenido)
     HAVING COUNT(*) > 6
     )

select * from contenido join serie USING (idContenido) JOIN temporada USING (idcontenido) JOIN capitulo USING (idcontenido);--de las series con al menos una temporada de mas de 6 capitulos
insert into contenido (idcontenido, titulo, tipo)
    VALUES (3,'Stranger Things','S');
insert into serie (idcontenido, resumen)
    VALUES (3,'Unos guachines que juegan D&D');
insert into temporada (nro_temporada, idcontenido)
    VALUES (1,3);
insert into capitulo (nro_temporada, idcontenido, nrocapitulo, titulo, fecha_aparicion)
    VALUES (1,3,1,'Al guachin que lo rapta el bicho', '2025-06-19'::date);

INSERT INTO capitulo VALUES (1,2,3,'tercer capitulo','2026-10-21'::date),
                           (1,2,4,'cuarto capitulo','2026-10-24'::date),
                           (1,2,5,'quinto capitulo','2026-10-26'::date),
                           (1,2,6,'sexto capitulo','2026-11-03'::date),
                           (1,2,7,'septimo capitulo','2026-11-12'::date);
select * from vista_A;


--Defina las siguientes vistas sobre el esquema dado, teniendo en cuenta de construirlas de manera que resulten actualizables en PostgreSQL, siempre que sea posible. Justifique este aspecto.
--a) VistaA, con el identificador, título y resumen de las series con menos de dos temporadas de más de 6 capítulos.
mas de una temporada >1 de mas de 6 capitulos > 6

CREATE VIEW vista_B AS
SELECT c.idContenido, c.titulo, s.resumen
FROM CONTENIDO c
JOIN serie s USING (idcontenido)
WHERE EXISTS
    (SELECT 1 FROM
                  (SELECT t.nro_temporada, t.idcontenido
                     FROM TEMPORADA t
                     join capitulo ca USING(nro_temporada, idcontenido)
                     WHERE t.idcontenido = c.idcontenido
                     GROUP BY (t.nro_temporada, t.idcontenido)
                     HAVING COUNT(*) > 6 -- TODAS LAS TEMPORADAS DE MAS DE 6 CAPITULOS.
                  ) t GROUP BY 1 HAVING COUNT(*) < 2
              );
SELECT * FROM vista_B;
INSERT INTO temporada VALUES (2,2);
INSERT INTO capitulo VALUES(2,2,1,'primer capitulo','2026-10-21'::date),
                           (2,2,2,'segundo capitulo','2026-10-21'::date),
                           (2,2,3,'tercer capitulo','2026-10-21'::date),
                           (2,2,4,'cuarto capitulo','2026-10-24'::date),
                           (2,2,5,'quinto capitulo','2026-10-26'::date),
                           (2,2,6,'sexto capitulo','2026-11-03'::date),
                           (2,2,7,'septimo capitulo','2026-11-12'::date);


DELETE FROM capitulo WHERE nro_temporada = 2 AND idcontenido = 2 AND nrocapitulo = 7;



INSERT INTO CONTENIDO (idcontenido, titulo, tipo) VALUES (5,'El señor de los anillos', 'P');
INSERT INTO pelicula (idcontenido, descripcion, fecha_estreno) VALUES (5,'El chaval que le entrega el anillo a Sauron', '2025-12-22'::date);
INSERT INTO personaje (id_personaje, nombre_apellido, descripcion)
    VALUES (5,'Gandalf el blanco','El mago lechero'),
           (6,'Aragorn Rey de Gondor','El rey de los numenoir');
INSERT INTO actua (id_personaje, id_actor, pais_origen, monto_facturado, idcontenido)
    VALUES (5,2,'Argentina',60000,5),
           (6,4,'Argentina',25000,5);
--b) VistaB, con los datos de las películas estrenadas durante el mes pasado, en las cuales el monto promedio facturado por actuaciones de actores de origen español supere 30.000.

INSERT INTO actua (id_personaje, id_actor, pais_origen, monto_facturado, idcontenido)
    VALUES (5,5,'Australia',1,5);












SELECT *
FROM pelicula p
WHERE fecha_estreno >= date_trunc('month',CURRENT_DATE) - interval '1 month' AND fecha_estreno < date_trunc('month',CURRENT_DATE) AND EXISTS  -- con los datos de las películas estrenadas durante el mes pasado
(SELECT 1
     FROM actua a
     WHERE pais_origen ILIKE 'argentina'
       AND p.idcontenido = a.idcontenido
     GROUP BY a.idcontenido
     HAVING AVG(a.monto_facturado) > 30000
);

--c) VistaC, que contenga los actores menores de 30 años que han actuado únicamente en películas.

SELECT *
FROM actor a
WHERE EXTRACT (YEAR FROM AGE(a.fecha_nacim)) < 30 AND
      NOT EXISTS (SELECT 1 FROM actua act JOIN contenido c USING(idcontenido) WHERE a.id_actor = act.id_actor AND c.tipo = 'S') AND
      EXISTS (SELECT 1 FROM actua act JOIN contenido c USING(idcontenido) WHERE a.id_actor = act.id_actor AND c.tipo = 'P');


INSERT INTO actor VALUES (8,'Francia','Killian Mbappe','Traviño','2002-10-13'::date,'Madrid');
SELECT * FROM actor;


create table estreno_contenidos (
idcontenido  int  not null,
titulo  varchar(100)  not null,
tipo_contenido  char (1)  not null,
fecha_estreno  date  not null,
nro_temporada int null );

CREATE OR REPLACE FUNCTION updt_conten()
RETURNS TRIGGER AS $$
BEGIN
    TRUNCATE TABLE estreno_contenidos;
    INSERT INTO estreno_contenidos(idcontenido, titulo, tipo_contenido, fecha_estreno, nro_temporada)
    SELECT
        c.idcontenido, c.titulo, c.tipo, COALESCE(p.fecha_estreno,ca.fecha_aparicion), ca.nro_temporada
    FROM contenido c
    LEFT JOIN pelicula p USING(idcontenido)
    LEFT JOIN capitulo ca USING (idcontenido)
    WHERE  c.idcontenido = new.idcontenido AND ((ca.nrocapitulo = 1 AND (EXTRACT (YEAR FROM ca.fecha_aparicion) = EXTRACT(YEAR FROM current_date)+1)) OR ( c.tipo ilike 'p' AND (EXTRACT (YEAR FROM p.fecha_estreno) = EXTRACT(YEAR FROM current_date)+1)));
END;
$$ LANGUAGE 'plpgsql';




INSERT INTO CONTENIDO (idcontenido, titulo, tipo) VALUES (10,'messi la peli', 'P');
INSERT INTO pelicula (idcontenido, descripcion, fecha_estreno) VALUES (10,'la mejor peli del mundo', '2027-12-22'::date);
INSERT INTO temporada VALUES (3,2);
INSERT INTO capitulo VALUES(3,2,1,'primer capitulo','2027-10-21'::date);

SELECT
        c.idcontenido, c.titulo, c.tipo, COALESCE(p.fecha_estreno,ca.fecha_aparicion), ca.nro_temporada
    FROM contenido c
    LEFT JOIN pelicula p USING(idcontenido)
    LEFT JOIN serie s USING (idcontenido)
    LEFT JOIN temporada t USING (idcontenido)
    LEFT JOIN capitulo ca USING (idcontenido, nro_temporada)
WHERE ca.nrocapitulo = 1 OR c.tipo ilike 'p';



SELECT
        c.idcontenido, c.titulo, c.tipo, COALESCE(p.fecha_estreno,ca.fecha_aparicion), ca.nro_temporada
    FROM contenido c
    LEFT JOIN pelicula p USING(idcontenido)
    LEFT JOIN capitulo ca USING (idcontenido)
    WHERE (ca.nrocapitulo = 1 AND (EXTRACT (YEAR FROM ca.fecha_aparicion) = EXTRACT(YEAR FROM current_date)+1)) OR ( c.tipo ilike 'p' AND (EXTRACT (YEAR FROM p.fecha_estreno) = EXTRACT(YEAR FROM current_date)+1));


SELECT
        c.idcontenido, c.titulo, c.tipo, COALESCE(p.fecha_estreno,ca.fecha_aparicion), ca.nro_temporada
    FROM contenido c
    LEFT JOIN pelicula p USING(idcontenido)
    LEFT JOIN capitulo ca USING (idcontenido)
    WHERE  c.idcontenido = 2 AND ((ca.nrocapitulo = 1 AND (EXTRACT (YEAR FROM ca.fecha_aparicion) = EXTRACT(YEAR FROM current_date)+1)) OR ( c.tipo ilike 'p' AND (EXTRACT (YEAR FROM p.fecha_estreno) = EXTRACT(YEAR FROM current_date)+1)));




--A partir del esquema dado, la productora de contenidos desea analizar la disparidad salarial y el "Star System"
-- dentro de su catálogo de películas. Se requiere un reporte analítico que compare las ganancias de los actores,
-- pero segmentado estrictamente por su país de origen.
--Utilizando el metodo que considere más adecuado, genere un reporte desde un anio_minimo que será dado por el usuario, considerando exclusivamente las PELÍCULAS estrenadas a partir del anio_minimo (inclusive).
--El reporte debe devolver por lo menos las siguientes columnas:
--1- Pais: País de origen del actor.
--2- Nombre_Actor: Nombre real del actor.
--3- Total_Facturado: La suma total de monto_facturado por ese actor en películas del periodo.
--4-Ranking_Pais: La posición del actor dentro de su país según sus ganancias (El que más ganó es el #1).
--5-Diferencia_Con_El_Anterior: Cuánto dinero menos ganó este actor en comparación con el que está inmediatamente arriba de él en el ranking de su mismo país. (Para el #1, la diferencia debe ser 0).
--6-Porcentaje_Del_Pais: Qué porcentaje representa lo facturado por este actor sobre el total de dinero pagado a todos los actores de ese mismo país en el periodo.
   -- (Ej: Si en Argentina se pagaron $1000 en total y Darín cobró $500, su porcentaje es 50%).

CREATE TABLE star_system (
    pais                            varchar(30)      NOT NULL,
    nombre_actor                    varchar(50)      NOT NULL,
    total_facturado                 decimal          NOT NULL,
    ranking_pais                    bigint           NOT NULL,
    diferencia_con_el_anterior      decimal          NOT NULL,
    porcentaje_del_pais             DOUBLE PRECISION NOT NULL
);

CREATE OR REPLACE PROCEDURE pr_informar(anio_minimo int) LANGUAGE plpgsql AS $$
BEGIN
    TRUNCATE TABLE star_system;
    INSERT INTO star_system(pais, nombre_actor, total_facturado,ranking_pais, diferencia_con_el_anterior, porcentaje_del_pais)

    WITH mf AS (
        SELECT act.pais_origen, act.id_actor, SUM(act.monto_facturado) as montofacturado
        FROM actua act
        JOIN pelicula p USING (idcontenido)
        WHERE EXTRACT (YEAR FROM p.fecha_estreno) >= anio_minimo
        GROUP BY act.pais_origen, act.id_actor
    ),rank_monto AS (
        SELECT act.pais_origen, act.id_actor, rank() OVER (PARTITION BY pais_origen ORDER BY monto_facturado DESC) as rank
        FROM actua act
        JOIN pelicula p USING (idcontenido)
        WHERE EXTRACT (YEAR FROM p.fecha_estreno) >= anio_minimo
    ), dif_ant AS (
        SELECT act.pais_origen, act.id_actor, act.monto_facturado-lag(act.monto_facturado, 1, 0) OVER (PARTITION BY act.pais_origen ORDER BY rk.rank) as monto_anterior
        FROM actua act
        JOIN rank_monto rk USING(pais_origen, id_actor)
        JOIN pelicula p USING (idcontenido)
        WHERE EXTRACT (YEAR FROM p.fecha_estreno) >= anio_minimo
    )

    SELECT act.pais_origen, act.nombre_real, mf.montofacturado, rk.rank, dif_ant.monto_anterior, 0
    FROM actor act
    JOIN mf USING(pais_origen, id_actor)
    JOIN rank_monto rk USING(pais_origen, id_actor)
    JOIN dif_ant USING(pais_origen, id_actor);

END;
$$;


select a.id_actor, a.pais_origen, SUM(a.monto_facturado) as total
from actua a
join actor using(id_actor, pais_origen)
join pelicula using(idcontenido)
group by a.id_actor,a.pais_origen
ORDER BY pais_origen, total DESC;






CREATE OR REPLACE PROCEDURE pr_informar2(anio_minimo date)
LANGUAGE plpgsql
AS $$
BEGIN
    TRUNCATE TABLE star_system;

    INSERT INTO star_system (
        pais,
        nombre_actor,
        total_facturado,
        ranking_pais,
        diferencia_con_el_anterior,
        porcentaje_del_pais
    )

    WITH mf AS (
        SELECT
            act.pais_origen,
            act.id_actor,
            SUM(act.monto_facturado) AS total_facturado
        FROM actua act
        JOIN pelicula p USING (idcontenido)
        WHERE EXTRACT(YEAR FROM p.fecha_estreno) >= EXTRACT(YEAR FROM anio_minimo)
        GROUP BY act.pais_origen, act.id_actor
    ),

    ranking AS (
        SELECT
            pais_origen,
            id_actor,
            total_facturado,
            RANK() OVER (
                PARTITION BY pais_origen
                ORDER BY total_facturado DESC
            ) AS ranking_pais
        FROM mf
    ),

    diferencias AS (
        SELECT
            pais_origen,
            id_actor,
            total_facturado,
            ranking_pais,
            COALESCE(
            total_facturado
            - LAG(total_facturado) OVER (
                PARTITION BY pais_origen
                ORDER BY ranking_pais
              ), 0) AS diferencia_con_el_anterior,
            (
            total_facturado
            / SUM(total_facturado) OVER (PARTITION BY pais_origen)
            ) * 100 AS porcentaje_del_pais
        FROM ranking
    )

    SELECT
        d.pais_origen,
        a.nombre_real,
        d.total_facturado,
        d.ranking_pais,
        d.diferencia_con_el_anterior, d.porcentaje_del_pais
    FROM diferencias d
    JOIN actor a USING (id_actor, pais_origen);
END;
$$;


CALL pr_informar2('2025-01-10'::date);
SELECT * FROM star_system





JUANCITO 1 12000
PEDRO 2     6000     6000

EL LAG TOTAL FACTURADO(12000)- MI TOTAL FACTURADO(6000)

EL LAG DE JUANCITO mi facturado 12000 - MI FACTURADO 0








CREATE OR REPLACE FUNCTION fn_insert_actua()
RETURNS TRIGGER AS $$
DECLARE
    CANT1 int;
    CANT2 int;
BEGIN
    SELECT COUNT(*) INTO cant1 FROM
    ((
    SELECT a.id_actor, a.pais_origen
    FROM actua a
    WHERE a.idContenido = NEW.idContenido AND a.id_personaje = NEW.id_personaje
    AND NOT (
              TG_OP = 'UPDATE'
              AND a.id_actor     = OLD.id_actor
              AND a.pais_origen  = OLD.pais_origen
              AND a.id_personaje = OLD.id_personaje
              AND a.idContenido  = OLD.idContenido
            )
    )
    UNION
    (SELECT NEW.id_actor, NEW.pais_origen)) t;


    SELECT COUNT(*) INTO cant2 FROM
    ((
    SELECT id_personaje
    FROM actua a
    WHERE a.idContenido = NEW.idContenido AND a.id_actor = NEW.id_actor AND a.pais_origen = NEW.pais_origen
    AND NOT (
              TG_OP = 'UPDATE'
              AND a.id_actor     = OLD.id_actor
              AND a.pais_origen  = OLD.pais_origen
              AND a.id_personaje = OLD.id_personaje
              AND a.idContenido  = OLD.idContenido
            )
    )
    UNION
    (SELECT NEW.id_personaje)) t2;

    IF((CANT1>3 OR CANT2>2)) THEN
        RAISE EXCEPTION 'No se puede';
    END IF;
RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER tr_insert_actua
BEFORE INSERT OR UPDATE OF idContenido, id_actor, pais_origen, id_personaje ON ACTUA
FOR EACH ROW EXECUTE FUNCTION fn_insert_actua();












