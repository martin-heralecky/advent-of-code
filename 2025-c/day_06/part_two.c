#include <stdio.h>
#include <stdlib.h>

#define SIZE 3763

int main() {
	FILE *f = fopen("input.txt", "r");

	char ws[SIZE * 5];
	fread(ws, 1, SIZE * 5, f);

	long long total = 0;
	long long p;
	char op;
	for (int i = 0; i < SIZE; ++i) {
		char ns[5] = {0};
		int nsc = 0;
		for (int j = 0; j < 4; ++j) {
			if (ws[j * SIZE + i] != ' ' && ws[j * SIZE + i] != '\n') {
				ns[nsc++] = ws[j * SIZE + i];
			}
		}
		int n = atoi(ns);

		if (n == 0) {
			total += p;
			continue;
		}

		if (ws[4 * SIZE + i] != ' ' && ws[4 * SIZE + i] != '\n') {
			op = ws[4 * SIZE + i];
			if (op == '+') {
				p = 0;
			} else if (op == '*') {
				p = 1;
			}
		}

		if (op == '+') {
			p += n;
		} else if (op == '*') {
			p *= n;
		}
	}

	printf("%lld\n", total);

	return 0;
}
