/* 
    File: proj1.h
    Creator: Jeronimo Mendes 99086 LEIC-T
    Description: header file for proj.c
*/


/* Constants declarations */
#define NUMTASKS 10000 /* Limit of tasks */
#define DESCMAX 50 /* Description string max length */
#define USERNAMEMAX 20 /* Username string max length */
#define MAXUSERS 50 /* Limit of users */
#define MAXACTIVITIES 10 /* Limit of activities */
#define ACTIVITYDESC 20 /* Activity description string max length */
#define MENU "Kanban Board:\nq: terminate program\nt: add task <duration> <description>\n\n"
#define TOUT "task %i\n" /* output for t command */
#define True 1
#define False 0
#define TODO "TO DO"
#define INPROGRESS "IN PROGRESS"
#define DONE "DONE"
#define TODONE "duration=%i slack=%i\n"

/* Defines for error handling */
#define RETERROR -1 /* Function return error */
#define RETOK 0 /* Function return ok */
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
#define NOTASK  "no suck task\n"



/* Structures */
typedef struct{
    char description[ACTIVITYDESC];
} Activity;

typedef struct{
    char name[USERNAMEMAX];
} User;

typedef struct{
    int id; 
    int duration;
    int date_created;
    char description[DESCMAX];
    User user;
    Activity activity;
} Task;




/* Function prototypes */
void q();
int t();
int l();
int n();
int u();
int m();
int d();
int a();

void read_str(char str[], int length, int word);
int next_instruction();
int read_int();
int check_limit(int counter, int max, char error_message[]);
int check_lowercase(char string[]);
void ignore_rest();
void copyTaskArray(Task new[], Task original[]);
void orderTasksAlpha(Task array[], int length);
void insertionSort(int array[], int n);
void orderTasksTimeStart(Task array[], int length);

/* Variables declarations */
Task tasks[NUMTASKS];
Activity activities[MAXACTIVITIES] = {{TODO}, {INPROGRESS}, {DONE}};
User users[MAXUSERS];


int task_counter = 0;
int user_counter = 0;
int activities_counter = 3;
int time = 0;

/* !!!!! Temporary !!!!! */
void printTask(Task task);
