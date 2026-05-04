-- =============================================
-- INSERCIÓN DE DATOS
-- =============================================
USE IES_HORIZONTE;

-- Departamentos
INSERT INTO Departamento (nombre, descripcion) VALUES
('Matemáticas', 'Departamento de ciencias matemáticas y estadística'),
('Lengua y Literatura', 'Departamento de lengua española y literatura'),
('Ciencias Naturales', 'Departamento de biología, física y química'),
('Idiomas', 'Departamento de lenguas extranjeras'),
('Ciencias Sociales', 'Departamento de historia, geografía y filosofía'),
('Educación Física', 'Departamento de actividades físicas y deportes'),
('Tecnología', 'Departamento de informática y tecnología');

-- Profesores
INSERT INTO Profesor (DNI, id_depart, nombre, apellidos, telefono, email) VALUES
('12345678A', 1, 'Carlos', 'García Martínez', '600111222', 'carlos.garcia@ieshorizonte.es'),
('23456789B', 1, 'Ana', 'López Fernández', '600222333', 'ana.lopez@ieshorizonte.es'),
('34567890C', 2, 'María', 'Rodríguez Sánchez', '600333444', 'maria.rodriguez@ieshorizonte.es'),
('45678901D', 3, 'José', 'Martínez González', '600444555', 'jose.martinez@ieshorizonte.es'),
('56789012E', 3, 'Laura', 'Hernández Díaz', '600555666', 'laura.hernandez@ieshorizonte.es'),
('67890123F', 4, 'David', 'Pérez Ruiz', '600666777', 'david.perez@ieshorizonte.es'),
('78901234G', 5, 'Elena', 'Sánchez Moreno', '600777888', 'elena.sanchez@ieshorizonte.es'),
('89012345H', 6, 'Miguel', 'Torres Jiménez', '600888999', 'miguel.torres@ieshorizonte.es'),
('90123456I', 7, 'Sara', 'Ramírez Castro', '600999000', 'sara.ramirez@ieshorizonte.es');

-- Asignaturas
INSERT INTO Asignatura (nombre, horas_semanales) VALUES
('Matemáticas I', 4),
('Matemáticas II', 4),
('Lengua Castellana y Literatura', 3),
('Física y Química', 3),
('Biología y Geología', 3),
('Inglés', 3),
('Historia de España', 3),
('Geografía', 2),
('Educación Física', 2),
('Tecnología', 2),
('Informática', 2),
('Filosofía', 2);

-- Aulas
INSERT INTO Aula (capacidad, planta) VALUES
(30, 1),
(30, 1),
(25, 2),
(25, 2),
(35, 0),
(20, 3);

-- Cursos
INSERT INTO Curso (id_aula, nombre, nivel) VALUES
(1, '1º ESO A', '1º ESO'),
(2, '2º ESO A', '2º ESO'),
(3, '3º ESO A', '3º ESO'),
(4, '4º ESO A', '4º ESO'),
(5, '1º Bachillerato', '1º Bach'),
(6, '2º Bachillerato', '2º Bach');

-- Padres
INSERT INTO Padres (DNI, nombre, apellidos, telefono, email, relacion) VALUES
('11111111A', 'Juan', 'García López', '655111111', 'juan.garcia@email.com', 'Padre'),
('22222222B', 'Carmen', 'Fernández Ruiz', '655222222', 'carmen.fernandez@email.com', 'Madre'),
('33333333C', 'Pedro', 'Martínez Soto', '655333333', 'pedro.martinez@email.com', 'Padre'),
('44444444D', 'Isabel', 'González Mora', '655444444', 'isabel.gonzalez@email.com', 'Madre'),
('55555555E', 'Antonio', 'Rodríguez Vila', '655555555', 'antonio.rodriguez@email.com', 'Padre'),
('66666666F', 'Rosa', 'Jiménez Ramos', '655666666', 'rosa.jimenez@email.com', 'Madre'),
('77777777G', 'Francisco', 'Díaz Romero', '655777777', 'francisco.diaz@email.com', 'Padre'),
('88888888H', 'Dolores', 'Muñoz Ortiz', '655888888', 'dolores.munoz@email.com', 'Madre');

