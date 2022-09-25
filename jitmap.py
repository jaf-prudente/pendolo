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
# Rangos en los que gráficará el mapa
rangos_lista =  [(0,0.5),(0.5,1),(1,3),(3,5),(5,10),(10,15),(15,20),(20,60),(60,80),(80,101)]
rangos_labels = ['[0, 0.5]','[0.5, 1]','[1, 3]','[3,5]','[5, 10]','[10, 15]','[15, 20]','[20, 60]','[60,80]','$\mathregular{\leq 80}$']#,'$\mathregular{\geq 80}$']
for i in range(0,len(tg)):
        for k in range(0,len(rangos_lista)):
            if rangos_lista[k][0]<tg[i]<=rangos_lista[k][1]:
                tg[i] = k
            

#---------------------------------------------------------------

dpi_valor = 160
colores =  'mako'
cmap_colors = colores
figsize = 8
espacio_barra_color = 0
fig, ax = plt.subplots(dpi=dpi_valor,  figsize=(figsize+espacio_barra_color, figsize))

# Se define el tamaño de la letra de las marcas de los ejes.
x_ticks_size = y_ticks_size = 15
delta = 1.9e-2 # Espacio entre borde e imagen.

# Se define el tipo de letra que se usará.
csfont = {'fontname':'DejaVu Sans'}
# Se define las etiqietas de los ejes, ele tipo de letra y tamaño
ax.set_xlabel("$\mathregular{θ_1 [rad]}$", size=20, **csfont)
ax.set_ylabel("$\mathregular{θ_2 [rad]}$", size=20, **csfont)

# Se definen las posiciones y etiquetas de las marcas de los ejes x & y.
ax.set_xticks([  102, 818, 1534, 2250, 2966,3682,4398])
ax.set_xticklabels(['-3','2', '1' ,'0', '1', '2','3'])
plt.xticks(fontsize=x_ticks_size, **csfont)
ax.set_yticks([  102, 818, 1534, 2250, 2966,3682,4398])
ax.set_yticklabels(['-3','2', '1' ,'0', '1', '2','3'])
plt.yticks(fontsize=y_ticks_size, **csfont)

sb.set(context = 'paper')
sb.set_style("ticks", {'axes.grid' : False})

# Se trabaja la parte de la barra de color
labels = np.array(rangos_lista)
len_lab = len(rangos_labels)
norm = matplotlib.colors.BoundaryNorm( [i for i in range(0, len_lab+1)] , len_lab, clip=True)
fmt = matplotlib.ticker.FuncFormatter(lambda x, pos: rangos_labels[norm(x)])
norm_bins = np.array([i for i in range(len(rangos_lista))])
diff = np.ones(len_lab )
tickz = norm_bins[:] + diff / 2
barra_color = plt.cm.ScalarMappable(cmap=ListedColormap(cmap_colors),
                           norm=plt.Normalize(vmin=0, vmax=len(rangos_labels) ))
barra_color._A = []
cmap = plt.get_cmap(colores,len(rangos_lista))
sm = mpl.cm.ScalarMappable(cmap=cmap, norm=norm)
#sm.set_array([])
cbar = plt.colorbar(sm, format=fmt, ticks=tickz, orientation="horizontal")
cbar.set_label('Flip time intervals [$\omega^{-1}$]',  size=20,  **csfont, labelpad=10)
#cbar.set_yticks
cbar.ax.tick_params(labelsize=10) 

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
grafica = plt.imshow(data_pivoteada, cmap=colores, aspect = "auto")
#plt. title("Diagrama de tiempos de giro", size=30, **csfont)
plt.savefig(nombre, dpi = dpi_valor)