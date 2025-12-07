#include <stdio.h>

int main() {
	FILE *f = fopen("input.txt", "r");

	long long fresh[182][2];

	int i = 0;
	int pos = 0;
	while (fscanf(f, "%lld-%lld\n", &fresh[i][0], &fresh[i][1]) == 2) {
		++i;
		pos = ftell(f);
	}
	fseek(f, pos, SEEK_SET);

	int count = 0;

	long long id;
	while (fscanf(f, "%lld\n", &id) == 1) {
		int old_count = count;
		for (int i = 0; i < sizeof(fresh) / sizeof(fresh[0]); ++i) {
			if (id >= fresh[i][0] && id <= fresh[i][1]) {
				++count;
				break;
			}
		}
	}

	printf("%d\n", count);

	return 0;
}
