%{
#include <stdlib.h>
#include <string.h>
#include "iimp.tab.h"


%}


Var [A-Za-z]+[A-Za-z0-9\-\_]*

%%

[1-9][0-9]*     {yylval.value = atoi(yytext); return I;}
:=              {return Af;}
Skip            {return Sk;}
;               {return Se;}
if              {return If;}
then            {return Th;}
else            {return El;}
while           {return Wh;}
do              {return Do;}
'+'             {return Pl;}
'-'             {return Mo;}
'*'             {return Mu;}
{Var}           {yylval.var = strdup(yytext); return V;}

%%

