#-------------
#  psnil 
#  2013-3-3
#  pm 16:00
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
tmp=/tmp/$$                 #下载urlfile所指路径的网页，下载上面的图片链接
des=pic                     #下载后存放图片的文件夹
urlfile=baozou_url          #存放要下载的暴走图片所在网站的url   
data=baozou_data  #存放已经下载过的暴走 图片的url

#取得url列表
for url in `cat $urlfile`
do
src[$count]=$url
#echo ${src[$count]}
((count++))
done
((count--)) 

if [ ! -f $data ];then
    touch baozou_data
fi

cd $des

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
	    wget $comic   
	fi
	done
done
rm $tmp
	    #打包发送操作
	    exist=`ls  | wc -l`
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
	    convert * +compress baozou.pdf
	    zip -m baozou.zip baozou.pdf
	    echo "kindle" | mutt -s "baozou" 513322938@free.kindle.com -a baozou.zip  #一次性传输不能太大，否则会失败，分多次传输
	    rm *
	    cd ..
    	    fi
exit
