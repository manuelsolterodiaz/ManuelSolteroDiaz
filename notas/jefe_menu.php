<?php
include("auth.php");
require_role("jefe");
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Jefe de estudios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand">Jefe de estudios</span>
        <a href="logout.php" class="btn btn-outline-light btn-sm">Salir</a>
    </div>
</nav>

<div class="container">
    <a href="jefe_ver_notas.php" class="btn btn-success w-100 mb-3">Ver todas las notas</a>
</div>

</body>
</html>
