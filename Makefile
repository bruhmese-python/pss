all: generate compile
generate:
	flex pss.l && bison -t -dy pss.y
compile:
	g++ lex.yy.c y.tab.c -o pss
clean:
	rm ./pss
	rm y.tab.c y.tab.h
	rm lex.yy.c 
