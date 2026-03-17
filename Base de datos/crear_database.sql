-- Base de datos para la gestión del IES HORIZONTE
-- Autor: Manuel Soltero Díaz

CREATE DATABASE IF NOT EXISTS IES_HORIZONTE;
USE IES_HORIZONTE;

-- Tabla: Departamento
CREATE TABLE Departamento (
    id_depart INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Tabla: Aula
CREATE TABLE Aula (
    id_aula INT AUTO_INCREMENT PRIMARY KEY,
    capacidad INT NOT NULL,
    planta VARCHAR(20) NOT NULL
);

-- Tabla: Asignatura
CREATE TABLE Asignatura (
    id_asignatura INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    horas_semanales INT NOT NULL
);

-- Tabla: Padres
CREATE TABLE Padres (
    DNI VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100),
    relacion VARCHAR(50) NOT NULL
);

-- Tabla: Curso
CREATE TABLE Curso (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    id_aula INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    nivel VARCHAR(10) NOT NULL,
    FOREIGN KEY (id_aula) REFERENCES Aula(id_aula)
);

-- Tabla: Profesor 
CREATE TABLE Profesor (
DNI VARCHAR(9) PRIMARY KEY,
id_depart INT NOT NULL,
nombre VARCHAR(50) NOT NULL,
apellidos VARCHAR(50) NOT NULL,
telefono VARCHAR(15),
email VARCHAR(100),
FOREIGN KEY (id_depart) REFERENCES Departamento(id_depart)
);

-- Tabla: Alumno
CREATE TABLE Alumno (
    DNI VARCHAR(9) PRIMARY KEY,
    DNI_padre VARCHAR(9),
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    direccion VARCHAR(150),
    email VARCHAR(100),
    FOREIGN KEY (DNI_padre) REFERENCES Padres(DNI)
);

-- Tabla: Calificaciones
CREATE TABLE Calificaciones (
    id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_asignatura INT NOT NULL,
    DNI_alumno VARCHAR(9) NOT NULL,
    nota DECIMAL(4,2) NOT NULL,
    fecha DATE NOT NULL,
    observaciones TEXT,
    FOREIGN KEY (id_asignatura) REFERENCES Asignatura(id_asignatura),
    FOREIGN KEY (DNI_alumno) REFERENCES Alumno(DNI)
);


-- Tabla: Imparte (Profesor-Asignatura)
CREATE TABLE Imparte (
    DNI_profesor VARCHAR(9),
    id_asignatura INT,
    PRIMARY KEY (DNI_profesor, id_asignatura),
    FOREIGN KEY (DNI_profesor) REFERENCES Profesor(DNI),
    FOREIGN KEY (id_asignatura) REFERENCES Asignatura(id_asignatura)
);

-- Tabla: Cursan (Alumno-Asignatura)
CREATE TABLE Cursan (
    DNI_alumno VARCHAR(9),
    id_asignatura INT,
    PRIMARY KEY (DNI_alumno, id_asignatura),
    FOREIGN KEY (DNI_alumno) REFERENCES Alumno(DNI),
    FOREIGN KEY (id_asignatura) REFERENCES Asignatura(id_asignatura)
);

-- Tabla: Matricula (Alumno-Curso)
CREATE TABLE Matricula (
    DNI_alumno VARCHAR(9),
    id_curso INT,
    fecha DATE NOT NULL,
    PRIMARY KEY (DNI_alumno, id_curso),
    FOREIGN KEY (DNI_alumno) REFERENCES Alumno(DNI),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso)
);

-- Tabla: Contiene (Curso-Asignatura)
CREATE TABLE Contiene (
    id_curso INT,
    id_asignatura INT,
    PRIMARY KEY (id_curso, id_asignatura),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso),
    FOREIGN KEY (id_asignatura) REFERENCES Asignatura(id_asignatura)
);