-- Alumnos
INSERT INTO Alumno (DNI, DNI_padre, nombre, apellidos, fecha_nacimiento, direccion, email) VALUES
('51111111A', '11111111A', 'Pablo', 'García Fernández', '2010-03-15', 'Calle Mayor 12, Villablanca', 'pablo.garcia@estudiante.es'),
('52222222B', '22222222B', 'Lucía', 'Fernández Martínez', '2009-07-22', 'Avenida Andalucía 45, Villablanca', 'lucia.fernandez@estudiante.es'),
('53333333C', '33333333C', 'Javier', 'Martínez González', '2010-11-08', 'Plaza España 3, Villablanca', 'javier.martinez@estudiante.es'),
('54444444D', '44444444D', 'Marta', 'González Rodríguez', '2008-05-30', 'Calle Sevilla 78, Villablanca', 'marta.gonzalez@estudiante.es'),
('55555555E', '55555555E', 'Sergio', 'Rodríguez Jiménez', '2009-01-12', 'Calle Huelva 23, Villablanca', 'sergio.rodriguez@estudiante.es'),
('56666666F', '66666666F', 'Andrea', 'Jiménez Díaz', '2010-09-25', 'Avenida Portugal 56, Villablanca', 'andrea.jimenez@estudiante.es'),
('57777777G', '77777777G', 'Daniel', 'Díaz Muñoz', '2008-12-03', 'Calle Paz 89, Villablanca', 'daniel.diaz@estudiante.es'),
('58888888H', '88888888H', 'Carmen', 'Muñoz López', '2009-04-18', 'Plaza Constitución 15, Villablanca', 'carmen.munoz@estudiante.es');

-- Relación: Profesor imparte Asignatura
INSERT INTO Imparte (DNI_profesor, id_asignatura) VALUES
('12345678A', 1), ('12345678A', 2),
('23456789B', 1),
('34567890C', 3),
('45678901D', 4), ('45678901D', 5),
('56789012E', 5),
('67890123F', 6),
('78901234G', 7), ('78901234G', 8),
('89012345H', 9),
('90123456I', 10), ('90123456I', 11);

-- Relación: Curso contiene Asignatura
INSERT INTO Contiene (id_curso, id_asignatura) VALUES
(1, 1), (1, 3), (1, 4), (1, 6), (1, 9), (1, 10),
(2, 1), (2, 3), (2, 5), (2, 6), (2, 9), (2, 10),
(3, 1), (3, 3), (3, 5), (3, 6), (3, 7), (3, 9),
(4, 2), (4, 3), (4, 4), (4, 6), (4, 8), (4, 9),
(5, 2), (5, 3), (5, 4), (5, 6), (5, 7), (5, 12),
(6, 2), (6, 3), (6, 5), (6, 6), (6, 7), (6, 12);

-- Relación: Alumno se matricula en Curso
INSERT INTO Matricula (DNI_alumno, id_curso, fecha) VALUES
('51111111A', 1, '2024-09-01'),
('52222222B', 2, '2024-09-01'),
('53333333C', 1, '2024-09-01'),
('54444444D', 4, '2024-09-01'),
('55555555E', 2, '2024-09-01'),
('56666666F', 1, '2024-09-01'),
('57777777G', 4, '2024-09-01'),
('58888888H', 2, '2024-09-01');

-- Relación: Alumno cursa Asignatura
INSERT INTO Cursan (DNI_alumno, id_asignatura) VALUES
('51111111A', 1), ('51111111A', 3), ('51111111A', 4), ('51111111A', 6), ('51111111A', 9),
('52222222B', 1), ('52222222B', 3), ('52222222B', 5), ('52222222B', 6), ('52222222B', 9),
('53333333C', 1), ('53333333C', 3), ('53333333C', 4), ('53333333C', 6),
('54444444D', 2), ('54444444D', 3), ('54444444D', 4), ('54444444D', 6), ('54444444D', 9),
('55555555E', 1), ('55555555E', 3), ('55555555E', 5), ('55555555E', 6),
('56666666F', 1), ('56666666F', 3), ('56666666F', 4), ('56666666F', 9),
('57777777G', 2), ('57777777G', 3), ('57777777G', 6), ('57777777G', 8),
('58888888H', 1), ('58888888H', 3), ('58888888H', 5), ('58888888H', 6);

-- Calificaciones
INSERT INTO Calificaciones (id_asignatura, DNI_alumno, nota, fecha, observaciones) VALUES
(1, '51111111A', 7.50, '2024-12-15', 'Buen rendimiento en geometría'),
(3, '51111111A', 8.00, '2024-12-15', 'Excelente comprensión lectora'),
(4, '51111111A', 6.50, '2024-12-15', NULL),
(1, '52222222B', 9.00, '2024-12-15', 'Alumna destacada'),
(5, '52222222B', 8.50, '2024-12-15', 'Muy participativa en laboratorio'),
(2, '54444444D', 7.00, '2024-12-15', NULL),
(3, '54444444D', 6.00, '2024-12-15', 'Debe mejorar redacción'),
(1, '55555555E', 5.50, '2024-12-15', 'Necesita refuerzo'),
(3, '55555555E', 7.50, '2024-12-15', NULL),
(2, '57777777G', 8.00, '2024-12-15', 'Buen progreso'),
(6, '57777777G', 9.50, '2024-12-15', 'Nivel avanzado de inglés');
