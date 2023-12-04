all: generate compile

generate:
	flex pcss.l 
compile:
	gcc lex.yy.c -o pcss
#generate:
#	flex pcss.l && bison -dy pcss.y
#compile:
#	gcc lex.yy.c y.tab.c -o pcss
