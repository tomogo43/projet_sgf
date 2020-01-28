--******************************************************************
--                      body package interpreteur
--******************************************************************

--******************************************************************
--                          description
--corps du package interpreteur
--******************************************************************

with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

with arbre;
with text_io;
use text_io;

--SGF
with sgf;
use sgf;

with ada.integer_text_io;
use ada.integer_text_io;

with ada.float_text_io;
use ada.float_text_io;

package body interpreteur is
    
    function nbSeparateur(chaine:in String;lchaine:in integer;sep:in character) return integer is
        nb:integer;
        begin -- début nbSeparateur
            nb := 0;

            for i in 1..lchaine loop
                if(chaine(i) = sep) then
                    nb := nb + 1;
                end if;
            end loop;
            return nb;
    end nbSeparateur;

    function input_commande(commande:in out String;lcommande:in out integer;courant:in out P_sgf) return P_sgf is

        --type tableauSepSlash is array(integer range <>) of unbounded_string;
        emplacement:unbounded_string;

        begin --debut input_commande

            --saisie de commande
            
            loop --boucle tant que l'utilisateur ne saisisse pas exit ou ^C
                --demande à l'utilisateur de saisir une commande 

                emplacement := repertoire_courant(courant) & to_unbounded_string("$");
                put(to_string(emplacement)); --invite l'utilisateur à saisir  

                get_line(commande,lcommande);
                
                courant := detection_commande(commande,lcommande,courant);

                exit when (commande(commande'First..lcommande) = "exit");
                
            end loop;

            return courant;

    end input_commande;


    --procedure detection_commande qui detecte la première commande saisie
    function detection_commande(commande:in string;lcommande:in integer;noeud:in out P_sgf) return P_sgf is
        --R0:[Comment détecter la première commande saisie]


        new_noeud:P_sgf;
        tmpC1:unbounded_string;
        tmpC2:unbounded_string;

        chemin:unbounded_string;    --contient le chemin de la commande "cd"
        chemin2:unbounded_string;   
        lchemin:integer;            --contient la taille du chemin
        lchemin2:integer;            --contient la taille du chemin
        tmpChemin:unbounded_string; --contient le chemin temporaire
        ltmpC1:integer;
        i:integer;
        begin --debut detection_commande 

            --met à jour le noeud
            new_noeud := noeud;

            --R1:Comment R0

            --R2:Si "cd"

            if(commande(commande'First..commande'First+1) = "cd") then
                --R3:Réalise les opérations sur la commande cd

                --récupère le chemin de la commande cd
                chemin := to_unbounded_string(commande(commande'First + 3 .. lcommande));

                --détermine la taille du chemin
                lchemin := lcommande - 3;
                
                --détermine le nombre de séparateur / dans le chemin 

                if(nbSeparateur(to_string(chemin),lchemin,'/') > 0) then --si il y a un separateur / dans le chemin
                    
                    put("split");
                    new_line;
                    put(to_string(chemin));
                    new_line;
                    new_line;

                    --prend le premier repertoire
                    i:=1;
                    loop
                        i := i + 1;
                        if(commande(i) = '/') then
                            i:=i-1; --indique le premier répertoire
                            exit;
                        end if;
                        exit when (i=lcommande);
                    end loop;

                else
                    if(to_string(chemin)="..") then
                        new_noeud := asc_arborescence_sgf(noeud); --remonte dans l'arborescence
                    else
                        new_noeud := desc_arborescence_sgf(noeud,to_string(chemin)); --descend vers le bon repertoire
                    end if;

                    new_line;
                end if;


            --R2:Si "ls"    
            elsif(commande(commande'First..commande'First+1) = "ls") then

                afficher_liste(noeud);

                new_line;
            
            --R2:Si "mkdir"
            elsif(commande(commande'First..commande'First+4) = "mkdir") then
                inserer_repertoire(noeud,commande( (commande'First + 6) .. lcommande ));
            
            --R2:Si "touch"
            elsif(commande(commande'First..commande'First+4) = "touch") then
                inserer_fichier(noeud, commande( (commande'First + 6) .. lcommande ));

            --R2:Si "rm"
            elsif(commande(commande'First..commande'First+1) = "rm") then
                put("supprimer fichier");
                new_line;
                supprimer_fichier(noeud, commande(commande'First + 3 .. lcommande));

            elsif(commande(commande'First..commande'First+2) = "pwd") then
                --R3:Affiche l'emplacement du repertoire
                put(to_string(repertoire_courant(noeud)));
                new_line;

    
            --R2:Commande inconnue
            else
                --R3:Affiche commande introuvable
                put(commande(commande'First..lcommande));
                put(" : commande introuvable");
                new_line;
            end if;

            return new_noeud;
    end detection_commande; --fin detection_commande


    --procedure split
    procedure split(chaine:in string;lchaine:in integer;sep:in character) is
        --R0:[Comment faire un split]
        
        firstChaine: unbounded_string;  --première chaine avant le séparateur
        secondChaine: unbounded_string; --deuxième chaine après le séparateur
        lNewChaine:integer;             --longueur de la nouvelle chaine à tester
        i:integer;  

        tab:tabSep(1..nbSeparateur(chaine,lchaine,sep));

        --CMAX:integer := nbSeparateur(chaine,lchaine,sep);

        begin --debut split

            --R1:Comment R0
            new_line;
            --put(chaine(chaine'First..lchaine));

            i:=lchaine + 1;

            loop
                i := i-1;
                

                if (chaine(i) = sep) then
                    exit;
                end if;

                exit when (i = 1);

            end loop;

            if (i /= 1) then
                firstChaine := to_unbounded_string(chaine((i+1) .. lchaine ));

                secondChaine := to_unbounded_string(chaine(chaine'First .. (i-1)));

                --return split(to_string(secondChaine),i-1,sep);
            else
                firstChaine := to_unbounded_string(chaine(chaine'First .. lchaine));
                new_line;
            end if;

            --put(to_string(firstChaine));
            --new_line;
            --return to_string(firstChaine);
            --return tab;

    end split; --fin split;

end interpreteur;