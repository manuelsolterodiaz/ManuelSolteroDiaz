<?php
session_start();

function require_login() {
    if (!isset($_SESSION["dni"]) || !isset($_SESSION["rol"])) {
        header("Location: login.php");
        exit;
    }
}

function require_role($rol) {
    require_login();
    if ($_SESSION["rol"] !== $rol) {
        header("Location: index.php");
        exit;
    }
}
?>
