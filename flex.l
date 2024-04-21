%{
    #include "y.tab.h"

    //extern unsigned int g_line_amt;
    extern int yyerror(const char *);
%}

DIGIT [0-9]

/* All symbols [A-z] and [a-z] including {'*', '+', '-', '@', '\'} */
UNIT_NAME [_a-zA-Z\*\-\+\@\\]

%%

"#"[^\n]*                   { }
\n                          { return ENTER; }

^[ \t]+[^\n]*               { printf("\nCOMMAND\n"); return COMMAND; }
({UNIT_NAME}|{DIGIT}|[\.])* { printf("\nVAR_NAME\n"); return VAR_NAME;}

"="|":="|"?="               { printf("\nVAR_ASSIGNMENT\n");return VAR_ASSIGNMENT; } 
":"                         { return ':'; }
<<EOF>>                     { return EOF_; }

%%

int yywrap(){
    return 1;
}