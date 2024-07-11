function [data] = data_reading(fileobs,filesp3,filesp3a,filesp3b,fileatx,fileclk,filedcb,filesnx,option)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[fid,errmsg] = fopen(fileobs);

if any(errmsg)
    error   ('OBS file can not be opened !');
end

%得到OBS文件版本号
while 1
    tline = fgetl(fid);
    tag = strtrim(tline(61:end));
    if strcmp(tag,'RINEX VERSION / TYPE')
        ver = sscanf(tline(1:20),'%f');
        break
    end
end
%跟据得到的OBS版本号判断使用哪个函数
if ver>=3
    [bia] = readbia(filedcb);%读取BIA文件
    [inf] = readrnx3(fileobs,bia);
elseif ver>=2
    [inf] = readrnx2(fileobs);
else
    error('RINEX version is wrong !');
end
%读取精密星历文件
[sat,inf] = readsp3(filesp3,inf);
%判定相邻三天的精密星历数据量是否相等
if ~isempty(filesp3a) && ~isempty(filesp3b)
    [satb,~] = readsp3(filesp3b,inf);
    [sata,~] = readsp3(filesp3a,inf);
    if (size(satb.sp3,1)==size(sata.sp3,1))&&(size(satb.sp3,1)==size(sat.sp3,1))...
            &&(size(sat.sp3,1)==size(sata.sp3,1))%相等的话进行轨道数据的合并，用于之后的插值计算
        sat.sp3 = vertcat(satb.sp3(end-4:end,:,:),...
        sat.sp3(:,:,:),...
        sata.sp3(1:5,:,:));
    end
end
%读取精密钟差
[clk] = readclk(fileclk,option);
inf.time.clkint = option.clkint;

%读取测站精确坐标信息（用于计算外符合精度）
[inf] = readsnx(filesnx,inf);

%读取天线相位改正文件
[atx] = readatx(fileatx,inf);
%存储读取的数据
data.inf  = inf;%存储了导航和定位数据的相关信息。
data.sat  = sat;%存储卫星轨道数据。
data.clk  = clk;%存储时钟数据
data.atx  = atx;%存储天线相位中心偏移数据。
end

