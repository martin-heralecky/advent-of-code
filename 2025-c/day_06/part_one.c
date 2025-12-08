#include <stdio.h>

int main() {
	FILE *f = fopen("input.txt", "r");

	long long add[1000] = {0};
	long long mul[1000];

	for (int i = 0; i < sizeof(mul) / sizeof(mul[0]); ++i) {
		mul[i] = 1;
	}

	for (int l = 0; l < 4; ++l) {
		for (int i = 0; i < sizeof(add) / sizeof(add[0]); ++i) {
			long long n;
			fscanf(f, "%lld", &n);
			add[i] += n;
			mul[i] *= n;
		}
	}

	long long total = 0;

	for (int i = 0; i < sizeof(add) / sizeof(add[0]); ++i) {
		char op;
		fscanf(f, " %c", &op);

		if (op == '+') {
			total += add[i];
		} else if (op == '*') {
			total += mul[i];
		}
	}

	printf("%lld\n", total);

	return 0;
}
