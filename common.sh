script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]
  then
    echo -e "\e[42mSUCCESS\e[0m"
  else
    echo -e "\e[41mFailure\e[0m"
    echo " Refer log file for information log-$LOG"
    exit
  fi
}

install_requriments() {

  echo -e "\e[33mInstalling zip\e[0m"
  sudo dnf install zip -y  &>>${LOG}
  status_check

}

print_head() {
  echo -e "\e[1m $1 \e[0m"
}