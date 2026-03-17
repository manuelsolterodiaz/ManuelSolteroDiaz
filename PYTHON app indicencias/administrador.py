import os

# Ruta del archivo de incidencias en C:
ARCHIVO_INCIDENCIAS = "C:\IES Horizonte\incidencias.txt"


def limpiar_pantalla():
    os.system('cls' if os.name == 'nt' else 'clear')

def leer_incidencias():
# Lee todas las incidencias del archivo y las devuelve como lista de diccionarios
    if not os.path.exists(ARCHIVO_INCIDENCIAS):
        return []
    
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

def guardar_incidencias(incidencias):
# Guarda las incidencias pendientes en el archivo
    with open(ARCHIVO_INCIDENCIAS, "w", encoding="utf-8") as archivo:
        for inc in incidencias:
            archivo.write("-" * 50 + "\n")
            archivo.write(f"TÍTULO: {inc.get('TÍTULO', '')}\n")
            archivo.write(f"DESCRIPCIÓN: {inc.get('DESCRIPCIÓN', '')}\n")
            archivo.write(f"DOCENTE: {inc.get('DOCENTE', '')}\n")
            archivo.write(f"CATEGORÍA: {inc.get('CATEGORÍA', '')}\n")
            archivo.write(f"UBICACIÓN: {inc.get('UBICACIÓN', '')}\n")
            archivo.write(f"PRIORIDAD: {inc.get('PRIORIDAD', '')}\n")
            archivo.write(f"FECHA: {inc.get('FECHA', '')}\n")
            archivo.write(f"HORA: {inc.get('HORA', '')}\n")
            archivo.write(f"ESTADO: {inc.get('ESTADO', '')}\n")
            archivo.write("-" * 50 + "\n\n")

def mostrar_incidencias(incidencias):
# Muestra todas las incidencias numeradas
    if not incidencias:
        print("No hay incidencias registradas")
        return False
    
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
    
    return True

def cambiar_estado():
# Permite cambiar el estado de una incidencia
    limpiar_pantalla()
    print("-" * 50)
    print("  CAMBIAR ESTADO DE INCIDENCIA")
    print("-" * 50)
    
    incidencias = leer_incidencias()
    
    if not mostrar_incidencias(incidencias):
        input("\nPresione Enter para continuar...")
        return
    
    print("\n" + "-" * 50)
    num = input("\n¿Qué incidencia desea cambiar? (número): ").strip()
    
    try:
        num = int(num)
        if num < 1 or num > len(incidencias):
            print("Número de incidencia no válido")
            input("\nPresione Enter para continuar...")
            return
    except ValueError:
        print("Debe introducir un número")
        input("\nPresione Enter para continuar...")
        return
    
    incidencia = incidencias[num - 1]
    
    print(f"\nIncidencia seleccionada: {incidencia.get('TÍTULO', '')}")
    print(f"Estado actual: {incidencia.get('ESTADO', '')}")
    
    print("\nNuevo estado:")
    print("1. Pendiente")
    print("2. Resuelto")
    
    opcion = input("\nSeleccione nuevo estado (1-2): ").strip()
    
    if opcion == "1":
        incidencias[num - 1]['ESTADO'] = "Pendiente"
        guardar_incidencias(incidencias)
        print("\n Estado cambiado a Pendiente")
    elif opcion == "2":
        incidencias[num - 1]['ESTADO'] = "Resuelto"
        # Eliminar la incidencia resuelta
        incidencias.pop(num - 1)
        guardar_incidencias(incidencias)
        print("\n Incidencia marcada como Resuelta y eliminada del sistema")
    else:
        print("Opción no válida")
    
    input("\nPresione Enter para continuar...")

def ver_incidencias():
# Muestra todas las incidencias
    limpiar_pantalla()
    print("-" * 50)
    print("  LISTADO DE INCIDENCIAS")
    print("  IES Horizonte - Vista Informático")
    print("-" * 50)
    
    incidencias = leer_incidencias()
    mostrar_incidencias(incidencias)
    
    print("\n" + "-" * 50)

def main():
    while True:
        limpiar_pantalla()
        print("-" * 50)
        print("  SISTEMA DE GESTIÓN DE INCIDENCIAS")
        print("  IES Horizonte - Vista Informático")
        print("-" * 50)
        print("\n1. Ver todas las incidencias")
        print("2. Cambiar estado de incidencia")
        print("3. Salir")
        print("\n" + "-" * 50)
        
        opcion = input("\nSeleccione una opción: ").strip()
        
        if opcion == "1":
            ver_incidencias()
            input("\nPresione Enter para continuar...")
        elif opcion == "2":
            cambiar_estado()
        elif opcion == "3":
            limpiar_pantalla()
            print("\n¡Hasta pronto!\n")
            break
        else:
            print("Opción no válida")
            input("\nPresione Enter para continuar...")

if __name__ == "__main__":
    main()

