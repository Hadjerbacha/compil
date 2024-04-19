%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntaxique.tab.h"
#include "TS.h"
#include "quadr.h"

#define YYERROR_VERBOSE 
extern YYSTYPE yylval;
extern int yylex();
extern FILE* yyin;
extern int line, col;
char temp[20];
char TempV[20]; // Ajout : déclaration de TempV
int yyerror( char *s);
char* sauvtype ;
char *sauvVal;
int end_if=0;
int begin_else=0;
int qc=0;
char tmp[20];

%}
%union {
    int Integer;
    char* str;
    float Reel;
    struct {
            char* type;
            }NT;
}

%token<str> IDF INT_TYPE FLOAT_TYPE
%token CHAR_TYPE AFF ACOUV ACFER BROUV BRFER PO PF DPOINT PVG  VIRG 
%token CHAR CONST
%token VAR_GLOBAL DECLARATION INSTRUCTION IF ELSE FOR WHILE READ WRITE
%token<Reel>  FLOAT
%token<Integer>  INTEGER
%token AND OR
%token NOT
%token SUP SUP_EG EGAL DIF INF_EG INF
%token ADD SUB
%token MUL DIV
%left AND OR
%left NOT
%left SUP SUP_EG EGAL DIF INF_EG INF
%left ADD SUB
%left MUL DIV
%type<NT> EXP 
%start S
%%

S: VARIABLE_GLOBALE declaration instruction
 {
        printf("programme correct \n"); YYACCEPT;
 };

VARIABLE_GLOBALE : VAR_GLOBAL BROUV DECs BRFER;

declaration: DECLARATION BROUV DECs BRFER;

instruction : INSTRUCTION BROUV LISTE_INSTRUCTIONS BRFER;

DECs : DECs DEC
    |  
    ;

DEC:  type LISTE_VARIABLES PVG 
    | type IDF ACOUV INTEGER ACFER PVG {if (doubleDeclaration($2)!=0) {
                    // Si l'identifiant a deja ete declare, affichez un message d'erreur
                    printf("Erreur: L'identifiant %s est deja declare.\n", $2);
                    YYABORT; // Arrêtez l'analyse syntaxique
                                        } else { if ($4<0) {printf("erreur semantique a la ligne %d la taille doit etre positive \n",line); 
                                                } else {
                                                    insererType($2,sauvtype);
                                                }
                                        }
                                       }
    | CONST IDF AFF INTEGER PVG {
                    insererType($2,"INTEGER");
                    insererConst($2,sauvVal);
                    
                    }
    | CONST IDF AFF FLOAT PVG { 
                    insererConst($2,sauvVal);
                    insererType($2,"FLOAT");
                    } 
                    
    ;

type : INT_TYPE {sauvtype=strdup($1);}
     | FLOAT_TYPE {sauvtype=strdup($1);}
     ;

LISTE_VARIABLES : IDF { 
                        insererType($1,sauvtype);
                        
                        }
                | LISTE_VARIABLES VIRG IDF { 
                        insererType($3,sauvtype);
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

affectation: IDF AFF EXP PVG {if (variable_non_dec($1)==0) {
                                   printf ("erreur idf non declare" );
                                  YYABORT;
                                } else {
                                    if(strcmp(rechercher_type($1),$3.type)!=0){ 
                                                    printf("erreur Semantique:incompatibilite de type  a la ligne %d et la colonne %d\n",line,col);YYACCEPT;      
                                    } /*else { if(strcmp("const",GetCode($1))==0){ 
                                            printf("erreur Semantique: %s est une constante  on peut pas la modifier, a la ligne %d et la colonne %d\n",$1,ligne,colonne);
                                                    YYABORT;
                                    } */ else { if (strcmp(rechercher_type($1), sauvtype) != 0) {
                                        printf("erreur Semantique: %s ne recoit pas une valeur de son type, a la ligne %d et la colonne %d\n", $1, line, col);
                                        YYABORT;
                                    } else {
                                       // inserervaleur($1,val);
                                       // sprintf(tmp,"%d",$3);
                                       // quadr("=",tmp,"empty",$1);
                                    } }}
                            }
; 
// kayen probleme kitkon EXP constante nrml f case val ykteb hadih valeur  ex x= 3 ; donc yhawes 3la idf x w f case val ykteb 3 mais ida kanet ex  x = y + 1 ; f case val ydi ghir 1er elt ydi ghir y 
EXP : EXP ADD EXP {$$.type=$1.type; }
    | EXP SUB EXP {$$.type=$1.type; }
    | EXP MUL EXP {$$.type=$1.type; }
    | EXP DIV INTEGER    { {$$.type=$1.type; }
        if ($3 == 0) {
            printf("Erreur sémantique : Division par zéro");
            YYABORT; // Arrête l'analyse syntaxique en cas d'erreur sémantique
        }
    }    
    | EXP DIV FLOAT    { {$$.type=$1.type; }
        if ($3 == 0) {
            printf("Erreur sémantique : Division par zéro");
            YYABORT; // Arrête l'analyse syntaxique en cas d'erreur sémantique
        }
    }                                                 
    | SUB EXP { $$.type=$2.type; }
    | PO EXP PF  { $$.type=$2.type; }
    | IDF {$$.type=rechercher_type($1);if(doubleDeclaration($1)==0){
                     printf("erreur Semantique: %s n'est pas declare, a la ligne %d et la colonne%d\n",$1, line,col);YYABORT;
           }
         }
  //  | IDF ACOUV TAILLE ACFER  
   // | IDF ACOUV INTEGER ACFER 
    | CONSTANTE  {$$.type=sauvtype; }
    ;

CONSTANTE : INTEGER  {char temp[20];
                sprintf(temp, "%d", $1); // Convertit l'entier en chaîne de caractères
                sauvVal = strdup(temp);
                sauvtype=strdup("INTEGER");}
          | FLOAT {char temp[20];
                sprintf(temp, "%f", $1); // Convertit le flottant en chaîne de caractères
                sauvVal = strdup(temp);
                sauvtype=strdup("FLOAT");  }
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

%%
int yyerror(char *s) {
     printf( "Erreur syntaxique : %s ligne: %d colonne: %d\n", s,line,col);
     return 1;
}

int main() {
    yyin = fopen("input.txt", "r");
    yyparse();
    fclose(yyin);
    afficher();
    return 0;
}

int yywrap() {
    return 1;
}
