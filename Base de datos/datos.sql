USE IES_HORIZONTE;

INSERT INTO Departamento (nombre, descripcion) VALUES
('Matemáticas', 'Departamento de Ciencias Matemáticas'),
('Lengua y Literatura', 'Departamento de Lengua Castellana y Literatura'),
('Inglés', 'Departamento de Idiomas - Inglés'),
('Ciencias Naturales', 'Departamento de Biología, Física y Química'),
('Ciencias Sociales', 'Departamento de Historia y Geografía'),
('Educación Física', 'Departamento de Educación Física y Deportes'),
('Tecnología', 'Departamento de Tecnología e Informática');

INSERT INTO Aula (capacidad, planta) VALUES
(30, 'Planta Baja'),
(30, 'Planta Baja'),
(28, 'Primera'),
(28, 'Primera'),
(25, 'Segunda'),
(25, 'Segunda'),
(20, 'Segunda');

INSERT INTO Asignatura (nombre, horas_semanales) VALUES
('Matemáticas', 4),
('Lengua Castellana', 4),
('Inglés', 3),
('Biología', 3),
('Física y Química', 3),
('Geografía e Historia', 3),
('Educación Física', 2),
('Tecnología', 3),
('Informática', 2),
('Música', 2);

INSERT INTO Padres (DNI, nombre, apellidos, telefono, email, relacion) VALUES
('11111111A', 'Carlos', 'García López', '600111111', 'carlos.garcia@email.com', 'Padre'),
('22222222B', 'María', 'Martínez Ruiz', '600222222', 'maria.martinez@email.com', 'Madre'),
('33333333C', 'José', 'Fernández Sánchez', '600333333', 'jose.fernandez@email.com', 'Padre'),
('44444444D', 'Ana', 'Rodríguez Pérez', '600444444', 'ana.rodriguez@email.com', 'Madre'),
('55555555E', 'Luis', 'González Moreno', '600555555', 'luis.gonzalez@email.com', 'Padre'),
('66666666F', 'Carmen', 'López Jiménez', '600666666', 'carmen.lopez@email.com', 'Madre'),
('77777777G', 'Pedro', 'Díaz Navarro', '600777777', 'pedro.diaz@email.com', 'Padre'),
('88888888H', 'Isabel', 'Romero Gil', '600888888', 'isabel.romero@email.com', 'Madre');

INSERT INTO Curso (id_aula, nombre, nivel) VALUES
(1, '1º ESO A', '1º ESO'),
(2, '2º ESO A', '2º ESO'),
(3, '3º ESO A', '3º ESO'),
(4, '4º ESO A', '4º ESO'),
(5, '1º Bachillerato', '1º Bach'),
(6, '2º Bachillerato', '2º Bach');

INSERT INTO Profesor (DNI, id_depart, nombre, apellidos, telefono, email) VALUES
('12345678A', 1, 'Juan', 'Pérez Gómez', '655123456', 'juan.perez@ieshorizonte.es'),
('23456789B', 1, 'Laura', 'Sánchez Torres', '655234567', 'laura.sanchez@ieshorizonte.es'),
('34567890C', 2, 'Antonio', 'Ruiz Morales', '655345678', 'antonio.ruiz@ieshorizonte.es'),
('45678901D', 3, 'Emma', 'Johnson Smith', '655456789', 'emma.johnson@ieshorizonte.es'),
('56789012E', 4, 'Miguel', 'Hernández López', '655567890', 'miguel.hernandez@ieshorizonte.es'),
('67890123F', 4, 'Elena', 'Castro Vega', '655678901', 'elena.castro@ieshorizonte.es'),
('78901234G', 5, 'Francisco', 'Jiménez Ortiz', '655789012', 'francisco.jimenez@ieshorizonte.es'),
('89012345H', 6, 'Marta', 'Navarro Blanco', '655890123', 'marta.navarro@ieshorizonte.es'),
('90123456I', 7, 'David', 'Molina Reyes', '655901234', 'david.molina@ieshorizonte.es');

