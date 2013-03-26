# @file smtp.sh
# @Synopsis   判断网络，smtp服务是否已经start
# @author psnail  peaksnail@gmail.com
# @version 1
# @date 2013-03-26
#!/bin/bash

 smtp ()  {
declare -i on=0;
on=`netstat -tl | grep smtp | wc -l`
if [ $on -eq 0 ];then
    echo "smtp stop now ,you can openn it with systemctl!"
    exit
else
    echo "smtp have start ..."
fi
}
 net()  {
     declare -i on=0
     on=`ifconfig | grep "yourip" | wc -l` 
     if [ $on -eq 0 ];then
        echo "network is down now"
        exit
     else 
        echo "network ready ..."
     fi
 }
