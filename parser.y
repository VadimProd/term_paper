%{
#include <stdio.h> 
#include <string.h>
#include <math.h>
#include <ctype.h>

extern int yyerror(const char *s);

enum error_type {
	XYU
};

void print_error(const char* text, int line) {
	printf("%s in line %d\n", text, line);
	exit(0);
}

%}

%union{
	int num;
	char word[256];
}

%start starter

%token EOF_
%token ENTER
%token VAR_NAME VAR_ASSIGNMENT
%token COMMAND

%left '+' '-'
%left '*' '/'
%right '^'
%%

starter:
	begin
;

begin:
	str
	| begin str
;

enter:
	ENTER 
	| enter ENTER
	| EOF_{ printf("\nEnd of file\n"); exit (0); }

str:
	| enter
	| variables_init
	| rule
	| command
;

variables_init:
	VAR_NAME VAR_ASSIGNMENT var_value
;

var_value:
	VAR_NAME
	| var_value VAR_NAME
;

rule:
	VAR_NAME ':' dependences {printf("\nRule\n");}
	//| target ':'
	//| target ':' WORD
;

/* ------------------------------------------------------------------- */

dependences:
	| dependence
	| dependences dependence
;
dependence:
	VAR_NAME
;

/* ------------------------------------------------------------------- */
commands:
	| command
	| commands command
;

command:
	COMMAND
;

/* ------------------------------------------------------------------- */
	

//| variables_init
