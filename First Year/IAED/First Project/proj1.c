/* 
**    File: proj1.c
**    Creator: Jeronimo Mendes 99086 LEIC-T
**    Description: Kanban program.
*/

#include <stdio.h>
#include "proj1.h"
#include <string.h>


int main(){
    char command;

    while ((command = getchar()) != 'q'){
        switch (command)
        {
        case 't':
            t();
            break;
        
        case 'l':
            l();
            break;

        case 'n':
            n();
            break;

        case 'u':
            u();
            break;

        case 'a':
            a();
            break;

        case 'm':
            m();
            break;

        case 'd':
            d();
            break;
        }
    } 
    return 0;
}


/* Handles t command: creates a task */
int t(){
    int duration;
    char description[DESCMAX];

    if (check_limit(task_counter, NUMTASKS, TASKOVERFLOW)){
        ignore_rest();
        return RETERROR;
    } 

    next_instruction();
    duration = read_int();
    
    next_instruction();
    read_str(description, DESCMAX, False);
    if (checkTask(description)){ 
		printError(DUPDESC);
        return RETERROR;
    }

    if (duration <= 0){
		printError(INVALIDDURATION);
		return RETERROR;
	}

    createTask(description, duration);
    printf(TOUT, tasks[task_counter++].id);
    return RETOK;
}


/* Handles u command: shows time of advances it */
int n(){
    int amount;

    next_instruction();
    amount =  read_int();

    if (amount < 0){
        printf(INVALIDTIME);
        return RETERROR;
    } 

    if (amount == 0) {
        printf("%i\n", time);
        return RETOK;
    }
    
    time += amount;

    printf("%i\n", time);

    return RETOK;
}


/* Handles u command: creates an user or lists them all */
int u(){
    char name[USERNAMEMAX];
    int i;

    if (getchar() == '\n'){
        for (i = 0; i < user_counter; i++){
            printf("%s\n", users[i].name);
        }
    } else {

        if (check_limit(user_counter, MAXUSERS, USEROVERFLOW)){
            ignore_rest();
            return RETERROR;
        }
        next_instruction();
        read_str(name, USERNAMEMAX, True);
        ignore_rest();

        if (checkUser(name)){ 
            printf(DUPUSER);
            return RETERROR;
        }
        
        strcpy(users[user_counter].name, name);
        user_counter++;
    }
    return RETOK;
}


/* Handles a command: creates an activity or lists them all */
int a(){
    char desc[ACTIVITYDESC];
    int i;

    if (getchar() == '\n'){
        for (i = 0; i < activities_counter; i++){
            printf("%s\n", activities[i].description);
        }
        return RETOK;
    }
    if (check_limit(activities_counter, MAXACTIVITIES, ACTOVERFLOW)){
        ignore_rest();
        return RETERROR;
    } 
    next_instruction();
    read_str(desc, ACTIVITYDESC, False);
    if (check_lowercase(desc)){printf(INVACTIVITYDESC); return RETERROR;}

    if (checkActivity(desc)){
		printError(DUPACT);
        return RETERROR;
    }
    
    strcpy(activities[activities_counter++].description, desc);
    return RETOK;
}


/* Handles l command: lists given tasks or all */
int l(){
    int i, j, size, tasklist[NUMTASKS], aux;
    Task orderedArray[NUMTASKS];
    copyTaskArray(orderedArray, tasks);

    if (getchar() == '\n'){
        quickSortTasks(orderedArray, 0, task_counter-1, True);
        for (i = 0; i < task_counter; i++){
            printTask(orderedArray[i]);
        }
        return RETOK;
    }
    next_instruction();
    size = 0;

    while ((aux = scanf("%i ", &tasklist[size])) > 0){
        tasklist[size++]--;
        next_instruction();
    }
 
    for (i = 0; i < size; i++){
        if ((j = tasklist[i]) < task_counter && j >= 0){
            printTask(orderedArray[j]);
        } else printf(INVALIDTASK, j + 1);
        
    }

    return RETOK;
}


/* Handles m command: moves a task to an activity */
int m(){
    int id;
    char username[USERNAMEMAX], activity[ACTIVITYDESC];

    if (!ValidArgumentsM(&username, &activity, &id)) return RETERROR;

    if (!strcmp(tasks[id].activity.description, TODO) &&\
         tasks[id].date_created == 0){
        tasks[id].date_created = time;
    }

    strcpy(tasks[id].user.name, username);
    strcpy(tasks[id].activity.description, activity);

    if (!strcmp(activity, DONE)) calculateSlackUsed(tasks[id]);

    return RETOK;
}


/* Handles d command: lists tasks of a given activity */
int d(){
    char activity[ACTIVITYDESC];
    Task listTasks[NUMTASKS];
    int i, lengthList = 0;

    next_instruction();
    read_str(activity, ACTIVITYDESC, False);
    if (!checkActivity(activity)) {
		printf(NOACTIVITY);
		return RETERROR;
	}

    for (i = 0; i < task_counter; i++){
        if (!strcmp(tasks[i].activity.description, activity)){
            listTasks[lengthList] = tasks[i];
            lengthList++;
        }
    }

    quickSortTasks(listTasks, 0, lengthList-1, True);
    quickSortTasks(listTasks, 0, lengthList-1, False);

    for (i = 0; i < lengthList; i++){
        printf("%i %i %s\n", listTasks[i].id, listTasks[i].date_created,\
                 listTasks[i].description);
    }

    return RETOK;
}


/* Ordering functions */

/* Quicksort function to sort an array of Task. If alpha = true, it will
** sort the tasks alphabetically, if false it will sort them by
** date of creation.
*/
void quickSortTasks(Task array[], int left, int right, int alpha){
    int i;

    if (right <= left) return;

    if (alpha) i = partitionAlpha(array, left, right);
    else i = partitionTime(array, left, right);
    
    quickSortTasks(array, left, i - 1, alpha);
    quickSortTasks(array, i + 1, right, alpha);
}


