%{
	#include<string>
	using std::string;
	string id_buffer = "";
%}

IDENTIFIER [A-Za-z_]+[A-Za-z_0-9]*
WHITESPACE [" "\n]+
EXTENDS "extends"
EQUALS "="

%x property

%%
\{      { printf("<opening braces>");}
\}      { printf("<closing braces>");}
{IDENTIFIER} 				{ id_buffer += yytext;if(id_buffer!=keyword) BEGIN(property); }
<property>{WHITESPACE}*/:		{ printf("\n\n<property-name: %s>",id_buffer.c_str());id_buffer.clear();BEGIN(INITIAL);}
<property>(-[A-Za-z_0-9]+)* 		{ printf("\n\n<property-name-with-hyphen: %s%s>",id_buffer.c_str(),yytext);id_buffer.clear();BEGIN(INITIAL);}
<property>{WHITESPACE}*/.		{ printf("\n\n<identifier: %s>",id_buffer.c_str());id_buffer.clear();BEGIN(INITIAL);}
\.{IDENTIFIER}(-[A-Za-z_0-9]+)* 	{ printf("\n\n<class: %s>",yytext);}
;	{ printf("<property separator>"); }
:	{ printf("<pair separator>"); }
.	{ ECHO; }
%%
int yywrap(void){}
//printf("\n\n<identifier: %s>",yytext);
int main(){
	yylex();
	return 0;
}
