#include <math.h>
#include <stdio.h>

int main() {
	FILE *f = fopen("input.txt", "r");

	char line[100];

	long long joltage = 0;

	while (fread(line, 1, sizeof(line), f)) {
		int max[12];

		for (int n = 0; n < 12; ++n) {
			max[n] = n > 0 ? max[n - 1] + 1 : 0;
			for (int i = n > 0 ? max[n - 1] + 1 : 0; i < sizeof(line) - 11 + n; ++i) {
				if (line[i] > line[max[n]]) {
					max[n] = i;
				}
			}

			joltage += (line[max[n]] - '0') * pow(10, 11 - n);
		}

		fseek(f, 1, SEEK_CUR);
	}

	printf("%lld\n", joltage);

	return 0;
}
