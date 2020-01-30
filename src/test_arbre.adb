--******************************************************************
--                               test_arbre
--******************************************************************

--******************************************************************
--                          description
--Tests unitaires pour l'arbre du SGF
--******************************************************************

with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;


with arbre;


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

    package arbre_integer is new arbre(T_Element=>integer,
                                       affiche=>affichenombre);
    
    use arbre_integer;

    abr:P_Arbre;
    noeud:P_Arbre;

    recup_element:P_Arbre;

    begin --debut test_arbre

        --*********************initialisation de l'arbre***********************
        initialiser_arbre(abr);
        --*********************************************************************
        
        --*********************************************************************
        --                         tests sur l'arbre
        --*********************************************************************

        pragma assert(est_vide(abr));

        if (est_vide(abr)) then  --vérifie si l'arbre n'est pas vide ==> non initialisé
            put("l'arbre est vide");
            new_line;

            --insérer un élément en tête de l'arbre 
            inserer_en_tete(abr,2);

            --vérifie si l'arbre est vide 
            if (est_vide(abr)) then
                put("l'arbre est vide");
                new_line;
            else 
                put("l'arbre n'est pas vide");
                new_line;
                inserer_noeud(abr,3);
                inserer_noeud(abr,4);

                abr := desc_arborescence(abr,4);
                inserer_noeud(abr,21);
                abr := asc_arborescence(abr);

                --noeud := asc_arborescence(noeud);
                --afficher_arbre(abr);
                
                --jeu de test sur le changement de noeud dans le répertoire 

                
                --affiche_noeud(noeud);
                --new_line;
                --noeud := desc_arborescence(noeud,3);
                --affiche_noeud(noeud);
                --new_line;
                --inserer_noeud(noeud,21);
                --inserer_noeud(noeud,44);
                --afficher_noeuds_enfants(noeud);
                --noeud := asc_arborescence(noeud);
                --affiche_noeud(noeud);
                --new_line;
                --afficher_noeuds_enfants(noeud);
                --noeud := asc_arborescence(noeud);
                --affiche_noeud(noeud);
                --new_line;
                --afficher_noeuds_enfants(noeud);

                noeud:=abr;
                affiche_noeud(noeud);
                --new_line;
                --modifier_noeud(noeud,5);
                --affiche_noeud(noeud);
                new_line;
                afficher_noeuds_enfants(noeud);

                new_line;

                parcourir_arbre(noeud);

                --affiche_noeud(noeud);
                --noeud := desc_arborescence(noeud,3);
                --new_line;
                --affiche_noeud(noeud);


                --noeud := asc_arborescence(noeud);
                --affiche_noeud(noeud);
                --new_line;
                --modifier_noeud(noeud,5);
                --affiche_noeud(noeud);
                --new_line;
                --noeud := desc_arborescence(noeud,3);
                --affiche_noeud(noeud);

                
            end if;

        else
            put("larbre n'est pas vide");
        end if;


    
end test_arbre; --fin test_arbre