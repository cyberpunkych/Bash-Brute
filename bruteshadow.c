#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <crypt.h>

int main(int argc, char* argv[])
{
  FILE *fd1, *fd2;
  char *str1, *str2;
  char *salt, *hash, *key, *key1;
  char buf[13], word[100], pass[100];
  
  if (argc != 2) {
   fprintf(stderr, "Usage: %s <file shadow>\n", argv[0]);
   exit(-1);
  }

  str1 = (char*)malloc(100);
  str2 = (char*)malloc(100);

  // ��������� ���� � �������������� ��������
  fd1 = fopen(argv[1], "r");
  
  fprintf(stderr, "Please, wait...\n");
  
  // ������ � ����� ������ ������� �����    
  while(fgets(str1, 100, fd1) != NULL)
  {
    str2 = strstr(str1, "$1$"); // ���� � ������ ������� $1$

    if (str2 != NULL) // � ���� �������, �� 
    {
      // �������� ������������� ������
      key = strtok(str2, ":"); 
      snprintf(pass, sizeof(pass), "%s", key);    
      printf ("pass=%s (%d)\n", pass, strlen(pass));
    
      // �������� salt � ������������� ������
      strtok(key, "$");    
      salt = strtok(NULL, "$");
      hash = strtok(NULL, "\0"); // ��� �������� ����� �� ������

      // ��������� salt � ���� $1$salt$    
      snprintf(buf, sizeof(buf), "$1$%s$", salt);        
    
      // ��������� ���� �������
      fd2 = fopen("/usr/share/dict/words", "r"); 

      // ������ � ����� ������ ����� �� �������
      while(fgets(word, 100, fd2) != NULL)
      {
        // ������� ������ ����� ������
    	(&word[strlen(word)])[-1] = '\0';
	
	// ��������� ����� ������������� ������
        key1 = crypt(word, buf);

	// ���������� ������������� ������
        if (!strncmp(key1, pass, strlen(key1))) {
          printf("OK! Password: %s\n\n", word);
	  break;
        }
      }
    }
  }

  fclose(fd1);
  fclose(fd2);
  free(str1);
  free(str2);

  return 0;
}
