#---------------------------------------------------------------
# Importamos bibliotecas.
from codecs import charmap_build
import csv
from fileinput import close
from mailbox import NoSuchMailboxError
from random import betavariate
import pandas as pd
import seaborn as sb
import matplotlib 
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.colors import ListedColormap
import matplotlib.colors as mcolors
import matplotlib as mpl


#---------------------------------------------------------------
# Definimos el nombre del archivo y arreglos.
fractal = 'fractal.csv'

Theta1 = [ ]
Theta2 = [ ]
tg = [ ]


#---------------------------------------------------------------
# Abrimos el archivo y llenamos los arreglos con las columnas.
with open(fractal, 'r') as archivo:

    lector = csv.reader(archivo, delimiter=',')

    next(lector)

    for fila in lector:
        Theta1.append( float( fila[0] ) )
        Theta2.append( float( fila[1] ) )
        tg.append( float( fila[2] ) )

archivo.close()


#---------------------------------------------------------------
# Definimos los tamaños de la figura, el espacio a la barra de 
# color y el canvas de la figura.
figsize = 8
espacio_barra_color = 2.8
fig, ax = plt.subplots(dpi=100,  figsize=(figsize+espacio_barra_color, figsize))

# Se define el tamaño de la letra de las marcas de los ejes.
x_ticks_size = y_ticks_size = 15
delta = 1.9e-2 # Espacio entre borde e imagen.

# Se define el tipo de letra que se usará.
csfont = {'fontname':'DejaVu Sans'}
# Se define las etiqietas de los ejes, ele tipo de letra y tamaño
ax.set_xlabel("$\mathregular{θ_1 [rad]}$", size=20, **csfont)
ax.set_ylabel("$\mathregular{θ_2 [rad]}$", size=20, **csfont)

# Se definen las posiciones y etiquetas de las marcas de los ejes x & y.
ax.set_xticks([  34, 273, 512, 750, 990,1229,1468])
ax.set_xticklabels(['-3','2', '1' ,'0', '1', '2','3'])
plt.xticks(fontsize=x_ticks_size, **csfont)
ax.set_yticks([  34, 273, 512, 750, 990,1229,1468])
ax.set_yticklabels(['-3','2', '1' ,'0', '1', '2','3'])
plt.yticks(fontsize=y_ticks_size, **csfont)

sb.set(context = 'paper')
sb.set_style("ticks", {'axes.grid' : False})


#---------------------------------------------------------------
# Configuramos el nombre de la imagen.
input = '../input.par'
vars = [ ]

with open(input, 'r') as archivo:

    lector = csv.reader(archivo, delimiter=' ')

    next(lector)
    next(lector)
    next(lector)

    for fila in lector:
        vars.append( str( fila[0] ) )

nombre = 'alpha='+vars[0]+', beta='+vars[1]+', w='+vars[2]+'.png'

archivo.close()


#---------------------------------------------------------------
# Graficamos.
data = pd.DataFrame({'X': Theta1, 'Y': Theta2, 'Z': tg})
data_pivoteada = data.pivot('Y', 'X', 'Z')
grafica = plt.imshow(data_pivoteada)
fig.colorbar(grafica)
plt.savefig(nombre, dpi = 600)