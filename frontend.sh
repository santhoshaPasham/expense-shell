#!/bin/bash 

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%S)
SCRIPTNAME=$( echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"


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

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Validate existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip  &>>$LOGFILE
VALIDATE $? "Downloading frontend code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Unzipping frontend code"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Validate expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting nginx"


