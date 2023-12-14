%{
#include<string.h>
#include<stdbool.h>
#include "y.tab.h"

char id_buffer[256]= "\0";
bool commented = false;

int is_keyword(){
	if(strcmp(yytext,"extends")==0) {return EXTENDS;}
	return -1;
}
%}

IDENTIFIER [A-Za-z_]+[A-Za-z_0-9]*
WHITESPACE [" "\t\n]
COMMENT_BEGIN "/*"
COMMENT_END "*/"

%x property

%%
\{      { return OPENING_BRACES;}
\}      { return CLOSING_BRACES;}
{IDENTIFIER} 				{ 
						if(commented) return COMMENT; 
						int keyword = is_keyword();
						if(keyword != -1) {return keyword;}
						else { 
							strcpy(id_buffer, yytext);
							BEGIN(property);
						}
					}
<property>(-[A-Za-z_0-9]+)*/{WHITESPACE}*: 		{ if(commented) return COMMENT; BEGIN(INITIAL);strcat(id_buffer,yytext);yylval.string = strdup(id_buffer);return PROPERTY_NAME;}
<property>{WHITESPACE}*/.		{ if(commented) return COMMENT; BEGIN(INITIAL);strcat(id_buffer,yytext);yylval.string = strdup(id_buffer);return IDENTIFIER;}
\.{IDENTIFIER}(-[A-Za-z_0-9]+)* 	{ if(commented) return COMMENT; /*printf("class: %s",yytext);*/yylval.string = strdup(yytext);return CLASS_NAME;}
{COMMENT_BEGIN}				{ commented=true; return COMMENT; }
{COMMENT_END}				{ commented=false; }
;		{ if(commented) return COMMENT; return PROPERTY_SEPARATOR; }
:		{ if(commented) return COMMENT; return PAIR_SEPARATOR; }
{WHITESPACE} 	{ if(commented) return COMMENT; return WHITESPACE;}
= 		{ if(commented) return COMMENT; return ASSIGN;}
.		{ if(commented) return COMMENT; return TEXT; }
%%