INSERT INTO Alumno (DNI, DNI_padre, nombre, apellidos, fecha_nacimiento, direccion, email) VALUES
('11223344A', '11111111A', 'Pablo', 'García Martínez', '2010-03-15', 'Calle Mayor 10', 'pablo.garcia@estudiante.es'),
('22334455B', '22222222B', 'Lucía', 'Martínez Ruiz', '2010-07-22', 'Avenida España 25', 'lucia.martinez@estudiante.es'),
('33445566C', '33333333C', 'Javier', 'Fernández López', '2009-11-08', 'Plaza del Sol 5', 'javier.fernandez@estudiante.es'),
('44556677D', '44444444D', 'Sofía', 'Rodríguez García', '2009-05-30', 'Calle Luna 18', 'sofia.rodriguez@estudiante.es'),
('55667788E', '55555555E', 'Daniel', 'González Pérez', '2008-09-12', 'Calle Estrella 32', 'daniel.gonzalez@estudiante.es'),
('66778899F', '66666666F', 'María', 'López Sánchez', '2008-02-17', 'Avenida Libertad 7', 'maria.lopez@estudiante.es'),
('77889900G', '77777777G', 'Alejandro', 'Díaz Moreno', '2007-12-03', 'Calle Paz 14', 'alejandro.diaz@estudiante.es'),
('88990011H', '88888888H', 'Carmen', 'Romero Torres', '2007-06-25', 'Plaza Mayor 3', 'carmen.romero@estudiante.es'),
('99001122I', '11111111A', 'Andrea', 'García Martínez', '2011-04-10', 'Calle Mayor 10', 'andrea.garcia@estudiante.es'),
('00112233J', '22222222B', 'Diego', 'Martínez Ruiz', '2011-08-19', 'Avenida España 25', 'diego.martinez@estudiante.es');

INSERT INTO Calificaciones (id_asignatura, DNI_alumno, nota, fecha, observaciones) VALUES
(1, '11223344A', 7.50, '2024-12-15', 'Buen progreso en geometría'),
(2, '11223344A', 8.00, '2024-12-15', 'Excelente comprensión lectora'),
(3, '11223344A', 6.50, '2024-12-15', 'Debe mejorar la pronunciación'),
(1, '22334455B', 9.00, '2024-12-15', 'Sobresaliente en álgebra'),
(2, '22334455B', 8.50, '2024-12-15', 'Muy buena redacción'),
(4, '33445566C', 7.00, '2024-12-15', 'Buena participación en prácticas'),
(5, '33445566C', 7.50, '2024-12-15', 'Domina los conceptos básicos'),
(1, '44556677D', 8.50, '2024-12-15', 'Destacada en resolución de problemas'),
(6, '55667788E', 6.00, '2024-12-15', 'Necesita repasar fechas históricas'),
(7, '55667788E', 9.00, '2024-12-15', 'Excelente forma física');

INSERT INTO Imparte (DNI_profesor, id_asignatura) VALUES
('12345678A', 1),
('23456789B', 1),
('34567890C', 2),
('45678901D', 3),
('56789012E', 4),
('56789012E', 5),
('67890123F', 4),
('78901234G', 6),
('89012345H', 7),
('90123456I', 8),
('90123456I', 9);

INSERT INTO Cursan (DNI_alumno, id_asignatura) VALUES
('11223344A', 1), ('11223344A', 2), ('11223344A', 3), ('11223344A', 7),
('22334455B', 1), ('22334455B', 2), ('22334455B', 3), ('22334455B', 7),
('33445566C', 1), ('33445566C', 4), ('33445566C', 5), ('33445566C', 8),
('44556677D', 1), ('44556677D', 2), ('44556677D', 6), ('44556677D', 7),
('55667788E', 1), ('55667788E', 6), ('55667788E', 7), ('55667788E', 8),
('66778899F', 1), ('66778899F', 2), ('66778899F', 4), ('66778899F', 5),
('77889900G', 1), ('77889900G', 5), ('77889900G', 6), ('77889900G', 9),
('88990011H', 1), ('88990011H', 2), ('88990011H', 3), ('88990011H', 4);

INSERT INTO Matricula (DNI_alumno, id_curso, fecha) VALUES
('11223344A', 1, '2024-09-01'),
('22334455B', 1, '2024-09-01'),
('99001122I', 1, '2024-09-01'),
('00112233J', 1, '2024-09-01'),
('33445566C', 2, '2024-09-01'),
('44556677D', 2, '2024-09-01'),
('55667788E', 3, '2024-09-01'),
('66778899F', 3, '2024-09-01'),
('77889900G', 4, '2024-09-01'),
('88990011H', 4, '2024-09-01');

INSERT INTO Contiene (id_curso, id_asignatura) VALUES
(1, 1), (1, 2), (1, 3), (1, 7), (1, 10),
(2, 1), (2, 2), (2, 4), (2, 5), (2, 6), (2, 7), (2, 8),
(3, 1), (3, 2), (3, 4), (3, 5), (3, 6), (3, 7), (3, 8),
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (4, 6), (4, 9),
(5, 1), (5, 2), (5, 3), (5, 5), (5, 6),
(6, 1), (6, 2), (6, 3), (6, 5), (6, 6);