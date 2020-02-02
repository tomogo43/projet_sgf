--package SGF

with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

with p_arbre_gen;


package p_sgf_gen is

    --*****************************Les types****************************
    --le type d'élément possible
        type type_elt is (FIL,DIR); --soit file ==> FIL ou directory ==> DIR
        
        --description de l'élément 
        type description_elt is 
            record
                nom:unbounded_string;
                element_type:type_elt;
                --(TO DO) ajouter la taille
                taille:integer;
            end record;

    

    --*****************************************************************
    --Le module SGF s'appuie sur un module qui spécifie et implante une
    --structure de type arbre
    --*****************************************************************

    --*********************************************************************
    --nom: afficheX
    --sémantique: Permet d'afficher le type générique T_Element
    --paramètres:
    --      E: Mode(IN) xx; element générique qui sera de type xx
    --pré condition: 
    --post condition: affiche le type générique avec le type souhaité
    --*********************************************************************
    procedure affiche_element (E:in description_elt);

    --instanciation de l'arbre générique 
    package arbre_description_element is new p_arbre_gen(T_Element=>description_elt,
                                                         affiche=>affiche_element);
    
    use arbre_description_element;

    --type P_sgf qui définit le type de l'arborescence de notre SGF de même 
    --type que P_Arbre

    type P_sgf is new P_Arbre;

    sgf:P_Arbre; --déclaration du SGF de type P_Arbre

    --*****************************Fonctions******************************

    --*********************************************************************
    --nom: desc_arborescence_sgf
    --sémantique: Permet d'atteindre un enfant du noeud courant
    --paramètres:
    --      courant: Mode(IN) P_sgf; emplacement courant
    --      element: Mode(IN) description_elt; élément à rechercher
    --      etat: Mode(IN/OUT) boolean; indique si l'élément a été trouvé
    --pré condition: abr non nul
    --post condition: retourne l'adresse noeud que l'on souhaite joindre
    --retourne: P_sgf
    --*********************************************************************
    function desc_arborescence_sgf(courant:in P_sgf;nom:in string;etat:in out boolean) return P_sgf;

    --*********************************************************************
    --nom: desc_arborescence_sgf
    --sémantique: Permet d'atteindre le parent de l'élément courant
    --paramètres:
    --      courant: Mode(IN) P_sgf; emplacement courant
    --pré condition: sgf non nul
    --post condition: retourne l'adresse noeud que l'on souhaite joindre
    --retourne: P_sgf
    --*********************************************************************

    function asc_arborescence_sgf(courant:in P_sgf) return P_sgf;

    --*********************************************************************
    --nom: repertoire_courant
    --sémantique: Permet de connaître l'emplacement du répertoire courant 
    --dans le SGF
    --paramètres:
    --      courant: Mode(IN) P_sgf; emplacement courant
    --pré condition: sgf non nul
    --post condition: retourne l'emplacement du répertoire courant
    --retourne: unbounded_string
    --*********************************************************************

    function repertoire_courant(sgf:in P_sgf) return unbounded_string;

    function remonte_racine_sgf(courant:in P_sgf) return P_sgf;

    --*********************************************************************
    --nom: isTrouve
    --sémantique: Permet de savoir si un élément est présent dans le sgf
    --paramètres:
    --      courant: Mode(IN) P_sgf; emplacement courant
    --      nom: Mode(IN) string; répertoire à chercher
    --pré condition: sgf non nul
    --post condition: renvoit true si trouve et false sinon
    --retourne: boolean
    --*********************************************************************
    function isTrouve(sgf:in P_sgf;nom:in string) return boolean;

    --*****************************Procédures******************************
    
    --*********************************************************************
    --nom: initialise SGF
    --sémantique: Permet d'initialiser le SGF avec la racine
    --paramètres:
    --      courant: Mode(IN/OUT) P_Arbre; emplacement courant
    --      element: Mode(IN) T_Element; élément à rechercher
    --pré condition: abr non nul
    --post condition: retourne l'adresse noeud que l'on souhaite joindre
    --retourne: P_sgf
    --*********************************************************************

    procedure initialiser_sgf(sgf:in out P_sgf);

    --*********************************************************************
    --nom: afficher_noeud_sgf
    --sémantique: Affiche le noeud courant du SGF
    --paramètres:
    --      courant: Mode(IN) P_sgf; emplacement courant
    --pré condition: abr non nul
    --post condition: affiche le repertoire courant 
    --*********************************************************************

    procedure afficher_noeud_sgf(sgf:in P_sgf);

    --*********************************************************************
    --nom: inserer_repertoire
    --sémantique: Insere un répertoire dans le SGF
    --paramètres:
    --      courant: Mode(IN/OUT) P_sgf; emplacement courant
    --      nom: Mode(IN) description_elt; nom du répertoire
    --pré condition: aucune
    --post condition: Insère le dossier dans le repertoire courant 
    --*********************************************************************

    procedure inserer_repertoire(sgf:in P_sgf;nom:string);

    --*********************************************************************
    --nom: inserer_fichier
    --sémantique: Insere un fichier dans le SGF
    --paramètres:
    --      courant: Mode(IN/OUT) P_sgf; emplacement courant
    --      nom: Mode(IN) description_elt; nom du fichier
    --pré condition: aucune
    --post condition: Insère le fichier dans le repertoire courant 
    --*********************************************************************

    procedure inserer_fichier(sgf:in P_sgf;nom:string);

    --*********************************************************************
    --nom: afficher_liste
    --sémantique: Affiche la liste des répertoires et des fichiers contenus
    --dans le courant
    --paramètres:
    --      courant: Mode(IN) P_sgf; emplacement courant
    --pré condition: aucune
    --post condition: Effectue la commande ls
    --*********************************************************************

    procedure afficher_liste(noeud:in P_sgf);

    procedure supprimer_fichier(sgf:in out P_sgf; nom:string);
 

end p_sgf_gen;