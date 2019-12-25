MYROOT = .

compile: $(MYROOT)/*.nasm
	for file in $^ ; do nasm -felf64 $${file} ; done

link: $(MYROOT)/*.o
	ld $^ -o out

clean: $(MYROOT)/*.o
	rm $^

all: compile link clean
