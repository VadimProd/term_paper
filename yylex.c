#include <stdio.h>
#include "y.tab.h"

#define DEBUG 0

extern FILE* yyin;
//extern int line;

int yyerror(symbol) {
	if (symbol == EOF) { printf("yyerror %d", symbol); }
	printf("Some error with symbol %d(%c)\n", symbol, symbol);
	exit(0);

	//print_error("Unexpected lexical error", line);
}

int is_symbol(int sym){
	if (sym == '=' || sym == '?' || sym == ':' || sym == '$' || sym == '(' || sym == ')') return 1;
	//else if (ispunct(sym)) return 0;
	else if(isspace(sym)) return 1;
	else if(sym == '\n'){ return 1; }
	else return 0;
}

void skip_spaces(int *symbol){
	while (*symbol == ' ') *symbol = getc(yyin);
}

void skip_enter(int *symbol){
	while (*symbol == '\n') *symbol = getc(yyin);
}

int yylex() {
	
	int symbol = getc(yyin);
	//printf("Symbol1 is %d\n", symbol);
	if (symbol == EOF) { exit(0); }

	while (symbol == ' ') symbol = getc(yyin);

	// check comments
	if (symbol == '\n'){
		symbol = getc(yyin);
		skip_enter(&symbol);
		skip_spaces(&symbol);
	}
	//printf("Symbol2 is %d\n", symbol);

	#ifdef DEBUG
		#if DEBUG == 1
			printf("Symbol is %d\n", symbol);
		#endif
	#endif

	while (symbol == '#') {
		symbol = getc(yyin);

		while (symbol != '\n') {
			if (symbol == EOF) exit(0);
			symbol = getc(yyin);
		}
		skip_enter(&symbol);
	}

	if (isdigit(symbol)){
		yylval.num = symbol - '0';
		return DIGIT;
	}
	else if(!is_symbol(symbol)){
		//printf("-> GO <- ");
		char buf[256] = {0};
		int i = 0;
		buf[i++] = symbol;

		while (!is_symbol(symbol = getc(yyin))) {
			if (symbol == EOF) break;
			buf[i++] = symbol;
		}
		printf("%s\n", buf);
		strcpy(yylval.word, buf);

		return WORD;
	}
	//else if(ispunct(symbol)){
	//	return symbol;
	//}
	else{
		printf("else\n");
		return symbol;
	}
	/*
symbol
	if (ispunct(symbol)) {

		if (symbol == '=' || symbol == '\\' || symbol == '.' || symbol == '*' || symbol == '$' || symbol == ':' || symbol == '-'
		    || symbol == '?' || sysymbolmbol == '|' || symbol == '{' || symbol == '}' || symbol == '(' || symbol == ')' || symbol == ';') { 
			return symbol;
		}
		else { 
			printf("Lexical error: invalid character '%c' in line %d\n", symbol, line);
			exit(0);
		}
	}
	else if (isdigit(symbol)) { yylval = symbol - '0'; return DIGIT; }
	else if (islower(symbol)) { yylval = symbol - 'a'; return LETTER; }
	else if (isupper(symbol)) { yylval = symbol - 'A'; return BIG_LETTER; }
	else if (isspace(symbol)) { return symbol; }
	else { return symbol; }
	*/
}