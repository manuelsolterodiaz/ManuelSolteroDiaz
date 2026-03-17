# ============================
# Configuración inicial
# ============================

Import-Module ActiveDirectory

$dominio = "DC=ieshorizonte,DC=edu"
$anio = (Get-Date).Year

# Diccionario de OUs de Primaria
$ouPrimaria = @{
    "1" = "OU=1º Primaria,OU=Primaria,OU=Alumnos,$dominio"
    "2" = "OU=2º Primaria,OU=Primaria,OU=Alumnos,$dominio"
    "3" = "OU=3º Primaria,OU=Primaria,OU=Alumnos,$dominio"
    "4" = "OU=4º Primaria,OU=Primaria,OU=Alumnos,$dominio"
    "5" = "OU=5º Primaria,OU=Primaria,OU=Alumnos,$dominio"
    "6" = "OU=6º Primaria,OU=Primaria,OU=Alumnos,$dominio"
}

# ============================
# Validación y creación de OUs si faltan
# ============================

foreach ($curso in $ouPrimaria.Keys) {
    $ouPath = $ouPrimaria[$curso]
    try {
        Get-ADOrganizationalUnit -Identity $ouPath -ErrorAction Stop
        Write-Host " OU existente: $ouPath"
    } catch {
        Write-Warning "⚠ OU no encontrada: $ouPath → creando..."
        New-ADOrganizationalUnit -Name "$cursoº Primaria" -Path "OU=Primaria,OU=Alumnos,$dominio"
    }
}

# ============================
# Función para crear alumno de Primaria
# ============================

function Crear-AlumnoPrimaria {
    param(
        [string]$nombre,
        [string]$apellido1,
        [string]$apellido2,
        [int]$numero,
        [ValidateSet("1","2","3","4","5","6")]
        [string]$curso
    )

    if (-not $ouPrimaria.ContainsKey($curso)) {
        Write-Warning " El curso $curso no está definido en el diccionario."
        return
    }

    $ouPath = $ouPrimaria[$curso]

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

    # Contraseña: PRIM + curso + año + ! + número
    $pwdString = "PRIM${curso}$anio!{0:D2}" -f $numero
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

    Write-Host " Alumno creado: $sam / Contraseña: $pwdString / OU: $cursoº Primaria"
}

# ============================
# Ejemplos de creación
# ============================

Crear-AlumnoPrimaria -nombre "Ana"     -apellido1 "López"     -apellido2 "Torres"   -numero 1 -curso "1"
Crear-AlumnoPrimaria -nombre "Mario"   -apellido1 "Gómez"     -apellido2 "Ruiz"     -numero 2 -curso "2"
Crear-AlumnoPrimaria -nombre "Lucía"   -apellido1 "Fernández" -apellido2 "Santos"   -numero 3 -curso "3"
Crear-AlumnoPrimaria -nombre "Pedro"   -apellido1 "Sánchez"   -apellido2 "Moreno"   -numero 4 -curso "4"
Crear-AlumnoPrimaria -nombre "Carla"   -apellido1 "Martínez"  -apellido2 "Díaz"     -numero 5 -curso "5"
Crear-AlumnoPrimaria -nombre "Javier"  -apellido1 "Rodríguez" -apellido2 "Pérez"    -numero 6 -curso "6"