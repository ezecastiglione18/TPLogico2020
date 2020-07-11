%BASE DE CONOCIMIENTO
%zona(NOMBRE, REGION)
zona(comarca, eriador).
zona(rivendel, eriador).
zona(moria, montaniasNubladas).
zona(lothlorien, montaniasNubladas).
zona(edoras, rohan).
zona(isengard, rohan).
zona(abismoDeHelm, rohan).
zona(minasTirith, gondor).
zona(minasMorgul, mordor).
zona(monteDelDestino, mordor).

%camino(nombre camino, lista de zonas)
camino(camino1, [comarca, rivendel, moria, lothlorien, edoras, minasTirith, minasMorgul, monteDelDestino]).

%zonasLimitrofes(una zona, otra zona)
zonasLimitrofes(rivendel, moria).
zonasLimitrofes(moria, isengard).
zonasLimitrofes(lothlorien, edoras).
zonasLimitrofes(edoras, minasTirith).
zonasLimitrofes(minasTirith, minasMorgul).
zonasLimitrofes(Zona1, Zona2):-
    zona(Zona1, Region), zona(Zona2, Region), Zona1 \= Zona2.

% Punto 4

