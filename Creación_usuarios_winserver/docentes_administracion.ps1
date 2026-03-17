# ============================
# Configuración inicial
# ============================

Import-Module ActiveDirectory

$dominio = "DC=ieshorizonte,DC=edu"
$anio = (Get-Date).Year
$color = "Verde"  # Puedes cambiarlo por otro color institucional

# Diccionario de OUs para personal no alumno
$ouPersonal = @{
    "profesores"   = "OU=Profesores,OU=Docentes,$dominio"
    "maestros"     = "OU=Maestros,OU=Docentes,$dominio"
    "departamentos"= "OU=Departamentos,OU=Docentes,$dominio"
    "direccion"    = "OU=Dirección,OU=Administración,$dominio"
    "jefatura"     = "OU=Jefatura,OU=Administración,$dominio"
    "secretaria"   = "OU=Secretaría,OU=Administración,$dominio"
}

# ============================
# Validación y creación de OUs si faltan
# ============================

foreach ($clave in $ouPersonal.Keys) {
    $ouPath = $ouPersonal[$clave]
    try {
        Get-ADOrganizationalUnit -Identity $ouPath -ErrorAction Stop
        Write-Host " OU existente: $ouPath"
    } catch {
        Write-Warning " OU no encontrada: $ouPath → creando..."
        $partes = $ouPath.Split(",")[0].Split("=")[1]
        $padre  = ($ouPath -replace "^OU=$partes,", "")
        New-ADOrganizationalUnit -Name $partes -Path $padre
    }
}

# ============================
# Función para crear personal no alumno
# ============================

function Crear-Personal {
    param(
        [string]$nombre,
        [string]$apellido1,
        [string]$apellido2,
        [int]$numero,
        [ValidateSet("profesores","maestros","departamentos","direccion","jefatura","secretaria")]
        [string]$rol
    )

    if (-not $ouPersonal.ContainsKey($rol)) {
        Write-Warning " El rol '$rol' no está definido en el diccionario."
        return
    }

    $ouPath = $ouPersonal[$rol]

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

    # Contraseña: año + color + ! + número
    $pwdString = "$anio$color!{0:D2}" -f $numero
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

    Write-Host "Usuario creado: $sam / Contraseña: $pwdString / OU: $rol"
}

# ============================
# Ejemplos de creación
# ============================

Crear-Personal -nombre "Isabel"  -apellido1 "Romero"   -apellido2 "Navarro" -numero 1 -rol "profesores"
Crear-Personal -nombre "Luis"    -apellido1 "Crespo"   -apellido2 "Gómez"   -numero 2 -rol "maestros"
Crear-Personal -nombre "Teresa"  -apellido1 "Blanco"   -apellido2 "Santos"  -numero 3 -rol "departamentos"
Crear-Personal -nombre "Jorge"   -apellido1 "Muñoz"    -apellido2 "Pérez"   -numero 4 -rol "direccion"
Crear-Personal -nombre "Carmen"  -apellido1 "Delgado"  -apellido2 "Ruiz"    -numero 5 -rol "jefatura"
Crear-Personal -nombre "Alberto" -apellido1 "Vega"     -apellido2 "López"   -numero 6 -rol "secretaria"