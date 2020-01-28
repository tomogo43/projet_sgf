--******************************************************************
--                        test_interpreteur
--******************************************************************

--******************************************************************
--                          description
--Tests unitaires pour l'interpreteur
--******************************************************************

with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

with interpreteur;
use interpreteur;

with text_io;
use text_io;

with ada.integer_text_io;
use ada.integer_text_io;

with ada.float_text_io;
use ada.float_text_io;

procedure test_interpreteur is
    
    LONG:constant integer := 100;
    chaine:String(1..LONG);
    lchaine:integer;

    begin --début test_interpreteur
        --get_line(donnee,ldonnee);
        --put(ldonnee);
        --new_line;

        --test de la procedure split
            --get_line(chaine,lchaine);

            --split(chaine,lchaine,'-');

        --test la saisie de commande

        --input_commande(donnee,ldonnee);

        --new_line;

        --test du split

        get_line(chaine,lchaine);
        put("test");
        --put(split(chaine,lchaine,'/'));
        

end test_interpreteur;