#include <stdio.h>
#include <stdlib.h>

#define N 496

struct pair_size {
	short a;
	short b;
	long long size;
};

int tiles[N][2];
struct pair_size pairs[N * (N - 1) / 2];

int cmp_pair(const void *a, const void *b) {
	const struct pair_size *as = (const struct pair_size *)a;
	const struct pair_size *bs = (const struct pair_size *)b;
	return as->size < bs->size ? -1 : as->size > bs->size ? 1 : 0;
}

int main() {
	FILE *f = fopen("input.txt", "r");

	int i = 0, x, y;
	while (fscanf(f, "%d,%d", &x, &y) == 2) {
		tiles[i][0] = x;
		tiles[i][1] = y;
		++i;
	}

	for (int a = 0, i = 0; a < N - 1; ++a) {
		for (int b = a + 1; b < N; ++b) {
			long long size = llabs((long long)(tiles[a][0] - tiles[b][0] + 1) * (tiles[a][1] - tiles[b][1] + 1));
			pairs[i++] = (struct pair_size){a, b, size};
		}
	}

	qsort(pairs, sizeof(pairs) / sizeof(pairs[0]), sizeof(pairs[0]), cmp_pair);

	printf("%lld\n", pairs[N * (N - 1) / 2 - 1].size);

	return 0;
}
