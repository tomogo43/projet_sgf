--******************************************************************
--                      body package SGF
--******************************************************************

--******************************************************************
--                          description
--corps du package SGF
--******************************************************************

with arbre;
with text_io;
use text_io;

with ada.integer_text_io;
use ada.integer_text_io;

with ada.float_text_io;
use ada.float_text_io;

package body sgf is 

    --fonction desc_arborescence permet de descendre dans un repertoire enfant de l'arborescence
    function desc_arborescence_sgf(courant:in P_sgf;nom:in string) return P_sgf is
        new_noeud:P_sgf;
        repertoire:description_elt;
        begin --debut desc_arborescence
            repertoire := (to_unbounded_string(nom),DIR);

            new_noeud := desc_arborescence(courant,repertoire);

            if(new_noeud = courant) then
                new_line;
                put(nom);
                put(" : non trouvé");
            end if;

            return new_noeud;
    end desc_arborescence_sgf;

    --fonction asc_arborescence permet d'atteindre le repertoire parent depuis un enfant
    function asc_arborescence_sgf(courant:in P_sgf) return P_sgf is
        new_noeud:P_sgf;
        begin -- début asc_arborescence
            new_noeud := asc_arborescence(courant);
            return new_noeud;
    end asc_arborescence_sgf;

    --fonction repertoire_courant permet de connaitre dans quel repertoire courant se trouve l'utilisateur
    function repertoire_courant(sgf:in P_sgf) return unbounded_string is
        --R0:[Afficher le répertoire courant]

        emplacement:unbounded_string;   --retourne l'emplacement du repertoire courant
        courant:P_sgf;                  --noeud courant 
        noeud:unbounded_string;         --contient le nom du répertoire courant

        begin --début repertoire_courant

            --R1:Comment R0
            --  (1)Déterminer le noeud courant
            --  (2)Remonter à la racine du SGF /

            --R2:Comment R1-1

            courant := sgf; --Récupère le noeud courant
            emplacement := to_unbounded_string(""); 
            
            noeud := retourne_noeud(courant).nom;

            --R2:Comment R1-2
            loop
                
                --R3:Retrouver l'emplacement 

                --rajoute "/" à la fin du nom du répertoire pour spécifier qu'il s'agit d'un repertoire
                emplacement := noeud & to_unbounded_string("/") & emplacement;
 
                --on sort de la boucle quand on arrive à la racine
                exit when (to_string(retourne_noeud(courant).nom) = "~"); --lorsqu'on arrive à la racine

                --Sinon on continue à monter dans l'arborescence de notre SGF
                courant := asc_arborescence_sgf(courant);
                noeud := retourne_noeud(courant).nom ;

            end loop;

            return emplacement; --retourne l'emplacement du répertoire courant

    end repertoire_courant; --fin répertoire courant
    

    procedure affiche_element (E:in description_elt) is 
        begin --début affichenombre
            put(to_string(E.nom));

            if(E.element_type = DIR) then
                put("(DIR)  ");
            else
                put("(FIL)  ");
            end if;

    end affiche_element;

    procedure initialiser_sgf(sgf:in out P_sgf) is
        racine:description_elt;

        begin --début initialiser_sgf

            --déclaration de la racine de notre SGF
            racine.nom := to_unbounded_string("~");
            racine.element_type := DIR;

            --initialisation de l'arbre
            initialiser_arbre(sgf); 

            --vérifie si l'arbre est vide
            if(est_vide(sgf)) then
                put("sgf initialisé");
                new_line;
            end if;

            --intègre la racine en tête du SGF
            inserer_en_tete(sgf,racine);

    end initialiser_sgf; --fin initialiser_sgf

    --procedure afficher_noeuf_sgf affiche le noeud courant dans le SGF
    procedure afficher_noeud_sgf(sgf:in P_sgf) is
        begin --debut afficher_arbre
            affiche_noeud(sgf);
    end afficher_noeud_sgf;

    --procedure inserer_repertoire inserer un repertoire dans le parent
    procedure inserer_repertoire(sgf:in P_sgf;nom:string) is
        repertoire:description_elt;
        begin --debut inserer_repertoire
            repertoire.nom := to_unbounded_string(nom);
            repertoire.element_type := DIR;
            inserer_noeud(sgf,repertoire);
    end inserer_repertoire;

    --procedure inserer_repertoire inserer un repertoire dans le parent
    procedure inserer_fichier(sgf:in P_sgf;nom:string) is
        fichier:description_elt;
        begin --debut inserer_repertoire
            fichier.nom := to_unbounded_string(nom);
            fichier.element_type := FIL;
            inserer_noeud(sgf,fichier);
    end inserer_fichier;

    --procedure supprime_fichier supprime un fichier
    procedure supprimer_fichier(sgf:in out P_sgf; nom:string) is
        fichier:description_elt;
        begin --début supprime_fichier
            put(nom);
            new_line;
            fichier.nom := to_unbounded_string(nom);
            fichier.element_type := FIL;

            supprimer_noeud(sgf,fichier);

    end supprimer_fichier;


    --procedure afficher_liste affiche les repertoires et les fichiers du parent
    procedure afficher_liste(noeud:in P_sgf) is
        begin --debut afficher_liste
            afficher_noeuds_enfants(noeud);
    end afficher_liste;

end sgf;