#include <stdio.h>
#include <string.h>

int main() {
	FILE *f = fopen("input.txt", "r");

	char line[141];
	long long state[141] = {0};

	while (fread(line, 1, sizeof(line), f)) {
		for (int i = 0; i < sizeof(line); ++i) {
			if (line[i] == 'S') {
				++state[i];
			} else if (line[i] == '^') {
				state[i - 1] += state[i];
				state[i + 1] += state[i];
				state[i] = 0;
			}
		}

		fseek(f, 1, SEEK_CUR);
	}

	long long count = 0;
	for (int i = 0; i < sizeof(state) / sizeof(state[0]); ++i) {
		count += state[i];
	}

	printf("%lld\n", count);

	return 0;
}
