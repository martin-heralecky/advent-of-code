#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define N 1000

struct pair_dist {
	short a;
	short b;
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
			pairs[i++] = (struct pair_dist){a, b, dist};
		}
	}

	qsort(pairs, sizeof(pairs) / sizeof(pairs[0]), sizeof(pairs[0]), cmp_pair);

	for (int i = 0; i < 1000; ++i) {
		int old_group = boxes[pairs[i].b][3];
		int new_group = boxes[pairs[i].a][3];

		for (int i = 0; i < sizeof(boxes) / sizeof(boxes[0]); ++i) {
			if (boxes[i][3] == old_group) {
				boxes[i][3] = new_group;
			}
		}
	}

	int group_sizes[N] = {0};
	for (int i = 0; i < sizeof(boxes) / sizeof(boxes[0]); ++i) {
		++group_sizes[boxes[i][3]];
	}

	int g1 = 0, g2 = 0, g3 = 0;
	for (int i = 0; i < sizeof(group_sizes) / sizeof(group_sizes[0]); ++i) {
		if (group_sizes[i] > g3) {
			g3 = group_sizes[i];
		}
		if (g3 > g2) {
			int tmp = g2;
			g2 = g3;
			g3 = tmp;
		}
		if (g2 > g1) {
			int tmp = g1;
			g1 = g2;
			g2 = tmp;
		}
	}

	printf("%d\n", g1 * g2 * g3);

	return 0;
}
