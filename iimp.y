%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <stdarg.h>
  #include "utils.h"
  #include "environ.c"
  
  #define YYDEBUG 1
  extern int yyerror(char*);
  extern int yylex();
  extern int ex(ENV *e,arbre ab);


  
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
  arbre new_arbre(int type, const char *name, int value,  ...){
    arbre tmp;
    int i;
    int nb_args;
    va_list argp;
    /*allocation mémoire de l'arbre */
    tmp = (arbre) malloc(sizeof(node));
    
    
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
      if (tmp->degree !=0) {
	tmp->child=(arbre *)calloc(tmp->degree, sizeof(arbre));
	va_start(argp,value);
	for(i=0; i<nb_args; i++) {
	  tmp->child[i]=va_arg(argp, arbre) ;
	}
	va_end(argp);
      }
    }
    return tmp;
  }
  
%}

%union {
    int val;
    char* var;
    arbre nodes;
}

%token Af Sk Se If Th El Wh Do Pl Mo Mu
%token <var> V
%token <val> I
%start Start
%type <nodes> E T F C0 C
%%

Start : C {ENV e = Envalloc(); ex(&e,$1);}

 E: E Pl T   {$$ = new_arbre(TYPE_OPR,"Pl",eval(Pl,$1->value,$3->value),$1,$3,NULL);}
  | E Mo T   {$$ = new_arbre(TYPE_OPR,"Mo",eval(Mo,$1->value,$3->value),$1,$3,NULL);}
  | T        {$$ = $1;}
  ;

 T: T Mu F   {$$ = new_arbre(TYPE_OPR,"Mu",eval(Mu,$1->value,$3->value),$1,$3,NULL);}
  | F        {$$ = $1;}
  ;

 F: '(' E ')'  {$$ = $2;}
  | I          {$$ = new_arbre(TYPE_CONST,"I",$1,NULL);}
  | V          {$$ = new_arbre(TYPE_VAR,$1,0,NULL);}
  ;

 C0 : V Af E    {$$ = new_arbre(TYPE_OPR,"Af",0,$1,$3,NULL);}
  | '(' C ')'  {$$ = $2;}
  | Sk         {$$=new_arbre(TYPE_OPR,"Sk",0,NULL);}
  | Se	{$$=new_arbre(TYPE_OPR,"Se",0, NULL);} 
  | If E Th C El C0    {$$=new_arbre(TYPE_OPR,"If",0, $2, $4, $6,NULL);}
  | Wh E Do C0         {$$= new_arbre(TYPE_OPR, "Wh",$2->value,$4,NULL);}
  ;
  
  C : C Se C0	{$$ = new_arbre(TYPE_OPR,"Se",0,$1,$3,NULL);}
    | C0	{$$ = $1;}


%%

void parcours(arbre ab, void (*PreFct) (arbre), void (*PostFct) (arbre)){
  int i;
  if (ab==NULL) 
    exit(-1);
  if (PreFct!=NULL) PreFct(ab);
  if (ab->type == TYPE_OPR){
    for(i=0; i<ab->degree; i++)
      parcours(ab->child[i],PreFct,PostFct);
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
  yydebug = 0;
  yyparse();
}
