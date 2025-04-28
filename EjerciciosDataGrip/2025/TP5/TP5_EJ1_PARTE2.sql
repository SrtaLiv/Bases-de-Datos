-- bd de voluntarios
create table continente
(
    nombre_continente varchar(25),
    id_continente     numeric not null
        constraint pk_continente
            primary key
)
    with (autovacuum_enabled = true);

alter table continente
    owner to postgres;

grant references, select on continente to public;

create table pais
(
    nombre_pais   varchar(40),
    id_continente numeric not null
        constraint fk_continente
            references continente,
    id_pais       char(2) not null
        constraint pk_pais
            primary key
)
    with (autovacuum_enabled = true);

alter table pais
    owner to postgres;

create table direccion
(
    calle         varchar(40),
    codigo_postal varchar(12),
    ciudad        varchar(30) not null,
    provincia     varchar(25),
    id_pais       char(2)     not null
        constraint fk_pais
            references pais,
    id_direccion  numeric(4)  not null
        constraint pk_direccion
            primary key
)
    with (autovacuum_enabled = true);

alter table direccion
    owner to postgres;

grant references, select on direccion to public;

create table institucion
(
    nombre_institucion varchar(60) not null,
    id_director        numeric(6),
    id_direccion       numeric(4)
        constraint fk_direccion
            references direccion,
    id_institucion     numeric(4)  not null
        constraint pk_institucion
            primary key
)
    with (autovacuum_enabled = true);

alter table institucion
    owner to postgres;

grant references, select on institucion to public;

grant references, select on pais to public;

create table tarea
(
    nombre_tarea varchar(40) not null,
    min_horas    numeric(6),
    id_tarea     varchar(10) not null
        constraint pk_tarea
            primary key,
    max_horas    numeric(6)
)
    with (autovacuum_enabled = true);

alter table tarea
    owner to postgres;

grant references, select on tarea to public;

create table voluntario
(
    nombre           varchar(20),
    apellido         varchar(25) not null,
    e_mail           varchar(40) not null,
    telefono         varchar(20),
    fecha_nacimiento date        not null,
    id_tarea         varchar(10) not null
        constraint fk_tarea_v
            references tarea,
    nro_voluntario   numeric(6)  not null
        constraint pk_voluntario
            primary key,
    horas_aportadas  numeric(8, 2)
        constraint chk_hs_ap
            check (horas_aportadas > (0)::numeric),
    porcentaje       numeric(2, 2),
    id_institucion   numeric(4)
        constraint fk_institucion_v
            references institucion,
    id_coordinador   numeric(6)
        constraint fk_coordinador
            references voluntario
)
    with (autovacuum_enabled = true);

alter table voluntario
    owner to postgres;

create table historico
(
    fecha_inicio   date        not null,
    nro_voluntario numeric(6)  not null
        constraint fk_voluntario_h
            references voluntario,
    fecha_fin      date        not null,
    id_tarea       varchar(10) not null
        constraint fk_tarea_h
            references tarea,
    id_institucion numeric(4)
        constraint fk_institucion_h
            references institucion,
    constraint pk_historico
        primary key (fecha_inicio, nro_voluntario),
    constraint historico_check
        check (fecha_fin > fecha_inicio)
)
    with (autovacuum_enabled = true);

alter table historico
    owner to postgres;

grant references, select on historico to public;

alter table institucion
    add constraint fk_director
        foreign key (id_director) references voluntario;

create unique index emp_email_uk
    on voluntario (e_mail);

grant references, select on voluntario to public;

-- registros
    INSERT INTO continente (id_continente, nombre_continente)
VALUES
(1, 'América'),
(2, 'Europa'),
(3, 'Asia');

INSERT INTO pais (id_pais, nombre_pais, id_continente)
VALUES
('AR', 'Argentina', 1),
('US', 'Estados Unidos', 1),
('FR', 'Francia', 2),
('IN', 'India', 3);

INSERT INTO direccion (id_direccion, calle, codigo_postal, ciudad, provincia, id_pais)
VALUES
(1, 'Av. Corrientes 1234', 'C1034AAA', 'Buenos Aires', 'Buenos Aires', 'AR'),
(2, 'Rua Augusta 456', 'SP12345', 'São Paulo', 'São Paulo', 'FR'),
(3, 'Avenue des Champs-Élysées', '75008', 'París', 'Île-de-France', 'FR'),
(4, 'Connaught Place', '110001', 'Delhi', 'Delhi', 'IN');

INSERT INTO institucion (id_institucion, nombre_institucion, id_direccion, id_director)
VALUES
(3, 'Fundación Internacional Solidaria', 3, NULL),
(4, 'Ayuda Global', 4, NULL);

INSERT INTO tarea (id_tarea, nombre_tarea, min_horas, max_horas)
VALUES
(2, 'Distribución de alimentos', 3, 8),
(3, 'Recolección de fondos', 4, 10),
(4, 'Asistencia en eventos', 2, 6),
(5, 'Ayuda en hospitales', 5, 12);

