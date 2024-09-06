script_location=$(pwd)
Log=/tmp/roboshop.log

status_check () {
  if [ $? -eq 0 ]
  then
    echo -e "\e[32mSuccess\e[0m"
  else
    echo "\e[31mFailure\e[0m"
    echo "Refer to the file ${LOG}"
    exit
  fi
}