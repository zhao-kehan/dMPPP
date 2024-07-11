function [clk] = readclk(fileclk,option)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[fid,errmsg] = fopen(fileclk);

if any(errmsg)
    error   ('CLK file has error');
end
interval = option.clkint;
tn = 86400/interval;
clk = zeros(tn,152);
epoch = 0;

while ~feof(fid)
    tline = fgetl(fid);
    if strcmp(tline(1:4),'AS G')
        data=sscanf(tline(5:end),'%f',[1,9]);
        sat_no = data(1);
          if sat_no<33
            epoch =(data(5)*3600 + data(6)*60 + data(7))/interval + 1;
            clk(epoch,sat_no) = data(9);
        else
            continue
          end
    elseif strcmp(tline(1:4),'AS R')
        data=sscanf(tline(5:end),'%f',[1,9]);
        sat_no =32 + data(1);
          if sat_no<57
            epoch =(data(5)*3600 + data(6)*60 + data(7))/interval + 1;
            clk(epoch,sat_no) = data(9);
        else
            continue
          end
    elseif strcmp(tline(1:4),'AS E')
        data=sscanf(tline(5:end),'%f',[1,9]);
        sat_no =56 + data(1);
          if sat_no<93
            epoch =(data(5)*3600 + data(6)*60 + data(7))/interval + 1;
            clk(epoch,sat_no) = data(9);
        else
            continue
          end
    elseif strcmp(tline(1:4),'AS C')
        data=sscanf(tline(5:end),'%f',[1,9]);
        sat_no =92 + data(1);
          if sat_no<152
            epoch =(data(5)*3600 + data(6)*60 + data(7))/interval + 1;
            clk(epoch,sat_no) = data(9);
        else
            continue
          end
    end
    if epoch>2880
        break
    end
end
fclose('all');
end

