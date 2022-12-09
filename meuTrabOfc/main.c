void puts ( const char * str );
char * gets ( char * str );
int atoi (const char * str);
char *  itoa ( int value, char * str, int base );
unsigned int get_time(void);
void sleep(int ms);
int approx_sqrt(int x, int iterations);
void filter_1d_image(char * img, char * filter);

char buffer[100];
char img[256]; // variável preenchida estaticamente pelo assistente
char res[256]; // variável preenchida estaticamente pelo assistente
int number; // variável preenchida estaticamente pelo assistente

void run_operation(int op){
  int t0, t1, i; 
  char filter[3];
  switch (op){
  case 0:
    puts(buffer);
    break;

  case 1:
    gets(buffer);
    puts(buffer);
    break;

  case 2:
    puts(itoa(number, buffer, 10));
    break;

  case 3:
    puts(itoa(atoi(gets(buffer)), buffer, 16));
    break;

  case 4:
    t0 = get_time();
    sleep(number);
    t1 = get_time();
    puts(itoa(t1-t0, buffer, 10));
    break;

  case 6:
    puts(itoa(approx_sqrt(number, 40), buffer, 10));
    break;

  case 9:
    for (i = 0; i < 3; i++){
      filter[i] = atoi(gets(buffer));
    }
    filter_1d_image(img, filter);
    t0 = 0;
    for (i = 0; i < 256; i++){
      if (img[i] == res[i]) {
        t0++;
      }
    }
    puts(itoa(t0, buffer, 10));
    break;
  
  default:
    break;
  }
}

int main(){
  int operation = atoi(gets(buffer));
  run_operation(operation);
  while(1);
  return 0;
}