/* partition for sorting alphabetically */
int partitionAlpha(Task array[], int left, int right){
    char pivot[DESCMAX];
    int i = left - 1, j;

    strcpy(pivot, array[right].description);

    for (j = left; j < right; j++){
        if (strcmp(array[j].description, pivot) < 0) {
            i++;
            exchTask(array[i], array[j]);
        }
    }

    exchTask(array[i + 1], array[j]);

    return i + 1;
}


/* partition for sorting by date of creation */
int partitionTime(Task array[], int left, int right){
    int pivot = array[right].date_created;
    int i = left - 1, j;

    for (j = left; j < right; j++){
        if (array[j].date_created <= pivot) {
            i++;
            exchTask(array[i], array[j]);
        }
    }

    exchTask(array[i + 1], array[j]);

    return i + 1;
}


/* Copies an array of Task */
void copyTaskArray(Task new[], Task original[]){
    int i;

    for (i = 0; i < NUMTASKS; i++){
        new[i] = original[i];
    }
}


/* Checks if a certain stack is full.
Returns True if it is, False otherwise
*/
int check_limit(int counter, int max, char error_message[]){
    if (counter == max){
            printf("%s", error_message);
            return True;
        }

    return False;
}


/* Checks if a string has lowercase letters.
*  Returns True if it does, False otherwise
*/
int check_lowercase(char string[]){
    int i = 0;
    char letter;

    while ((letter = string[i]) != '\0'){
        if ((letter >= 'a' && letter <= 'z') && letter != ' '){
            return True;
        }
        i++;
    }

    return False;
}


/* Creates a task */
void createTask(char description[], int duration){
    Activity temp = {TODO};

    strcpy(tasks[task_counter].description, description);
    tasks[task_counter].duration = duration;
    tasks[task_counter].date_created = 0;
    tasks[task_counter].id = task_counter + 1;
    tasks[task_counter].activity = temp;
}


/* Prints a task, who would have guessed ?! */
void printTask(Task task){
    printf("%i %s #%i %s\n", 
            task.id, 
            task.activity.description,
            task.duration,
            task.description
            );
}


/* Clears the line and prints an error message. */
void printError(char errorMsg[]){
	ignore_rest();
	printf("%s", errorMsg);
}


/* Checks if user exists. Returns True if it does, false otherwise. */
int checkUser(char username[]){
    int isIn = False, i;

    for (i = 0; i < user_counter; i++){
        if (!strcmp(username, users[i].name)){
            isIn = True;
        } 
    }

    return isIn;
}


/* Checks if activity exists. Returns True if it does, false otherwise. */
int checkActivity(char description[]){
    int isIn = False, i;

    for (i = 0; i < activities_counter; i++){
        if (!strcmp(description, activities[i].description)){
            isIn = True;
        } 
    }

    return isIn;
}


/* Checks if task exists. Returns True if it does, false otherwise. */
int checkTask(char description[]){
    int isIn = False, i;

    for (i = 0; i < task_counter; i++){
        if (!strcmp(description, tasks[i].description)){
            isIn = True;
        } 
    }

    return isIn;
}


/* Calculates and prints slack and used time for an activity */
void calculateSlackUsed(Task task){
    int used, slack;

    used = time - task.date_created;
    slack = used - task.duration;

    printf(TODONE, used, slack);
}


/* 
** Validates arguments for m function, and throws respective errors.
** Returns True if they are valid, False otherwise
*/
int ValidArgumentsM(char (*username)[USERNAMEMAX],\
                    char (*activity)[ACTIVITYDESC], int *id){

    next_instruction();
    *id = read_int();
    if (*id > task_counter || (*id)-- < 1) {
		printError(NOTASK);
		return False;
	}

    next_instruction();
    read_str(*username, USERNAMEMAX, True);
    if (!checkUser(*username)) {
		printError(NOUSER);
        return False;
    } 

    next_instruction();
    read_str(*activity, ACTIVITYDESC, False);
    if (!checkActivity(*activity)) {
		printf(NOACTIVITY);
		return False;
	}

    if (strcmp(tasks[*id].activity.description, TODO) &&\
        !strcmp(*activity, TODO)){
        printf(TASKSTARTED);
        return False;
    }

    if (!strcmp(tasks[*id].activity.description, *activity)) return False;

    return True;
}


/* input functions */

/* Reads an integer */
int read_int(){  
    char input = getchar();
    int res = 0, positive = True;
    
    if (input == '-') positive = False;
    else res = input - '0';

    while ((input = getchar()) > '/' && input < ':'){
        res *= 10;
        res += input - '0';
    }

    if (input < '/' || input > ':') ungetc(input, stdin);

    if (positive) return res; 
    else return -res;
    
}


/* Reads a string. if word = true it only reads 1 word. */
void read_str(char str[], int length, int word){
    int i;
    char input;

    /* if word == True it will only read 1 word. */
    for (i = 0; i < length && (input = getchar()) != '\n' &&\
         input != EOF; i++){
        if (word && (input == ' ' || input == '\t')) break;
        str[i] = input;
    }
 
    str[i] = '\0'; 

    if (input == '\n') ungetc(input, stdin);
}


/* Skips to the next instruction. If there's no instruction, it return Error */
int next_instruction(){
    char input;

    while ((input = getchar()) == ' ' || input == '\t')

    if (input == '\n') return RETERROR;
    
    ungetc(input, stdin);
    return RETOK;
}


/* Discards the rest of the inputs on the same line */
void ignore_rest(){
    while (getchar() != '\n');
}
