<?php
error_reporting(E_ALL);
ini_set("display_errors", 1);

session_start();
include("conexion.php");
include("jefe.php");

$mensaje = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $usuario = trim($_POST["usuario"]);
    $clave   = trim($_POST["clave"]);

    $rol = "";
    $dni_real = "";

    // 1. Comprobar si es JEFE
    if ($usuario === $JEFE_USUARIO && $clave === $JEFE_CLAVE) {
        $rol = "jefe";
        $dni_real = "JEFE";
    }

    // 2. Si no es jefe, buscar en ALUMNO
    if ($rol === "") {
        $sql = "SELECT DNI FROM Alumno WHERE nombre = :nombre";
        $stmt = $conexion->prepare($sql);
        $stmt->bindParam(":nombre", $usuario);
        $stmt->execute();
        $alumno = $stmt->fetch();

        if ($alumno) {
            if ($clave === $alumno["DNI"]) {
                $rol = "alumno";
                $dni_real = $alumno["DNI"];
            } else {
                $mensaje = "Contraseña incorrecta";
            }
        }
    }

    // 3. Si no es alumno, buscar en PROFESOR
    if ($rol === "") {
        $sql = "SELECT DNI FROM Profesor WHERE nombre = :nombre";
        $stmt = $conexion->prepare($sql);
        $stmt->bindParam(":nombre", $usuario);
        $stmt->execute();
        $profe = $stmt->fetch();

        if ($profe) {
            if ($clave === $profe["DNI"]) {
                $rol = "profesor";
                $dni_real = $profe["DNI"];
            } else {
                $mensaje = "Contraseña incorrecta";
            }
        }
    }

    // 4. Si hay rol, entrar
    if ($rol !== "") {
        $_SESSION["dni"] = $dni_real;
        $_SESSION["rol"] = $rol;

        if ($rol === "alumno")  header("Location: alumno_notas.php");
        if ($rol === "profesor") header("Location: profesor_menu.php");
        if ($rol === "jefe")    header("Location: jefe_menu.php");
        exit;
    }

    // 5. Si no se encontró nada
    if ($mensaje === "") {
        $mensaje = "Usuario o contraseña incorrectos";
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Centro educativo - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5" style="max-width: 400px;">
    <h3 class="mb-4 text-center">Acceso al sistema</h3>

    <?php if ($mensaje): ?>
        <div class="alert alert-danger"><?= $mensaje ?></div>
    <?php endif; ?>

    <form method="POST" class="card p-4 shadow-sm">
        <input type="text" name="usuario" class="form-control mb-3" placeholder="Nombre" required>
        <input type="password" name="clave" class="form-control mb-3" placeholder="DNI" required>
        <button class="btn btn-primary w-100">Entrar</button>
    </form>
</div>

</body>
</html>
