%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	#define TRUE 1
	#define FALSE 0

	int yyparse();
	int yyerror(const char *s);

	extern int yylex();           
	extern unsigned int g_if_end = 0;
	extern unsigned int g_if_else = 0;

	enum locations{
		EMPTY,
		TARGET,
		COND
	};

	enum locations location = EMPTY;
%}

%token VAR_VALUE COMMAND
%token TEMPLATE TEMPLATE_TARGET SPECIAL_TARGET

%token EOF_
%token ENTER
%token ELSE ENDIF
%token INCLUDE DEFINE EXPORT
%token IF IFDEF

%token PATH
%token UNIT_NAME
%token FILE_NAME

%start starter

%%

/* -------------------------------------------------------------------------------------------- */

starter:
    str
    | starter str
;

str: 
	enter                                                 
    | variable                  { location = EMPTY;  }           
    | target                    { location = TARGET; }
	| command					{ 
		(!location) ? yyerror("Command is not in the target's body") : "\0";
	}
    | condition					{ location = COND;   }           
    | include                   
    | DEFINE                    
;

enter:
	ENTER
	| enter ENTER
	| EOF_ 						{ printf("\nThis is MakeFile!\n"); exit(0); }
;

/* -------------------------------------------------------------------------------------------- */

variable: 	
	UNIT_NAME VAR_VALUE 	//init var: UNIT_NAME = <...>

	// Export vars
    | EXPORT UNIT_NAME enter
    | EXPORT variable
;

/* -------------------------------------------------------------------------------------------- */

target: 
    target_spec dependences enter       
    | target_spec dependences ';' units enter
    | target_spec dependences ';' enter
;

target_spec: 
    target_names ':'
    | target_names ':'':'
    | SPECIAL_TARGET ':'
;

target_names: 
    target_name
    | target_names target_name
;

target_name: 
    unit
    | TEMPLATE_TARGET
    | template
;

/* -------------------------------------------------------------------------------------------- */

dependences: 
    | dependence
    | dependences dependence
;

dependence: 
    unit
    | template
;

template: 
    TEMPLATE
    | '('TEMPLATE')'
;

/* -------------------------------------------------------------------------------------------- */

command:
	COMMAND enter
	| VAR_VALUE
;

/* -------------------------------------------------------------------------------------------- */

condition: 
    IF '(' unit ',' unit ')' enter 
    | IF '(' ',' unit ')' enter
    | IF '(' unit ',' ')' enter
    | IF '(' ',' ')' enter
    | IFDEF unit enter
    | ELSE { 
		(!g_if_else) ? yyerror("Else without ifeq/ifdef statement") : --g_if_else;
	}
    | ENDIF enter { 
		(!g_if_end) ? yyerror("Endif without ifeq/ifdef statement") : --g_if_end;
	}
;

/* -------------------------------------------------------------------------------------------- */

include: 
	INCLUDE unit
;

units: 
    unit
    | units unit
;

unit: 
    UNIT_NAME  
    | PATH
    | FILE_NAME
    | variable_value
;

variable_value: 
    '$' UNIT_NAME                                    
    | '$' '$' UNIT_NAME    
    | '$' '(' UNIT_NAME ')'                      
    | '$' '{' UNIT_NAME '}'
    | '$' '(' VAR_VALUE ')'
    | '$' '{' VAR_VALUE '}'
    | '$' '$' '(' VAR_VALUE ')'
    | '$' '$' '{' VAR_VALUE '}'
;

%%