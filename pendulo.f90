program pendulo
    
    !==============================================================!
    !                Este programa soluciona péndulos.             !
    !==============================================================!
    
    ! La luna vino a la fragua con su polisón de nardos.

    !---------------------------------------------------------------
    ! Usamos el módulo 'vars' para tener información de los parámetros de entrada.
    use vars
    
    ! Por precaución no dejamos ningún tipo implícito.
    implicit none

    ! Declaramos variables útiles.
    integer i, j, k

    real(8) tg, tl

    ! Declaramos variables del método.
    real(8) k1Th1, k1Th2, k1Xi1, k1Xi2
    real(8) k2Th1, k2Th2, k2Xi1, k2Xi2
    real(8) k3Th1, k3Th2, k3Xi1, k3Xi2
    real(8) k4Th1, k4Th2, k4Xi1, k4Xi2

    ! Declaramos variables que guarden a las funciones derivadas.
    real(8) dTh1, dTh2, dXi1, dXi2

    ! Declaramos los arreglos que usaremos.
    real(8), allocatable, dimension (:) :: t, Th1, Th2, Xi1, Xi2
    real(8), allocatable, dimension (:) :: tiempo_g, tiempo_l
    
    ! Llamamos la subrutina que lee la información de entrada.
    call lector

    ! Alojamos en memoria los arreglos declarados.
    allocate( t(0:Nt), Th1(0:Nt), Th2(0:Nt), Xi1(0:Nt), Xi2(0:Nt) )
    allocate( tiempo_g(0:Nt*Nt), tiempo_l(0:Nt*Nt) )

    !---------------------------------------------------------------
    ! Definimos las condiciones iniciales.
    Th1(0) = -pi
    Th2(0) = -pi
    Xi1(0) = cero
    Xi2(0) = cero

    t(0) = cero

    !---------------------------------------------------------------
    ! Abrimos un archivo para guardar los datos, accedemos a él con la etiqueta '10'.
    open(10, file = 'fractal.csv', status = 'replace')

    ! Escribimos el cabezal del archivo.
    write(10,*) '#Th1, Th2, tg, tl'

    ! Imprimimos en terminal información útil.
    write(*,*) '---------------------------------'
    write(*,*) '| Vamos a comenzar a solucionar |'
    write(*,*) '---------------------------------'
    write(*,*) '|     Línea     |     Total     |'
    write(*,*) '---------------------------------'

    ! Iniciamos el contador de líneas y el contador de índices para los tiempos.
    j = 1
    k = 0

    !---------------------------------------------------------------
    ! Iniciamos los ciclos.
    do while (Th1(0) <= pi)

        do while (Th2(0) <= pi)
            
            !---------------------------------------------------------------
            ! Solucionamos solo la mitad izquierda.
            if (Th1(0) <= 0) then

                ! Esta es la condición de giro.
                !alpha*beta*cos(Th2(0)) + (1+alpha)*cos(Th1(0)) > 1 + alpha*(1-beta)
                if ( alpha*beta*cos(Th2(0)) + (1+alpha)*cos(Th1(0)) > 1 + alpha*(1-beta) ) then

                    !---------------------------------------------------------------
                    ! Si no gira ni latigea podemos decir que lo hace al tiempo final.
                    tg = tf
                    tl = tf

                    !---------------------------------------------------------------
                    ! Escribimos la información en el archivo.
                    write(10,100) Th1(0), Th2(0), tg, tl

                    !---------------------------------------------------------------
                    ! Guardamos el tiempo de giro y latiganzo en un arreglo.
                    tiempo_g(k) = tg
                    tiempo_l(k) = tl
                
                else
                    !---------------------------------------------------------------
                    ! Si no se cumple la condición calculemos en qué momento gira.

                    ! Hacemos el método de Runge-Kutta en sí.
                    do i=0, Nt-1

                        !-------------------------------------------
                        call derivadas( Th1(i), Th2(i), Xi1(i), Xi2(i), &
                        dTh1, dTh2, dXi1, dXi2 )

                        k1Th1 = dTh1
                        k1Th2 = dTh2
                        k1Xi1 = dXi1
                        k1Xi2 = dXi2

                        !-------------------------------------------
                        call derivadas( Th1(i) + medio*k1Th1*dt, Th2(i) + medio*k1Th2*dt, Xi1(i) + medio*k1Xi1*dt, &
                        Xi2(i) + medio*k1Xi2*dt, dTh1, dTh2, dXi1, dXi2 )

                        k2Th1 = dTh1
                        k2Th2 = dTh2
                        k2Xi1 = dXi1
                        k2Xi2 = dXi2

                        !-------------------------------------------
                        call derivadas( Th1(i) + medio*k2Th1*dt, Th2(i) + medio*k2Th2*dt, Xi1(i) + medio*k2Xi1*dt, &
                        Xi2(i) + medio*k2Xi2*dt, dTh1, dTh2, dXi1, dXi2 )

                        k3Th1 = dTh1
                        k3Th2 = dTh2
                        k3Xi1 = dXi1
                        k3Xi2 = dXi2

                        !-------------------------------------------
                        call derivadas( Th1(i) + k3Th1*dt, Th2(i) + k3Th2*dt, Xi1(i) + k3Xi1*dt, Xi2(i) + k3Xi2*dt, &
                        dTh1, dTh2, dXi1, dXi2 )

                        k4Th1 = dTh1
                        k4Th2 = dTh2
                        k4Xi1 = dXi1
                        k4Xi2 = dXi2

                        !-------------------------------------------
                        Th1(i+1) = Th1(i) + ( k1Th1 + dos*k2Th1 + dos*k3Th1 + k4Th1 )*( dt*sexto )
                        Th2(i+1) = Th2(i) + ( k1Th2 + dos*k2Th2 + dos*k3Th2 + k4Th2 )*( dt*sexto )
                        Xi1(i+1) = Xi1(i) + ( k1Xi1 + dos*k2Xi1 + dos*k3Xi1 + k4Xi1 )*( dt*sexto )
                        Xi2(i+1) = Xi2(i) + ( k1Xi2 + dos*k2Xi2 + dos*k3Xi2 + k4Xi2 )*( dt*sexto )

                        !-------------------------------------------
                        t(i+1) = t(i) + dt

                    end do

                    !---------------------------------------------------------------
                    ! Reiniciamos los tiempos de giro y latiganzo.
                    tg = tf
                    tl = tf

                    !---------------------------------------------------------------
                    ! Calculamos el tiempo de giro.
                    do i = 5, Nt
                        if ( ( abs(Th1(i)) > pi ) .or. ( abs(Th2(i)) > pi ) ) then
                            tg = t(i-1)
                            exit
                        end if
                    end do
                        
                    !---------------------------------------------------------------
                    ! Calculamos el tiempo de latiganzo.
                    do i = 5, Nt
                        if ( Xi1(i)*Xi2(i) < 0 ) then
                            tl = t(i-1)
                            exit
                        end if
                    end do
                    
                    !---------------------------------------------------------------
                    ! Escribimos la información en el archivo.
                    write(10,100) Th1(0), Th2(0), tg, tl

                    !---------------------------------------------------------------
                    ! Guardamos el tiempo de giro y latiganzo en un arreglo.
                    tiempo_g(k) = tg
                    tiempo_l(k) = tl
                end if
                
                !---------------------------------------------------------------
                ! Actualizamos el contador de los tiempos.
                k = k + 1
            
            !---------------------------------------------------------------
            ! Hacemos la reflexión.
            else
                !---------------------------------------------------------------
                ! Calculamos los tiempos de giro y latiganzo en función de los ya guardados.
                tg = tiempo_g(k)
                tl = tiempo_l(k)

                !---------------------------------------------------------------
                ! Escribimos en el archivo.
                write(10,100) Th1(0), Th2(0), tg, tl

                !---------------------------------------------------------------
                ! Movemos el contador de los tiempos al contrario.
                k = k - 1
            end if

            ! Damos un paso hacia arriba en la línea para \theta_2(0).
            Th2(0) = Th2(0) + dx

        end do

        ! Damos un paso en la malla para \theta_1(0) y reiniciamos el valor de \theta_2(0).
        Th1(0) = Th1(0) + dx
        Th2(0) = -pi

        ! Imprimimos en pantalla en qué línea vamos.
        write(*,"(a5,i7,a9,i7,a6)") ' |   ',j,'     de  ',Nx,'     |'
        
        ! Actualizamos el contador de líneas.
        j = j + 1

    end do

    ! Imprimimos información útil en pantalla.
    write(*,*) '---------------------------------'
    write(*,*) '|  Ya terminamos, Camarada UwU  |'
    write(*,*) '---------------------------------'

    ! Cerramos el archivo donde escribimos la información.
    close(10)

    ! Definimos el formato de escritura en el archivo, este es estilo cvs.
    100 format (f20.16,',',f20.16,',',f20.16,',',f20.16)

end program