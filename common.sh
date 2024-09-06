script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check () {
  if [ $? -eq 0 ]
  then
    echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo "\e[1;31mFAILURE\e[0m"
    echo "Refer to the file ${LOG}"
    exit
  fi
}

print_head () {
  echo -e "\e[40m $1 \e[0m"
}