--******************************************************************
--                      body package interpreteur
--******************************************************************

--******************************************************************
--                          description
--corps du package interpreteur
--******************************************************************

with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

with p_arbre_gen;
with text_io;
use text_io;

--SGF
with p_sgf_gen;
use p_sgf_gen;

with ada.integer_text_io;
use ada.integer_text_io;

with ada.float_text_io;
use ada.float_text_io;

package body p_interpreteur is
    
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

    --fonction change_directory permet de changer de chemin 
    function change_directory(noeud:in P_sgf;chemin:in string;lchemin:in integer;create:in boolean) return P_sgf is

        taille:constant integer:=20;
        tab:tabSep(1..taille);
        trouve_noeud:P_sgf;
        new_noeud:P_sgf;
        isTrouve:boolean := false;

        nbRepertoire:integer; --nombre de répertoires à spliter 

        valideChemin:boolean:=true; 

        --R0:[Comment faire un change directory]

        begin --debut change_directory 

            --R1:Comment R0

            --R2:Regarder si le chemin possède des séparateurs /

            if(nbSeparateur(chemin,lchemin,'/') > 0) then --si il y a un separateur / dans le chemin
                    
                --R3:Cherche le noeud en fonction du chemin saisi
                trouve_noeud := noeud;

                split(chemin,lchemin,'/',tab);
                
                --SI création d'un dossier ou d'un fichier
                if (create) then
                    nbRepertoire := nbSeparateur(chemin,lchemin,'/'); --le dernier morceau est l'élément à ajouter
                else
                    nbRepertoire := nbSeparateur(chemin,lchemin,'/') + 1;
                end if;

                for i in 1..nbRepertoire loop

                    trouve_noeud := desc_arborescence_sgf(trouve_noeud,to_string(tab(i)),isTrouve);

                    if( (isTrouve = false) and (create =false)) then --si le chemin n'est pas trouvable

                        --affiche l'erreur du chemin introuvable 
                        put(chemin);
                        put(" : chemin introuvable");
                        new_line;
                        valideChemin := false;
                        exit; --sort de la boucle
                        
                    end if;
                end loop;

                --le chemin a bien été trouvé 
                if(valideChemin) then
                    new_noeud := trouve_noeud;
                else
                    new_noeud := noeud;
                end if;

            else
                if(chemin="..") then
                    new_noeud := asc_arborescence_sgf(noeud); --remonte dans l'arborescence

                elsif(chemin="~") then             --remonte à la racine du SGF
                    new_noeud := remonte_racine_sgf(noeud);
                else
                new_noeud := desc_arborescence_sgf(noeud,chemin,isTrouve); --descend vers le bon repertoire

                --affiche un message pour dire que l'événement n'a pas été trouvé
                if(isTrouve /= true) then
                    new_line;
                    put(chemin);
                    put(" : non trouvé");
                    new_line;
                end if;

            end if;

        end if;

        return new_noeud;

    end change_directory; --fin change_directory



    --fonction detection_commande qui detecte la première commande saisie
    function detection_commande(commande:in string;lcommande:in integer;noeud:in out P_sgf) return P_sgf is
        --R0:[Comment détecter la première commande saisie]


        new_noeud:P_sgf;

        trouve_noeud:P_sgf;

        isTrouve:boolean := false;

        --contient le chemin de la commande "cd" et "ls"
        chemin:unbounded_string:= to_unbounded_string(commande(commande'First + 3 .. lcommande));

        --contient le chemin de la commande "mkdir"
        chemin2:unbounded_string;
            
        --contient la taille du chemin
        lchemin:integer:= lcommande - 3;

        --contient la taille du chemin 2 pour mkdir et touch
        lchemin2:integer; 

        i:integer; --variable d'incrémentation

        nom:unbounded_string; --contient le nom du fichier ou du dossier à créer 

        --boolean qui informe si le chemin est correct ou non
        valideChemin:boolean:=true; 

        taille:constant integer:=20;     --taille du tableau assez grand avec 20 séparateurs
        tab:tabSep(1..taille);           --contient les éléments split du chemin

        begin --debut detection_commande 

            --met à jour le noeud
            new_noeud := noeud;

            --R1:Comment R0

            --R2:Si "cd"

            if(commande(commande'First..commande'First+1) = "cd") then
                --R3:Réalise les opérations sur la commande cd
                

                new_noeud := change_directory(noeud,to_string(chemin),lchemin,false);

            --R2:Si "ls"    
            elsif(commande(commande'First..commande'First+1) = "ls") then

                --R3:Les différents fonctionnement de ls
                --  (1) un chemin est spécifié ou demande le détaille 
                --  (2) aucun chemin n'est renseigné
                

                --R4:Comment R3-1
                if(lcommande > 2) then


                    --R5:commande ls avec un chemin

                        --R6:Accéder aux informations du répertoire ciblé 
                        new_noeud := change_directory(noeud,to_string(chemin),lchemin,false);

                        --le chemin est correct
                        if(new_noeud /= noeud) then
                            afficher_liste(new_noeud);
                            --revient au chemin
                             new_noeud:=noeud;
                        end if;                

                else
                --R4:Comment R3-2
                    afficher_liste(noeud);
                end if;

                new_line;
                        
            --R2:Si "mkdir"
            elsif(commande(commande'First..commande'First+4) = "mkdir") then

                --R3:Vérifie si la commande est valide                

                if(lcommande > 5) then
                    
                    chemin2 := to_unbounded_string(commande(commande'First + 6 .. lcommande));
                    lchemin2 := lcommande - 6;

                    --R4:Si un chemin est spécifié pour la commande mkdir
                    if(nbSeparateur(commande,lcommande,'/') > 0) then
                        
                        --R5:Chemin où il faut créer le repertoire
                        new_noeud := change_directory(noeud,to_string(chemin2),lchemin2,true);

                        --si noeud trouvé
                        if(new_noeud /= noeud) then

                            i:=lcommande;

                            --R6:Récupère le nom du répertoire à insérer 
                            loop
                                if(commande(i) = '/') then
                                    exit;
                                else
                                    i:= i-1;
                                end if;
                            end loop;

                            --on se déplace dans le répertoire cible
                            nom := to_unbounded_string(commande((i+1) .. lcommande));

                            --le répertoire est inséré dans le répertoire cible
                            inserer_repertoire(new_noeud,to_string(nom));

                            --revient au noeud courant
                            new_noeud := noeud;

                        else
                            put("mkdir : impossible de créer le répertoire " & to_string(chemin2) & " aucun fichier ou dossier de ce type");
                            new_line;
                        end if;
                    else
                        inserer_repertoire(noeud,to_string(chemin2));

                    end if;
                else 
                    put("mkdir : opérande manquante");
                    new_line;
                end if;
                
            
            --R2:Si "touch"
            elsif(commande(commande'First..commande'First+4) = "touch") then
                --inserer_fichier(noeud, commande( (commande'First + 6) .. lcommande ));

                --R3:Vérifie si la commande est valide                

                if(lcommande > 5) then
                    
                    chemin2 := to_unbounded_string(commande(commande'First + 6 .. lcommande));
                    lchemin2 := lcommande - 6;

                    --R4:Si un chemin est spécifié pour la commande mkdir
                    if(nbSeparateur(commande,lcommande,'/') > 0) then
                        
                        --R5:Chemin où il faut créer le repertoire
                        new_noeud := change_directory(noeud,to_string(chemin2),lchemin2,true);

                        --si noeud trouvé
                        if(new_noeud /= noeud) then

                            i:=lcommande;

                            --R6:Récupère le nom du répertoire à insérer 
                            loop
                                if(commande(i) = '/') then
                                    exit;
                                else
                                    i:= i-1;
                                end if;
                            end loop;

                            --on se déplace dans le répertoire cible
                            nom := to_unbounded_string(commande((i+1) .. lcommande));

                            --le répertoire est inséré dans le répertoire cible
                            inserer_fichier(new_noeud,to_string(nom));

                            --revient au noeud courant
                            new_noeud := noeud;

                        else
                            put("touch : impossible de faire un touch " & to_string(chemin2) & " aucun fichier ou dossier de ce type");
                            new_line;
                        end if;
                    else
                        inserer_fichier(noeud,to_string(chemin2));

                    end if;
                else 
                    put("touch : opérande de fichier manquant");
                    new_line;
                end if;


            --R2:Si "rm"
            elsif(commande(commande'First..commande'First+1) = "rm") then
                put("supprimer fichier");
                new_line;
                supprimer_fichier(noeud, commande(commande'First + 3 .. lcommande));

            --R2:Si "pwd"
            elsif(commande(commande'First..commande'First+2) = "pwd") then
                --R3:Affiche l'emplacement du repertoire
                put(to_string(repertoire_courant(noeud)));
                new_line;

            --R2:Si "exit"
            elsif(commande(commande'First..commande'First+3) = "exit") then
                --R3:Affiche message 
                put("A bientôt!");
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

            --R1:Comment R0

            --variable d'incrémentation
            i:=0; 
            j:=1;

            deb:=chaine'First; 

            --R2:Parcourir la chaine est séparer tous les éléments en fonction du séparateur
            loop

                --R3:Récupérer le premier morceau entre le début de la chaîne et le separateur
                loop
                    i:=i+1;
                    exit when (chaine(i) = sep);
                end loop;
                
                --ch1 prend la valeur du premier morceau
                ch1 := to_unbounded_string(chaine(deb..i-1));

                --morceau suivant à traiter
                ch2 := to_unbounded_string(chaine(i+1..lchaine));

                --le tableau est rempli avec tous les morceaux séparés
                tab(j) := ch1;

                --change la position de recherche 
                deb:=i+1;
                j := j + 1;
                
                --longeueur de la deuxième chaîne à traiter
                lch2 := lchaine - i;

                --si il n'y a plus de séparateur dans ch2
                if(nbSeparateur(to_string(ch2),lch2,sep)=0) then
                    tab(j) := ch2; --on ajoute le deuxième morceau dans le tableau 
                    exit;
                end if;

            end loop;

            --R1:Comment R0
    end split; --fin split;

end p_interpreteur;