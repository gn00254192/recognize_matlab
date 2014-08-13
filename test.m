clc;
clear;
act=5; %5 from path 6 from ans
url=['http://mjimagenetapi.appspot.com/getpath?&act=' num2str(act)];
s = urlread(url);     %去http://mjimagenetapi.appspot.com/getpath?&act=5讀出資料
num=findstr(s,10);    %抓取所有NODE資料  10是ascii的換行鍵
if num>0
    nnum=length(num);  %幾筆資料+1
    num=[0 num];       %放入陣列裡
    for i=1:1:nnum 
        list{i}=s(num(i)+1:num(i+1)-1);  %把NODE資訊讀入陣列  EX{'02127808','02127808','02127808','02374451','02374451','google,1','google,2';}
    end
    l{1}=list{1};
    j=1;
    for i=1:1:nnum               %把NODE的重複拿掉           
                l{j}=list{i};                        
    end
end

act=1;
if num>=0
    for i=1:1:length(list)
        node=list{i};
        
        
%-----------getpath------------------------------------------------    
   %act=1; %1from path 3 from ans
%node='02676566';
url=['http://mjimagenetapi.appspot.com/getpath?node=' node '&act=' num2str(act)];  %軌跡資料 EX  http://mjimagenetapi.appspot.com/getpath?node=02127808&act=1  

s = urlread(url);
if length(s)>10
    
    n1=findstr(s,'http://summer3c.host56.com/upload/')+34;   %-------以下三行主要是要讀出
    n2=findstr(s,'.png')-1;
    name=[s(n1:n2) ];
    
    fid = fopen( [name '.txt'], 'w');
    fprintf(fid, s);
    fclose(fid);
    a= dir([name '.txt']);
    pause(10);
    
        if a.bytes>10000            
        n1=findstr(s,'http://summer3c.host56.com/upload/')-2;
        s1=s(1:n1);
        url=['http://mjimagenetapi.appspot.com/getpath?key=' s1 '&act=' num2str(act+1)];
        s = urlread(url);
    end
end

%-----------------------------------------------------------------------        
        
         pause(10);
    end
end