

# Aplicación de Respaldo para Base de Datos MariaDB
# Interfaz Gráfica Principal
# Autor: Manuel Soltero Díaz
# IES Horizonte

import tkinter as tk
from tkinter import messagebox, ttk
import subprocess
from datetime import datetime

def realizar_copia():
    copia = tk.Toplevel()
    copia.title("Realizar Copia")
    copia.geometry("400x450")
    
    # Título
    tk.Label(copia, text="Realizar Copia", font=("Arial", 16, "bold")).pack(pady=20)
    
    # Variables para guardar los datos
    var1 = tk.StringVar()
    var2 = tk.StringVar()
    var3 = tk.StringVar()
    var4 = tk.StringVar()
    var5 = tk.StringVar()
    
    # Campo 1
    tk.Label(copia, text="Usuario:").pack(pady=5)
    tk.Entry(copia, textvariable=var1, width=30).pack()
    
    # Campo 2
    tk.Label(copia, text="Contraseña:").pack(pady=5)
    tk.Entry(copia, textvariable=var2, width=30, show="*").pack()
    
    # Campo 3 (solo lectura)
    tk.Label(copia, text="Nombre Base de Datos:").pack(pady=5)
    entry_db = tk.Entry(copia, textvariable=var3, width=30, state='readonly')
    entry_db.pack()
    var3.set("ies_horizonte")
    
    # Campo 4 (solo lectura)
    tk.Label(copia, text="Ruta destino:").pack(pady=5)
    entry_ruta = tk.Entry(copia, textvariable=var4, width=30, state='readonly')
    entry_ruta.pack()
    var4.set("/home/vagrant/COPIAS")
    
    # Campo 5
    tk.Label(copia, text="Nombre copia:").pack(pady=5)
    tk.Entry(copia, textvariable=var5, width=30).pack()
    
    # Función para guardar el contenido de las variables
    def guardar_datos():
        usuario = var1.get()
        contraseña = var2.get()
        nombredb = var3.get()
        ruta = var4.get()
        nombrecopia = var5.get()
        
        try:
            # Primer comando: Realizar la copia
            comando_copia = f'vagrant ssh db1 -c "sudo bash /home/vagrant/SCRIPTS/copia.sh {usuario} {contraseña} {nombredb} {ruta} {nombrecopia}"'
            resultado1 = subprocess.run(comando_copia, shell=True, capture_output=True, text=True, cwd="C:/Users/manue/Desktop/proyecto")
            
            if resultado1.returncode == 0:
                # Segundo comando: Copiar el archivo a Windows (Anfitrión)
                scp = f'scp -P 2222 -i C:/Users/manue/Desktop/proyecto/.vagrant/machines/db1/virtualbox/private_key vagrant@127.0.0.1:{ruta}/{nombrecopia}.sql.gz C:/Users/manue/CopiasBBDD/'
                resultado2 = subprocess.run(scp, shell=True, capture_output=True, text=True, cwd="C:/Users/manue/Desktop/proyecto")
                
                if resultado2.returncode == 0:
                    # Obtener fecha actual
                    fecha = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
                    
                    # Guardar en el historial
                    historial = f'vagrant ssh db1 -c "echo \'{nombrecopia}.sql.gz - {fecha}\' >> /home/vagrant/COPIAS/historial.txt"'
                    subprocess.run(historial, shell=True, cwd="C:/Users/manue/Desktop/proyecto")
                    
                    messagebox.showinfo("Éxito", "Copia realizada y descargada correctamente")
                else:
                    messagebox.showerror("Error", "Copia realizada pero error al descargar")
            else:
                messagebox.showerror("Error", "Error al realizar la copia")
        except:
            messagebox.showerror("Error", "No se pudo ejecutar el comando")
    
    # Botón
    tk.Button(copia, text="Realizar copia", command=guardar_datos, width=20, bg="green", fg="white").pack(pady=20)
