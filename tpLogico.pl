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

%camino(lista de zonas)

camino([comarca, rivendel, moria, lothlorien, edoras, minasTirith, minasMorgul, monteDelDestino]).

%zonasLimitrofes(una zona, otra zona)

zonasLimitrofes(rivendel, moria).
zonasLimitrofes(moria, isengard).
zonasLimitrofes(lothlorien, edoras).
zonasLimitrofes(edoras, minasTirith).
zonasLimitrofes(minasTirith, minasMorgul).

zonasLimitrofes(Zona1, Zona2) :-
    mismaRegion(Zona1, Zona2), Zona1 \= Zona2.

mismaRegion(Zona1, Zona2) :-
    zona(Zona1, Region), zona(Zona2, Region).

sonZonasLimitrofes(Zona1, Zona2):-
    zonasLimitrofes(Zona1, Zona2).

sonZonasLimitrofes(Zona1, Zona2):-
    zonasLimitrofes(Zona2, Zona1).

%Punto4

regionesLimitrofes(UnaRegion,OtraRegion) :-
    zona(UnaZona,UnaRegion),
    zona(OtraZona,OtraRegion),
    sonZonasLimitrofes(UnaZona,OtraZona),
    UnaRegion \= OtraRegion.

regionesLejanas(UnaRegion,OtraRegion) :-
    zona(_,UnaRegion),
    zona(_,OtraRegion),
    not(regionesLimitrofes(UnaRegion,OtraRegion)),
    not(hayRegionLimitrofeEntre(UnaRegion,OtraRegion)).

hayRegionLimitrofeEntre(UnaRegion,OtraRegion) :-
    regionesLimitrofes(UnaRegion,UnaRegionIntermedia),
    regionesLimitrofes(OtraRegion,UnaRegionIntermedia).

%Punto5

puedeSeguirCon(UnCamino,UnaZona):-
    last(UnCamino,UltimaZona),
    sonZonasLimitrofes(UnaZona,UltimaZona).

sonConsecutivos(UnCamino,OtroCamino):-
    nth1(1,OtroCamino,UnaZona),
    puedeSeguirCon(UnCamino,UnaZona).

% Punto 6

tieneLogica([Zona|ZonaSiguiente|RestoDeZonas]):-
    sonZonasLimitrofes(Zona, ZonaSiguiente),
    tieneLogica([ZonaSiguiente|RestoDeZonas]).

esSeguro([Zona|ZonaSiguiente|RestoDeZonas]):-
    cambiaDeRegion(Zona, ZonaSiguiente),
    esSeguro(RestoDeZonas).

esSeguro([_|Zona|ZonaSiguiente|RestoDeZonas]):-
    cambiaDeRegion(Zona, ZonaSiguiente),
    esSeguro(RestoDeZonas).

cambiaDeRegion(UnaZona, OtraZona):-
    zona(UnaZona,UnaRegion),
    zona(OtraZona,OtraRegion),
    UnaRegion \= OtraRegion

% Punto 7

cantidadDeRegiones(Camino, CantidadDeRegiones):-
    findall(Region, regionDe(Camino, Region), Regiones), % Tengo que conseguir una lista de regiones
    list_to_set(Regiones, RegionesSinRepetidos),
    length(RegionesSinRepetidos, CantidadDeRegiones).

 todosLosCaminosConducenAMordor(Camino|Resto):-
    last(Camino, UltimaZona),
    zona(UltimaZona, mordor),
    todosLosCaminosConducenAMordor(Resto).

