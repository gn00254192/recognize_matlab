allFile = dir('*.txt');
for k=1:1:length(allFile)
    fidin=fopen(allFile(k).name);
    for i=1:1:3
        fgetl(fidin);
    end
    data.w=fgetl(fidin);
    data.h=fgetl(fidin);
    data.type=fgetl(fidin);
    data.node=fgetl(fidin);
    data.nodenumber=fgetl(fidin);
    data.l=fgetl(fidin);
    data.search=fgetl(fidin);
    pic=zeros(str2num(data.h),str2num(data.w));
    allpath=fgetl(fidin);
    pn=findstr(allpath,'!');
    pn=[0 pn];
    clear path;
    clear p;
    clear steppath;
    for i=1:1:length(pn)-1
        path{i}=allpath((pn(i)+1):pn(i+1));
        temp=findstr(path{i},';');
        path{i}=path{i}(temp(3)+2:length(path{i}));
        temp1=findstr(path{i},';');
        temp1=[0 temp1];
        for j=1:1:length(temp1)-1
            p{i}.path{j}=path{i}(temp1(j)+1:temp1(j+1));
            p{i}.path{j}=strrep(p{i}.path{j}, ';',',');
            if p{i}.path{j}(1)=='m'
                steppath{i}.step{j}.action='m';
                temp3=findstr(p{i}.path{j},',');
                steppath{i}.step{j}.x1=sixtwo(p{i}.path{j}(temp3(1)+1:temp3(2)-1))+1;
                steppath{i}.step{j}.y1=sixtwo(p{i}.path{j}(temp3(2)+1:temp3(3)-1))+1;
            end
            if p{i}.path{j}(1)=='l'
                steppath{i}.step{j}.action='l';
                temp3=findstr(p{i}.path{j},',');
                steppath{i}.step{j}.x1=sixtwo(p{i}.path{j}(temp3(1)+1:temp3(2)-1))+1;
                steppath{i}.step{j}.y1=sixtwo(p{i}.path{j}(temp3(2)+1:temp3(3)-1))+1;
                x1=steppath{i}.step{j-1}.x1;
                y1=steppath{i}.step{j-1}.y1;
                x2=steppath{i}.step{j}.x1;
                y2=steppath{i}.step{j}.y1;
                r=0.5/sqrt((x1-x2)^2+(y1-y2)^2);
                if r==inf
                    r=1;
                end
                for z=0:r:1
                    x3=(1-z)*x1+z*x2;
                    y3=(1-z)*y1+z*y2;
                    pic(floor(y3),floor(x3))=1;
                end
            end
            if p{i}.path{j}(1)=='q'
                steppath{i}.step{j}.action='q';
                temp3=findstr(p{i}.path{j},',');
                steppath{i}.step{j}.x1=sixtwo(p{i}.path{j}(temp3(1)+1:temp3(2)-1))+1;
                steppath{i}.step{j}.y1=sixtwo(p{i}.path{j}(temp3(2)+1:temp3(3)-1))+1;
                steppath{i}.step{j}.x2=sixtwo(p{i}.path{j}(temp3(3)+1:temp3(4)-1))+1;
                steppath{i}.step{j}.y2=sixtwo(p{i}.path{j}(temp3(4)+1:temp3(5)-1))+1;
                
                pic=quadto([steppath{i}.step{j-1}.y1 steppath{i}.step{j}.y1 steppath{i}.step{j}.y2],[steppath{i}.step{j-1}.x1 steppath{i}.step{j}.x1 steppath{i}.step{j}.x2],pic);
                
            end
            
        end
    end
    save([allFile(k).name(1:length(allFile(k).name)-4) '.mat' ] ,'data','steppath')
    imwrite(pic, [allFile(k).name(1:length(allFile(k).name)-4) '.tif' ],'tif');
end