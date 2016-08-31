pcc: lexico_pcc.l sintatico_pcc.y
	bison -d sintatico_pcc.y
	mv sintatico_pcc.tab.h sintatico.h
	mv sintatico_pcc.tab.c sintatico.c
	flex lexico_pcc.l
	mv lex.yy.c lexico.c
	gcc -o pcc sintatico.c lexico.c

clean:
	rm lexico.* sintatico.* pcc
