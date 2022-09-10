module vars

    !==============================================================!
    !      Este módulo lee y guarda los parámetros de entrada.     !
    !==============================================================!

    ! Definimos un módulo que lea información y la comparta de forma global.
    implicit none

    ! Declaramos las variables que pediremos.
    integer Nt, Nx
    real(8) tf
    real(8) alpha, beta, w

    ! Declaramos constantes útiles.
    real(8) cero, sexto, medio, uno, dos, pi
    real(8) dt, dx
    
    contains
    
    !---------------------------------------------------------------
    ! Definimos una subrutina que solicite variables de entrada.
    subroutine lector

        ! Definimos un entero para referirnos al 'input.par'.
        integer fid

        ! Abrimos el 'input.par'.
        open(newunit = fid, file = '../input.par', action = 'read', position = 'rewind')

        !---------------------------------------------------------------
        ! Comenzamos a solicitar la información.

        ! Valor de Nx, el número de divisiones de las C.I.'.
        read(fid,*) Nx

        ! Valor de Nt, el número de divisiones temporales.
        read(fid,*) Nt

        ! Valor de tf, el tiempo final de integración.
        read(fid,*) tf

        ! Valor de alpha.
        read(fid,*) alpha

        ! Valor de beta.
        read(fid,*) beta

        ! Valor de w.
        read(fid,*) w

        !---------------------------------------------------------------
        ! Definimos las constantes útiles.
        cero   = 0.0D0
        sexto  = 1.0D0/6.0D0
        medio  = 1.0D0/2.0D0
        uno    = 1.0D0
        dos    = 2.0D0
        pi     = 4.0D0*atan(1.0D0)

        ! Definimos los pasos temporales.
        dt = tf/Nt
        dx = ( 2*pi )/Nx

        !---------------------------------------------------------------
        ! Cerramos las puertas que abrimos.
        close(fid)

    end subroutine

end module