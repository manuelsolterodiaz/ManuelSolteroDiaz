<?php
include("auth.php");
require_role("profesor");
include("conexion.php");

$alumnos = [];
$asignaturas = [];
$resultados = [];
$mensaje = "";

try {
    $alumnos = $conexion->query("SELECT DNI, nombre, apellidos FROM Alumno ORDER BY apellidos, nombre")->fetchAll();
    $asignaturas = $conexion->query("SELECT id_asignatura, nombre FROM Asignatura ORDER BY nombre")->fetchAll();
} catch (PDOException $e) {
    die("ERROR AL CARGAR DATOS: " . $e->getMessage());
}

// Actualizar nota
if ($_SERVER["REQUEST_METHOD"] === "POST" && isset($_POST["dni"], $_POST["id_asignatura"], $_POST["fecha"], $_POST["nota"])) {
    $dni   = $_POST["dni"];
    $asig  = $_POST["id_asignatura"];
    $fecha = $_POST["fecha"];
    $nota  = $_POST["nota"];

    try {
        $sql = "UPDATE Calificaciones
                SET nota = :nota
                WHERE DNI_alumno = :dni
                  AND id_asignatura = :asig
                  AND fecha = :fecha";
        $stmt = $conexion->prepare($sql);
        $stmt->bindParam(":nota", $nota);
        $stmt->bindParam(":dni", $dni);
        $stmt->bindParam(":asig", $asig, PDO::PARAM_INT);
        $stmt->bindParam(":fecha", $fecha);
        if ($stmt->execute()) {
            $mensaje = "Nota actualizada correctamente.";
        } else {
            $mensaje = "No se pudo actualizar la nota.";
        }
    } catch (PDOException $e) {
        $mensaje = "ERROR AL ACTUALIZAR NOTA: " . $e->getMessage();
    }

    $_GET["alumno"] = $dni;
    $_GET["asignatura"] = $asig;
}

// Consultar notas de un alumno y asignatura
if (isset($_GET["alumno"], $_GET["asignatura"]) && $_GET["alumno"] !== "" && $_GET["asignatura"] !== "") {
    $dni  = $_GET["alumno"];
    $asig = $_GET["asignatura"];

    try {
        $sql = "
            SELECT 
                Calificaciones.DNI_alumno,
                Calificaciones.id_asignatura,
                Calificaciones.nota,
                Calificaciones.fecha,
                Alumno.nombre,
                Alumno.apellidos,
                Asignatura.nombre AS asignatura
            FROM Calificaciones, Alumno, Asignatura
            WHERE Calificaciones.DNI_alumno = Alumno.DNI
              AND Calificaciones.id_asignatura = Asignatura.id_asignatura
              AND Calificaciones.DNI_alumno = :dni
              AND Calificaciones.id_asignatura = :asig
            ORDER BY Calificaciones.fecha DESC
        ";
        $stmt = $conexion->prepare($sql);
        $stmt->bindParam(":dni", $dni);
        $stmt->bindParam(":asig", $asig, PDO::PARAM_INT);
        $stmt->execute();
        $resultados = $stmt->fetchAll();
    } catch (PDOException $e) {
        die("ERROR EN LA CONSULTA: " . $e->getMessage());
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Modificar nota</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand">Modificar nota</span>
        <a href="profesor_menu.php" class="btn btn-outline-light btn-sm">Menú profesor</a>
    </div>
</nav>

<div class="container">

    <?php if ($mensaje): ?>
        <div class="alert alert-info"><?= htmlspecialchars($mensaje) ?></div>
    <?php endif; ?>

    <form class="card p-4 mb-4" method="GET">
        <h4 class="mb-3">Seleccione alumno y asignatura</h4>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Alumno</label>
                <select name="alumno" class="form-select" required>
                    <option value="">Seleccione un alumno</option>
                    <?php foreach ($alumnos as $a): ?>
                        <option value="<?= htmlspecialchars($a['DNI']) ?>"
                            <?= (($_GET["alumno"] ?? "") === $a['DNI']) ? "selected" : "" ?>>
                            <?= htmlspecialchars($a['apellidos'] . ", " . $a['nombre']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Asignatura</label>
                <select name="asignatura" class="form-select" required>
                    <option value="">Seleccione una asignatura</option>
                    <?php foreach ($asignaturas as $as): ?>
                        <option value="<?= htmlspecialchars($as['id_asignatura']) ?>"
                            <?= (($_GET["asignatura"] ?? "") == $as['id_asignatura']) ? "selected" : "" ?>>
                            <?= htmlspecialchars($as['nombre']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
        </div>

        <button class="btn btn-warning w-100">Buscar notas</button>
    </form>

    <?php if (!empty($resultados)): ?>
        <h4 class="mb-3">Notas encontradas</h4>

        <table class="table table-striped table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>Alumno</th>
                    <th>Asignatura</th>
                    <th>Nota</th>
                    <th>Fecha</th>
                    <th>Modificar</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($resultados as $fila): ?>
                    <tr>
                        <td><?= htmlspecialchars($fila['apellidos'] . ", " . $fila['nombre']) ?></td>
                        <td><?= htmlspecialchars($fila['asignatura']) ?></td>
                        <td><?= htmlspecialchars($fila['nota']) ?></td>
                        <td><?= htmlspecialchars($fila['fecha']) ?></td>
                        <td>
                            <form method="POST" class="d-flex gap-2">
                                <input type="hidden" name="dni" value="<?= htmlspecialchars($fila['DNI_alumno']) ?>">
                                <input type="hidden" name="id_asignatura" value="<?= htmlspecialchars($fila['id_asignatura']) ?>">
                                <input type="hidden" name="fecha" value="<?= htmlspecialchars($fila['fecha']) ?>">

                                <input type="number" name="nota" class="form-control form-control-sm"
                                       min="0" max="10" step="0.25" value="<?= htmlspecialchars($fila['nota']) ?>" required>

                                <button class="btn btn-sm btn-primary">Guardar</button>
                            </form>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

    <?php elseif (isset($_GET["alumno"], $_GET["asignatura"]) && $_GET["alumno"] !== "" && $_GET["asignatura"] !== ""): ?>
        <div class="alert alert-warning">No hay notas para ese alumno y asignatura.</div>
    <?php endif; ?>

</div>
</body>
</html>
