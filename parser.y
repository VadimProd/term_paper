%{
#include <stdio.h> 
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <stdbool.h>

enum error_type {
	XYU
};

void print_error(const char* text, int line) {
	printf("%s in line %d\n", text, line);
	exit(0);
}

void error_list(enum error_type error) {
	return;
}

%}

%union{
	int num;
	char word[256];
}

%token <word> WORD
%token <num> NUM

%start starter

%token DIGIT LETTER

%left '+' '-'
%left '*' '/'
%right '^'
%%

starter:
	begin
;

begin:
	| command
	| begin command
;

command:
	variables_init
	| rule
	| recipe
	| WORD
;

recipe:
	'$' '(' WORD ')' recipe {printf("\nTEST\n");}
	| WORD

variables_init:
	WORD '=' WORD
	| WORD ':' '=' WORD
	| WORD '?' '=' WORD
;

rule:
	target ':' dependence
	| target ':'
	| target ':' WORD

target: 
	WORD

dependence:
	WORD
	| dependence WORD
;
