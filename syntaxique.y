%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntaxique.tab.h"

#define YYERROR_VERBOSE
extern YYSTYPE yylval;
extern int yylex();
extern FILE* yyin;
extern int line, col;
char temp[20]; char sauvType[20]; char sauvVal[20];
char TempV[20]; // Ajout : déclaration de TempV

// Déclaration de la fonction typeIdf si elle n'est pas définie dans les fichiers d'en-tête
char* typeIdf(char* idf);
char* rechercher_type(char* idf);
// Prototype de la fonction afficher()
void afficher();
void afficher_qdr();
void insererConst(char* idf, char* val);
void insererVal(char* idf, char* val);
void insererType (char* idf , char* type);
int variable_non_dec(char* idf);
void yyerror(const char *s) {
     fprintf(stderr, "Erreur syntaxique : %s ligne: %d colonne: %d\n", s,line,col);
}
void yyerror_semantique(const char *s) {
     fprintf(stderr, "Erreur sémantique : %s ligne: %d colonne: %d\n", s, line, col);
}

%}
%union {
    int Integer;
    char* str;
    float Reel;
}

%token<str> INT_TYPE FLOAT_TYPE CHAR_TYPE BOOL_TYPE AFF ACOUV ACFER BROUV BRFER PO PF DPOINT PVG  VIRG 
%token<str> IDF CHAR BOOL
%token<str> VAR_GLOBAL DECLARATION INSTRUCTION CONST IF ELSE FOR WHILE READ WRITE
%token<Reel>  FLOAT
%token<Integer>  INTEGER
%token<str> AND OR
%token<str> NOT
%token<str> SUP SUP_EG EGAL DIF INF_EG INF
%token<str> ADD SUB
%token<str> MUL DIV
%left AND OR
%left NOT
%left SUP SUP_EG EGAL DIF INF_EG INF
%left ADD SUB
%left MUL DIV
%type<str> EXP CONSTANTE type CONDITION
%start S
%%

S: VARIABLE_GLOBALE declaration instruction
 {
        printf("programme correct \n"); YYACCEPT;
 };

VARIABLE_GLOBALE : VAR_GLOBAL BROUV DEC BRFER;

declaration: DECLARATION BROUV DEC BRFER;

instruction : INSTRUCTION BROUV LISTE_INSTRUCTIONS BRFER;

DEC : DEC A 
    |  
    ;

A:    type LISTE_VARIABLES PVG {insererType(sauvVal,$1);}
    | type IDF ACOUV INTEGER ACFER PVG {insererType($2,$1);
                                       if ($4<0) printf("erreur semantique a la ligne %d la taille doit etre positive \n",line);}
    | CONST IDF AFF CONSTANTE PVG {insererConst($2,$4);} 
    ;

type : INT_TYPE { $$ = $1; } 
     | FLOAT_TYPE { $$ = $1; } 
     ;

LISTE_VARIABLES : IDF {strcpy(sauvVal,$1); } 
                | LISTE_VARIABLES VIRG IDF {strcpy(sauvVal,$3); } 
                ;
/*
A : type IDF ACOUV TAILLE ACFER PVG
TAILLE : IDF 
       | INTEGER 
       ; 
*/

CONSTANTE : INTEGER { 
                char temp[20];
                sprintf(temp, "%d", $1); // Convertit l'entier en chaîne de caractères
                $$ = strdup(temp);
            } 
          | FLOAT { 
                char temp[20];
                sprintf(temp, "%f", $1); // Convertit le flottant en chaîne de caractères
                $$ = strdup(temp);
            }  
          ;
LISTE_INSTRUCTIONS  : LISTE_INSTRUCTIONS INST
                    |  
                    ;

INST: affectation
    | BOUCLE
    | entree 
    | sortie 
    ;

affectation: IDF AFF EXP PVG{if (variable_non_dec($1)==0) 
                                   printf ("erreur idf non declare" );
                               }
; 
// kayen probleme kitkon EXP constante nrml f case val ykteb hadih valeur  ex x= 3 ; donc yhawes 3la idf x w f case val ykteb 3 mais ida kanet ex  x = y + 1 ; f case val ydi ghir 1er elt ydi ghir y 
EXP : EXP ADD EXP
    | EXP SUB EXP
    | EXP MUL EXP
    | EXP DIV EXP    {
        if ($3 == 0) {
            yyerror_semantique("Erreur sémantique : Division par zéro");
            YYABORT; // Arrête l'analyse syntaxique en cas d'erreur sémantique
        }
    }                                                   
    | SUB EXP
    | PO EXP PF 
    | IDF
  //  | IDF ACOUV TAILLE ACFER  
    | IDF ACOUV INTEGER ACFER 
    | CONSTANTE  
    ;


BOUCLE: boucle_while 
      | boucle_if 
      | boucle_for 
      ;

boucle_while: C BROUV LISTE_INSTRUCTIONS BRFER 
;

C : D PO CONDITION PF 
;

D: WHILE 
;

boucle_if: B2 LISTE_INSTRUCTIONS BRFER 
         
         ;


B2: IF PO CONDITION PF BROUV 
;                            
/*
B3: B4 LISTE_INSTRUCTIONS BRFER {Fin_if=qc;
                quadr("BR", "","vide", "vide"); 
		sprintf(tmp,"%d",qc); 
                ajour_quad(deb_else,1,tmp);}
;    

B4: IF PO CONDITION PF BROUV { deb_else=qc; 
                               quadr("BZ", "","temp_cond", "vide"); }
;*/

boucle_for: FOR PO IDF DPOINT INTEGER DPOINT INTEGER DPOINT IDF PF BROUV LISTE_INSTRUCTIONS BRFER 
          ;

entree: READ PO IDF PF PVG;

sortie: WRITE PO CHAR VIRG IDF VIRG CHAR PF PVG 
      | WRITE PO CHAR PF PVG
      ;

CONDITION: EXP INF EXP 
         | EXP SUP EXP
         | EXP INF_EG EXP
         | EXP SUP_EG EXP
         | EXP EGAL EXP
         | EXP DIF EXP
         | CONDITION AND CONDITION
         | CONDITION OR CONDITION
         | NOT CONDITION
         
         ;

/*
comparaison : comparaison outil_comparaison CONDITION 
            | CONDITION outil_comparaison CONDITION 
            | OUTIL CONDITION 
            ;

outil_comparaison : AND 
                  | OR  
                  
                  ;
OUTIL:  NOT 
      | SUB 
      ;

exp_log : EXP op EXP
        | EXP op exp_log 
        ;

op : INF 
   | SUP 
   | EGAL 
   | DIF 
   | INF_EG
   | SUP_EG;
*/
%%

int main() {
    yyin = fopen("input.txt", "r");
    yyparse();
    afficher();
    afficher_qdr();
    fclose(yyin);
    return 0;
}

int yywrap() {
    return 1;
}
