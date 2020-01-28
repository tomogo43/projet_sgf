--package de l'interpreteur

with ada.integer_text_io;
use ada.integer_text_io;

with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

with sgf;
use sgf;

package interpreteur is

    --********************************Variables********************************
    
    CMAX: constant integer := 200; --taille max de la commande 
    donnee:string(1..CMAX);        --commande de type String
    ldonnee:integer;               --longueur réelle de la commande

    type tabSep is array (integer range <>) of unbounded_string;

    --********************************Les types********************************    


    --*********************************Fonctions*******************************

    function nbSeparateur(chaine:in String;lchaine:in integer;sep:in character) return integer;

    --*********************************Procédures*******************************
    
    --*********************************************************************
    --nom: input_commande
    --sémantique: procédure qui invite l'utilisateur à saisir une commande
    --paramètres:
    --      commande: Mode(IN/OUT) String; commande entrée par l'utilisateur 
    --      lcommande : Mode(IN/OUT) integer; longueur réelle de la commande
    --pré condition: aucune
    --post condition: invite et traite la commande entrée par l'utilisateur
    --*********************************************************************

    function input_commande(commande:in out String;lcommande:in out integer;courant:in out P_sgf) return P_sgf;

    --*********************************************************************
    --nom: detection_commande
    --sémantique: Procédure qui detecte la commande saisie par l'utilisateur
    --paramètres:
    --      commande: Mode(IN/OUT) String; commande saisie par l'utilisateur
    --      lcommande: Mode(IN) integer; longueur réelle de la commande
    --pré condition: aucune
    --post condition: Réagi en fonction de la commande saisie 
    --*********************************************************************
    function detection_commande(commande:in string;lcommande:in integer;noeud:in out P_sgf) return P_sgf;

    --*********************************************************************
    --nom: split
    --sémantique: Procédure qui split une chaîne de caractère 
    --paramètres:
    --      chaine: Mode(IN) String; chaine à spliter
    --      sep : Mode(IN) character; caractère séparateur
    --pré condition: aucune
    --post condition: la chaîne est splité en fonction du séparateur  
    --*********************************************************************
    procedure split(chaine:in string;lchaine:in integer;sep:in character);


    
end interpreteur;