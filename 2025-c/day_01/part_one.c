#include <stdio.h>

int main() {
	FILE *f = fopen("input.txt", "r");

	int zero = 0;
	int cur = 50;
	char d;
	int r;
	while (fscanf(f, "%c%d\n", &d, &r) == 2) {
		if (d == 'R') {
			cur += r;
		} else if (d == 'L') {
			cur -= r;
		}
		if (cur % 100 == 0) {
			++zero;
		}
	}

	printf("%d\n", zero);

	return 0;
}
