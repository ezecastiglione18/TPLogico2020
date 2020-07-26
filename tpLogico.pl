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

% viajero(Nombre, Raza, armas([arma(nivel)])
% Raza: maiar(nivel, nivelMagico)
% Raza: hobbit(edad)
% Raza: ent(edad)

viajero(gandalf,    maiar(25, 260),         armas(  [baston                 ]   )).

viajero(legolas,    guerrero(elfo),         armas(  [arco(29), espada(20)   ]   )).
viajero(gimli,      guerrero(enano),        armas(  [hacha(26)              ]   )).
viajero(aragorn,    guerrero(dunedain),     armas(  [espada(30)             ]   )).
viajero(boromir,    guerrero(hombre),       armas(  [espada(26)             ]   )).
viajero(gorbag,     guerrero(orco),         armas(  [ballesta(24)           ]   )).
viajero(ugluk,      guerrero(urukhai),      armas(  [espada(26), arco(22)   ]   )).

viajero(frodo,      pacifista(hobbit(51)),  armas(  [espadaCorta            ]   )).
viajero(sam,        pacifista(hobbit(36)),  armas(  [daga                   ]   )).
viajero(barbol,     pacifista(ent(5300)),   armas(  [fuerza                 ]   )).

% Punto 9

raza(Nombre, Tipo) :-
    viajero(Nombre, Raza, _),
    tipoDeRaza(Raza, Tipo).

tipoDeRaza(guerrero(_), guerrera).
tipoDeRaza(guerrero(elfo),   elfo).
tipoDeRaza(guerrero(enano),   enano).
tipoDeRaza(guerrero(dunedain),   dunedain).
tipoDeRaza(maiar(_,_),  maiar).
tipoDeRaza(pacifista(_),   pacifista).


armas(Nombre, Armas) :-
    viajero(Nombre, _, armas(Armas)).
    
nivel(Nombre, Nivel) :-
    viajero(Nombre, maiar(Nivel, _), _).

nivel(Nombre, Nivel) :-
    viajero(Nombre, pacifista(hobbit(Edad)), _),
    Nivel is Edad / 3.

nivel(Nombre, Nivel) :-
    viajero(Nombre, pacifista(ent(Edad)), _),
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
integrante(maiar,moria,24).
integrante(maiar,isengard,27).
integrante(elfo,isengard,30).

%         Item       Zona CantidadMinima
elemento(cotaDeMalla,moria,1).

%     Raza Zona PoderMinimo
magia(enano,moria,50).

cumpleAlgunRequerimiento(Viajero,Zona) :-
 raza(Viajero,Raza),
 nivel(Viajero,Nivel),
 integrante(Raza,Zona,NivelMinimo),
 Nivel >= NivelMinimo.

cumpleAlgunRequerimiento(Viajero,Zona) :-
 elemento(Item,Zona,CantidadMinima),
 findall(_,tieneArma(Viajero,Item),Armas),
 length(Armas,CantidadDeArmas),
 CantidadDeArmas >= CantidadMinima.

cumpleAlgunRequerimiento(Viajero,Zona) :-
 raza(Viajero,Raza),
 poder(Viajero,Poder),
 magia(Raza,Zona,PoderMinimo),
 Poder >= PoderMinimo.

tieneArma(Viajero,Arma) :-
 viajero(Viajero,_,armas(ListaDeArmas)),
 member(Arma,ListaDeArmas).

poder(Viajero,Poder) :-
 raza(Viajero,elfo),
 nivel(Viajero,Nivel),
 Poder is Nivel * 2.
poder(Viajero,Nivel) :-
 raza(Viajero, dunedain),
 nivel(Viajero,Nivel).
poder(Viajero,Nivel) :-
 raza(Viajero, enano),
 nivel(Viajero, Nivel).

puedeAtravesar(Zona,ListaDeViajeros) :-
 esZona(Zona),
 forall(member(Viajero,ListaDeViajeros),cumpleAlgunRequerimiento(Viajero,Zona)).

% Punto 11
seSienteComoEnCasa(ListaDeViajeros,Region):-
 zona(_,Region),
 forall(zona(Zona,Region),puedeAtravesar(Zona,ListaDeViajeros)).