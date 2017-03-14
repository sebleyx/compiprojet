%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <stdarg.h>
  #include "utils.h"
  
  

  extern void yyerror(char* s);
 
  
%}

%union {
    int val;
    char* var;
    node node;
}

%token Af Sk Se If Th El Wh Do Pl Mo Mu
%token <var> V
%token <val> I
%start Start
%type <node> E T F C0 C
%%

Start : C

 E: E Pl T   {$$ = new_arbre(TYPE_OPR,"Pl",eval(Pl,$1,$3),$1,$3,NULL);}
  | E Mo T   {$$ = new_arbre(TYPE_OPR,"Mo",eval(Mo,$1,$3),$1,$3,NULL);}
  | T        {$$ = $1;}
  ;

 T: T Mu F   {$$ = new_arbre(TYPE_OPR,"Mu",eval(Mu,$1,$3),$1,$3,NULL);}
  | F        {$$ = $1;}
  ;

 F: '(' E ')'  {$$ = $2;}
  | I          {$$ = new_arbre(TYPE_CONST,"I",$1,NULL);}
  | V          {$$ = new_arbre(TYPE_VAR,$1,NULL,NULL);}
  ;

 C0 : V Af E    {$$ = new_arbre(TYPE_OPR,"Af",NULL,$1,$3,NULL);}
  | '(' C ')'  {$$ = $2;}
  | Sk         {$$=new_arbre(TYPE_OPR,"Sk",NULL,NULL);}
  | Se	{$$=new_arbre(TYPE_OPR,"Se",NULL, NULL);} 
  | If E Th C El C0    {$$=new_arbre(TYPE_OPR,"If",NULL, $2, $4, $6,NULL);}
  | Wh E Do C0         {$$= new_arbre(TYPE_OPR, "Wh",$2,$4,NULL);}
  ;
  
  C : C Se C0	{$$ = new_arbre(TYPE_OPR,"Se",NULL,$1,$3,NULL);}
    | C0	{$$ = $1;}


%%

  
/**
\fn arbre new_arbre(int type,const char *name, int value,  ...)
\author Carlos Nezout & Sebastien Leyx
\brief 
\param int type 
\param char* name 
\param int value 
\return un arbre initialisé selon le type de noeud 
\remarks aucune 
*/
arbre new_arbre(int type,const char *name, int value,  ...){
    arbre tmp;
    int i;
    int nb_args;
    va_list argp;
    /*allocation mémoire de l'arbre */
    tmp = (arbre) malloc(sizeof(node));
    
    tmp->var = malloc(MAXIDENT*sizeof(char));
    
    tmp->degree=0;
    tmp->type = type;
    tmp->value=value;
    tmp->var=strdup(name);
    /* Création des noeuds fils opérandes (de type TYPE_CONST) */
    if (type== TYPE_OPR){ //cas de noeud de type Opération (seul traitement distingué)
      va_start(argp, value);
      nb_args=0;
      while(va_arg(argp, arbre) != NULL)
	nb_args++;
      va_end(argp);
      tmp->degree = nb_args;
      if (temp->degre !=0) {
	tmp->child=(arbre *) calloc(tmp->degre, sizeof(arbre));
	va_start(argp,name);
	for(i=0; i<n_args; i++) {
	  tmp->child[i]=va_arg(argp, arbre) ;
	}
	va_end(argp);
      }
    }
    return tmp;
}

void parcours(arbre ab, void (*Pre) (arbre), void (*Post) (arbre)){
  int i;
  if (ab==NULL) 
    return;
  if (PreFct!=NULL) PreFct(ab);
  for(i=0; i<ab->degre; i++)
    parcours(ab->child[i],Pre,Post);
  if (PostFct!=NULL)
    PostFct(ab);
}


void free_arbre(arbre ab){
  void free_node(arbre p){
    free(p->var);
    free(p->child);
    free(p);
  }
  parcours(ab,NULL, free_node);
}


void yyerror(char* s){
  fprintf(stderr,"** error %s **\n ",s);
}

void yywrap(){
}

void main(){
  yyparse();
}
