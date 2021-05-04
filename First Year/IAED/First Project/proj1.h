/* 
**    File: proj1.h
**    Creator: Jeronimo Mendes 99086 LEIC-T
**    Description: header file for proj.c
*/

/* Constants declarations */
#define NUMTASKS 10000      /* Limit of tasks */
#define DESCMAX 50 + 1      /* Description string max length */
#define USERNAMEMAX 20 + 1  /* Username string max length */
#define MAXUSERS 50         /* Limit of users */
#define MAXACTIVITIES 10    /* Limit of activities */
#define ACTIVITYDESC 20 + 1 /* Activity description string max length */
#define TOUT "task %i\n"    /* output for t command */
#define True 1
#define False 0
#define TODO "TO DO"
#define INPROGRESS "IN PROGRESS"
#define DONE "DONE"
#define TODONE "duration=%i slack=%i\n"

/* Defines for error handling */
#define RETERROR -1                             /* Function return error */
#define RETOK 0                                 /* Function return ok */
#define DUPDESC "duplicate description\n"
#define TASKOVERFLOW "too many tasks\n"
#define INVALIDTIME "invalid time\n"
#define DUPUSER "user already exists\n"
#define USEROVERFLOW "too many users\n"
#define INVACTIVITYDESC "invalid description\n"
#define DUPACT "duplicate activity\n"
#define ACTOVERFLOW "too many activities\n"
#define INVALIDDURATION "invalid duration\n"
#define INVALIDTASK "%i: no such task\n"
#define NOUSER "no such user\n"
#define NOACTIVITY "no such activity\n"
#define TASKSTARTED "task already started\n"
#define NOTASK  "no such task\n"

/* Auxiliars for the sorting functions */
#define exch(A, B) {int t = A; A = B; B = t;}
#define exchTask(A, B) {Task t = A; A = B; B = t;}
#define compexch(A, B) if (less(B, A)) exch(A, B)

/* Structures */

/* Represents an activity. Even though it only has one member,
** it allows for future expansion of the project, like adding
** a second description, with more detailed information...  
*/
typedef struct{
    char description[ACTIVITYDESC];
} Activity;

/* Represents an user. Same as description, the struct allows future expansion
** like user ID, etc... 
*/
typedef struct{
    char name[USERNAMEMAX];
} User;

/* Represents a task */
typedef struct{
    int id; 
    int duration;
    int date_created;
    char description[DESCMAX];
    User user;
    Activity activity;
} Task;


/* Function prototypes */

int t();
int l();
int n();
int u();
int m();
int d();
int a();

/* Functions that handle user input */
    
void read_str(char str[], int length, int word);
int next_instruction();
int read_int();
void ignore_rest();
int check_limit(int counter, int max, char error_message[]);
int check_lowercase(char string[]);

/* Auxiliar functions */

void createTask(char description[], int duration);
void printTask(Task task);
void copyTaskArray(Task new[], Task original[]);
int checkUser(char username[]);
int checkActivity(char description[]);
int checkTask(char description[]);
void printError(char errorMsg[]);
void calculateSlackUsed(Task task);
int ValidArgumentsM(char (*username)[USERNAMEMAX], char (*activity)[ACTIVITYDESC], int *id);

/* Sorting functions */

void quickSort(int array[], int left, int right);
void quickSortTasks(Task array[], int left, int right, int alpha);
int partition(int array[], int left, int right);
int partitionAlpha(Task array[], int left, int right);
int partitionTime(Task array[], int left, int right);

/* Variables declarations */

/* Array to store tasks */
Task tasks[NUMTASKS];
/* Array with activities, initialized with TO DO, IN PROGRESS and DONE */
Activity activities[MAXACTIVITIES] = {{TODO}, {INPROGRESS}, {DONE}};
/* Array to store users */
User users[MAXUSERS];

/* Keeps the count of the number of tasks created */
int task_counter = 0;
/* Keeps the count of the number of users created */
int user_counter = 0;
/* Keeps the count of the number of activities created */
int activities_counter = 3;
/* time value */
int time = 0;
