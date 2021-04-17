/* 
    File: proj1.c
    Creator: Jeronimo Mendes 99086 LEIC-T
    Description: Kanban program.
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
        
        case 'l': ;
            l();
            break;

        case 'n':
            n();
            break;

        case 'u':
            u();
            break;

        case  'a':
            a();
            break;

        case 'm':
            m();
            break;

        case 'd':
            d();
            break;

        default:

            break;
        }

    }

    return 0;
}

/* t() adds a new task to the system */
/* Arguments: duration (int); description (string) */
int t(){
    int duration, i;
    char description[DESCMAX];
    Activity temp = {TODO};

    if (check_limit(task_counter, NUMTASKS, TASKOVERFLOW)) return RETERROR;

    next_instruction();
    duration = read_int();

    if (duration <= 0) {printf(INVALIDDURATION); return RETERROR;}

    next_instruction();
    read_str(description, DESCMAX, False);

    for (i = 0; i < task_counter; i++){ /* Checks for same description tasks  */
        if (!strcmp(tasks[i].description, description)){ 
            printf(DUPDESC);
            return RETERROR;
        }
    }

    strcpy(tasks[task_counter].description, description);
    tasks[task_counter].duration = duration;
    tasks[task_counter].date_created = 0;
    tasks[task_counter].id = task_counter + 1;
    tasks[task_counter].activity = temp;

    printf(TOUT, tasks[task_counter].id);

    task_counter++;
    return tasks[task_counter].id;
}


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


int u(){
    char name[USERNAMEMAX];
    int i;

    if (getchar() == '\n'){
        for (i = 0; i < user_counter; i++){
            printf("%s\n", users[i].name);
        }
    } else {

        if (check_limit(user_counter, MAXUSERS, USEROVERFLOW)) return RETERROR;

        next_instruction();
        read_str(name, USERNAMEMAX, True);
        ignore_rest();

        for (i = 0; i < user_counter; i++){ /* Checks for same name users  */
        if (!strcmp(users[i].name, name)){ 
            printf(DUPUSER);
            return RETERROR;
        }
    }

        strcpy(users[user_counter].name, name);

        user_counter++;
    }

    return RETOK;

}


int a(){
    char desc[ACTIVITYDESC];
    int i;

    if (getchar() == '\n'){
        for (i = 0; i < activities_counter; i++){
            printf("%s\n", activities[i].description);
        }
    } else {

        if (check_limit(activities_counter, MAXACTIVITIES, ACTOVERFLOW)) return RETERROR;

        next_instruction();
        read_str(desc, ACTIVITYDESC, False);

        if (check_lowercase(desc)){printf(INVACTIVITYDESC); return RETERROR;}

        for (i = 0; i < activities_counter; i++){ /* Checks for same name users  */
        if (!strcmp(activities[i].description, desc)){ 
            printf(DUPACT);
            return RETERROR;
        }
    }

        strcpy(activities[activities_counter].description, desc);

        activities_counter++;
    }
    return RETOK;
}


int l(){
    int i, size, tasklist[NUMTASKS], aux;
    Task orderedArray[NUMTASKS];
    copyTaskArray(orderedArray, tasks);

    if (getchar() == '\n'){
        orderTasksAlpha(orderedArray, task_counter);
        for (i = 0; i < task_counter; i++){
            printf("%i %s #%i %s\n", orderedArray[i].id, orderedArray[i].activity.description, orderedArray[i].duration, orderedArray[i].description);
        }

        return RETOK;
    }

    next_instruction();
    size = 0;
    while ((aux = scanf("%i", &tasklist[size])) > 0){
        tasklist[size]--;
        size++;
        next_instruction();
    }

    insertionSort(tasklist, size);

    for (i = 0; i < size; i++){
        if (tasklist[i] < task_counter){
            printf("%i %s #%i %s\n", orderedArray[tasklist[i]].id, orderedArray[tasklist[i]].activity.description, orderedArray[tasklist[i]].duration, orderedArray[tasklist[i]].description);
        } else {
            printf(INVALIDTASK, tasklist[i] + 1);
        }
    }



    return RETOK;
}


