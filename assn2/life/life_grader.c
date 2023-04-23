#include "life_engine.h"

// struct to store the answers we will parse from the text file
typedef struct{
  int data[10][3];
  int size;
}Answers;

// parses the answers text file that gets passed in by life_grader.sh 
void read_ans(char *filename, Answers **arr){
  FILE *fp = fopen(filename, "r");
  if (NULL==fp) {
    fprintf(stderr, "Cannot open file %s\n, killing self.", filename);
    exit(-1);
  }
  int ans_num=0;
  char line[128];

  while(fgets(line, sizeof(line), fp)){
    if (line[0]=='^'){
      ans_num++;
    }
    else{
      int v1,v2,v3;
      sscanf(line, "%d, %d,%d", &v1, &v2, &v3);
      // format: arr[]->data[][]
      arr[ans_num]->data[arr[ans_num]->size][0]=v1;
      arr[ans_num]->data[arr[ans_num]->size][1]=v2;
      arr[ans_num]->data[arr[ans_num]->size][2]=v3;
      arr[ans_num]->size++;
    }
  }
  fclose(fp);
}

int check_get_index(life_board board, Answers *ans){
  int score=0;

  for (int i=0; i < ans->size; i++){
  int st_ret = get_index(board, ans->data[i][0], ans->data[i][1]);
    if (st_ret == ans->data[i][2]){
      score++;
    }
    else{
      printf("Case %d wrong\n", i+1);
      printf("Row: %d, Col: %d, Ans: %d, St: %d\n", ans->data[i][0], ans->data[i][1], ans->data[i][2], st_ret);
    }
  }
  return score;
}

int check_is_in_range(life_board board, Answers *ans){
  int score = 0;
  for (int i=0; i<ans->size; i++){
    // is_in_range isnt included in the .h file (added it myself TT)
    int st_ret = is_in_range(board, ans->data[i][0], ans->data[i][1]);
    if (st_ret == ans->data[i][2]){
      score++;
    }
    else{
      printf("Case %d wrong\n", i+1);
      printf("Row: %d, Col: %d, Ans: %d, St: %d\n", ans->data[i][0], ans->data[i][1], ans->data[i][2], st_ret);
    }
  }
  return score;
}

int check_is_alive(life_board board, Answers *ans){
  int score = 0;
  for (int i=0; i<ans->size; i++){
    // is_alive needs to be added to .h file
    int st_ret = is_alive(board, ans->data[i][0], ans->data[i][1]);
    if (st_ret == ans->data[i][2]){
      score++;
    }
    else{
      printf("Case %d wrong\n", i+1);
      printf("Row: %d, Col: %d, Ans: %d, St: %d\n", ans->data[i][0], ans->data[i][1], ans->data[i][2], st_ret);
    }
  }
  return score;
}

int check_count_live_nbrs(life_board board, Answers *ans){
  int score = 0;
  for (int i=0; i<ans->size; i++){
    // count_live_nbrs needs to be added to .h file
    int st_ret = count_live_nbrs(board, ans->data[i][0], ans->data[i][1]);
    if (st_ret == ans->data[i][2]){
      score++;
    }
    else{
      printf("Case %d wrong\n", i+1);
      printf("Row: %d, Col: %d, Ans: %d, St: %d\n", ans->data[i][0], ans->data[i][1], ans->data[i][2], st_ret);
    }
  }
  return score;

}

int check_make_next_board(life_board board, life_board ans){

  for (int row=0;row<board.num_rows;++row) {
    for (int col=0;col<board.num_cols;++col) {
      if (board.cells[row*board.num_cols+col] != ans.cells[row*ans.num_cols+col])
        return 0;
    }
  }
  printf("Final board: passed!\n");
  return 10;
}


int main(int argc, char *argv[]){
  int score = 0;

    life_board b0, b1, ans_board;
    life_board *rb[2] = { &b0, &b1 };

    // array that will store the struct of answers to each question
    Answers a0, a1, a2, a3;
    Answers *ans_arr[4]={ &a0, &a1, &a2, &a3 };

    if (argc==4){
      // first arg is one_life.txt, 2nd is ans_board.txt
      read_board_from_file(argv[1], &b0);
      read_board_from_file(argv[2], &ans_board);

      // setup answer arrays
      for (int i = 0; i < 4; i++) {
        ans_arr[i]->size = 0;
      }
      read_ans(argv[3], ans_arr);

      // set size b1 = b0, malloc space for b1
      b1.num_cols = b0.num_cols;
      b1.num_rows = b0.num_rows;
      b1.cells = (unsigned char*) malloc(b0.num_cols*b0.num_rows*sizeof(unsigned char));
      int count = 10;
      int this=0;

      score += check_get_index(b0, ans_arr[0]);
      score += check_is_in_range(b0, ans_arr[1]);
      score += check_is_alive(b0, ans_arr[2]);
      score += check_count_live_nbrs(b0, ans_arr[3]);

      // check make next board
      //calculate final board using st. code
      for (int round=0;round<count;++round,this=!this){
        make_next_board(*rb[this], *rb[!this]);
      }
      score += check_make_next_board(b1, ans_board);
    }

    else{
      printf("Files missing");
    }
    
  printf("Score: %d\n", score);
  return 0;
}
