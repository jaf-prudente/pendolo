subroutine derivadas( Th1, Th2, Xi1, Xi2, dTh1, dTh2, dXi1, dXi2 )

    !==============================================================!
    !     Esta subrutina tiene escritas las EDO's a solucionar.    !
    !==============================================================!

    ! Usamos el módulo 'vars' para tener información de los parámetros de entrada.
    use vars

    implicit none

    ! Declaramos las variables que usaremos.
    real(8) Th1, Th2, Xi1, Xi2
    real(8) dTh1, dTh2, dXi1, dXi2
    real(8) gamma, delta
    real(8) c1, c2

    ! Definimos variables auxiliares.
    gamma = uno + alpha*sin(Th1 - Th2)**2
    delta = Xi1**2 + alpha*(beta**2)*(uno + alpha)*(Xi2**2) - dos*alpha*beta*Xi1*Xi2*cos(Th1 - Th2)
    c1    = ( alpha*beta*Xi1*Xi2*sin(Th1 - Th2) ) / gamma 
    c2    = ( alpha*delta*sin( dos*(Th1 - Th2) ) )/( 2*gamma**2 )

    ! Definimos en sí las ecuaciones diferenciales.
    dTh1 = ( Xi1 - alpha*beta*Xi2*cos(Th1 - Th2) )/gamma
    dTh2 = ( alpha*(beta**2)*(uno + alpha)*Xi2 - alpha*beta*Xi1*cos(Th1 - Th2) ) / gamma
    dXi1 = -(w**2)*(uno + alpha)*sin(Th1) - c1 + c2
    dXi2 = -(w**2)*alpha*beta*sin(Th2) + c1 - c2

end subroutine