INSERT INTO voluntario (nro_voluntario, nombre, apellido, e_mail, telefono, fecha_nacimiento, id_tarea, horas_aportadas, porcentaje, id_institucion, id_coordinador)
VALUES
(1001, 'Juan', 'Pérez', 'juan.perez@email.com', '1122334455', '1985-06-15', 'T001', 50, 0.75, 3, NULL),
(1002, 'Ana', 'Gómez', 'ana.gomez@email.com', '1122334456', '1990-08-20', 'T002', 60, 0.85, 3, 1001),
(1003, 'Carlos', 'López', 'carlos.lopez@email.com', '1122334457', '1992-01-30', 'T003', 45, 0.90, 3, 1001),
(1004, 'Lucía', 'Martínez', 'lucia.martinez@email.com', '1122334458', '1987-11-10', 'T004', 40, 0.80, 4, 1002);

INSERT INTO historico (fecha_inicio, nro_voluntario, fecha_fin, id_tarea, id_institucion)
VALUES
('2022-01-01', 1001, '2022-06-01', 'T001', 1),
('2022-03-01', 1002, '2022-09-01', 'T002', 2),
('2022-06-01', 1003, '2022-12-01', 'T003', 3),
('2022-02-01', 1004, '2022-07-01', 'T004', 4);

-- Ejercicio 1
-- Considere las siguientes restricciones que debe definir sobre el esquema de la BD de Voluntarios:
-- No puede haber voluntarios de más de 70 años. Aquí como la edad es un dato que depende de la fecha actual lo
-- deberíamos controlar de otra manera.
CREATE ASSERTION edad_voluntarios_menor_70
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM VOLUNTARIOS
        WHERE (CURRENT_DATE - fecha_nacimiento) > INTERVAL '70 years'
    )
);

-- A.Bis - Controlar que los voluntarios deben ser mayores a 18 años.
-- contrario: los voluntarios no sean menores a 18
CREATE ASSERTION edad_mayor
CHECK (
       NOT EXISTS (
       SELECT 1
       FROM VOLUNTARIOS
       WHERE (CURRENT_DATE - fecha_nacimiento) < INTERVAL '18 years'
       )
)

-- Ningún voluntario puede aportar más horas que las de su coordinador.
-- atributos involucraos: id_coordinarod, nro_voluntario, horas_aportadas
-- para mi es de tabla ya que en realidad hay q hacer un join pq nro_voluntario es diferente
-- al de coordinador

CREATE ASSERTION voluntario_mas_horas
CHECK (
       NOT EXIST(
            -- VOLUNTARIOS CON MAS HROAS Q SU COORDINAOR
            SELECT v1.*
            FROM unc_46203524.voluntario v1
            JOIN  unc_46203524.voluntario v2
            ON v1.nro_voluntario = v2.id_coordinador
            WHERE v1.horas_aportadas > v2.horas_aportadas
       )
)

-- C. Las horas aportadas por los voluntarios deben estar dentro de los valores máximos y mínimos consignados en la tarea.
-- QUE NO EXISTAN VOLUNTARIOS SIN HORAS DENTRO DE LOS VALORES MAX Y MIN DE SUS TAREAS CONSIGNADAS
CREATE ASSERTION voluntarios_dentro_horas
CHECK(
       NOT EXISTS(
            SELECT 1
            FROM unc_46203524.voluntario v
            JOIN unc_46203524.tarea t
            USING (id_tarea)
            WHERE v.horas_aportadas
            NOT BETWEEN t.min_horas AND t.max_horas
       )
)


-- D. Todos los voluntarios deben realizar la misma tarea que su coordinador.
-- Q NO EXISTAN VOLUNTARIOS CON TAREAS DIFERENTES A LA DE SU COORDINADOR
CREATE ASSERTION voluntarios_tarea_coordinador(
       CHECK(
       NOT EXISTS(
            SELECT 1
            FROM unc_46203524.voluntario v
            JOIN unc_46203524.voluntario c
            ON v.nro_voluntario = c.id_coordinador
            WHERE v.id_tarea <> c.id_tarea
       )
       )
)



-- e. Los voluntarios no pueden cambiar de institución más de tres veces al año.

-- que no existan voluntarios que cambiaron de institucion menos de 3 veces al año
CREATE ASSERTION voluntarios_cambio_max_3_anio
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM (
            SELECT
              h.nro_voluntario,
              EXTRACT(YEAR FROM h.fecha_inicio) AS anio,
              COUNT(*) AS cambios
            FROM unc_46203524.historico h
            GROUP BY
              h.nro_voluntario,
              EXTRACT(YEAR FROM h.fecha_inicio)
            HAVING
              COUNT(*) > 3
        ) sub
    )
);

SELECT h.nro_voluntario, EXTRACT(YEAR FROM h.fecha_inicio) AS anio
FROM historico h
GROUP BY h.nro_voluntario,
EXTRACT(YEAR FROM h.fecha_inicio)
HAVING count(*) < 3;


-- f. En el histórico, la fecha de inicio debe ser siempre menor que la fecha de finalización.
-- LA FECHA DE INICIO NUNCA DEBE SER MAYOR QUE LA FECHA DE FINALIZACION (tupla)

alter table historico
ADD CONSTRAINT ck_inicio_menor_fin
    CHECK ( historico.fecha_inicio < historico.fecha_fin );

INSERT INTO historico VALUES ('2022-02-21', 1001, '2022-03-21', 2, 3);
INSERT INTO historico VALUES ('2025-02-21', 1001, '2022-03-21', 2, 3);

