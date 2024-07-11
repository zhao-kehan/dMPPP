function [bia] = readbia(filebia)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[fid,errmsg] = fopen(filebia);

if any(errmsg)
    error('BIA File has error!');                                             
end

linenum = 0;
gps.c = zeros(32,3,10);
gps.l = zeros(32,3,10);
glo.c = zeros(24,5,3);
glo.l = zeros(24,5,3);
gal.c = zeros(36,5,5);
gal.l = zeros(36,5,5);
bds.c = zeros(60,5,6);
bds.l = zeros(60,5,6);

while ~feof(fid)
    tline = fgetl(fid);
    linenum = linenum + 1;
    if ~isempty(tline) && strcmp(tline(2:7),'OSB  G')
        num = sscanf(tline(13:14),'%d');
        if strcmp(tline(26),'C')
            if strcmp(tline(27),'1')
                if strcmp(tline(28),'C')
                    gps.c(num,1,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'S')
                    gps.c(num,1,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'L')
                    gps.c(num,1,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gps.c(num,1,4) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    gps.c(num,1,5) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'W')
                    gps.c(num,1,6) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Y')
                    gps.c(num,1,7) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'M')
                    gps.c(num,1,8) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'2')
                if strcmp(tline(28),'C')
                    gps.c(num,2,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'D')
                    gps.c(num,2,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'S')
                    gps.c(num,2,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'L')
                    gps.c(num,2,4) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gps.c(num,2,5) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    gps.c(num,2,6) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'W')
                    gps.c(num,2,7) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Y')
                    gps.c(num,2,8) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'M')
                    gps.c(num,2,9) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'5')
                if strcmp(tline(28),'I')
                    gps.c(num,3,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    gps.c(num,3,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gps.c(num,3,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            else
                continue
            end
        elseif strcmp(tline(26),'L')
            if strcmp(tline(27),'1')
                if strcmp(tline(28),'C')
                    gps.l(num,1,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'S')
                    gps.l(num,1,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'L')
                    gps.l(num,1,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gps.l(num,1,4) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    gps.l(num,1,5) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'W')
                    gps.l(num,1,6) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Y')
                    gps.l(num,1,7) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'M')
                    gps.l(num,1,8) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'2')
                if strcmp(tline(28),'C')
                    gps.l(num,2,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'D')
                    gps.l(num,2,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'S')
                    gps.l(num,2,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'L')
                    gps.l(num,2,4) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gps.l(num,2,5) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    gps.l(num,2,6) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'W')
                    gps.l(num,2,7) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Y')
                    gps.l(num,2,8) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'M')
                    gps.l(num,2,9) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'5')
                if strcmp(tline(28),'I')
                    gps.l(num,3,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    gps.l(num,3,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gps.l(num,3,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            else
                continue
            end
        end
    elseif ~isempty(tline) && strcmp(tline(2:7),'OSB  R')
        num = sscanf(tline(13:14),'%d');
        if strcmp(tline(26),'C')
            if strcmp(tline(27),'1')
                if strcmp(tline(28),'C')
                    glo.c(num,1,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    glo.c(num,1,2) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'4')
                if strcmp(tline(28),'A')
                    glo.c(num,2,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'B')
                    glo.c(num,2,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    glo.c(num,2,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'2')
                if strcmp(tline(28),'C')
                    glo.c(num,3,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    glo.c(num,3,2) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'6')
                if strcmp(tline(28),'A')
                    glo.c(num,4,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'B')
                    glo.c(num,4,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    glo.c(num,4,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'3')
                if strcmp(tline(28),'I')
                    glo.c(num,5,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    glo.c(num,5,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    glo.c(num,5,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            else
                continue
            end
        elseif strcmp(tline(26),'L')
            if strcmp(tline(27),'1')
                if strcmp(tline(28),'C')
                    glo.l(num,1,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    glo.l(num,1,2) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'4')
                if strcmp(tline(28),'A')
                    glo.l(num,2,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'B')
                    glo.l(num,2,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    glo.l(num,2,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'2')
                if strcmp(tline(28),'C')
                    glo.l(num,3,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    glo.l(num,3,2) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'6')
                if strcmp(tline(28),'A')
                    glo.l(num,4,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'B')
                    glo.l(num,4,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    glo.l(num,4,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'3')
                if strcmp(tline(28),'I')
                    glo.l(num,5,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    glo.l(num,5,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    glo.l(num,5,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            else
                continue
            end
        end
    elseif ~isempty(tline) && strcmp(tline(2:7),'OSB  E')
        num = sscanf(tline(13:14),'%d');
        if strcmp(tline(26),'C')
            if strcmp(tline(27),'1')
                if strcmp(tline(28),'A')
                    gal.c(num,1,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'B')
                    gal.c(num,1,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'C')
                    gal.c(num,1,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gal.c(num,1,4) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Z')
                    gal.c(num,1,5) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'5')
                if strcmp(tline(28),'I')
                    gal.c(num,2,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    gal.c(num,2,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gal.c(num,2,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'7')
                if strcmp(tline(28),'I')
                    gal.c(num,3,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    gal.c(num,3,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gal.c(num,3,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'8')
                if strcmp(tline(28),'I')
                    gal.c(num,4,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    gal.c(num,4,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gal.c(num,4,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'6')
                if strcmp(tline(28),'A')
                    gal.c(num,5,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'B')
                    gal.c(num,5,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'C')
                    gal.c(num,5,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gal.c(num,5,4) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Z')
                    gal.c(num,5,5) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            else
                continue
            end
        elseif strcmp(tline(26),'L')
            if strcmp(tline(27),'1')
                if strcmp(tline(28),'A')
                    gal.l(num,1,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'B')
                    gal.l(num,1,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'C')
                    gal.l(num,1,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gal.l(num,1,4) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Z')
                    gal.l(num,1,5) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'5')
                if strcmp(tline(28),'I')
                    gal.l(num,2,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    gal.l(num,2,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gal.l(num,2,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'7')
                if strcmp(tline(28),'I')
                    gal.l(num,3,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    gal.l(num,3,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gal.l(num,3,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'8')
                if strcmp(tline(28),'I')
                    gal.l(num,4,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    gal.l(num,4,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gal.l(num,4,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'6')
                if strcmp(tline(28),'A')
                    gal.l(num,5,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'B')
                    gal.l(num,5,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'C')
                    gal.l(num,5,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    gal.l(num,5,4) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Z')
                    gal.l(num,5,5) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            else
                continue
            end
        end
    elseif ~isempty(tline) && strcmp(tline(2:7),'OSB  C')
        num = sscanf(tline(13:14),'%d');
        if strcmp(tline(26),'C')
            if strcmp(tline(27),'2')
                if strcmp(tline(28),'I')
                    bds.c(num,1,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    bds.c(num,1,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    bds.c(num,1,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'1')
                if strcmp(tline(28),'D')
                    bds.c(num,2,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    bds.c(num,2,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    bds.c(num,2,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'A')
                    bds.c(num,2,4) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'5')
                if strcmp(tline(28),'D')
                    bds.c(num,3,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    bds.c(num,3,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    bds.c(num,3,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'7')
                if strcmp(tline(28),'I')
                    bds.c(num,4,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    bds.c(num,4,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    bds.c(num,4,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'D')
                    bds.c(num,4,4) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    bds.c(num,4,5) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Z')
                    bds.c(num,4,6) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'6')
                if strcmp(tline(28),'I')
                    bds.c(num,5,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    bds.c(num,5,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    bds.c(num,5,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'A')
                    bds.c(num,5,4) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            else
                continue
            end
        elseif strcmp(tline(26),'L')
            if strcmp(tline(27),'2')
                if strcmp(tline(28),'I')
                    bds.l(num,1,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    bds.l(num,1,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    bds.l(num,1,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'1')
                if strcmp(tline(28),'D')
                    bds.l(num,2,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    bds.l(num,2,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    bds.l(num,2,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'A')
                    bds.l(num,2,4) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'5')
                if strcmp(tline(28),'D')
                    bds.l(num,3,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    bds.l(num,3,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    bds.l(num,3,3) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'7')
                if strcmp(tline(28),'I')
                    bds.l(num,4,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    bds.l(num,4,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    bds.l(num,4,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'D')
                    bds.l(num,4,4) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'P')
                    bds.l(num,4,5) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Z')
                    bds.l(num,4,6) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            elseif strcmp(tline(27),'6')
                if strcmp(tline(28),'I')
                    bds.l(num,5,1) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'Q')
                    bds.l(num,5,2) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'X')
                    bds.l(num,5,3) = sscanf(tline(71:91),'%f');
                elseif strcmp(tline(28),'A')
                    bds.l(num,5,4) = sscanf(tline(71:91),'%f');
                else
                    continue
                end
            else
                continue
            end
        end
    else
        continue
    end
end

bia.gps.c = gps.c;
bia.gps.l = gps.l;
bia.glo.c = glo.c;
bia.glo.l = glo.l;
bia.gal.c = gal.c;
bia.gal.l = gal.l;
bia.bds.c = bds.c;
bia.bds.l = bds.l;

fclose('all');
end




