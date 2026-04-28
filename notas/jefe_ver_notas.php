<?php
include("auth.php");
require_role("jefe");
include("conexion.php");

$sql = "
    SELECT 
        Alumno.apellidos,
        Alumno.nombre,
        Asignatura.nombre AS asignatura,
        Calificaciones.nota,
        Calificaciones.fecha
    FROM Calificaciones, Alumno, Asignatura
    WHERE Calificaciones.DNI_alumno = Alumno.DNI
      AND Calificaciones.id_asignatura = Asignatura.id_asignatura
    ORDER BY Alumno.apellidos, Alumno.nombre, Asignatura.nombre, Calificaciones.fecha DESC
";

$notas = $conexion->query($sql)->fetchAll();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Todas las notas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand">Todas las notas</span>
        <a href="jefe_menu.php" class="btn btn-outline-light btn-sm">Volver</a>
    </div>
</nav>

<div class="container">
    <?php if (empty($notas)): ?>
        <div class="alert alert-info">No hay notas registradas.</div>
    <?php else: ?>
        <table class="table table-striped table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>Alumno</th>
                    <th>Asignatura</th>
                    <th>Nota</th>
                    <th>Fecha</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($notas as $n): ?>
                    <tr>
                        <td><?= htmlspecialchars($n['apellidos'] . ", " . $n['nombre']) ?></td>
                        <td><?= htmlspecialchars($n['asignatura']) ?></td>
                        <td><?= htmlspecialchars($n['nota']) ?></td>
                        <td><?= htmlspecialchars($n['fecha']) ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php endif; ?>
</div>

</body>
</html>
