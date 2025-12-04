#include <stdio.h>

const int size = 140;
char grid[19740];

int is_roll(int x, int y) {
	return x >= 0 && x < size && y >= 0 && y < size && grid[y * size + y + x] == '@';
}

int main() {
	FILE *f = fopen("input.txt", "r");
	fread(grid, sizeof(grid), 1, f);

	int rem_rolls = 0;
	int prev_rem_rolls = -1;
	while (rem_rolls > prev_rem_rolls) {
		prev_rem_rolls = rem_rolls;

		for (int i = 0; i < size * size + size; ++i) {
			if (grid[i] != '@') {
				continue;
			}
	
			int x = i % (size + 1);
			int y = i / (size + 1);
	
			int adj = 0;
			adj += is_roll(x - 1, y - 1);
			adj += is_roll(x - 1, y);
			adj += is_roll(x - 1, y + 1);
			adj += is_roll(x, y - 1);
			adj += is_roll(x, y + 1);
			adj += is_roll(x + 1, y - 1);
			adj += is_roll(x + 1, y);
			adj += is_roll(x + 1, y + 1);
	
			if (adj < 4) {
				grid[i] = '.';
				++rem_rolls;
			}
		}
	}

	printf("%d\n", rem_rolls);

	return 0;
}
