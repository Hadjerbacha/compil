#include "quadr.h"
#include <stdlib.h>
#include <stdio.h> 
#include <string.h>

extern int qc;
void quadr(char op[],char arg1[],char arg2[],char result[])
{
strcpy(quad[qc].op,op);
strcpy(quad[qc].arg1,arg1);
strcpy(quad[qc].arg2,arg2);
strcpy(quad[qc].result,result);
qc++;
} 


void update_quad(int num_quad, int column_quad, char val[]) {
switch (column_quad) {
case 0: strcpy(quad[num_quad].op,val); break;
case 1: strcpy(quad[num_quad].arg1,val); break;
case 2: strcpy(quad[num_quad].arg2,val); break;
case 3: strcpy(quad[num_quad].result,val); break;
}
}



void print_quad()
{
printf("*********************Les Quadruplets***********************\n");
int i;
for(i=0;i<qc;i++)
{
printf("\n %d - ( %s , %s , %s , %s )",i,quad[i].op,quad[i].arg1,quad[i].arg2,
quad[i].result);
printf("\n______________________________\n");
}
}