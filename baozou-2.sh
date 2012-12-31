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
des=your/path
urlfile=your/baozou/urlfile
#取得url列表
for url in `cat $urlfile`
do
src[$count]=$url
#echo ${src[$count]}
((count++))
done
((count--)) 
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

#get the button comic //一行是名字，一行是漫画url
	for line in `cat $tmp  | egrep "'text'|'pic'" | sed "s/''/'fuck'/" | awk -F\' '{print $4}'`
	do
	if [ $flag -eq 0 ] ;then
	name=$line
	flag=1
       	else
	comic=$line
#字符串操作，判断文件格式后，判断此文件是否存在
	len=${#comic}
	format=${comic:len-4}
	if [ ${format:0:1} = "." ];then   #判断jpeg或者是其他的后缀后3的格式
	    format=${comic:len-3}
	fi
	file=$name.$format
	#echo $file
	#测试文件是否存在
	if [ ! -e $des/$file ];then
	    wget $comic -O $file  
	    cp $file $des/new/
	fi
	flag=0
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
	    for image in *
	    do
	    convert $image -pointsize 35  -draw "text 50,30 '$image'" $image 
	    done
	    convert * +compress baozou.pdf
	    zip -m baozou.zip baozou.pdf
	    echo "kindle" | mutt -s "baozou" yourkindle @free.kindle.com -a baozou.zip
	    rm *
	    cd ..
    	    fi
cd $pwd
exit
#fi
