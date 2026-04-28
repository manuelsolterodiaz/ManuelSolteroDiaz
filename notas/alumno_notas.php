<?php
include("auth.php");
require_role("alumno");
include("conexion.php");

$dni = $_SESSION["dni"];

$sql = "
    SELECT Asignatura.nombre AS asignatura,
           Calificaciones.nota,
           Calificaciones.fecha
    FROM Calificaciones, Asignatura
    WHERE Calificaciones.id_asignatura = Asignatura.id_asignatura
      AND Calificaciones.DNI_alumno = :dni
    ORDER BY Calificaciones.fecha DESC
";

$stmt = $conexion->prepare($sql);
$stmt->bindParam(":dni", $dni);
$stmt->execute();
$notas = $stmt->fetchAll();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis notas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand">Mis notas</span>
        <a href="logout.php" class="btn btn-outline-light btn-sm">Salir</a>
    </div>
</nav>

<div class="container">
    <?php if (empty($notas)): ?>
        <div class="alert alert-info">No hay notas registradas.</div>
    <?php else: ?>
        <table class="table table-striped table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>Asignatura</th>
                    <th>Nota</th>
                    <th>Fecha</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($notas as $n): ?>
                    <tr>
                        <td><?= htmlspecialchars($n["asignatura"]) ?></td>
                        <td><?= htmlspecialchars($n["nota"]) ?></td>
                        <td><?= htmlspecialchars($n["fecha"]) ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php endif; ?>
</div>

</body>
</html>
