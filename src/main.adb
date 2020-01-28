--******************************************************************
--                               Main SGF
--******************************************************************

--******************************************************************
--                          description
--******************************************************************

--sgf
with sgf;
use sgf;

--interpreteur
with interpreteur;
use interpreteur;

with text_io;
use text_io;

with ada.integer_text_io;
use ada.integer_text_io;

with ada.float_text_io;
use ada.float_text_io;

procedure main is
    sgf:P_sgf;
    begin --début du programme
        put("main");
        new_line;

        --initialisation du SGF
        initialiser_sgf(sgf);



        new_line;

        --affiche le noeud courant
        --afficher_noeud_sgf(sgf);

        --inserere deux repertoires
        --inserer_repertoire(sgf,"toto");
        --inserer_repertoire(sgf,"titi");

        --insere un fichier
        --inserer_fichier(sgf,"dodo");

        --test la saisie de commande

        sgf := input_commande(donnee,ldonnee,sgf);

        --commande ls
        --afficher_liste(sgf);

        --descente dans l'arborescence
        
        --sgf := desc_arborescence_sgf(sgf,"toto");

        --afficher_noeud_sgf(sgf);

        --inserer un repertoire dans toto

        --inserer_repertoire(sgf,"dora");

        --inserer un fichier dans toto

        --inserer_fichier(sgf,"dodo");


        --afficher_liste(sgf);

        --afficher_noeud_sgf(sgf);

        --remonte dans l'arborescence 
        --sgf := asc_arborescence_sgf(sgf);

        --affiche le noeud courant
        --afficher_noeud_sgf(sgf);

end main; --fin du programme