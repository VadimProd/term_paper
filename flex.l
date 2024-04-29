%{
    #include "y.tab.h"

    #define INITIAL 0

    extern unsigned int g_if_end;
    extern unsigned int g_if_else;

    extern int yyerror(const char *);
%}

%option noyywrap

DIGIT [[:digit:]]
UNIT_NAME [_[:alpha:]\*\-\+\@\\]

%x VALUE
%x DEFINE_VALUE

%%

\n                                                { return ENTER; }

"#"[^\n]*

"("                                               { return '('; }
")"                                               { return ')'; }
"{"                                               { return '{'; }
"}"                                               { return '}'; }

"$"                                               { return '$'; }
";"                                               { return ';'; }
","                                               { return ','; }           
":"                                               { return ':'; }

"ifeq"|"ifneq"                                    { ++g_if_end; ++g_if_else; return IF;    }
"ifdef"|"ifndef"                                  { ++g_if_end; ++g_if_else; return IFDEF; }

"endif"                                           { return ENDIF; }
"else"                                            { return ELSE;  }

^"export"                                         { return EXPORT; }
^"include"                                        { return INCLUDE; }

^[[:blank:]]+[^\n]*                               { return COMMAND; }
^[[:blank:]]+[^\\]*                               { BEGIN(VALUE); }

^"define"[[:space:]]+{UNIT_NAME}[[:space:]]*.*\n  { BEGIN(DEFINE_VALUE); }
<DEFINE_VALUE>(.*\n)*endef                        { BEGIN(INITIAL); return DEFINE; }

"="                                               { BEGIN(VALUE); }
<VALUE>(.*\\\n)*
<VALUE>.*\n                                       { BEGIN(INITIAL); return VAR_VALUE; }

({UNIT_NAME}|{DIGIT})+                            { return UNIT_NAME; }
\%({UNIT_NAME}|{DIGIT}|[\.])*                     { return TEMPLATE; }

^\%({UNIT_NAME}|{DIGIT}|[\.]|[//])*               { return TEMPLATE_TARGET;}
^\.({UNIT_NAME}|{DIGIT})*\.({UNIT_NAME}|{DIGIT})+ { return SPECIAL_TARGET;}

([[:alnum:]//]|[\.])+                                                 { return FILE_NAME; }
(\/|[\.\.]|[\.])?(([[:alnum:]//]|[\.]|[\.\.])+[\/]?)+([\/]|[\/\*])?   { return PATH; }

<<EOF>>                                           { return EOF_; }

[[:blank:]]
. { printf("Unrecognized symbol: %c\n",yytext[0]); yyerror("lexical error"); exit(0); }

%%