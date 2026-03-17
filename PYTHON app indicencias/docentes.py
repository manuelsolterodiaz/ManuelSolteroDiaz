import os
from datetime import datetime

# Ruta del archivo de incidencias en C:
ARCHIVO_INCIDENCIAS = "C:\IES Horizonte\incidencias.txt"

def limpiar_pantalla():
    os.system('cls' if os.name == 'nt' else 'clear')

def crear_incidencia():
    limpiar_pantalla()
    print("-" * 50)
    print("  NUEVA INCIDENCIA")
    print("-" * 50)
    
    titulo = input("\nTítulo: ").strip()
    descripcion = input("Descripción detallada: ").strip()
    nombre_docente = os.environ["USERNAME"] 
    print(nombre_docente)
    
    print("\nCategoría:")
    print("1. Técnica (ordenadores, proyectores, impresoras, red)")
    print("2. Infraestructura (mobiliario, luces, climatización)")
    print("3. Materiales (falta de recursos didácticos)")
    cat_opcion = input("Seleccione categoría (1-3): ").strip()
    
    categorias = {
        "1": "Técnica",
        "2": "Infraestructura",
        "3": "Materiales"
    }
    categoria = categorias.get(cat_opcion, "Técnica")
    
    ubicacion = input("Ubicación (aula, laboratorio, etc.): ").strip()
    
    print("\nPrioridad:")
    print("1. Baja")
    print("2. Media")
    print("3. Alta")
    prio_opcion = input("Seleccione prioridad (1-3): ").strip()
    
    prioridades = {
        "1": "Baja",
        "2": "Media",
        "3": "Alta"
    }
    prioridad = prioridades.get(prio_opcion, "Media")
    
    fecha = datetime.now().strftime("%d/%m/%Y")
    hora = datetime.now().strftime("%H:%M:%S")
    estado = "Pendiente"
    
    # Guardar en C:\IES Horizonte\incidencias.txt
    with open(ARCHIVO_INCIDENCIAS, "a", encoding="utf-8") as archivo:
        archivo.write("-" * 50 + "\n")
        archivo.write(f"TÍTULO: {titulo}\n")
        archivo.write(f"DESCRIPCIÓN: {descripcion}\n")
        archivo.write(f"DOCENTE: {nombre_docente}\n")
        archivo.write(f"CATEGORÍA: {categoria}\n")
        archivo.write(f"UBICACIÓN: {ubicacion}\n")
        archivo.write(f"PRIORIDAD: {prioridad}\n")
        archivo.write(f"FECHA: {fecha}\n")
        archivo.write(f"HORA: {hora}\n")
        archivo.write(f"ESTADO: {estado}\n")
        archivo.write("-" * 50 + "\n\n")
    
    print("\n Incidencia registrada correctamente")
    input("\nPresione Enter para continuar...")

def main():
    while True:
        limpiar_pantalla()
        print("-" * 50)
        print("  SISTEMA DE REGISTRO DE INCIDENCIAS")
        print("  IES Horizonte - Vista Docente")
        print("-" * 50)
        print("\n1. Crear nueva incidencia")
        print("2. Salir")
        print("\n" + "-" * 50)
        
        opcion = input("\nSeleccione una opción: ").strip()
        
        if opcion == "1":
            crear_incidencia()
        elif opcion == "2":
            limpiar_pantalla()
            print("\n¡Hasta pronto!\n")
            break
        else:
            print("Opción no válida")
            input("\nPresione Enter para continuar...")

if __name__ == "__main__":
    main()