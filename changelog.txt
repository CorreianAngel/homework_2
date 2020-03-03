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
  
  
*/

//Patrick Swick
/*
  Contact info:
  email: 003875273@coyote.csusb.edu
  Add changes here:
*/

//Hugo Romero
/*
  Contact info:Smoke signals
  email:006420449@coyote.csusb.edu
  Add changes here:
    
    Added group id as (gid)and user id as (uid), both unsigned ints in "proc.h" right under (int pid) above (proc *parent).
    ![proc.h](https://github.com/CorreianAngel/homework_2/blob/master/images/proc.h_changes.png)
    
    Added unsigned ints ["getuid", "getgid", "getppid"] and ints ["setuid", "setgid"] ins "users.h" lines: 23-27.
    ![users.h](https://github.com/CorreianAngel/homework_2/blob/master/images/users.h_changes.png)
*/

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
