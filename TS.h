#ifndef TAB_H
#define TAB_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h> 

typedef struct
{
   int state;
   char name[20];
   char code[20];
   char type[20];
   char constante[20];
   char val[20];
 } element;

typedef struct
{ 
   int state; 
   char name[20];
   char type[20];
} elt;

element tab[1000]; //tab: IDF et constantes
elt tabs[40],tabm[40]; //tabs: séparateurs, tabm:mots clés

void inserer(char *idf, char *code, char *type, char *constante, char *val, int y) ;
void rechercher (char *idf, char *code, char *type, char *constante, char *val, int y) ;
char* typeIdf(char* idf);
int rechercherIDF (char* idf);
char* rechercher_type(char* idf);
void afficher();
void insererConst(char *idf, double val);
void insererVal(char* idf, char* val);
void insererType (char* idf , char* type);
int variable_non_dec(char* idf);
int doubleDeclaration(char* idf);
#endif