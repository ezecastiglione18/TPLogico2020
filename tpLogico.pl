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

esZona(Zona):-
    zona(Zona, _).

esRegion(Region):-
    zona(_, Region).

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
    esRegion(UnaRegion),
    esRegion(OtraRegion),
    not(regionesLimitrofes(UnaRegion,OtraRegion)),
    not(hayRegionLimitrofeEntre(UnaRegion,OtraRegion)).

hayRegionLimitrofeEntre(UnaRegion,OtraRegion):-
    regionesLimitrofes(UnaRegion,UnaRegionIntermedia),
    regionesLimitrofes(OtraRegion,UnaRegionIntermedia).

%Punto5

puedeSeguirCon(UnCamino,UnaZona):-
    esCamino(UnCamino),
    last(UnCamino,UltimaZona),
    sonZonasLimitrofes(UnaZona,UltimaZona).

sonConsecutivos(UnCamino,OtroCamino):-
    esCamino(UnCamino),
    nth1(1,OtroCamino,UnaZona),
    puedeSeguirCon(UnCamino,UnaZona).

esCamino(UnCamino):-    camino(UnCamino).

% Punto 6

tieneLogica([Zona, ZonaSiguiente|RestoDeZonas]):-
    esZona(Zona),
    sonZonasLimitrofes(Zona, ZonaSiguiente),
    tieneLogica([ZonaSiguiente|RestoDeZonas]).

tieneLogica([Zona, ZonaSiguiente]):-
    sonZonasLimitrofes(Zona, ZonaSiguiente).

esSeguro(Camino):-
    esCamino(Camino),
    not(tiene3ZonasSeguidas(Camino)).

tiene3ZonasSeguidas(Camino):-
    member(Zona1, Camino),
    member(Zona2, Camino),
    forall((member(Zona3, Camino), Zona3 \= Zona1, Zona3 \= Zona2), sonSeguidas(Zona1, Zona2, Zona3)),
    Zona1 \= Zona2.

sonSeguidas(Zona1, Zona2, Zona3):-
    sonZonasLimitrofes(Zona1, Zona2), sonZonasLimitrofes(Zona2, Zona3), sonZonasLimitrofes(Zona1, Zona3).


% Punto 7

cantidadDeRegiones(Camino, Cantidad):-
    esCamino(Camino),
    findall(Region, regionDe(Camino, Region), Regiones),
    list_to_set(Regiones, RegionesSinRepetidos),
    length(RegionesSinRepetidos, Cantidad).

regionDe(Camino, Region):-
    member(Zona, Camino),
    zona(Zona, Region).

todosLosCaminosConducenAMordor(ListaCaminos):-
    forall(member(Camino, ListaCaminos), terminaEn(Camino, mordor)).

terminaEn(Camino, Region):-
    last(UltimaZona, Camino),
    zona(UltimaZona, Region).


% Punto 8

% viajero(Nombre, maiar(Nivel), NivelMagico)
% viajero(Nombre, CualquierGuerrero, armas([arma(nivel)])
% viajero(Nombre, hobbit/Ent, Edad)

viajero(gandalf,    maiar(25), 260).

viajero(legolas,    elfo,     armas( [arco(29), espada(20)   ] )).
viajero(gimli,      enano,    armas( [hacha(26)              ] )).
viajero(aragorn,    dunedain, armas( [espada(30)             ] )).
viajero(boromir,    hombre,   armas( [espada(26)             ] )).
viajero(gorbag,     orco,     armas( [ballesta(24)           ] )).
viajero(ugluk,      urukhai,  armas( [espada(26), arco(22)   ] )).

viajero(frodo, hobbit, 51).
viajero(sam, hobbit, 36).
viajero(barbol, ent, 5300).

% Punto 9

raza(Nombre, Tipo) :-
    viajero(Nombre, Raza, _),
    tipoDeRaza(Raza, Tipo).

tipoDeRaza(Raza, guerrera) :-
    guerrero(Raza).

tipoDeRaza(maiar(_, _), maiar).

tipoDeRaza(Raza, pacifista) :-
    pacifista(Raza).

guerrero(enano).
guerrero(dunedain).
guerrero(hombre).
guerrero(orco).
guerrero(urukhai).
pacifista(hobbit).
pacifista(ent).

armas(Nombre, baston) :-
    raza(Nombre, maiar).

armas(Nombre, Armas) :-
    raza(Nombre, guerrera),
    viajero(Nombre, _, armas(Armas)).

armas(Nombre, Arma) :-
    viajero(Nombre, hobbit, Edad),
    armaPorEdad(Arma, Edad).

armaPorEdad(daga, Edad) :-
    Edad<50.

armaPorEdad(espadaCorta, Edad) :-
    Edad>=50.

armas(Nombre, fuerza) :-
    viajero(Nombre, ent, _).
    
nivel(Nombre, Nivel) :-
    viajero(Nombre, maiar(Nivel), _).

nivel(Nombre, Nivel) :-
    viajero(Nombre, hobbit, Edad),
    Nivel is Edad / 3.

nivel(Nombre, Nivel) :-
    viajero(Nombre, ent, Edad),
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

% Punto 10

%          Raza  Zona  NivelMinimo
integrante(maiar, moria, 24).
integrante(maiar, isengard, 27).
integrante(elfo, isengard, 30).

%         Item       Zona CantidadMinima
elemento(cotaDeMalla, moria, 1).

%     Raza Zona PoderMinimo
magia(enano, moria, 50).

cumpleAlgunRequerimiento(Viajero, Zona) :-
    raza(Viajero, Raza),
    nivel(Viajero, Nivel),
    integrante(Raza, Zona, NivelMinimo),
    Nivel >= NivelMinimo.

cumpleAlgunRequerimiento(Viajero, Zona) :-
    elemento(Item, Zona, CantidadMinima),
    findall(_, tieneArma(Viajero, Item), Armas),
    length(Armas, CantidadDeArmas),
    CantidadDeArmas >= CantidadMinima.

cumpleAlgunRequerimiento(Viajero, Zona) :-
    raza(Viajero, Raza),
    poder(Viajero, Poder),
    magia(Raza, Zona, PoderMinimo),
    Poder >= PoderMinimo.

tieneArma(Viajero, Arma) :-
    viajero(Viajero, _, armas(ListaDeArmas)),
    member(Arma, ListaDeArmas).

poder(Viajero, Poder) :-
    raza(Viajero, elfo),
    nivel(Viajero, Nivel),
    Poder is Nivel * 2.

poder(Viajero, Nivel) :-
    raza(Viajero, dunedain),
    nivel(Viajero, Nivel).

poder(Viajero, Nivel) :-
    raza(Viajero, enano),
    nivel(Viajero, Nivel).

puedeAtravesar(Zona, ListaDeViajeros) :-
    esZona(Zona),
    forall(member(Viajero, ListaDeViajeros), cumpleAlgunRequerimiento(Viajero, Zona)).

% Punto 11
seSienteComoEnCasa(ListaDeViajeros, Region):-
    zona(_, Region),
    forall(zona(Zona, Region), puedeAtravesar(Zona, ListaDeViajeros)).