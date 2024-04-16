#include <stdio.h>
#include "y.tab.h"

extern FILE* yyin;
//extern int line;

int yyerror(symbol) {
	if (symbol == EOF) { printf("yyerror %d", symbol); }
	printf("Some error\n");

	//print_error("Unexpected lexical error", line);
}

int is_symbol(int sym){
	if (sym == '_') return 0;
	else if (ispunct(sym)) return 1;
	else if(isspace(sym)) return 1;
	else if(sym == '\n') return 1;
	else return 0;
}

int yylex() {
	
	int symbol = getc(yyin);
	if (symbol == EOF) { printf("File is empty\n"); exit(0); }

	while (symbol == ' ') symbol = getc(yyin);

	// check comments
	if (symbol == '#') {
		symbol = getc(yyin);

		while (symbol != '\n') {
			if (symbol == EOF) exit(0);
			symbol = getc(yyin);
		}
	}

	//printf("Symbol is %d\n", symbol);

	if (isdigit(symbol)){
		yylval.num = symbol - '0';
		return DIGIT;
	}
	else if(!is_symbol(symbol)){
		char buf[256] = {0};
		int i = 0;
		buf[i++] = symbol;

		while (!is_symbol(symbol = getc(yyin))) {
			if (symbol == EOF) exit(0);
			buf[i++] = symbol;
		}
		printf("%s\n", buf);
		strcpy(yylval.word, buf);
		fseek(yyin, - 1, SEEK_CUR);

		return WORD;
	}
	else if(ispunct(symbol)){
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