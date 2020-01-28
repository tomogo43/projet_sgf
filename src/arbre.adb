--******************************************************************
--                      body package arbre generic
--******************************************************************

--******************************************************************
--                          description
--corps du package generic arbre
--******************************************************************

with arbre;
with text_io;
use text_io;

with ada.integer_text_io;
use ada.integer_text_io;

with ada.float_text_io;
use ada.float_text_io;

package body arbre is

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
    function rechercher(element: in T_element;enfant: in out T_Liste_Enfant) return T_Liste_Enfant is
        adresse:T_Liste_Enfant:=null;
        courant:T_Liste_Enfant:=enfant;
        begin --début rechercher
        

        if enfant /= null then

            loop

                if element/= courant.all.noeud.element then
                    courant:=courant.all.suivant;
                    adresse:=null;
                    
                else
                    adresse:=courant;
                end if;
            exit when courant=null or adresse/=null;
            end loop;
        end if;
        return adresse;
    end rechercher;

    --fonction retourne_noeud retourne le noeud courant
    function retourne_noeud(noeud:in P_Arbre) return T_Element is
        --R0:[Comment retourner le noeud courant]
        begin --debut affiche_noeud

            --R1:Comment R0

            return noeud.all.element ;
    end retourne_noeud;

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
                    exit when liste.all.suivant = null;
                    liste:= liste.all.suivant;
                end loop;

                --R4:Le nouveau noeud est ajouté à la fin de la liste
                liste.all.suivant := new T_Cellule_Enfant'(new_noeud,null);
            end if;
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
        --R0:[Comment supprimer un élément dans un arbre
        begin --début supprimer_noeud

            --R1:Comment R0
            put("supprimer_noeud");


            --if rechercher(F_e,F_l) /= null then
            --loop
            --courant:=courant.all.suivant;
            --exit when courant.all.suivant.all.element=F_e;
            --end loop;
            --courant.all.suivant:=courant.all.suivant.all.suivant;
            --end if;

            --R2:Si le noeud courant n'est pas null
            if(noeud /= null) then
                --R3:Parcourir les enfants du noeud courant
                enfant:=noeud.all.enfant;

                new_line;

                if (rechercher(element,enfant) /= null) then

                    put("element trouvé");
                    new_line;

                else
                    put("element non trouvé");
                    new_line;
                end if;




            --R2:Si le noeud à la valeur null
            else
                put("le noeud est inexistant");

            end if;


    end supprimer_noeud;


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


end arbre;
