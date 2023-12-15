%{
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

bool extends_mode_on = false;

void register_class(const char* s){
	if(extends_mode_on)
		printf("<inheriting class:%s>",s);
	else
		printf("\n<class:%s>",s);
}

void yyerror(const char* s);
int yylex(void);

%}

%define parse.error custom

%union{
    char* string;
}

%token OPENING_BRACES
%token CLOSING_BRACES
%token <string> PROPERTY_NAME
%token <string> IDENTIFIER
%token PROPERTY_SEPARATOR
%token PAIR_SEPARATOR
%token <string> CLASS_NAME
%token ASSIGN
%token EXTENDS
%token <string> TEXT
%token WHITESPACE
%token <string> COMMENT

%nterm <string> valid_value

%%

css: opt_whitespace css 
	| variable css 
	| class_definition css
	| comment css  
	| class_definition
	| comment 
	;

class_definition:  class_names opt_extends_class_names open_brace opt_whitespace property_pairs CLOSING_BRACES opt_whitespace opt_eof;

variable: IDENTIFIER opt_whitespace ASSIGN opt_whitespace valid_value opt_whitespace PROPERTY_SEPARATOR {printf("<variable[%s] : %s>",$1,$5);};

open_brace: OPENING_BRACES {extends_mode_on = false;};

class_names: CLASS_NAME 				{register_class($1);}
	   | CLASS_NAME opt_whitespace 			{register_class($1);}
	   | CLASS_NAME opt_whitespace class_names 	{register_class($1);}
	   ;

opt_extends_class_names: EMPTY 
		        | extends opt_whitespace class_names 
			;

extends: EXTENDS {printf("<extends>");extends_mode_on = true;}
 
property_pairs: property_pair opt_whitespace PROPERTY_SEPARATOR opt_whitespace
	      | property_pair opt_whitespace 
	      | property_pair opt_whitespace PROPERTY_SEPARATOR opt_whitespace property_pairs opt_whitespace 
	      ;

property_pair: PROPERTY_NAME opt_whitespace PAIR_SEPARATOR opt_whitespace valid_value {printf("\n<property pair: %s : %s>",$1,$5);};

valid_value: TEXT 
           | IDENTIFIER 
           | valid_value TEXT {$$=strcat($$,$2);}
           | valid_value IDENTIFIER {$$=strcat($$,$2);}
           | valid_value WHITESPACE {$$=strcat($$," ");}
           ;

EMPTY: /*empty*/;
opt_whitespace: EMPTY 
	      | WHITESPACE opt_whitespace 
	      ;
		
comment: COMMENT {printf("%s",$1);}

opt_eof:  EMPTY 
        | YYEOF
	;

%%

int yywrap(void) {return 1;}

void yyerror(const char* s) {
    printf("\nError: %s\n", s);
}

static int yyreport_syntax_error (const yypcontext_t *ctx) { 
	int res = 0; 
	YY_LOCATION_PRINT (stderr, *yypcontext_location (ctx));
	fprintf (stderr, ": syntax error");
 // Report the tokens expected at this point. 
{ 
	enum { TOKENMAX = 5 };
	yysymbol_kind_t expected[TOKENMAX];
	int n = yypcontext_expected_tokens (ctx, expected, TOKENMAX);
	if (n < 0) // Forward errors to yyparse. 
		res = n; 
	else
		for (int i = 0; i < n; ++i) 
			fprintf (stderr, "%s %s", i == 0 ? ": expected" : " or", yysymbol_name (expected[i])); 
} // Report the unexpected token. 
{ 
	yysymbol_kind_t lookahead = yypcontext_token (ctx); 
	if (lookahead != YYSYMBOL_YYEMPTY) 
	fprintf (stderr, " before %s at ", yysymbol_name (lookahead)); 
	YY_LOCATION_PRINT (stderr, *yypcontext_location (ctx));
} 
	fprintf (stderr, "\n"); 
	return res;
}
int main() {
    yyparse();
    return 0;
}

