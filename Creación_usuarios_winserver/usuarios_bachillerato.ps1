# ============================
# Configuración inicial
# ============================

Import-Module ActiveDirectory

$dominio = "DC=ieshorizonte,DC=edu"
$anio = (Get-Date).Year

# Diccionario de OUs de Bachillerato (según estructura real)
$ouBach = @{
    "1" = "OU=1º Bachillerato,OU=Bachillerato,OU=Alumnos,$dominio"
    "2" = "OU=2º Bachillerato,OU=Bachillerato,OU=Alumnos,$dominio"
}

# ============================
# Validación y creación de OUs si faltan
# ============================

foreach ($curso in $ouBach.Keys) {
    $ouPath = $ouBach[$curso]
    try {
        Get-ADOrganizationalUnit -Identity $ouPath -ErrorAction Stop
        Write-Host " OU existente: $ouPath"
    } catch {
        Write-Warning "⚠️ OU no encontrada: $ouPath → creando..."
        New-ADOrganizationalUnit -Name "$cursoº Bachillerato" -Path "OU=Bachillerato,OU=Alumnos,$dominio"
    }
}

# ============================
# Función para crear alumno de Bachillerato
# ============================

function Crear-AlumnoBach {
    param(
        [string]$nombre,
        [string]$apellido1,
        [string]$apellido2,
        [int]$numero,
        [ValidateSet("1","2")]
        [string]$curso
    )

    if (-not $ouBach.ContainsKey($curso)) {
        Write-Warning " El curso $curso no está definido en el diccionario."
        return
    }

    $ouPath = $ouBach[$curso]

    # Normalización básica
    function Normalizar($texto) {
        $sinAcentos = $texto.Normalize("FormD") -replace '\p{Mn}', ''
        return ($sinAcentos -replace '[^a-zA-Z0-9]', '').ToLower()
    }

    $n1 = Normalizar $nombre
    $a1 = Normalizar $apellido1
    $a2 = Normalizar $apellido2

    # Usuario: inicial nombre + apellido1 + inicial apellido2 + número
    $samBase = $n1.Substring(0,1) + $a1 + $a2.Substring(0,1) + "{0:D2}" -f $numero
    $sam = $samBase.Substring(0, [Math]::Min(20, $samBase.Length))

    # Verificar unicidad del UPN
    $upn = "$sam@ieshorizonte.edu"
    if (Get-ADUser -Filter "UserPrincipalName -eq '$upn'" -ErrorAction SilentlyContinue) {
        Write-Warning " UPN duplicado: $upn → usuario no creado."
        return
    }

    # Contraseña: BACH + curso + año + ! + número
    $pwdString = "BACH${curso}$anio!{0:D2}" -f $numero
    $pwd = ConvertTo-SecureString $pwdString -AsPlainText -Force

    # Crear usuario
    New-ADUser -Name "$nombre $apellido1 $apellido2" `
        -GivenName $nombre `
        -Surname "$apellido1 $apellido2" `
        -DisplayName "$nombre $apellido1 $apellido2" `
        -SamAccountName $sam `
        -UserPrincipalName $upn `
        -Path $ouPath `
        -AccountPassword $pwd `
        -ChangePasswordAtLogon $true `
        -Enabled $true `
        -PasswordNeverExpires $false

    Write-Host " Alumno creado: $sam / Contraseña: $pwdString / OU: $cursoº Bachillerato"
}

# ============================
# Ejemplos de creación (nombres nuevos)
# ============================

Crear-AlumnoBach -nombre "Nuria"   -apellido1 "Cano"     -apellido2 "Reyes"    -numero 1 -curso "1"
Crear-AlumnoBach -nombre "David"   -apellido1 "Alonso"   -apellido2 "Gil"      -numero 2 -curso "1"
Crear-AlumnoBach -nombre "Claudia" -apellido1 "Vargas"   -apellido2 "Serrano"  -numero 1 -curso "2"
Crear-AlumnoBach -nombre "Hugo"    -apellido1 "Molina"   -apellido2 "Bravo"    -numero 2 -curso "2"