def restaurar_copia():
    restaurar = tk.Toplevel()
    restaurar.title("Restaurar Copia")
    restaurar.geometry("400x450")
    
    # Título
    tk.Label(restaurar, text="Restaurar Copia", font=("Arial", 16, "bold")).pack(pady=20)
    
    # Variables para guardar los datos
    var1 = tk.StringVar()
    var2 = tk.StringVar()
    var3 = tk.StringVar()
    var_copia = tk.StringVar()
    
    # Campo 1
    tk.Label(restaurar, text="Usuario:").pack(pady=5)
    tk.Entry(restaurar, textvariable=var1, width=30).pack()
    
    # Campo 2
    tk.Label(restaurar, text="Contraseña:").pack(pady=5)
    tk.Entry(restaurar, textvariable=var2, width=30, show="*").pack()
    
    # Campo 3 (solo lectura)
    tk.Label(restaurar, text="Nombre Base de Datos:").pack(pady=5)
    entry_db = tk.Entry(restaurar, textvariable=var3, width=30, state='readonly')
    entry_db.pack()
    var3.set("ies_horizonte")
    
    # Lista de copias disponibles
    tk.Label(restaurar, text="Seleccionar Copia:").pack(pady=5)
    combo_copias = ttk.Combobox(restaurar, textvariable=var_copia, width=27, state='readonly')
    combo_copias.pack()
    
   # Obtener lista de copias
    try:
        comando_listar = 'vagrant ssh db1 -c "find /home/vagrant/COPIAS -name \'*.sql.gz\' -type f -printf \'%f\\n\'"'
        resultado = subprocess.run(comando_listar, shell=True, capture_output=True, text=True, cwd="C:/Users/manue/Desktop/proyecto")
        
        if resultado.returncode == 0 and resultado.stdout.strip():
            copias = [linea.strip() for linea in resultado.stdout.strip().split('\n') if linea.strip()]
            combo_copias['values'] = copias
        else:
            combo_copias['values'] = ["No hay copias disponibles"]
    except:
        combo_copias['values'] = ["Error al obtener copias"]
    
    # Función para restaurar
    def ejecutar_restaurar():
        usuario = var1.get()
        contraseña = var2.get()
        nombredb = var3.get()
        copia_seleccionada = var_copia.get()
        
        if not copia_seleccionada:
            messagebox.showwarning("Advertencia", "Por favor selecciona una copia")
            return
        
        # Quitar la extensión .sql.gz del nombre
        nombre_sin_extension = copia_seleccionada.replace('.sql.gz', '')
        
        try:
            # Comando para restaurar - orden: usuario, nombre_base, ruta, password, nombre_copia
            comando_restaurar = f'vagrant ssh db1 -c "sudo bash /home/vagrant/SCRIPTS/restaurar.sh {usuario} {nombredb} /home/vagrant/COPIAS {contraseña} {nombre_sin_extension}"'
            resultado = subprocess.run(comando_restaurar, shell=True, capture_output=True, text=True, cwd="C:/Users/manue/Desktop/proyecto")
            
            if resultado.returncode == 0:
                # Guardar en el historial
                fecha = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
                historial = f'vagrant ssh db1 -c "echo \'Restauración: {copia_seleccionada} - {fecha}\' >> /home/vagrant/COPIAS/historial.txt"'
                subprocess.run(historial, shell=True, cwd="C:/Users/manue/Desktop/proyecto")
                
                messagebox.showinfo("Éxito", "Restauración realizada correctamente")
            else:
                messagebox.showerror("Error", "Error al restaurar la copia")
        except:
            messagebox.showerror("Error", "No se pudo ejecutar el comando")
    
    # Botón
    tk.Button(restaurar, text="Restaurar", command=ejecutar_restaurar, width=20, bg="blue", fg="white").pack(pady=20)
def ver_copias():
    ventana_copias = tk.Toplevel()
    ventana_copias.title("Ver Copias")
    ventana_copias.geometry("500x400")
    
    # Título
    tk.Label(ventana_copias, text="Copias Disponibles", font=("Arial", 16, "bold")).pack(pady=20)
    
    # Crear un área de texto con scroll
    frame = tk.Frame(ventana_copias)
    frame.pack(expand=True, fill='both', padx=20, pady=10)
    
    scrollbar = tk.Scrollbar(frame)
    scrollbar.pack(side='right', fill='y')
    
    texto = tk.Text(frame, yscrollcommand=scrollbar.set, width=60, height=15, font=("Arial", 12))
    texto.pack(side='left', fill='both', expand=True)
    scrollbar.config(command=texto.yview)
    
    # Leer las copias desde Vagrant
    try:
        comando = 'vagrant ssh db1 -c "ls /home/vagrant/COPIAS/*.sql.gz 2>/dev/null | xargs -n 1 basename"'
        resultado = subprocess.run(comando, shell=True, capture_output=True, text=True, cwd="C:/Users/manue/Desktop/proyecto")
        
        if resultado.returncode == 0 and resultado.stdout.strip():
            copias = resultado.stdout.strip().split()
            texto.insert('1.0', '\n'.join(copias))
        else:
            texto.insert('1.0', "No hay copias disponibles")
    except:
        texto.insert('1.0', "Error al listar las copias")
    
    texto.config(state='disabled')

def historial():
    ventana_historial = tk.Toplevel()
    ventana_historial.title("Historial de Copias")
    ventana_historial.geometry("600x400")
    
    # Título
    tk.Label(ventana_historial, text="Historial de Copias", font=("Arial", 16, "bold")).pack(pady=20)
    
    # Crear un área de texto con scroll
    frame = tk.Frame(ventana_historial)
    frame.pack(expand=True, fill='both', padx=20, pady=10)
    
    scrollbar = tk.Scrollbar(frame)
    scrollbar.pack(side='right', fill='y')
    
    texto = tk.Text(frame, yscrollcommand=scrollbar.set, width=70, height=15)
    texto.pack(side='left', fill='both', expand=True)
    scrollbar.config(command=texto.yview)
    
    # Leer el historial desde Vagrant
    try:
        comando = 'vagrant ssh db1 -c "cat /home/vagrant/COPIAS/historial.txt"'
        resultado = subprocess.run(comando, shell=True, capture_output=True, text=True, cwd="C:/Users/manue/Desktop/proyecto")
        
        if resultado.returncode == 0:
            texto.insert('1.0', resultado.stdout)
        else:
            texto.insert('1.0', "No hay historial disponible")
    except:
        texto.insert('1.0', "Error al leer el historial")
    
    texto.config(state='disabled')  # Hacer el texto de solo lectura
# Ventana principal
app = tk.Tk()
app.title("Ventana Principal")
app.geometry("400x350")

# Título
tk.Label(app, text="Copias / Restauración", font=("Arial", 16, "bold")).pack(pady=20)
# Botones
tk.Button(app, text="Realizar copia", command=realizar_copia, width=30, height=2, bg="green", fg="white").pack(pady=15)
tk.Button(app, text="Restaurar copia", command=restaurar_copia, width=30, height=2, bg="blue", fg="white").pack(pady=15)
tk.Button(app, text="Ver copias", command=ver_copias, width=30, height=2, bg="orange", fg="black").pack(pady=15)
tk.Button(app, text="Historial", command=historial, width=30, height=2).pack(pady=15)

# Mensaje que es una ventana emergente al abrir la aplicación
messagebox.showinfo("Recordatorio", "Recuerda que tienes que hacer una copia de seguridad")

app.mainloop()