int m(){
    int id, i, used, slack, isIn = False;
    char username[USERNAMEMAX], activity[ACTIVITYDESC];

    next_instruction();
    id = read_int();
    if (id > task_counter) {printf(NOTASK); return RETERROR;};

    next_instruction();
    read_str(username, USERNAMEMAX, True);
    for (i = 0; i < user_counter; i++){
        if (!strcmp(username, users[i].name)){
            isIn = True;
        } 
    }
    if (!isIn) {printf(NOUSER); return RETERROR;}
    isIn = False;

    next_instruction();
    read_str(activity, ACTIVITYDESC, False);
    for (i = 0; i < activities_counter; i++){
        if (!strcmp(activity, activities[i].description)){
            isIn = True;
        } 
    }
    if (!isIn) {printf(NOACTIVITY); return RETERROR;}


    if (!strcmp(tasks[id - 1].activity.description, DONE) && !strcmp(activity, TODO)){
        printf(TASKSTARTED);
        return RETERROR;
    }

    if (!strcmp(tasks[id - 1].activity.description, activity)) return RETERROR;

    if (!strcmp(tasks[id - 1].activity.description, TODO) && tasks[id - 1].date_created == 0){
        tasks[id - 1].date_created = time;
    }

    strcpy(tasks[id - 1].user.name, username);
    strcpy(tasks[id - 1].activity.description, activity);

    if (!strcmp(activity, DONE)){
        used = time - tasks[id - 1].date_created;
        slack = used - tasks[id - 1].duration;
        printf(TODONE, used, slack);
    }


    return RETOK;
}


int d(){
    char acti[ACTIVITYDESC];
    Task listTasks[NUMTASKS];
    int i, lengthList = 0, isIn = False;

    next_instruction();
    read_str(acti, ACTIVITYDESC, False);

    for (i = 0; i < activities_counter; i++){
        if (!strcmp(acti, activities[i].description)) isIn = True;
    }
    if (!isIn) {printf(NOACTIVITY); return RETERROR;}

    for (i = 0; i < task_counter; i++){
        if (!strcmp(tasks[i].activity.description, acti)){
            listTasks[lengthList] = tasks[i];
            lengthList++;
        }
    }

    orderTasksAlpha(listTasks, lengthList);
    orderTasksTimeStart(listTasks, lengthList);

    for (i = 0; i < lengthList; i++){
        printf("%i %i %s\n", listTasks[i].id, listTasks[i].date_created, listTasks[i].description);
    }

    return RETOK;
}


/* Ordering functions */

/* insertion sort algorithm that orders an array of tasks alphabetically */
void orderTasksAlpha(Task array[], int length){
    int i, j ;
    char string[DESCMAX];
    Task temp;

    for (i = 1; i < length; i++){
        j = 1;
        strcpy(string, array[i].description);
        while (strcmp(array[i - j].description, string) > 0 && i - j > -1){
            temp = array[i - j + 1];
            array[i - j + 1] = array[i - j];
            array[i - j] = temp;
            j++;
        }
    }
}

void orderTasksTimeStart(Task array[], int length){
    int i, j, time ;
    Task temp;

    for (i = 1; i < length; i++){
        j = 1;
        time = array[i].date_created;
        while (time < array[i - j].date_created && i - j > -1){
            temp = array[i - j + 1];
            array[i - j + 1] = array[i - j];
            array[i - j] = temp;
            j++;
        }
    }
}

/* Name self-explanatory, orders an array of integers */
void insertionSort(int array[], int n){
    int i, number, j, temp;

    for (i = 1; i < n; i++){
        j = 1;
        number = array[i];
        while (number < array[i - j] && i - j > -1){
            temp = array[i - j + 1];
            array[i - j + 1] = array[i - j];
            array[i - j] = temp;
            j++;
        }
    }
}


void copyTaskArray(Task new[], Task original[]){
    int i;

    for (i = 0; i < NUMTASKS; i++){
        new[i] = original[i];
    }
}
/* Checks if a certain stack is full. Returns True if it is, False otherwise */
int check_limit(int counter, int max, char error_message[]){
    if (counter == max){
            printf("%s", error_message);
            return True;
        }
    return False;
}

/* Checks if a string has lowercase letters. Returns True if it does, False otherwise */
int check_lowercase(char string[]){
    int i = 0;
    char letter;

    while ((letter = string[i]) != '\0'){
        if ((letter > 'a' && letter < 'z') && letter != ' '){
            return True;
        }
        i++;
    }
    return False;
}


/* user input functions */

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

    if (word){ /* if word == True it will only read 1 word. */
        for (i = 0; i < length && (input = getchar()) != '\n' && input != EOF && input != ' '; i++){
            str[i] = input;
        }
    } else {
        for (i = 0; i < length && (input = getchar()) != '\n' && input != EOF; i++){
            str[i] = input;
        }
    }    
    
    str[i] = '\0';
    ungetc(input, stdin);
}


/* Skips space chars */
int next_instruction(){
    char input;

    while ((input = getchar()) == ' '){}

    if (input == '\n') return RETERROR;
    
    ungetc(input, stdin);
    return RETOK;
}


/* Discards the rest of the inputs on the same line */
void ignore_rest(){
    while (getchar() != '\n');
}