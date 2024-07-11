function [inf] = readsnx(filesnx,inf)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[fid,errmsg] = fopen(filesnx);

if any(errmsg)
    error('SNX File has error!');
end

inf.rec.ppos = NaN(3,1);
stationame = inf.rec.name;

while ~feof(fid)
    tline = fgetl(fid);
    if size(tline,2)>=68 && strcmp(tline(8:11),'STAX') && strcmp(tline(15:18),stationame)
        inf.rec.ppos(1,1) = sscanf(tline(47:68),'%f');
    elseif size(tline,2)>=68 && strcmp(tline(8:11),'STAY') && strcmp(tline(15:18),stationame)
        inf.rec.ppos(2,1) = sscanf(tline(47:68),'%f');
    elseif size(tline,2)>=68 && strcmp(tline(8:11),'STAZ') && strcmp(tline(15:18),stationame)
        inf.rec.ppos(3,1) = sscanf(tline(47:68),'%f');
    else
        continue
    end
    
    x = inf.rec.ppos(1,1);
    y = inf.rec.ppos(2,1);
    z = inf.rec.ppos(3,1);
    if ~isnan(x) && ~isnan(y) && ~isnan(z)
        break
    end
end
end

