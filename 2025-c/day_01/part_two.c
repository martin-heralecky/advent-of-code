#include <stdio.h>
#include <stdlib.h>

int main() {
	FILE *f = fopen("input.txt", "r");

	int zero = 0;
	int cur = 2000000050;
	char d;
	int r;
	while (fscanf(f, "%c%d\n", &d, &r) == 2) {
		int old = cur;
		if (d == 'R') {
			cur += r;
		} else if (d == 'L') {
			cur -= r;
		}
		zero += abs(old / 100 - cur / 100);
		if (cur % 100 == 0 && d == 'L') {
			++zero;
		}
		if (old % 100 == 0 && d == 'L' && r > 0) {
			--zero;
		}
	}

	printf("%d\n", zero);

	return 0;
}
