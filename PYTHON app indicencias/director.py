import os

# Ruta del archivo de incidencias en C:
ARCHIVO_INCIDENCIAS = "C:\IES Horizonte\incidencias.txt"

def limpiar_pantalla():
    os.system('cls' if os.name == 'nt' else 'clear')

def leer_incidencias():
# Lee todas las incidencias del archivo y las devuelve como lista de diccionarios
    if not os.path.exists(ARCHIVO_INCIDENCIAS):
        return
    
    incidencias = []
    incidencia_actual = {}
    
    with open(ARCHIVO_INCIDENCIAS, "r", encoding="utf-8") as archivo:
        for linea in archivo:
            linea = linea.strip()
            if linea.startswith("-" * 50):
                if incidencia_actual:
                    incidencias.append(incidencia_actual)
                    incidencia_actual = {}
            elif ": " in linea and not linea.startswith("-"):
                clave, valor = linea.split(": ", 1)
                incidencia_actual[clave] = valor
    
    return incidencias

def mostrar_incidencias(incidencias, titulo="LISTADO DE INCIDENCIAS"):
# Muestra todas las incidencias
    limpiar_pantalla()
    print("-" * 50)
    print(f"  {titulo}")
    print("  IES Horizonte - Vista Director")
    print("-" * 50)
    
    if not incidencias:
        print("\nNo hay incidencias registradas")
        return
    
    for i, inc in enumerate(incidencias, 1):
        print(f"\n{'-' * 50}")
        print(f"  INCIDENCIA #{i}")
        print(f"{'-' * 50}")
        print(f"TÍTULO: {inc.get('TÍTULO', '')}")
        print(f"DESCRIPCIÓN: {inc.get('DESCRIPCIÓN', '')}")
        print(f"DOCENTE: {inc.get('DOCENTE', '')}")
        print(f"CATEGORÍA: {inc.get('CATEGORÍA', '')}")
        print(f"UBICACIÓN: {inc.get('UBICACIÓN', '')}")
        print(f"PRIORIDAD: {inc.get('PRIORIDAD', '')}")
        print(f"FECHA: {inc.get('FECHA', '')}")
        print(f"HORA: {inc.get('HORA', '')}")
        print(f"ESTADO: {inc.get('ESTADO', '')}")
    
    print(f"\n{'-' * 50}")
    print(f"Total de incidencias: {len(incidencias)}")
    print("-" * 50)

def ver_todas():
# Muestra todas las incidencias sin filtro
    incidencias = leer_incidencias()
    mostrar_incidencias(incidencias, "TODAS LAS INCIDENCIAS")
    input("\nPresione Enter para continuar...")

def filtrar_por_fecha():
# Filtra incidencias por fecha
    incidencias = leer_incidencias()
    
    if not incidencias:
        limpiar_pantalla()
        print("No hay incidencias registradas")
        input("\nPresione Enter para continuar...")
        return
    
    limpiar_pantalla()
    print("-" * 50)
    print("  FILTRAR POR FECHA")
    print("-" * 50)
    
    fecha = input("\nIntroduzca la fecha (DD/MM/YYYY): ").strip()
    
    incidencias_filtradas = [inc for inc in incidencias if inc.get('FECHA', '') == fecha]
    
    if incidencias_filtradas:
        mostrar_incidencias(incidencias_filtradas, f"INCIDENCIAS DEL {fecha}")
    else:
        limpiar_pantalla()
        print(f"\nNo hay incidencias registradas para la fecha {fecha}")
    
    input("\nPresione Enter para continuar...")

def filtrar_por_dia():
# Filtra incidencias por día (DD)
    incidencias = leer_incidencias()
    
    if not incidencias:
        limpiar_pantalla()
        print("No hay incidencias registradas")
        input("\nPresione Enter para continuar...")
        return
    
    limpiar_pantalla()
    print("-" * 50)
    print("  FILTRAR POR DÍA")
    print("-" * 50)
    
    dia = input("\nIntroduzca el día (DD): ").strip()
    
    incidencias_filtradas = [inc for inc in incidencias if inc.get('FECHA', '').startswith(dia + "/")]
    
    if incidencias_filtradas:
        mostrar_incidencias(incidencias_filtradas, f"INCIDENCIAS DEL DÍA {dia}")
    else:
        limpiar_pantalla()
        print(f"\nNo hay incidencias registradas para el día {dia}")
    
    input("\nPresione Enter para continuar...")

def main():
    while True:
        limpiar_pantalla()
        print("-" * 50)
        print("  SISTEMA DE CONSULTA DE INCIDENCIAS")
        print("  IES Horizonte - Vista Director")
        print("-" * 50)
        print("\n1. Ver todas las incidencias")
        print("2. Filtrar por fecha completa (DD/MM/YYYY)")
        print("3. Filtrar por día (DD)")
        print("4. Salir")
        print("\n" + "-" * 50)
        
        opcion = input("\nSeleccione una opción: ").strip()
        
        if opcion == "1":
            ver_todas()
        elif opcion == "2":
            filtrar_por_fecha()
        elif opcion == "3":
            filtrar_por_dia()
        elif opcion == "4":
            limpiar_pantalla()
            print("\n¡Hasta pronto!\n")
            break
        else:
            print("Opción no válida")
            input("\nPresione Enter para continuar...")

if __name__ == "__main__":
    main()