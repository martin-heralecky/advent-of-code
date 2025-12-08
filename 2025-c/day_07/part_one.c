#include <stdio.h>
#include <string.h>

int main() {
	FILE *f = fopen("input.txt", "r");

	char prev[141] = {0};
	char curr[141];

	int count = 0;

	while (fread(curr, 1, sizeof(curr), f)) {
		for (int i = 0; i < sizeof(prev); ++i) {
			if (prev[i] == '|' || prev[i] == 'S') {
				if (curr[i] == '.') {
					curr[i] = '|';
				} else if (curr[i] == '^') {
					curr[i - 1] = '|';
					curr[i + 1] = '|';
					++count;
				}
			}
		}

		memcpy(prev, curr, sizeof(prev));

		fseek(f, 1, SEEK_CUR);
	}

	printf("%d\n", count);

	return 0;
}
