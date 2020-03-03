//touch.c
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char buf[512];

int
main(int argc, char *argv[])
{
  int fdd;

  if(argc < 1)
  {
      printf(1, "touch file1, file2, file3");
      exit();
  }
  for(int i = 0; i < argc; i++)
  {
   fdd = open(argv[i], O_CREATE);
   close(fdd);
  }

  exit();
}