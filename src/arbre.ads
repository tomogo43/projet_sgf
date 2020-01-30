--package generic arbre
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

generic 
    type T_Element is private;

    --utilisation d'une procedure permettant d'afficher un type generic
    with procedure affiche(E:in T_Element); --pour afficher T_Element

package arbre is


    type P_Arbre is private;
    type T_Arbre is private;
    type T_Cellule_Enfant is private;
    type T_Liste_Enfant is private;

    --*********************************Fonctions*******************************
    
    --*********************************************************************
    --nom: est_vide
    --sémantique: Vérifie si un arbre est vide en retournant un boolean à
    --true si c'est le cas
    --paramètres:
    --      abr: Mode(IN) P_Arbre; arbre à tester 
    --pré condition: aucune
    --post condition: indique si l'arbre est vide ou non
    --retourne: boolean
    --*********************************************************************

    function est_vide(abr:in P_Arbre) return boolean;

    --*********************************************************************
    --nom: desc_arborescence
    --sémantique: Permet d'atteindre un enfant du noeud courant
    --paramètres:
    --      courant: Mode(IN/OUT) P_Arbre; emplacement courant
    --      element: Mode(IN) T_Element; élément à rechercher
    --pré condition: abr non nul
    --post condition: retourne l'adresse noeud que l'on souhaite joindre
    --retourne: P_Arbre
    --*********************************************************************

    function desc_arborescence(courant:in P_Arbre;element:in T_Element) return P_Arbre;

    --*********************************************************************
    --nom: asc_arborescence
    --sémantique: Permet d'atteindre le parent du noeud courant
    --paramètres:
    --      courant: Mode(IN/OUT) P_Arbre; emplacement courant
    --pré condition: abr non nul
    --post condition: retourne l'adresse du noeud parent
    --retourne: P_Arbre
    --*********************************************************************

    function asc_arborescence(courant:in P_Arbre) return P_Arbre;

    --*********************************************************************
    --nom: retourne_noeud
    --sémantique: Retourne le noeud courant
    --paramètres:
    --      courant: Mode(IN/OUT) P_Arbre; emplacement courant
    --pré condition: abr non nul
    --post condition: retourne le noeud courant
    --retourne: T_Element
    --*********************************************************************

    function retourne_noeud(noeud:in P_Arbre) return T_Element;

    --*********************************Procedure*******************************

    --*********************************************************************
    --nom: initialiser_arbre
    --sémantique: Initialise un arbre en le mettant à null
    --paramètres:
    --      abr: Mode(OUT) P_Arbre; arbre à initialiser 
    --pré condition: aucune
    --post condition: abr vaut null
    --*********************************************************************
    procedure initialiser_arbre(abr:out P_Arbre); 

    --*********************************************************************
    --nom: inserer_en_tete
    --sémantique: Insère un élément en tête de l'arbre (elt racine)
    --paramètres:
    --      abr: Mode(IN/OUT) P_Arbre; arbre avec donnée à inserer
    --      element: Mode(IN) T_Element; element à ajouter en tête 
    --pré condition: aucune
    --post condition: element est inséré en tête 
    --*********************************************************************

    procedure inserer_en_tete(abr:in out P_Arbre;element:in T_Element);

    --*********************************************************************
    --nom: inserer_element
    --sémantique: insere un élément dans l'arbre 
    --paramètres:
    --      abr: Mode(IN/OUT) P_Arbre; arbre avec élément à insérer 
    --pré condition: aucune
    --post condition: element est inséré dans l'arbre 
    --*********************************************************************

    procedure inserer_noeud(abr:in P_Arbre;element:in T_Element);

    --procedure inserer_element(abr:in out P_Arbre;element: in T_Element);

    --*********************************************************************
    --nom: afficher_arbre
    --sémantique: affiche l'arbre chaques éléments avec ses enfants 
    --paramètres:
    --      abr: Mode(IN/OUT) P_Arbre; arbre avec élément à insérer 
    --pré condition: aucune
    --post condition: affiche l'arbre
    --*********************************************************************

    procedure afficher_arbre(abr:in P_Arbre); 
    
    --procedure afficher_enfant(liste_enfant:in out T_Liste_Enfant);

    --*********************************************************************
    --nom: parcourir_enfant
    --sémantique: parcour la liste des enfants
    --paramètres:
    --      enfant: Mode(IN/OUT) T_Liste_Enfant; liste_enfant à parcourir 
    --pré condition: aucune
    --post condition: parcourt la liste des enfants
    --*********************************************************************
    
    procedure parcourir_enfant(enfant:in out T_Liste_Enfant);

    --*********************************************************************
    --nom: afficher_noeuds_enfants
    --sémantique: affiche les noeuds enfants d'un noeud parent
    --paramètres:
    --      noeud: Mode(IN) P_Arbre; noeud parent
    --pré condition: aucune
    --post condition: affiche les noeuds enfants du noeud parent
    --*********************************************************************

    procedure afficher_noeuds_enfants(noeud:in P_Arbre);

    --*********************************************************************
    --nom: afficher_noeud
    --sémantique: affiche le noeud courant 
    --paramètres:
    --      noeud: Mode(IN) P_Arbre; noeud parent
    --pré condition: aucune
    --post condition: affiche le noeud courant
    --*********************************************************************
    
    procedure affiche_noeud(noeud:in P_Arbre);

    --*********************************************************************
    --nom: modifier_noeud
    --sémantique: modifie l'élément du noeud par le nouvel élément
    --paramètres:
    --      noeud: Mode(IN/OUT) P_Arbre; noeud parent
    --      new_element: Mode(IN) T_Element; nouvel élément du noeud 
    --pré condition: aucune
    --post condition: l'élément du noeud est modifié 
    --*********************************************************************

    procedure modifier_noeud(noeud:in out P_Arbre;new_element: in T_Element);

    procedure supprimer_noeud(noeud:in out P_arbre;element: in T_Element);

    procedure parcourir_arbre(abr:in P_arbre);

    private

        --le type d'élément possible
        type type_elt is (FIL,DIR); --soit file ==> FIL ou directory ==> DIR
        
        --description de l'élément 
        type description_elt is 
            record
                nom:unbounded_string;
                element_type:type_elt;
            end record;

        --type T_Arbre;

        type P_Arbre is access T_Arbre; 

        --type T_Arbre is 
        type T_Arbre is 
            record
                --parent:P_Arbre;
                parent:P_Arbre;
                element:T_Element;
                enfant:T_Liste_Enfant; --pointe sur la tête d'une liste chaînée
            end record;

        --liste chaînée des enfants d'un répertoire
        --type T_Cellule_Enfant;

        type T_Liste_Enfant is access T_Cellule_Enfant;

        type T_Cellule_Enfant is
            record
                --element:T_Element;
                noeud:P_Arbre;
                suivant:T_Liste_Enfant;
            end record;
end arbre;