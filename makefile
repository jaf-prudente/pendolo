FLAGS = -O2 -ffree-form -w 

OBJS = pendulo.o vars.o derivadas.o

build : dir link

test : dir_test link_test

dir :
	@ mkdir -p fractal

dir_test :
	@ mkdir -p test

link : $(OBJS)
	@ echo 'Compilando (...)'
	@ gfortran $(FLAGS) -o exe $(OBJS)
	@ echo 'Limpiando archivos extra (...)'
	@ rm *.o
	@ echo 'Moviendo el ejecutable a la carpeta 'fractal' (...)'
	@ mv exe fractal
	@ echo 'Copiando el graficador a la carpeta 'fractal' (...)'
	@ cp jitmap.py fractal
	@ echo 'Todo está listo para ejecutar UwUr'

link_test : $(OBJS)
	@ echo 'Compilando (...)'
	@ gfortran $(FLAGS) -o exe $(OBJS)
	@ echo 'Limpiando archivos extra (...)'
	@ rm *.o
	@ echo 'Moviendo el ejecutable a la carpeta final (...)'
	@ mv exe test
	@ echo 'Copiando el graficador a la carpeta final (...)'
	@ cp jitmap.py test
	@ echo 'Todo está listo para ejecutar UwUr'

pendulo.o : pendulo.f90
	@ gfortran $(FLAGS) -c pendulo.f90

vars.o : vars.f90
	@ gfortran $(FLAGS) -c vars.f90

derivadas.o : derivadas.f90
	@ gfortran $(FLAGS) -c derivadas.f90

clean :
	@ echo 'Limpiando el espacio de trabajo (...)'
	@ /bin/rm -r fractal
	@ echo 'Todo quedó como antes de compilar UwUr'