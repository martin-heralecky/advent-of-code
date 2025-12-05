#include <stdio.h>

int main() {
	FILE *f = fopen("input.txt", "r");

	char line[100];

	int joltage = 0;

	while (fread(line, 1, sizeof(line), f)) {
		int first_i = 0;
		for (int i = 0; i < sizeof(line) - 1; ++i) {
			if (line[i] > line[first_i]) {
				first_i = i;
			}
		}

		int second_i = first_i + 1;
		for (int i = first_i + 1; i < sizeof(line); ++i) {
			if (line[i] > line[second_i]) {
				second_i = i;
			}
		}

		joltage += (line[first_i] - '0') * 10 + line[second_i] - '0';

		fseek(f, 1, SEEK_CUR);
	}

	printf("%d\n", joltage);

	return 0;
}
