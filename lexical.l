%{
#include <stdio.h>
#include <stdlib.h> 
#include <string.h>
#include "syntaxique.tab.h"
#include "TS.h"

extern YYSTYPE yylval;
int col= 0 ;
int line = 1;
int j;
%}

%option noyywrap
/*%option yylineno*/
/*%option case-insensitive*/

chiffre [0-9]
char \"[^"]*\"
IDF [a-zA-Z][a-z0-9]*
NBRINTEGER ({chiffre}+|\([+|-]{chiffre}+\))
NBRFLOAT ({chiffre}+"."{chiffre}+|\([+|-]{chiffre}+"."{chiffre}+\))
commentaire "%%".*$
espace ("\t"|" ")+
saut "\n"+

%%
"INTEGER" {rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
printf("%s Type\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return INT_TYPE ;}
"FLOAT" {rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
printf("%s Type\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return FLOAT_TYPE ;}
"CHAR" {rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
printf("%s Type\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return CHAR_TYPE;}
"CONST" { rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
printf("%s Mot cle\n",yytext); col+=yyleng; yylval.str = strdup(yytext); return CONST ;}
"IF" { rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
  printf("%s Mot cle\n",yytext); col+=yyleng; yylval.str = strdup(yytext); return IF ;}
"ELSE" {rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
printf("%s Mot cle\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return ELSE ;}
"WHILE" {rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
printf("%s Mot cle\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return WHILE ;}
"FOR" {rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
printf("%s Mot cle\n",yytext);  col+=yyleng; yylval.str = strdup(yytext);return FOR ;}
"READ" {rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
printf("%s Mot cle\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return READ;}
"WRITE" {rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
printf("%s Mot cle\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return WRITE;}
"VAR_GLOBAL" {rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
printf("%s Mot cle\n",yytext);  col+=yyleng; yylval.str = strdup(yytext);return VAR_GLOBAL ;}
"DECLARATION" {rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
printf("%s Mot cle\n",yytext);  col+=yyleng; yylval.str = strdup(yytext);return DECLARATION;}
"INSTRUCTION" {rechercher(yytext, "Mot cle", " ", "Oui", "1", 1);
printf("%s Mot cle\n",yytext);  col+=yyleng; yylval.str = strdup(yytext);return INSTRUCTION ;}
{char} {printf("%s CHAINE DE CARACTERE\n",yytext); col+=yyleng; yylval.str = strdup(yytext); return CHAR ;}
{IDF} {
        if (yyleng<=8)
          { rechercher(yytext, "IDF", " ", "Non", "", 0);
            printf("%s Idf\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return IDF ;}
        else 
          printf("Erreur lexicale ligne %d, colonne %d -IDF trop long-\n",line,col);
      }
{NBRINTEGER} {
          char myStr[100]="";
                            if(yytext[0]=='(')
                             {
                             for(j=1;j<yyleng-1;j++)
                             {
                              myStr[j-1] =yytext[j];
                             }
                            
                             col=col+ strlen(yytext);
                             if (atoi(myStr) <(-32768)  || atoi(myStr)>32767  )  {printf("erreur lexical dans la ligne : %d colonne :%d \n",line,col);
                             break;}
                              printf("%s est entier signé\n" ,yytext);
                             yylval.Integer= atoi(myStr);
                             return INTEGER;
                             }
                             else {
                             col=col+ strlen(yytext);
                             if (atoi(yytext) <(-32768)  || atoi(yytext)>32767  )  {printf("erreur lexical dans la ligne : %d colonne :%d \n",line,col);
                             break;}
                             printf("%s est entier\n" ,yytext);
                             yylval.Integer= atoi(yytext);
                             return INTEGER;
                             }
                             }
{NBRFLOAT} {
          char myStr[100]="";
                             if(yytext[0]=='(')
                             {
                             for(j=1;j<yyleng-1;j++)
                             {
                              myStr[j-1] =yytext[j];
                             }
                             col+=yyleng;
                             
                            printf("%s est reel signé\n" ,yytext);
                             yylval.Reel= atof(myStr);
                            return FLOAT;

                             }
                             else{
                             col+=yyleng;
                            printf("%s est reel\n" ,yytext); 
                             yylval.Reel= atof(yytext);
                             return FLOAT;
                             }
                             }
"&&" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return AND;}
"||" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return OR;}
"!" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return NOT;}
"+" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return ADD;}
"-" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return SUB;}
"*" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return MUL;}
"/" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return DIV;}
"=" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return AFF;}
":" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return DPOINT;}
";" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return PVG;}
"," {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return VIRG;}
"[" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return ACOUV;}
"]" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return ACFER;}
"{" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return BROUV ;}
"}" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return BRFER ;}
"(" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return PO ;}
")" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return PF ;}
"<" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return INF;}
">" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return SUP;}
"==" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return EGAL;}
"!=" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return DIF;}
"<=" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return INF_EG;}
">=" {rechercher(yytext, "Separateur", " ", "Non", "1", 2);
printf("%s Separateur\n",yytext); col+=yyleng; yylval.str = strdup(yytext);return SUP_EG;}
{commentaire} {printf("%s Commentaire\n",yytext); col+=yyleng; yylval.str = strdup(yytext); line++;}
{espace} {col+=yyleng;}
{saut} {line+=1;}
. {printf("Erreur lexicale ligne %d, colonne %d -caractere non reconnu-\n",line,col); col+=yyleng;}
%%

