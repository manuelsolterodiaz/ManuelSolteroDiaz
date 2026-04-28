<?php
include("auth.php");
require_role("profesor");
include("conexion.php");

$mensaje = "";
$alumnos = [];
$asignaturas = [];

try {
    $alumnos = $conexion->query("SELECT DNI, nombre, apellidos FROM Alumno ORDER BY apellidos, nombre")->fetchAll();
    $asignaturas = $conexion->query("SELECT id_asignatura, nombre FROM Asignatura ORDER BY nombre")->fetchAll();
} catch (PDOException $e) {
    die("ERROR AL CARGAR DATOS: " . $e->getMessage());
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $dni  = $_POST["alumno"] ?? "";
    $asig = $_POST["asignatura"] ?? "";
    $nota = $_POST["nota"] ?? "";

    if ($dni !== "" && $asig !== "" && $nota !== "") {
        try {
            $sql = "INSERT INTO Calificaciones (id_asignatura, DNI_alumno, nota, fecha)
                    VALUES (:asig, :dni, :nota, CURDATE())";
            $stmt = $conexion->prepare($sql);
            $stmt->bindParam(":asig", $asig, PDO::PARAM_INT);
            $stmt->bindParam(":dni",  $dni);
            $stmt->bindParam(":nota", $nota);
            if ($stmt->execute()) {
                $mensaje = "Nota insertada correctamente.";
            } else {
                $mensaje = "No se pudo insertar la nota.";
            }
        } catch (PDOException $e) {
            $mensaje = "ERROR AL INSERTAR NOTA: " . $e->getMessage();
        }
    } else {
        $mensaje = "Debe completar todos los campos.";
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Insertar nota</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand">Insertar nota</span>
        <a href="profesor_menu.php" class="btn btn-outline-light btn-sm">Menú profesor</a>
    </div>
</nav>

<div class="container">

    <?php if ($mensaje): ?>
        <div class="alert alert-info"><?= htmlspecialchars($mensaje) ?></div>
    <?php endif; ?>

    <form class="card p-4" method="POST">
        <h4 class="mb-3">Nueva calificación</h4>

        <label class="form-label">Alumno</label>
        <select name="alumno" class="form-select mb-3" required>
            <option value="">Seleccione un alumno</option>
            <?php foreach ($alumnos as $a): ?>
                <option value="<?= htmlspecialchars($a['DNI']) ?>">
                    <?= htmlspecialchars($a['apellidos'] . ", " . $a['nombre']) ?>
                </option>
            <?php endforeach; ?>
        </select>

        <label class="form-label">Asignatura</label>
        <select name="asignatura" class="form-select mb-3" required>
            <option value="">Seleccione una asignatura</option>
            <?php foreach ($asignaturas as $as): ?>
                <option value="<?= htmlspecialchars($as['id_asignatura']) ?>">
                    <?= htmlspecialchars($as['nombre']) ?>
                </option>
            <?php endforeach; ?>
        </select>

        <label class="form-label">Nota</label>
        <input type="number" name="nota" class="form-control mb-3" min="0" max="10" step="0.25" required>

        <button class="btn btn-primary w-100">Guardar nota</button>
    </form>

</div>
</body>
</html>
