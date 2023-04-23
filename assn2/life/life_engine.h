#ifndef __LIFE_ENGINE_H_
#define __LIFE_ENGINE_H_

#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
#include<string.h>

#define MAX_ROWS 1000
#define MAX_COLS 1000

#if defined(_DEBUG)
#define DEBUG(args...) fprintf(stderr, args)
#else
#define DEBUG(...)
#endif

 /*
  * The structure life_board stores a game-of-life configuration.
  * As should be self-explanatory, num_rows and num_cols
  * indicate the size of the board.  The contents of the board
  * are kept inside the cells variable, which is a 1-dimensional
  * array that stores the board in row-major order
  * (see https://en.wikipedia.org/wiki/Row-_and_column-major_order)
  * Each entry of cells is an unsigned char: a cell is empty
  * if the value is 0; it is nonempty otherwise.
  *
  * CONVENTION: rows and cols are 0-indexed, i.e., the first row and the
  * the first columns are called row 0 and column 0, respectively.
  */

typedef struct {
  int num_rows, num_cols;
  unsigned char *cells;
} life_board;

void print_board(life_board board);
void read_board_from_file(char *filename, life_board *board);
int get_index(life_board board, int row, int col);
void set_alive(life_board board, int row, int col);
void set_dead(life_board board, int row, int col);
void make_next_board(life_board current, life_board next);
int is_in_range(life_board board, int row, int col);
int is_alive(life_board board, int row, int col);
int count_live_nbrs(life_board board, int row, int col);

#endif
