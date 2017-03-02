%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>


  extern void yyerror(char* s);

  struct node{
    char var[256];
    int types;
    int value;
    node* f1;
    node* f2;
    node* f3;
  };
  typedef struct node node;

  
%}

%union {
    int val;
    char* var;
}

%token Af Sk Se If Th El Wh Do Pl Mo Mu
%token V
%token I
%start Start
%type<value> E T F C
%%

Start : C

 E: E Pl T   {$$ = eval(Pl,$1,$3);}
  | E Mo T   {$$ = eval(Mo,$1,$3);}
  | T        {$$ = $1;}
  ;

 T: T Mu F   {$$ = eval(Mu,$1,$3);}
  | F        {$$ = $1;}
  ;

 F: '(' E ')'  {$$ = $2;}
  | I          {$$ = $1;}
  | V          {$$ = $1;}
  ;

 C : V Af E    {$$ = eval(Af,$1,$3);}
  | Sk         ;
  | '(' C ')'  {$$ = $2;}
  | If E Th C El C    {if($2) $$ = $4 else $$ = $6;}
  | Wh E Do C         {while($2) do $4;}
  |  C Se C
  ;


%%

  node* new_node(int t,int v,node* n1,node* n2,node* n3

void yyerror(char* s){
  fprintf(stderr,"** error %s **\n ",s);
}

void yywrap(){
}

void main(){
  yyparse();
}
