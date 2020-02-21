
default: run
	

bin/Main.class: src
	${MAKE} build

build:
	javac -d bin -sourcepath src/ --add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED src/Main.java

run: bin/Main.class
	java -cp bin Main

clean:
	-rm -rf bin
	-rm -rf out
	