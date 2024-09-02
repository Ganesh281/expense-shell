#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGFILE="$LOGS_FOLDER/$SCRIPTNAME-$TIMESTAMP.log"

mkdir -p $LOGS_FOLDER

USERID=$(id -u)
#echo "User ID is: $USERID"

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Please run this script with root privileges $N" | tee -a $LOGFILE
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 is...$R FAILED $N" | tee -a $LOGFILE
        exit 1
    else
        echo -e "$2 is...$G SUCCESS $N" | tee -a $LOGFILE
    fi
}

echo "Script satrts executeing at : $(date)" | tee -a $LOGFILE

CHECK_ROOT

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabled MySQL Server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "started MySQL server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "Setting Up root password"
