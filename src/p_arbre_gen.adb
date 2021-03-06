--******************************************************************
--                      body package arbre generic
--******************************************************************

--******************************************************************
--                          description
--corps du package generic arbre
--******************************************************************

with p_arbre_gen;
with text_io;
use text_io;

with ada.integer_text_io;
use ada.integer_text_io;

with ada.float_text_io;
use ada.float_text_io;

package body p_arbre_gen is

    --*************************Fonctions****************************

    --fonction est_vide test si l'arbre est vide
    function est_vide(abr:in P_Arbre) return boolean is
        --R0:[Comment tester si un tableau est vide]
        begin --début est_vide
            --R1:Commment R0
            if(abr = null) then --si abr null renvoi true
                return true;
            else
                return false; --si abr /=null renvoi false
            end if;
    end est_vide;



    --fonction qui permet de descendre dans un enfant du noeud courant
    function desc_arborescence(courant:in P_Arbre;element:in T_Element) return P_Arbre is
        --R0:[Comment descendre dans un enfant du noeud parent]

        enfant:T_Liste_Enfant;   --enfants du noeud courant;
        new_noeud:P_Arbre:=null; --contient l'adresse du nouveau noeud (null si ne match pas avec element)
        begin --début desc_arborescence

            --R1:Comment R0

            --R2:Si le noeud courant n'est pas null
            if(courant /= null) then
                --R3:Parcourir les enfants de courant
                enfant:=courant.all.enfant;

                new_noeud := courant;

                if(enfant /= null) then

                    loop    

                        --R4:Vérifie si l'élément cherché fait partie des enfants du noeud courant
                        if(enfant.all.noeud.element = element) then
                            new_noeud := enfant.all.noeud;
                        
                        end if;

                        enfant:=enfant.all.suivant;
                    
                        
                        exit when enfant=null;

                    end loop;

                end if;


                --R5:Retourne l'adresse du nouveau noeud
                return new_noeud;

            --R2:Si le noeud à la valeur null
            else
                put("le noeud est inexistant");
                return new_noeud;
            end if;

    end desc_arborescence;

    --fonction asc_arborescence qui permet d'atteindre le noeud parent  
    function asc_arborescence(courant:in P_Arbre) return P_Arbre is
        --R0:[Comment joindre le noeud parent]
        begin --début asc_arborescence
            --R1:Comment R0

            --R2:Vérifier si le noeud courant a un parent
            if(courant.all.parent /= null) then
                return courant.all.parent;
            else    
                return courant;
            end if;

    end asc_arborescence;


    --Fonction qui recherche un entier dans la liste T_Liste_Entier
    function rechercher(element: in T_element;enfant: in T_Liste_Enfant) return T_Liste_Enfant is
        adresse:T_Liste_Enfant:=null;
        courant:T_Liste_Enfant:=enfant;
        ELEMENT_EXISTANT:exception;

        --R0:Comment rechercher dans les enfants d'un noeud

        begin --début rechercher
        
        --R1:Comment R0

        --R2:Vérifier si le noeud a des enfants
        if enfant /= null then

            --R3:Parcourir le noeud jusqu'à trouver l'élément cherché
            loop

                --tant que l'élément n'est pas trouvé l'adresse vaut null

                if element/= courant.all.noeud.element then
                    courant:=courant.all.suivant;
                    adresse:=null;
                    
                else 
                    --sinon l'adresse prend l'adresse de l'élément cherché
                    adresse:=courant;
                end if;
            exit when courant=null or adresse/=null;
            end loop;
        end if;


        if adresse /= null then
            return adresse;             --si adresse trouvé retourne son adresse
        else
            raise ELEMENT_EXISTANT;     --sinon lève l'exception
        end if;

        exception
            when ELEMENT_EXISTANT   => put_line("element non trouvé"); RAISE; --propagation de l'exception
            when others             => put_line("une autre erreur est apparue"); RAISE;  --propagation de l'exception

        
    end rechercher;

    --fonction retourne_noeud retourne le noeud courant
    function retourne_noeud(noeud:in P_Arbre) return T_Element is
        --R0:[Comment retourner le noeud courant]
        begin --debut affiche_noeud

            --R1:Comment R0

            return noeud.all.element ;
    end retourne_noeud;


    function existe_enfant_element(noeud:in P_Arbre;element:in T_Element) return boolean is
        enfant:T_Liste_Enfant;
        begin --debut existe_enfant_element
            enfant := noeud.all.enfant;

            if enfant = null then
                return false;
            else
                loop    
                    if (enfant.all.noeud.all.element = element) then
                        return true;
                    else
                        enfant := enfant.all.suivant;
                        if(enfant = null) then
                            return false;
                        end if;
                    end if;
                end loop;
            end if;
    end existe_enfant_element;


    --*************************Procedures****************************

    --procédure initialiser_arbre permet d'initialiser l'arbre
    procedure initialiser_arbre(abr: out P_Arbre) is

        --R0:[Comment initialiser l'arbre]

        begin --debut initialiser_arbre
            --R1:Comment R0
            abr:=null; --l'arbre prend la valeur null
    end initialiser_arbre;

    --procedure inserer_en_tete permet d'insérer un élément à la racine de l'arbre
    procedure inserer_en_tete(abr:in out P_Arbre;element:in T_Element) is
        --R0:Comment insérer en tête dans un arbre vide 
        begin --debut inserer_en_tete
            --R1:Comment R0
            abr := new T_Arbre'(null,element,null); --noeud racine de l'arbre 
    end inserer_en_tete;

    --procédure inserer_noeud permet d'insérer un noeud dans l'arbre 
    procedure inserer_noeud(abr:in P_Arbre;element:in T_Element) is
        --R0:[Comment insérer un noeud dans l'arbre]

        new_noeud:P_Arbre;    --nouveau noeud à insérer
        liste:T_Liste_Enfant; --liste pointant sur le début de la liste des enfants de abr

        ELEMENT_EXISTANT:exception;
        
        begin --debut inserer_noeud

            --R1:Comment R0

            --R2:Créer un nouveau noeud
            new_noeud := new T_Arbre'(abr,element,null);

            --R2:Insérer le noeud dans l'arbre 

            --R3:Si le noeud parent n'a pas d'enfant
            if (abr.all.enfant = null) then
                abr.all.enfant := new T_Cellule_Enfant'(new_noeud,null);

            --R3:Si le noeud parent a des enfants
            else
                --R4:Parcourir la liste jusqu'à la fin de la liste des enfants 
                liste := abr.all.enfant;

                loop                    

                    --Si l'élément existe déjà
                    if(element = liste.all.noeud.all.element) then

                        raise ELEMENT_EXISTANT; --lève l'exception ELEMENT_EXISTANT et sort de la boucle
                        
                    end if;

                    --arrive à la fin de la liste 
                    if(liste.all.suivant = null) then
                        --R4:Le nouveau noeud est ajouté à la fin de la liste
                        liste.all.suivant := new T_Cellule_Enfant'(new_noeud,null);
                        exit;
                    end if;

                    liste:= liste.all.suivant;
                    

                    
                end loop;

                
            end if;

            --gestion des exceptions de la procédure
            exception
                when ELEMENT_EXISTANT    => put("l'élément :");
                                            affiche(element);
                                             put(" existe déjà");
                                            new_line;
                when others             => put("erreur insérer noeud"); 

    end inserer_noeud;

    --procedure parcourir_enfant qui parcourt une liste chaînée d'enfant
    procedure parcourir_enfant(enfant:in out T_Liste_Enfant) is
        --R0:[Comment parcourir les enfants]

        courant:T_Liste_Enfant;

        begin --début parcourir_enfant;
            --R1:Comment R0

            courant:=enfant;

            --R2:Lister et afficher l'ensemble des enfants de la liste 
            loop
                affiche(courant.all.noeud.all.element);
                courant := courant.all.suivant;
                exit when courant = null;
            end loop;
    end parcourir_enfant;

    --procédure afficher_noeuds_enfants qui affiche les enfants de noeud
    procedure afficher_noeuds_enfants(noeud:in P_Arbre) is
        --R0:[Comment afficher les enfants d'un noeud parent]
        begin --début afficher_noeuds_enfants

            --R1:Comment R0
            --  (1) noeud /= null
            if (noeud /= null) then
                --R2:Vérifier si le noeud a des enfants
                if(noeud.all.enfant /= null) then
                    --R3:Lister les enfants du noeud
                    parcourir_enfant(noeud.all.enfant);
                    
                else
                --R2:Si l'élément n'a pas d'enfant
                    put("le noeud n'a pas d'enfant");
                    new_line;
                end if;
            else
                --R1:Si noeud non défini
                put("erreur");
            end if;

    end afficher_noeuds_enfants;

    --procedure affiche_noeud affiche le noeud courant
    procedure affiche_noeud(noeud:in P_Arbre) is
        --R0:[Comment afficher le noeud courant]
        begin --debut affiche_noeud

            --R1:Comment R0

            affiche(noeud.all.element);
    end affiche_noeud;

    --procedure modifier_noeud modifie l'élément du noeud
    procedure modifier_noeud(noeud:in out P_Arbre;new_element: in T_Element) is
        --R0:[Comment modifier l'élément du noeud]
        begin --début modifier_noeud

            --R1:Comment R0;

            noeud.all.element := new_element; --prend la valeur de new_element

    end modifier_noeud;

    --procedure supprimer_noeud supprime un noeud dans l'arbre
    procedure supprimer_noeud(noeud:in out P_arbre;element: in T_Element) is
        enfant:T_Liste_Enfant;
        SUPPRESSION_IMPOSSIBLE:exception;

        --R0:[Comment supprimer un élément dans un arbre
        begin --début supprimer_noeud

            --R1:Comment R0

            --R2:Si le noeud courant n'est pas null
            if(noeud /= null) then
                --R3:Parcourir les enfants du noeud courant

                enfant:=noeud.all.enfant; --récupère les enfants


                if (rechercher(element,enfant) = null) then --si l'élément n'existe pas
                    raise SUPPRESSION_IMPOSSIBLE; --lève l'exception
                else    
                    put_line("do something");

                    loop
                        affiche(enfant.all.noeud.all.element);
                        enfant := enfant.all.suivant;
                        exit when (enfant = null);
                    end loop;
                    

                    if(enfant.all.noeud.all.element = element) then
                        put_line("supprime l'élément");
                        noeud.all.enfant := null;
                    else
                        put_line("cherche ailleurs");
                    end if;

                end if;
            else
                raise SUPPRESSION_IMPOSSIBLE;
            end if;

            exception
                when SUPPRESSION_IMPOSSIBLE => put_line("suppression impossible");
                when others                 => put_line("impossible de supprimer le noeud");


    end supprimer_noeud;


    --procedure parcourir_arbre parcourt un arbre
    procedure parcourir_arbre(abr:in P_Arbre) is
        noeud:P_arbre;
        courant:T_Liste_Enfant;
        begin --début parcourir_arbre
            noeud:=abr;
            put("parcourir arbre");
            new_line;

            if(noeud.all.enfant /= null) then
                affiche_noeud(noeud);
                --afficher_noeuds_enfants(noeud);
                
                courant := noeud.all.enfant;
                new_line;
                put("-----");
                new_line;
                loop
                    affiche(courant.all.noeud.all.element);
                    
                    if(courant.all.noeud.all.enfant /= null) then
                        parcourir_arbre(courant.all.noeud);
                        --put("ok");
                    end if;

                    courant := courant.all.suivant;

                    exit when courant = null;
                end loop;

            end if;

    end parcourir_arbre;


    --------------------------------------------------------------------------------
    --                                  TEST
    --------------------------------------------------------------------------------

    --procédure afficher_arbre procédure qui permet d'afficher le contenu d'un arbre 
    procedure afficher_arbre(abr:in P_Arbre) is
        courant:T_Liste_Enfant;
        sous_enfants:T_Liste_Enfant;
        i:integer;
        begin --début afficher arbre
            new_line;
            affiche(abr.all.element);
            new_line;
            if (abr.all.enfant /= null) then

                courant := abr.all.enfant;

                i:=0;
                loop
                    i:=i+1;
                    put("enfant:");
                    put(i);
                    put(" --> ");
                    affiche(courant.all.noeud.all.element);
                    new_line;

                    --vérifie si l'élément a des enfants

                    if(courant.all.noeud.all.enfant = null) then
                        put("          pas de sous_enfant");
                        new_line;
                    else
                        put("          sous_enfant");

                        --parcourt les sous_enfants
                        sous_enfants:=courant.all.noeud.all.enfant;
                        
                        loop
                            --affiche(sous_enfants.all.noeud.element);
                            afficher_arbre(sous_enfants.all.noeud);
                            sous_enfants := sous_enfants.all.suivant;
                            exit when sous_enfants = null;
                        end loop;
                        new_line;
                        --afficher_arbre(courant.all.noeud.all.enfant.all.noeud);
                    end if;

                    courant := courant.all.suivant;
                    exit when courant = null;
                end loop;

            end if;
    end afficher_arbre; --fin afficher arbre


end p_arbre_gen;
