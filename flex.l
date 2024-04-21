%{
    #include "y.tab.h"

    //extern unsigned int g_line_amt;
    extern int yyerror(const char *);
%}

DIGIT [0 - 9]
%%
%%

int yywrap(){
    return 1;
}