/*
    Main source of all changes made to the program
  Template as follows:
    /*
      Name - ,
      File source(s) - ,
      Date - ,
      Line index(es) modified - ,
      //-------------------------------------------------------------------//
      Short desc. of code details or changes - 
      //(comment) - line index(es)
    */
    
    Please add this template to your namespace for each added code along with 
   the desc. where the code is located in the file.
    Also please add any contact info you are willing to share, and check it
   as often as possible in order to ensure quick completion of the assignment
   
*/

/*
    Table of contents - to do list                  //Coders Involved
    1. date()                                       //Alex Correia
        a. implement new system call - date()       //Eric Diaz
        b. implement date command                   //Eric Diaz
    2. CTRL + P control sequence                    //Roman
    3. UID, GID, PPID                               //Hugo
    4. ps command                                   //Patrick
    5. file system protection                       //Narek
*/
/*
    Problem Section - Add any problems you want to ask other members
                      for help on here
    /*
        Table of Contents Number -
        File source(s) 
        Line index(es) -
        //-------------------------------------------------------------------//
        Short desc of problem/ what needs to be done -
    */
*/

//Alex Correia
/*
  Contact info:
  email: 006009584@coyote.csusb.edu
  Add changes here:
  File Source's: syscall.h, usys.S.
  Date: 2-27-20
  Line index(es) modified syscall.h - line 26, usys.S - line 35.
  Added #define SYS_date in syscall.h, specifiing the date command as a system call and call number 25.
  Added SYSCALL(date) in usys.S to define the system call of the date command.
  Date:3-2-20
  File Source: Makefile
  Added Makefile with _date/ added in on line 182, and the file date.c on 252.
  Date:3-2-20
  File Sources: proc.c proc.h
  Modified two files for #2, printing out PID- -STATE- -ELAPSE- -NAME- -SIZE- -PCs headers,PIDS, elapsed time,name,size, and process addreses. 
  proc.c
  line: 604-614
  proc.h
  line: 53
  
  
*/

//Patrick Swick
/*
  Contact info:
  email: 003875273@coyote.csusb.edu
  Add changes here:
*/

//Hugo Romero

  Contact info:Smoke signals
  email:006420449@coyote.csusb.edu
  Add changes here:
    
   Added group id as (gid)and user id as (uid), both unsigned ints in "proc.h" right under (int pid) above (proc *parent).
   lines: 44-45
    
   ![proc.h](https://github.com/CorreianAngel/homework_2/blob/master/images/proc.h_changes.png)
    
   Added unsigned ints ["getuid", "getgid", "getppid"] and ints ["setuid", "setgid"] ins "users.h" lines: 23-27.
   
   ![users.h](https://github.com/CorreianAngel/homework_2/blob/master/images/users.h_changes.png)
   
   Added system calls: SYS_getuid, SYS_getgid, SYS_getppid to "syscall.h" lines: 26-28
   
   
   
   ![syscall.h](https://github.com/CorreianAngel/homework_2/blob/master/images/syscall_h.png)


   Added syscalls to defs.h lines:126-130
   
   
   ![defs.h](https://github.com/CorreianAngel/homework_2/blob/master/images/defs_h.png)
   
   
   Added (uid) and (gid) to "fork()" in "proc.c" lines:203-204
   
   
   ![fork_proc.c](https://github.com/CorreianAngel/homework_2/blob/master/images/fork_proc_c.png)


   Added lines 39-60 in "sysproc.c"
    
    
    
   ![sysproc](https://github.com/CorreianAngel/homework_2/blob/master/images/sysproc_c.png)


   Added lines 28-31 in "usys.S"
   
   
   ![usys_S](https://github.com/CorreianAngel/homework_2/blob/master/images/usys_S.png)
   
   
   
   
   
   
   Added lines 92-95 and 124-127 in "syscall.c"
   
   
   
   ![syscall_c](https://github.com/CorreianAngel/homework_2/blob/master/images/syscall_c.png)
   
   
   ![syscall2](https://github.com/CorreianAngel/homework_2/blob/master/images/syscall2.png)
   
   
   
   Created "test_ids.c"
   
   
   ![test_ids](https://github.com/CorreianAngel/homework_2/blob/master/images/test_ids.png)
   
   
   ***
   stopped 3/9/20 1:46
   ***
   ![error](https://github.com/CorreianAngel/homework_2/blob/master/images/Screenshot%20from%202020-03-09%2013-45-29.png)
//Roman Rodriguez
/*
  Contact info:
  email: 005583431@coyote.csusb.edu
  Add changes here:
*/

//Narek Hovhannesyan
/*
  Contact info: 818 631 7613
  email: 005560850@coyote.csusb.edu
  Add changes here:
*/

//Eric Diaz
/*
  Contact info: 909 645 6949
  email: 005333857@coyote.csusb.edu
  Add changes here:
*/
