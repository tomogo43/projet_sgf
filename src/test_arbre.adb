--******************************************************************
--                               test_arbre
--******************************************************************

--******************************************************************
--                          description
--Tests unitaires pour l'arbre du SGF
--******************************************************************

with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;


with p_arbre_gen;

with Ada.Assertions;  
use Ada.Assertions;


with text_io;
use text_io;

with ada.integer_text_io;
use ada.integer_text_io;

with ada.float_text_io;
use ada.float_text_io;

procedure test_arbre is

    procedure affichenombre (E:in integer) is 
        begin --début affichenombre
            put(E);
    end affichenombre;

    --instanciation du package arbre generique avec element en integer et 
    --la procedure affiche qui s'appuie sur la procedure affichenombre
    package arbre_integer is new p_arbre_gen(T_Element=>integer,
                                       affiche=>affichenombre);
    
    use arbre_integer;

    abr:P_Arbre;
    parent:P_Arbre;
    enfant:P_Arbre;

    noeud:P_Arbre;

    recup_element:P_Arbre;

    begin --debut test_arbre

        --*********************initialisation de l'arbre***********************
        initialiser_arbre(abr);

        --lève une assertion si non vide
        Assert(est_vide(abr),"l'arbre n'est pas vide"); 
        --*********************************************************************
        
        --***************************insérer en tête***************************
        inserer_en_tete(abr,2);

        --lève une assertion si l'arbre n'est pas rempli 
        Assert(not est_vide(abr),"l'arbre n'est pas vide"); 

        --lève une assertion si le noeud avec l'élément 2 n'a pas été créé
        Assert(retourne_noeud(abr) = 2,"le noeud n' a pas été créé correctement");
        --*********************************************************************


        --*********************************************************************
        --                    Opérations sur l'arbre
        --*********************************************************************

        --***************************insérer noeud***************************

        --insère un neud d'élément 3 dans le noeud courant
        inserer_noeud(abr,3);
        --insère un noeud d'élément 4 dans le noeud courant
        inserer_noeud(abr,4);

        --vérifie si le noeud 3 est bien enfant du noeud courant (2)
        Assert(existe_enfant_element(abr,3),"noeud non créé dans le répertoire courant");
        --vérifie si le noeud 4 est bien enfant du noeud courant (2)
        Assert(existe_enfant_element(abr,4),"noeud non créé dans le répertoire courant");

        --*********************************************************************

        --***************************déplacement dans l'arbre***************************

        parent:=abr;

        --si on se déplace vers un enfant existant 
        enfant:=desc_arborescence(parent,3); 
        Assert(not (parent = enfant),"déplacement vers l'enfant 3 impossible");

        --revenir vers le noeud parent
        enfant:= asc_arborescence(enfant);
        Assert(parent = enfant,"Erreur sur la remontée du noeud");

        --si on souhaite remonter au dessus de la racine 
        enfant := asc_arborescence(parent);
        Assert(parent = enfant,"Erreur sur la remontée du noeud au dessus de la racine");

        --si on tente de joindre un noeud inexistant de l'arbre
        enfant := desc_arborescence(parent,21);
        Assert(parent = enfant,"Erreur si le noeud est non joignable");
        
        supprimer_noeud(abr,3);
        Assert(existe_enfant_element(abr,3),"noeud supp");





    
end test_arbre; --fin test_arbre