<?php
session_start();

if (!isset($_SESSION["rol"])) {
    header("Location: login.php");
    exit;
}

if ($_SESSION["rol"] === "alumno")  header("Location: alumno_notas.php");
if ($_SESSION["rol"] === "profesor") header("Location: profesor_menu.php");
if ($_SESSION["rol"] === "jefe")    header("Location: jefe_menu.php");
?>
