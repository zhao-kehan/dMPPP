function [sat,inf] = readsp3(filesp3,inf)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
[fid,errmsg] = fopen(filesp3);

if any(errmsg)
    error   ('SP3 file has error');
end

sp3 = NaN(1440,4,152);

while ~feof(fid)
    line = fgetl(fid);
    if strcmp(line(1),'#') && ~strcmp(line(1:2),'##')
        dat = sscanf(line(4:14),'%f');
    end
    if strcmp(line(1:2),'##')
        sp3int = sscanf(line(25:38),'%f');
        inf.time.sp3int = sp3int;
        epoch = 86400/sp3int; 
        sp3 = NaN(epoch,4,152);
    end
%     if line(1)=='+'&& ~isempty(line(4:6))
%         satnum = sscanf(line(4:6),'%d');
%     end
    if line(1)=='+'
        temp = sscanf(line(4:6),'%d');
        if ~isnan(temp)
            satnum = temp;
        end
    end
    %新历元开始，重新读取时间信息
    if line(1)=='*'
        ep = sscanf(line(2:end),'%f',[1,6]);
        if ep(1)~=dat(1) || ep(2)~=dat(2) || ep(3)~=dat(3)
            continue
        end
        epoch = ((ep(4)*3600 + ep(5)*60 + ep(6))/sp3int)+1;
        for k=1:satnum
            line = fgetl(fid);
            if strcmp(line(2),'G')
                satprn = sscanf(line(3:4),'%d');
                if satprn>32
                    continue
                else
                    xyzt = sscanf(line(5:end),'%f',[1,4]);%读取卫星坐标以及卫星钟差
                    sp3(epoch,1:3,satprn) = xyzt(1:3)*1000;
                    sp3(epoch,4,satprn) = xyzt(4)*10^-6; 
                end
            elseif strcmp(line(2),'R')
                satprn =32 + sscanf(line(3:4),'%d');
                if satprn>56
                    continue
                else
                    xyzt = sscanf(line(5:end),'%f',[1,4]);
                    sp3(epoch,1:3,satprn) = xyzt(1:3)*1000;
                    sp3(epoch,4,satprn) = xyzt(4)*10^-6; 
                end
            elseif strcmp(line(2),'E')
                satprn  = 56 + sscanf(line(3:4),'%d');
                if satprn>92
                    continue
                else
                    xyzt = sscanf(line(5:end),'%f',[1,4]);
                    sp3(epoch,1:3,satprn) = xyzt(1:3)*1000; 
                    sp3(epoch,4,satprn) = xyzt(4)*10^-6;  
                end
            elseif strcmp(line(2),'C')
                satprn  = 92 + sscanf(line(3:4),'%d');
                if satprn>152
                    continue
                else
                    xyzt = sscanf(line(5:end),'%f',[1,4]);
                    sp3(epoch,1:3,satprn) = xyzt(1:3)*1000; 
                    sp3(epoch,4,satprn) = xyzt(4)*10^-6;  
                end
            end
        end
    end
end

sat.sp3 = sp3;
fclose('all');

end

