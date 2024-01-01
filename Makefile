all: generate compile
generate:
	flex pss.l && bison -t -dy pss.y
compile:
	g++ -std=c++17 lex.yy.c y.tab.c -o pss
clean:
	rm ./pss
	rm y.tab.c y.tab.h
	rm lex.yy.c 

script:
	cp ./pss "/home/admin/Desktop/New Volume/scripts"
