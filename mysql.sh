##!/bin/bash


USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%S)
SCRIPTNAME=$( echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ]
then 
    echo "Please run this command with root access"
    exit 1
else
    echo "you are super user"
fi 

VALIDATE(){
if [ $1 -ne 0 ]
then 
    echo -e "$2 is $R failure $N"
    exit 1
else 
    echo -e "$2 is $G success $N"
fi
}

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing mysql-server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "setting root password"



