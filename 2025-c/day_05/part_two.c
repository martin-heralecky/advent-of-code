#include <stdio.h>

int main() {
	FILE *f = fopen("input.txt", "r");

	long long fresh[182][3];

	int i = 0;
	long long a, b;
	while (fscanf(f, "%lld-%lld\n", &a, &b) == 2) {
		fresh[i][2] = 1;

		for (int j = 0; j < i; ++j) {
			if (!fresh[j][2]) {
				continue;
			}

			if (b < fresh[j][0] || a > fresh[j][1]) {
				// fully outside
			} else if (a >= fresh[j][0] && b <= fresh[j][1]) {
				// fully inside
				fresh[i][2] = 0;
				break;
			} else if (a <= fresh[j][0] && b >= fresh[j][1]) {
				// fully overlaps
				fresh[j][2] = 0;
			} else if (a < fresh[j][0]) {
				b = fresh[j][0] - 1;
			} else if (b > fresh[j][1]) {
				a = fresh[j][1] + 1;
			} else {
				return 1;
			}
		}

		fresh[i][0] = a;
		fresh[i][1] = b;

		++i;
	}

	long long count = 0;
	for (int i = 0; i < sizeof(fresh) / sizeof(fresh[0]); ++i) {
		if (fresh[i][2]) {
			count += fresh[i][1] - fresh[i][0] + 1;
		}
	}

	printf("%lld\n", count);

	return 0;
}
