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
			int invalid = 0;
			for (int cur_len = 1; cur_len <= len / 2; ++cur_len) {
				if (len % cur_len != 0) {
					continue;
				}

				int q = 1;
				for (int i = 0; i < len / cur_len; ++i) {
					if (strncmp(buf, buf + i * cur_len, cur_len) != 0) {
						q = 0;
						break;
					}
					
				}

				if (q) {
					invalid = 1;
					break;
				}
			}

			if (invalid) {
				res += a;
			}
		}

		fseek(f, 1, SEEK_CUR);
	}

	printf("%lld\n", res);

	return 0;
}
