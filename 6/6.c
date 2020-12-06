#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

bool answers1[26];
bool answers2[26];

int countAndReset(bool *answers, bool startingValue)
{
  int count = 0;
  for (int i = 0; i < 26; i++)
  {
    if (answers[i] == true)
    {
      count++;
    }
    answers[i] = startingValue;
  }
  return count;
}

void processAnswers(char *answerString)
{
  for (int i = 0; i < strlen(answerString); i++)
  {
    char letter = answerString[i];
    if (letter >= 97 && letter <= 122)
    {
      answers1[letter - 97] = true;
    }
  }
  for (int i = 0; i < 26; i++)
  {
    bool present = false;
    for (int j = 0; j < strlen(answerString); j++)
    {
      char letter = answerString[j];
      if (i + 97 == letter)
      {
        present = true;
      }
    }
    if (answers2[i] && !present)
    {
      answers2[i] = false;
    }
  }
}

int main()
{
  FILE *file = fopen("input.txt", "r");
  char buffer[500];
  bool recordComplete = false;
  countAndReset(answers1, false);
  countAndReset(answers2, true);
  int total1 = 0;
  int total2 = 0;
  while (!feof(file))
  {
    recordComplete = false;
    while (!recordComplete)
    {
      fgets(buffer, 500, file);
      if (feof(file) || buffer[0] == '\n')
      {
        recordComplete = true;
        break;
      }
      processAnswers(buffer);
    }
    total1 += countAndReset(answers1, false);
    total2 += countAndReset(answers2, true);
  }
  printf("Part 1: %d\n", total1);
  printf("Part 2: %d\n", total2);
  fclose(file);
}
