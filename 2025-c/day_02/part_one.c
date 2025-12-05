#include <math.h>
#include <stdio.h>
#include <string.h>

int main() {
	FILE *f = fopen("input.txt", "r");

	long long res = 0;

	long long a, b;
	while (fscanf(f, "%lld-%lld", &a, &b) == 2) {
		for (; a <= b; ++a) {
			char buf[32];
			sprintf(buf, "%lld", a);
			int len = strlen(buf);
			if (len % 2 != 0) {
				continue;
			}
			if (strncmp(buf, buf + len / 2, len / 2) == 0) {
				res += a;
			}
		}

		fseek(f, 1, SEEK_CUR);
	}

	printf("%lld\n", res);

	return 0;
}
