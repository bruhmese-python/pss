%{
%}

IDENTIFIER [A-Za-z_]+[A-Za-z_0-9]*
WHITESPACE [" "\n]+
%%
\{      { printf("<opening braces>"); }
\}      { printf("<closing braces>");}
{IDENTIFIER} 				{ printf("\n\n<identifier: %s>",yytext); }
\.{IDENTIFIER}(-[A-Za-z_0-9]+)* 	{ printf("\n\n<class: %s>",yytext);}
{IDENTIFIER}(-[A-Za-z_0-9]+)* 		{ printf("\n\n<property-name: %s>",yytext);}
;	{ printf("<property separator>"); }
:	{ printf("<pair separator>"); }
.	{ printf("%s", yytext); }
%%
int yywrap(void){}
int main(){
	yylex();
	return 0;
}
