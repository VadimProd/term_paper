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

starter: begin 
	| begin enter starter
	| enter starter
	| enter 
;

enter: '\n' { /*line++;*/ }
;

begin: target ':' { printf("\nTEST\n"); }
	| target ':' dependence {  }

;

init: 

;

main: 

;  

target: WORD | WORD '.' WORD

dependence: target {}
	| dependence target {}
;
