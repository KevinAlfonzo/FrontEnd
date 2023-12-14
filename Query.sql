-- Database: ms-programs
-- DROP DATABASE IF EXISTS "ms-programs";
--CREATE DATABASE IF EXISTS "ms-programs" WITH
--    OWNER = postgres
--    ENCODING = 'UTF8'
--    LC_COLLATE = 'Spanish_Peru.1252'
--    LC_CTYPE = 'Spanish_Peru.1252'
--    TABLESPACE = pg_default
--    CONNECTION LIMIT = -1
--    IS_TEMPLATE = False;

-- Table: Programs
CREATE TABLE programs (
                          id serial PRIMARY KEY,
                          name VARCHAR(255),
                          type VARCHAR(255),
                          beneficiary VARCHAR(255),
                          responsible VARCHAR(255),
                          description VARCHAR(255),
                          condition CHAR(1) DEFAULT 'A',
                          duration INTEGER,
                          level CHAR(1)
);
-- Datos: Programs
select * from programs;
INSERT INTO programs (name, type, beneficiary, responsible, description, condition, duration, level)
VALUES
('ADN', 'Tutor familiar', 'Padres', 'Equipo Soa', 'Escuela para padres', 'A', 6, 'S'),
('Seguimos Ayudandos', 'Concientizacion', 'Adolescente', 'Equipo Soa', 'Ayudando a Familias', 'A', 2, 'S'),
('Bienvenido', 'Bienvenido', 'Bienvenido', 'Bienvenido', 'Bienvenido', 'A', 8, 'S'),
('Juntos Adelante', 'Concientización', 'Adolescente', 'SOA', 'Ayuda personal', 'A', 9, 'S'),
('Adolescente reinsertado', 'reinsertando al Adolescente', 'Adolescentes', 'Equipo Soa', 'Reinsercion del Adolescente', 'A', 2, 'S')
;
-- Table: Adolescents
CREATE SEQUENCE seq_teen;
CREATE TABLE teen(
     id_adolescente integer default nextval('seq_teen' :: regclass) PRIMARY KEY not null,
     name varchar(200),
     surnamefather varchar(200),
     surnamemother varchar(200),
     dni varchar(8),
     estado char (1) NOT NULL DEFAULT ('A')
);

-- Datos: Adolescents
INSERT INTO teen (name, surnamefather, surnamemother, dni, estado)
VALUES
    ('Juan', 'Pérez', 'González', '91234567', 'A'),
    ('María', 'López', 'Rodríguez', '91234568', 'A'),
    ('Carlos', 'Sánchez', 'Flores', '91234578', 'A'),
    ('Sofía', 'García', 'Ramírez', '91234578', 'A'),
    ('Eduardo', 'Torres', 'Díaz', '91234578', 'A')
;

select * from teen;

-- Tabla de Asignación
CREATE TABLE adolescent_program_assignment (
                                               id serial PRIMARY KEY,
                                               id_adolescent INTEGER REFERENCES teen (id_adolescente),
                                               id_program INTEGER REFERENCES programs (id),
                                               assignment_date DATE
);

BEGIN;

-- Datos: Programs + Adolescents
INSERT INTO adolescent_program_assignment (id_adolescent, id_program, assignment_date)
VALUES
    (1, 1, '2023-09-05'),
    (1, 2, '2023-09-05'),
    (2, 3, '2023-09-05');

COMMIT;

-- Crear la vista
CREATE OR REPLACE VIEW program_assignments_view AS
SELECT
    apa.id AS id_assignments,
    a.dni AS adolescent_dni,
    concat(a.name,' ',a.surnamefather, ' ', a.surnamemother) AS names,
    p.name AS program_name,
    p.duration AS program_duration,
    to_char(apa.assignment_date, 'DD - Mon - YY') as assignment_date,
    p.condition AS program_status
FROM
    adolescent_program_assignment apa
        INNER JOIN
    teen a ON apa.id_adolescent = a.id_adolescente
        INNER JOIN
    programs p ON apa.id_program = p.id;


UPDATE programs
SET name = 'NuevoNombre2',
    type = 'NuevoTipo3',
    beneficiary = 'NuevoBeneficiario2',
    responsible = 'NuevoResponsable2',
    description = 'NuevaDescripción2',
    condition = 'A', -- Nuevo valor para condition
    duration = 7,   -- Nuevo valor para duration
    level = 's'      -- Nuevo valor para level
WHERE id = 1;
COMMIT;
select * from programs;
select * from programs_history;

UPDATE programs SET name = 'Jose' WHERE id = 1;


CREATE TABLE programs_history (
                                  id serial PRIMARY KEY,
                                  program_id INTEGER,
                                  name VARCHAR(255),
                                  type VARCHAR(255),
                                  beneficiary VARCHAR(255),
                                  responsible VARCHAR(255),
                                  description VARCHAR(255),
                                  condition CHAR(1),
                                  duration INTEGER,
                                  level CHAR(1),
                                  change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION programs_history_trigger()
    RETURNS TRIGGER AS $$
BEGIN
    IF OLD IS DISTINCT FROM NEW THEN
        INSERT INTO programs_history (
            program_id,
            name,
            type,
            beneficiary,
            responsible,
            description,
            condition,
            duration,
            level
        ) VALUES (
                     OLD.id,
                     OLD.name,
                     OLD.type,
                     OLD.beneficiary,
                     OLD.responsible,
                     OLD.description,
                     OLD.condition,
                     OLD.duration,
                     OLD.level
                 );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER programs_history
    BEFORE UPDATE ON programs
    FOR EACH ROW
EXECUTE FUNCTION programs_history_trigger();

---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION programs_insert_history_trigger()
    RETURNS TRIGGER AS $$
BEGIN
    -- Insertar en el historial cuando se realiza un INSERT
    INSERT INTO programs_history (
        program_id,
        name,
        type,
        beneficiary,
        responsible,
        description,
        condition,
        duration,
        level
    ) VALUES (
                 NEW.id,
                 NEW.name,
                 NEW.type,
                 NEW.beneficiary,
                 NEW.responsible,
                 NEW.description,
                 NEW.condition,
                 NEW.duration,
                 NEW.level
             );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger
CREATE TRIGGER programs_insert_history
    AFTER INSERT ON programs
    FOR EACH ROW
EXECUTE FUNCTION programs_insert_history_trigger();