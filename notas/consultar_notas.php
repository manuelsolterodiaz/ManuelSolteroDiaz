<?php
include("./conexion.php");

$alumnos = [];
$asignaturas = [];
$resultados = [];

try {
    $alumnos = $conexion->query("SELECT DNI, nombre, apellidos FROM Alumno ORDER BY apellidos, nombre")->fetchAll();
    $asignaturas = $conexion->query("SELECT id_asignatura, nombre FROM Asignatura ORDER BY nombre")->fetchAll();
} catch (PDOException $e) {
    die("ERROR AL CARGAR DATOS: " . $e->getMessage());
}

if (!empty($_GET)) {
    $dni  = $_GET["alumno"] ?? "";
    $asig = $_GET["asignatura"] ?? "";
    $nota_min = $_GET["nota_min"] ?? "";
    $nota_max = $_GET["nota_max"] ?? "";

    $sql = "
        SELECT 
            Alumno.nombre,
            Alumno.apellidos,
            Asignatura.nombre AS asignatura,
            Calificaciones.nota,
            Calificaciones.fecha
        FROM Alumno, Asignatura, Calificaciones
        WHERE Alumno.DNI = Calificaciones.DNI_alumno
          AND Asignatura.id_asignatura = Calificaciones.id_asignatura
    ";

    $condiciones = [];
    $params = [];

    if ($dni !== "") {
        $condiciones[] = "Alumno.DNI = :dni";
        $params[":dni"] = $dni;
    }

    if ($asig !== "") {
        $condiciones[] = "Asignatura.id_asignatura = :asig";
        $params[":asig"] = $asig;
    }

    if ($nota_min !== "") {
        $condiciones[] = "Calificaciones.nota >= :nota_min";
        $params[":nota_min"] = $nota_min;
    }

    if ($nota_max !== "") {
        $condiciones[] = "Calificaciones.nota <= :nota_max";
        $params[":nota_max"] = $nota_max;
    }

    if (!empty($condiciones)) {
        $sql .= " AND " . implode(" AND ", $condiciones);
    }

    $sql .= " ORDER BY Calificaciones.fecha DESC";

    try {
        $stmt = $conexion->prepare($sql);
        foreach ($params as $clave => $valor) {
            $stmt->bindValue($clave, $valor);
        }
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
    <title>Consultar notas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand">Consultar notas</span>
    </div>
</nav>

<div class="container">

    <form class="card p-4 mb-4" method="GET">
        <h4 class="mb-3">Filtros de búsqueda</h4>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Alumno</label>
                <select name="alumno" class="form-select">
                    <option value="">Todos</option>
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
                <select name="asignatura" class="form-select">
                    <option value="">Todas</option>
                    <?php foreach ($asignaturas as $as): ?>
                        <option value="<?= htmlspecialchars($as['id_asignatura']) ?>"
                            <?= (($_GET["asignatura"] ?? "") == $as['id_asignatura']) ? "selected" : "" ?>>
                            <?= htmlspecialchars($as['nombre']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Nota mínima</label>
                <input type="number" name="nota_min" class="form-control" min="0" max="10" step="0.25"
                       value="<?= htmlspecialchars($_GET["nota_min"] ?? "") ?>">
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Nota máxima</label>
                <input type="number" name="nota_max" class="form-control" min="0" max="10" step="0.25"
                       value="<?= htmlspecialchars($_GET["nota_max"] ?? "") ?>">
            </div>
        </div>

        <button class="btn btn-success w-100">Consultar</button>
    </form>

    <?php if (!empty($resultados)): ?>
        <h4 class="mb-3">Resultados</h4>

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
                <?php foreach ($resultados as $fila): ?>
                    <tr>
                        <td><?= htmlspecialchars($fila['apellidos'] . ", " . $fila['nombre']) ?></td>
                        <td><?= htmlspecialchars($fila['asignatura']) ?></td>
                        <td><?= htmlspecialchars($fila['nota']) ?></td>
                        <td><?= htmlspecialchars($fila['fecha']) ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

    <?php elseif (!empty($_GET)): ?>
        <div class="alert alert-warning">No hay resultados para los filtros seleccionados.</div>
    <?php endif; ?>

    <a href="index.php" class="btn btn-secondary mt-4">← Volver al inicio</a>

</div>

</body>
</html>
