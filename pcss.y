%{
#include <stdio.h>
%}

%token NUM

%%

calclist: /* empty */
         | calclist exp '\n' { printf("Result: %d\n", $2); }
         ;

exp: factor
   | exp '+' factor { $$ = $1 + $3; }
   | exp '-' factor { $$ = $1 - $3; }
   ;

factor: term
      | factor '*' term { $$ = $1 * $3; }
      | factor '/' term { 
          if ($3 != 0) {
              $$ = $1 / $3;
          } else {
              yyerror("Division by zero");
              YYABORT;
          }
      }
      ;

term: NUM
    ;

%%

void yyerror(const char* s) {
    printf("Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}

