#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
// Collaborators: Kanladaporn Sirithatthamrong 6480952

// function to find max value in 1d array
int max(int arr[]){
    int max_val = 0;
    for (int k = 0; k < 26; k++){
        if (arr[k] > max_val){
            max_val = arr[k];
        }
    }
    return max_val;
}


int main()
{
    int chr;
    int tally[26] = {0};

    while (( chr = getchar()) != EOF) {
        chr = tolower(chr);
        int index = chr - 97;
            if (0 <= index && index < 26){
                tally[index]++;
            }
    }

    // create 2d array and populate with " " or "*"
    int max_val = max(tally);
    char hist_2d[max_val+1][26];
    for (int i = 0; i <= max_val; i++){
        if (i != max_val){
            for (int j = 0; j < 26; j++){
                int temp = max_val - 1 - i;
                if ((temp - tally[j]) >= 0){
                    hist_2d[i][j] = ' ';
                }
                else{
                    hist_2d[i][j] = '*';
                }
            }
        }
        else{
            char current = 'a';
            for (int j = 0; j< 26 ; j++){
                hist_2d[i][j] = current;
                current++;
            }
        }
    }

    // print content of 2d array
    for (int i = 0; i <= max_val; i++){
        for (int j = 0; j < 26; j++){
            printf("%c",hist_2d[i][j]);
        }
        printf("\n");
    }
    return 0;
}
