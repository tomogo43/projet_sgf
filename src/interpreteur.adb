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

        trouve_noeud:P_sgf;

        isTrouve:boolean := false;

        --contient le chemin de la commande "cd"
        chemin:unbounded_string:= to_unbounded_string(commande(commande'First + 3 .. lcommande));
            
        --contient la taille du chemin
        lchemin:integer:= lcommande - 3;  

        taille:constant integer:=20;     --taille du tableau assez grand avec 20 séparateurs
        tab:tabSep(1..taille);           --contient les éléments split du chemin

        begin --debut detection_commande 

            --met à jour le noeud
            new_noeud := noeud;

            --R1:Comment R0

            --R2:Si "cd"

            if(commande(commande'First..commande'First+1) = "cd") then
                --R3:Réalise les opérations sur la commande cd
                
                --détermine le nombre de séparateur / dans le chemin 
                if(nbSeparateur(to_string(chemin),lchemin,'/') > 0) then --si il y a un separateur / dans le chemin
                    
                    --taille := nbSeparateur(to_string(chemin),lchemin,'/') + 1; --n sperateurs = n+1 elt


                    put("split");
                    new_line;
                    split(to_string(chemin),lchemin,'/',tab);
                    
                    new_line;
                    put("***");
                    new_line;

                    trouve_noeud := noeud;

                    for i in 1..(nbSeparateur(to_string(chemin),lchemin,'/') + 1) loop
                        put(to_string(tab(i)));

                        trouve_noeud := desc_arborescence_sgf(noeud,to_string(tab(i)),isTrouve);

                        --if(isTrouve(noeud,to_string(tab(i)))) then
                        --    put("true");
                        --    new_linchemine;
                        --else
                        --    put("false");
                        --    new_line;
                        --end if;


                        new_line;
                    end loop;

                    put(nbSeparateur(to_string(chemin),lchemin,'/'));
                    new_line;


                else
                    if(to_string(chemin)="..") then
                        new_noeud := asc_arborescence_sgf(noeud); --remonte dans l'arborescence
                    else
                        new_noeud := desc_arborescence_sgf(noeud,to_string(chemin),isTrouve); --descend vers le bon repertoire

                        --affiche un message pour dire que l'événement n'a pas été trouvé
                        if(isTrouve /= true) then
                            new_line;
                            put(to_string(chemin));
                            put(" : non trouvé");
                        end if;

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
    procedure split(chaine:in string;lchaine:in integer;sep:in character;tab:in out tabSep) is
        --R0:[Comment faire un split]
        
        
        ch1:unbounded_string;
        ch2:unbounded_string;

        i,j:integer;
        deb:integer;
        lch2:integer; --longueur de la chaine suivante à traiter
        begin --debut split
            put(chaine);

            i:=0;
            j:=1;

            deb:=chaine'First;
            loop
                loop
                i:=i+1;
                    exit when (chaine(i) = sep);
                    i := i + 1;
                end loop;

                ch1 := to_unbounded_string(chaine(deb..i-1));
                ch2 := to_unbounded_string(chaine(i+1..lchaine));

                tab(j) := ch1;
                deb:=i+1;
                j := j + 1;

                lch2 := lchaine - i;

                if(nbSeparateur(to_string(ch2),lch2,sep)=0) then
                    tab(j) := ch2;
                    exit;
                end if;

            end loop;

            --R1:Comment R0
    end split; --fin split;

end interpreteur;