<?php
include("auth.php");
require_role("profesor");
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Menú profesor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand">Menú profesor</span>
        <a href="logout.php" class="btn btn-outline-light btn-sm">Salir</a>
    </div>
</nav>

<div class="container">
    <a href="insertar_nota.php" class="btn btn-primary w-100 mb-3">Insertar nota</a>
    <a href="modificar_nota.php" class="btn btn-warning w-100">Modificar nota</a>
</div>

</body>
</html>
