#include <stdio.h>
#include "y.tab.h"

extern FILE* yyin;

int yyerror(const char *s) {  
	printf("\nThis is not a make file\n");
    fprintf(stderr, "error %s\n", s);
    exit(0);
}

int main() {
	yyin = fopen("test.txt", "r");
	if (yyin == NULL) { 
		return -1; 
	}
	yyparse();
	fclose(yyin);
	printf("This is MakeFile!\n");
	return 0;
}

