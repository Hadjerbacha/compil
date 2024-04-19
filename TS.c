#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "TS.h" 

int cpt, cpts, cptm;
/*char sauvType[20];
int tabExp [1000] , tabOp [100], tabRes [1000] ,tabOpAr [100];
char *tabType [1000] ,*tabTypeR [1000] ; 
element tab[1000]; //tab: IDF et constantes
elt tabs[40],tabm[40]; //tabs: séparateurs, tabm:mots clés
int cpt, cpts, cptm;
extern int qc;
int x =0 ; */
/***Step 2: initialisation de l'état des cases des tables des symbloles***/
/*0: la case est libre    1: la case est occupée*/

void initialisation() {
    int i;
    for (i = 0; i < 1000; i++) {
        tab[i].state = 0;
    }
    for (i = 0; i < 40; i++) {
        tabs[i].state = 0;
        tabm[i].state = 0;
    }
    cpt = 0;
    cptm = 0;
    cpts = 0;
}

void inserer(char entite[], char code[], char type[], char constante[], char val[], int y) {
    switch (y) {
        case 0: /* Insertion dans la table des IDF et CONST */
            tab[cpt].state = 1;
            strcpy(tab[cpt].name, entite);
            strcpy(tab[cpt].code, code);
            strcpy(tab[cpt].type, type);
            strcpy(tab[cpt].constante, constante);
            strcpy(tab[cpt].val, val);
            cpt++;
            break;
        case 1: /* Insertion dans la table des mots clés */
            tabm[cptm].state = 1;
            strcpy(tabm[cptm].name, entite);
            strcpy(tabm[cptm].type, code);
            cptm++;
            break;
        case 2: /* Insertion dans la table des séparateurs */
            tabs[cpts].state = 1;
            strcpy(tabs[cpts].name, entite);
            strcpy(tabs[cpts].type, code);
            cpts++;
            break;
    }
}

void rechercher(char entite[], char code[], char type[], char constante[], char val[], int y) {
    int i;
    switch (y) {
        case 0: /* Recherche dans la table des IDF et CONST */
            for (i = 0; i < cpt; i++) {
                if (tab[i].state == 1 && strcmp(entite, tab[i].name) == 0) {
                    printf("Entite %s existe deja\n", entite);
                    return;
                }
            }
            inserer(entite, code, type, constante, val, y);
            break;
        case 1: /* Recherche dans la table des mots clés */
            for (i = 0; i < cptm; i++) {
                if (tabm[i].state == 1 && strcmp(entite, tabm[i].name) == 0) {
                    printf("Entite %s existe deja\n", entite);
                    return;
                }
            }
            inserer(entite, code, type, constante, val, y);
            break;
        case 2: /* Recherche dans la table des séparateurs */
            for (i = 0; i < cpts; i++) {
                if (tabs[i].state == 1 && strcmp(entite, tabs[i].name) == 0) {
                    printf("Entite %s existe deja\n", entite);
                    return;
                }
            }
            inserer(entite, code, type, constante, val, y);
            break;
    }
}
int rechercherIDF(char entite[]){
  int i=0;
  for (i; i<1000; i++){
    if (strcmp(entite,tab[i].name)==0){return i;}//retourne la position de l'IDF
  }
  return -1;//si l'IDF n'existe pas
}

void insererType (char entite[], char type[])
{   int pos;
     pos= rechercherIDF(entite);
     if (pos!=-1) {
    strcpy(tab[pos].type,type);
     }

}

void insererConst(char entite[],double val ) //float val 
 { 
   int pos;
    pos = rechercherIDF(entite);
    // Convertir le double en chaîne de caractères
    char str_val[20]; // Taille suffisamment grande pour stocker le double comme chaîne de caractères
    sprintf(str_val, "%lf", val);
    // Copier la chaîne de caractères dans tab[pos].val
    strcpy(tab[pos].val, str_val);        //cas de val float :tab[pos].val=atoi(val);
 }

void insererVal (char entite[], char val [])

{
  int pos ;
  pos=rechercherIDF(entite);
   strcpy(tab[pos].val,val); 

}

int doubleDeclaration (char entite[]) 
 { 
    int pos ; 
    pos = rechercherIDF(entite);
    if (strcmp(tab[pos].type, "")==0) //if (pos!= -1 && strcmp(tab[pos].type, "")==0)
        return 0 ;
    else return -1 ; 
 }

int variable_non_dec(char entite [])
{
   int pos;
  pos = rechercherIDF(entite); 
  if (strcmp (tab[pos].type ,"" )==0 && (tab[pos].val == 0 ))
     return 0 ;
  else return 1 ;

}
/***Step 5 L'affichage du contenue de la table des symboles ***/

void afficher() {
    printf("\n/***************Table des symboles IDF*************/\n");
    printf("_____________________________________________________________________________\n");
    printf("\t| Nom_Entite |  Code_Entite | Type_Entite | CONSTANTE | Val_Entite\n");
    printf("_____________________________________________________________________________\n");
    for (int i = 0; i < cpt; i++) {
        if (tab[i].state == 1) {
            printf("\t|%11s |%13s | %11s | %9s |  %10s | \n", tab[i].name, tab[i].code, tab[i].type, tab[i].constante, tab[i].val);
        }
    }
    printf("\n/***************Table des symboles mots cles*************/\n");
    printf("_____________________________________\n");
    printf("\t| NomEntite |  CodeEntite | \n");
    printf("_____________________________________\n");
    for (int i = 0; i < cptm; i++) {
        if (tabm[i].state == 1) {
            printf("\t|%10s |%12s | \n", tabm[i].name, tabm[i].type);
        }
    }
    printf("\n/***************Table des symboles separateurs*************/\n");
    printf("_____________________________________\n");
    printf("\t| NomEntite |  CodeEntite    | \n");
    printf("_____________________________________\n");
    for (int i = 0; i < cpts; i++) {
        if (tabs[i].state == 1) {
            printf("\t|%10s |%15s | \n", tabs[i].name, tabs[i].type);
        }
    }
}

char* typeIdf(char entite[])
{ int pos;
   char *Type ;
  pos = rechercherIDF(entite);
  Type=tab[pos].type ;
   return Type; 
}

char* rechercher_type(char entite[])
{ int pos;
   char *Type ;
  pos = rechercherIDF(entite);
  Type=tab[pos].type ;
   return Type; 
}

