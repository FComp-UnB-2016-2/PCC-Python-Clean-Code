# PCC-Python-Clean-Code
Trabalho realizado na disciplina de Fundamentos de Compiladores no segundo semestre de 2016 pelos alunos de Engenharia de Software da UnB:
- Eduardo Henrique Fonseca Moreira (13/0008371)
- Filipe Ribeiro de Morais (12/0117738)
- Omar Faria dos Santos Júnior (13/0015920)
- Matheus Silva Pereira (13/015369)

# Instruções de Uso
			 
Para compilar e executar o programa do compilador, execute os passos a seguir:

- Acesse o terminal do computador;
- Entre no diretório onde está localizado o arquivo Makefile do projeto
- Execute o comando para compilar o programa:
				
	$ make

- Posteriormente, o comando abaixo para gerar o arquivo de saída "nome_do_arquivo_de_saida_desejado" a partir do arquivo de entrada "nome_do_arquivo_de_entrada.py"
		
	$ ./pcc < { nome_do_arquivo_de_entrada.py nome_do_arquivo_de_saida_desejado

		
# Observações:

No diretório "ArquivosTestePCC" existem alguns arquivos de entrada que podem ser utilizados para teste do compilador. Para usar tais arquivos de teste, execute o comando a seguir após compilar o programa:

	$ ./pcc < /ArquivosTestePCC/exemplo1.py exemplo1_alterado

O nome do arquivo de entrada exemplo1.py pode ser alterado para exemplo2.py, exemplo3.py, ou qualquer outro disponível.

Para limpar os arquivos gerados pela compilação do programa do compilador, execulta-se o comando:

	$ make clean


