all: part_one part_two

part_one: part_one.o parseInt.o printlnInt.o
	ld -o $@ $^

part_two: part_two.o parseInt.o printlnInt.o
	ld -o $@ $^

%.o: %.asm
	nasm -felf64 -o $@ $<

clean:
	rm -f *.o part_one part_two
