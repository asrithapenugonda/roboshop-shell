script_location=$(pwd)
LOG=/tmp/roboshop.log

#status-check function
status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32msuccess\e[0m"
  else
    echo -e "\e[31mFailure\e[0m"
  fi
}