#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define N 1000

struct pair_dist {
	int (*a)[4];
	int (*b)[4];
	float dist;
};

int boxes[N][4]; // x, y, z, group
struct pair_dist pairs[N * (N - 1) / 2];

int cmp_pair(const void *a, const void *b) {
	const struct pair_dist *as = (const struct pair_dist *)a;
	const struct pair_dist *bs = (const struct pair_dist *)b;
	return as->dist < bs->dist ? -1 : as->dist > bs->dist ? 1 : 0;
}

int main() {
	FILE *f = fopen("input.txt", "r");

	int i = 0, x, y, z;
	while (fscanf(f, "%d,%d,%d", &x, &y, &z) == 3) {
		boxes[i][0] = x;
		boxes[i][1] = y;
		boxes[i][2] = z;
		boxes[i][3] = i;
		++i;
	}

	for (int a = 0, i = 0; a < N - 1; ++a) {
		for (int b = a + 1; b < N; ++b) {
			float dist = sqrt(
				pow(boxes[a][0] - boxes[b][0], 2)
				+ pow(boxes[a][1] - boxes[b][1], 2)
				+ pow(boxes[a][2] - boxes[b][2], 2)
			);
			pairs[i++] = (struct pair_dist){&boxes[a], &boxes[b], dist};
		}
	}

	qsort(pairs, sizeof(pairs) / sizeof(pairs[0]), sizeof(pairs[0]), cmp_pair);

	for (int i = 0; i < sizeof(pairs) / sizeof(pairs[0]); ++i) {
		int old_group = (*pairs[i].b)[3];
		int new_group = (*pairs[i].a)[3];

		for (int i = 0; i < sizeof(boxes) / sizeof(boxes[0]); ++i) {
			if (boxes[i][3] == old_group) {
				boxes[i][3] = new_group;
			}
		}

		int all_same_group = 1;
		for (int i = 0; i < sizeof(boxes) / sizeof(boxes[0]); ++i) {
			if (boxes[i][3] != new_group) {
				all_same_group = 0;
				break;
			}
		}

		if (all_same_group) {
			printf("%lld\n", (long long)(*pairs[i].a)[0] * (*pairs[i].b)[0]);
			break;
		}
	}

	return 0;
}
