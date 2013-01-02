#-------------
#  psnil 
#  2013-1-2
#-------------
#!/bin/bash  
#set -x #调试
declare -i flag=0            #判断此行是文件名字还是漫画url
declare -i i=2
declare -i count=0
declare -i exist=0
declare -a src
declare -i test=1
pwd=`pwd`
tmp=/tmp/$$
des=/mnt/sda5_documents/programs/shell/program/baozou/pic
urlfile=/mnt/sda5_documents/programs/shell/program/baozou/baozou_url
data=/mnt/sda5_documents/programs/shell/program/baozou/baozou_data
#取得url列表
for url in `cat $urlfile`
do
src[$count]=$url
#echo ${src[$count]}
((count++))
done
((count--)) 

if [ ! -f baozou_data ];then
    touch baozou_data
fi

cd $des

if [ ! -d new ];then
    mkdir new
fi
while [[ $count -ge 0  ]] 
do
    source=${src[$count]}
#    echo $source
    ((count--))
#done
#if [ $test -eq 0 ];then 

#get the source file
	lynx -source $source > $tmp  

#get the  comic url 
	for line in `cat $tmp  | egrep "'pic'" |  awk -F\' '{print $4}'`
	do
	comic=$line
	#测试文件是否存在,若不存在，写入保存文件，供以后比对
	exist=`grep $comic $data | wc -l`
	if [ $exist -eq 0 ];then
	    echo $comic >> $data
	    cd ./new/
	    wget $comic   
	    cd ..
	fi
	done
done
rm $tmp
	    #打包发送操作
	    exist=`ls ./new/ | wc -l`
	    if [ $exist -ne 0 ];then
	    #zip -m pic.zip ./new/*
	    #declare -i num=25  #kindle一次最多接受25个文件
	     #while [[ $num -gt 0 ]]
	     #do 
	#	 cd ./new/
	#	 zip -m -q  ../pic.zip `ls -rt | head -1`
	#	 ((num--))
	 #    done
	  #   cd ..
	  #这里采用convert合成图片为一张pdf来发送
	    cd ./new/
	    #先在图片上写上标题，合成pdf时不会显示文件名，所以在图片上写标题（good）
	    #for image in *
	    #do
	    #convert $image -pointsize 35  -draw "text 50,30 '$image'" $image 
	    #done
	    convert * +compress baozou.pdf
	    zip -m baozou.zip baozou.pdf
	    echo "kindle" | mutt -s "baozou" 513322938@free.kindle.com -a baozou.zip
	    echo "kindle" | mutt -s "baozou" lucienfeel@free.kindle.com -a baozou.zip
	    rm *
	    cd ..
    	    fi
cd $pwd
exit
