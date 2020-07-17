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

zonasLimitrofes(Zona1, Zona2):-
    mismaRegion(Zona1, Zona2), Zona1 \= Zona2.

mismaRegion(Zona1, Zona2):-
    zona(Zona1, Region), zona(Zona2, Region).

sonZonasLimitrofes(Zona1, Zona2):-
    zonasLimitrofes(Zona1, Zona2).

sonZonasLimitrofes(Zona1, Zona2):-
    zonasLimitrofes(Zona2, Zona1).

%Punto4

regionesLimitrofes(UnaRegion,OtraRegion):-
    zona(UnaZona,UnaRegion),
    zona(OtraZona,OtraRegion),
    sonZonasLimitrofes(UnaZona,OtraZona),
    UnaRegion \= OtraRegion.

regionesLejanas(UnaRegion,OtraRegion):-
    zona(_,UnaRegion),
    zona(_,OtraRegion),
    not(regionesLimitrofes(UnaRegion,OtraRegion)),
    not(hayRegionLimitrofeEntre(UnaRegion,OtraRegion)).

hayRegionLimitrofeEntre(UnaRegion,OtraRegion):-
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

tieneLogica([Zona, ZonaSiguiente|RestoDeZonas]):-
    sonZonasLimitrofes(Zona, ZonaSiguiente),
    tieneLogica([ZonaSiguiente|RestoDeZonas]).

tieneLogica([Zona, ZonaSiguiente]):-
    sonZonasLimitrofes(Zona, ZonaSiguiente).

esSeguro([Zona, ZonaSiguiente|RestoDeZonas]):-
    cambiaDeRegion(Zona, ZonaSiguiente),
    esSeguro(RestoDeZonas).

esSeguro([_, Zona, ZonaSiguiente|RestoDeZonas]):-
    cambiaDeRegion(Zona, ZonaSiguiente),
    esSeguro(RestoDeZonas).

esSeguro([Zona, ZonaSiguiente]):-
    cambiaDeRegion(Zona, ZonaSiguiente).

cambiaDeRegion(UnaZona, OtraZona):-
    zona(UnaZona,UnaRegion),
    zona(OtraZona,OtraRegion),
    UnaRegion \= OtraRegion.

% Punto 7

cantidadDeRegiones(Camino, Cantidad):-
    findall(Region, regionDe(Camino, Region), Regiones),
    list_to_set(Regiones, RegionesSinRepetidos),
    length(RegionesSinRepetidos, Cantidad).

regionDe(Camino, Region):-
    member(Zona, Camino),
    zona(Zona, Region).

 todosLosCaminosConducenAMordor([Camino|Resto]):-
    last(Camino, UltimaZona),
    zona(UltimaZona, mordor),
    todosLosCaminosConducenAMordor(Resto).

todosLosCaminosConducenAMordor([Camino]):-
    last(Camino, UltimaZona),
    zona(UltimaZona, mordor).

% Punto 8

% viajero(Nombre, Raza, armas([arma(nivel)])
% Raza: maiar(nivel, nivelMagico)
% Raza: hobbit(edad)
% Raza: ent(edad)

viajero(gandalf,    maiar(25, 260), armas(  [baston                 ]   )).

viajero(legolas,    elfo,           armas(  [arco(29), espada(20)   ]   )).
viajero(gimli,      enano,          armas(  [hacha(26)              ]   )).
viajero(aragorn,    dunedain,       armas(  [espada(30)             ]   )).
viajero(boromir,    hombre,         armas(  [espada(26)             ]   )).
viajero(gorbag,     orco,           armas(  [ballesta(24)           ]   )).
viajero(ugluk,      urukhai,        armas(  [espada(26), arco(22)   ]   )).

viajero(frodo,      hobbit(51),     armas(  [espadaCorta            ]   )).
viajero(sam,        hobbit(36),     armas(  [daga                   ]   )).
viajero(barbol,     ent(5300),      armas(  [fuerza                 ]   )).

% Punto 9

raza(Nombre, Tipo) :-
    viajero(Nombre, Raza, _),
    tipoDeRaza(Raza, Tipo).

tipoDeRaza(elfo,        guerrera).
tipoDeRaza(enano,       guerrera).
tipoDeRaza(dunedain,    guerrera).
tipoDeRaza(hombre,      guerrera).
tipoDeRaza(orco,        guerrera).
tipoDeRaza(urukhai,     guerrera).
tipoDeRaza(maiar(_,_),  maiar).
tipoDeRaza(hobbit(_),   pacifista).
tipoDeRaza(ent(_),      pacifista).

armas(Nombre, Armas) :-
    viajero(Nombre, _, armas(Armas)).

nivel(Nombre, Nivel) :-
    viajero(Nombre, hobbit(Edad), _),
    Nivel is Edad / 3.

nivel(Nombre, Nivel) :-
    viajero(Nombre, ent(Edad), _),
    Nivel is Edad / 100.

nivel(Nombre, Nivel) :-
    raza(Nombre, guerrera),
    armas(Nombre, Armas),
    findall(NivelArma, nivelArmas(Armas, NivelArma), NivelesArmas),
    max_member(Nivel, NivelesArmas).

nivelArmas(Armas, Nivel) :-
    member(Arma, Armas),
    nivelDelArma(Arma, Nivel).

nivelDelArma(arco(Nivel), Nivel).
nivelDelArma(hacha(Nivel), Nivel).
nivelDelArma(espada(Nivel), Nivel).
nivelDelArma(ballesta(Nivel), Nivel).
