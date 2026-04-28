<?php
$servidor = "192.168.40.11";
$usuario  = "admin";
$clave    = "abcd";
$bd       = "ies_horizonte";

$opciones = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false
];

try {
    $conexion = new PDO(
        "mysql:host=$servidor;dbname=$bd;charset=utf8",
        $usuario,
        $clave,
        $opciones
    );
} catch (PDOException $e) {
    die("ERROR DE CONEXIÓN: " . $e->getMessage());
}
?>
