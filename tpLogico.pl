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

tieneLogica([Zona,ZonaSiguiente|RestoDeZonas]) :-
    sonZonasLimitrofes(Zona, ZonaSiguiente),
    tieneLogica([ZonaSiguiente|RestoDeZonas]).

esSeguro([Zona,ZonaSiguiente|RestoDeZonas]) :-
    cambiaDeRegion(Zona, ZonaSiguiente),
    esSeguro(RestoDeZonas).

esSeguro([_,Zona,ZonaSiguiente|RestoDeZonas]) :-
    cambiaDeRegion(Zona, ZonaSiguiente),
    esSeguro(RestoDeZonas).

cambiaDeRegion(UnaZona, OtraZona) :-
    zona(UnaZona,UnaRegion),
    zona(OtraZona,OtraRegion),
    UnaRegion \= OtraRegion.

% Punto 7

cantidadDeRegiones(Camino, Cantidad) :-
    findall(Region, regionDe(Camino, Region), Regiones),
    list_to_set(Regiones, RegionesSinRepetidos),
    length(RegionesSinRepetidos, Cantidad).

regionDe(Camino, Region) :-
    member(Zona, Camino),
    zona(Zona, Region).

 todosLosCaminosConducenAMordor(Camino|Resto) :-
    last(Camino, UltimaZona),
    zona(UltimaZona, mordor),
    todosLosCaminosConducenAMordor(Resto).

todosLosCaminosConducenAMordor([]).

% Punto 8

% viajero(NOMBRE, tipo)

% TIPO: maiar(nivel, poderMagico)

viajero(gandalf, maiar(25, 260)).

% TIPO: guerrero(raza, armas(Arma, nivelManejo))

viajero(legolas, guerrero(elfo, ([(arco, 29), (espada, 20)]))).
viajero(gimli, guerrero(enano, ([hacha, 26]))).
viajero(aragorn, guerrero(dunedain, ([espada, 30]))).
viajero(boromir, guerrero(hombre, ([espada, 26]))).
viajero(gorbag, guerrero(orco, ([ballesta, 24]))).
viajero(ugluk, guerrero(urukhai, ([(espada, 26), (arco,22)]))).

% TIPO: pacifista(raza, edad)

viajero(frodo, pacifista(hobbit, 51)).
viajero(sam, pacifista(hobbit, 36)).
viajero(barbol, pacifista(ent, 5300)).

% Punto 9

% raza(viajero, suRaza)

%raza(gandalf, maiar).
%raza(legolas, elfo).
%raza(gimli, enano).
%raza(aragorn, dunedain).
%raza(boromir, hombre).
%raza(gorbag, orco).
%raza(ugluk, urukhai).
%raza(frodo, hobbit).
%raza(sam, hobbit).
%raza(barbol, ent).

raza(Viajero, Raza):-
    viajero(Viajero, _, (Raza, _)).

% arma(viajero, suArma)

arma(gandalf, baston).
arma(legolas, arco).
arma(legolas, espada).
arma(gimli, hacha).
arma(aragorn, espada).
arma(boromir, espada).
arma(gorbag, ballesta).
arma(ugluk, espada).
arma(ugluk, arco).
arma(frodo, espadaCorta).
arma(sam, daga).
arma(barbol, fuerza).

% nivel(viajero, suNivel)

%nivel(gandalf, 25).
%nivel(legolas, 29).
%nivel(gimli, 26).
%nivel(aragorn, 30).
%nivel(boromir, 26).
%nivel(gorbag, 24).
%nivel(ugluk, 26).

nivel(Viajero, Nivel):-
    viajero(Viajero, pacifista(hobbit, Edad)),
    Nivel is Edad / 3.

nivel(Viajero, Nivel):-
    viajero(Viajero, pacifista(ent, Edad)),
    Nivel is Edad / 100.

