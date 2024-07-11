function [inf] = readrnx2(fileobs)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
[fid,errmsg] = fopen(fileobs);

if any(errmsg)
    error   ('OBS file has error !');
end

while 1
    
    tline = fgetl(fid);
    tag  = strtrim(tline(61:end));
    switch tag
        case 'RINEX VERSION / TYPE'
            if strcmp(sscanf(tline(21),'%c'),'O')
                inf.rinex.type = sscanf(tline(21),'%c');
            else
                error   ('OBS file has error !');
            end
            inf.sat.system = sscanf(tline(41),'%c');
        
        case 'REC # / TYPE / VERS'
            inf.rec.number  = strtrim(tline( 1:20));
            inf.rec.type    = strtrim(tline(21:40));
            inf.rec.version = strtrim(tline(41:60));
       
        case 'ANT # / TYPE'
            inf.ant.number  = strtrim(tline( 1:20));
            inf.ant.type    = strtrim(tline(21:40));
       
        case 'APPROX POSITION XYZ'
            inf.rec.pos     = sscanf(tline,'%f',[1,3]);
        
        case 'ANTENNA: DELTA H/E/N'
            inf.ant.hen     = sscanf(tline,'%f',[1,3]);
            
        case '# / TYPES OF OBSERV'
            obno = sscanf(tline(1:6),'%d');
            inf.obsno = obno;
            if obno<=9
                temp = sscanf(tline(7:60),'%s');
            elseif obno<=18
                temp = sscanf(tline(7:60),'%s');
                tline = fgetl(fid);
                temp  = strcat(temp,sscanf(tline(7:60),'%s'));
            elseif obno<=27
                temp = sscanf(tline(7:60),'%s');
                tline = fgetl(fid);
                temp  = strcat(temp,sscanf(tline(7:60),'%s'));
                tline = fgetl(fid);
                temp  = strcat(temp,sscanf(tline(7:60),'%s'));
            end
            
            inf.seq.gps = zeros(1,5);
            inf.seq.glo = zeros(1,5);
            inf.seq.gal = zeros(1,4);
            % C1
            if contains(temp,'C1')
                inf.seq.gps(5) = (strfind(temp,'C1')+1)/2;
                inf.seq.glo(5) = (strfind(temp,'C1')+1)/2;
                inf.seq.gal(1) = (strfind(temp,'C1')+1)/2;
            end
            % P1
            if contains(temp,'P1')
                inf.seq.gps(1) = (strfind(temp,'P1')+1)/2;
                inf.seq.glo(1) = (strfind(temp,'P1')+1)/2;
            end
            % P2
            if contains(temp,'P2')
                inf.seq.gps(2) = (strfind(temp,'P2')+1)/2;
                inf.seq.glo(2) = (strfind(temp,'P2')+1)/2;
            end
            % C5
            if contains(temp,'C5')
                inf.seq.gal(2) = (strfind(temp,'C5')+1)/2;
            end
            % L1
            if contains(temp,'L1')
                inf.seq.gps(3) = (strfind(temp,'L1')+1)/2;
                inf.seq.glo(3) = (strfind(temp,'L1')+1)/2;
                inf.seq.gal(3) = (strfind(temp,'L1')+1)/2;
            end
            % L2
            if contains(temp,'L2')
                inf.seq.gps(4) = (strfind(temp,'L2')+1)/2;
                inf.seq.glo(4) = (strfind(temp,'L2')+1)/2;
            end
            % L5
            if contains(temp,'L5')
                inf.seq.gal(4) = (strfind(temp,'L5')+1)/2;
            end
            
        case 'INTERVAL'
            inf.time.int = sscanf(tline(1:10),'%d');
        case 'TIME OF FIRST OBS'
            inf.time.first  = sscanf(tline(1:43),'%d',[1,6]);
            inf.time.system = strtrim(tline(44:60));
        case 'TIME OF LAST OBS'
            inf.time.last   = sscanf(tline(1:43),'%d');
        case 'LEAP SECONDS'
            inf.time.leap = sscanf(tline,'%d');%jul和doy还没写！！！！！！！
        case 'END OF HEADER'
            break
    end
end

satnum= 88;
max=2880;
% allsec=(inf.time.last(4)-inf.time.first(4))*3600+(inf.time.last(5)-...
%         inf.time.first(5))*60+(inf.time.last(6)-inf.time.first(6)+30);
% if allsec == 86400
%     fi = inf.time.first(4)*3600 + inf.time.first(5)*60 + inf.time.first(6);
%     la = allsec;
%     max = (la-fi)/inf.time.int + 1;
% else
%     fi = inf.time.first(4)*3600 + inf.time.first(5)*60 + inf.time.first(6);
%     la = inf.time.last (4)*3600 + inf.time.last (5)*60 + inf.time.last (6);
%     max = (la-fi)/inf.time.int + 1;
% end

p1s  = NaN(max,satnum);
p2s  = NaN(max,satnum);
c1s  = NaN(max,satnum);
c5s  = NaN(max,satnum);
l1s  = NaN(max,satnum);
l2s  = NaN(max,satnum);
l5s  = NaN(max,satnum);
eps  = NaN(max, 1);
st   = zeros(max,satnum);
c = 299792458;
freq = zeros(105,5);
wavl = zeros(105,5);
glok = [1 -4 5 6 1 -4 5 6 -2 -7 0 -1 -2 -7 0 -1 4 -3 3 2 4 -3 3 2 0 0];
for i=1:88
    if i<33     % GPS
        freq(i,1) = 10.23*10^6*154;    %Hz L1
        wavl(i,1) = c/(10.23*10^6*154);%m 波长
        freq(i,2) = 10.23*10^6*120;    %Hz L2
        wavl(i,2) = c/(10.23*10^6*120);%m 波长
    elseif i<59 % GLONASS
        freq(i,1) = (1602 + 0.5625*glok(i-32))*10^6;    %Hz G1
        wavl(i,1) = c/((1602 + 0.5625*glok(i-32))*10^6);%m
        freq(i,2) = (1246 + 0.4375*glok(i-32))*10^6;    %Hz G2
        wavl(i,2) = c/((1246 + 0.4375*glok(i-32))*10^6);%m
    elseif i<89 % GALILEO
        freq(i,1) = 10.23*10^6*154;    %Hz E1
        wavl(i,1) = c/(10.23*10^6*154);%m
        freq(i,2) = 10.23*10^6*115;    %Hz E5a
        wavl(i,2) = c/(10.23*10^6*115);%m
    end
end

year = inf.time.first(1);
mon  = inf.time.first(2);
day  = inf.time.first(3);
if year<2000
    year = year - 1900;
else
    year = year - 2000;
end

epochnum = 0;
linenum = 0;
while 1
    tline = fgetl(fid);
    linenum = linenum + 1;
    
    if size(tline,2)<33
        ep = sscanf(tline(1:end),'%f',[1,8]);
    else
        ep = sscanf(tline(1:32),'%f',[1,8]);
    end
    
    if length(ep)==8 && ep(1)==year && ep(2)==mon && ep(3)==day && size(tline,2)>33
        epochnum  = epochnum + 1;
        epocs = ep(4)*3600 + ep(5)*60 + ep(6);
        eps(epochnum,1) = epocs;
        sats_no = ep(8);
        
         if sats_no<13
            if length(tline)<68
                satline = strtrim(tline(33:end));
            elseif length(tline)<=80
                satline = strtrim(tline(33:68));
            end
        elseif sats_no<25
            if length(tline)<68
                satline1 = strtrim(tline(33:end));
            elseif length(tline)<=80
                satline1 = strtrim(tline(33:68));
            end
            tline = fgetl(fid);
            linenum = linenum + 1;
            if length(tline)<68
                satline2 = strtrim(tline(33:end));
            elseif length(tline)<=80
                satline2 = strtrim(tline(33:68));
            end
            satline = strcat(satline1,satline2);
        elseif sats_no<37
            if length(tline)<68
                satline1 = strtrim(tline(33:end));
            elseif length(tline)<=80
                satline1 = strtrim(tline(33:68));
            end
            tline = fgetl(fid);
            linenum = linenum + 1;
            if length(tline)<68
                satline2 = strtrim(tline(33:end));
            elseif length(tline)<=80
                satline2 = strtrim(tline(33:68));
            end
            tline = fgetl(fid);
            linenum = linenum + 1;
            if length(tline)<68
                satline3 = strtrim(tline(33:end));
            elseif length(tline)<=80
                satline3 = strtrim(tline(33:68));
            end
            satline = strcat(satline1,satline2,satline3);
         end
        
         if any(strfind(satline,'G')) || any(strfind(satline,'R')) || any(strfind(satline,'E'))
            satline=strrep(satline,'G','1');
            satline=strrep(satline,' ','0');
            satline=strrep(satline,'R','2');
            satline=strrep(satline,'E','3');
         end
         
         sat = sscanf(satline,'%d');
         satgps= find(sat>100 & sat<133);
            satgps = satgps - 100;
            satglo = find(sat>200 & sat<227);
            satglo = satglo - 200 + 32;
            satgal = find(sat>310 & sat<331);
            satgal = satgal - 300 + 48;
            sat=cat(1,satgps,satglo,satgal);
            
         for i=sat'
            ls = NaN(1,inf.obsno);
            if i>100
                for k=1:ceil(inf.obsno/5)
                    fgetl(fid);
                    linenum = linenum + 1;
                end
            else
                for k=1:ceil(inf.obsno/5)
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    for n=0:4
                        st = (16*n+1); fn = (16*(n+1)-2);
                        if fn<=length(tline)
                            tls= sscanf(tline(st:fn),'%f');
                            if ~isempty(tls)
                                ls((5*(k-1))+(n+1)) = tls;
                            end
                        end
                    end
                end
                %GPS
                if i<33
                    % P1
                    if (inf.seq.gps(1)==0) || (isnan(ls(inf.seq.gps(1))))
                            c1s(epochnum,i) = ls(inf.seq.gps(5));%dcb%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    else
                        p1s(epochnum,i) = ls(inf.seq.gps(1));
                    end
                    % P2
                    p2s(epochnum,i) = ls(inf.seq.gps(2));
                    % L1
                    l1s(epochnum,i) = ls(inf.seq.gps(3))*wavl(i,1);
                    % L2
                    l2s(epochnum,i) = ls(inf.seq.gps(4))*wavl(i,2);
                %GLO
                elseif i<59
                    % P1
                    if (inf.seq.glo(1)==0) || (isnan(ls(inf.seq.glo(1))))                        
                            c1s(epochnum,i) = ls(inf.seq.glo(5));%dcb%%%%%%%%%%%%%%%%%%%
                    else
                        p1s(epochnum,i) = ls(inf.seq.glo(1));
                    end
                    p2s(epochnum,i) = ls(inf.seq.glo(2));
                    l1s(epochnum,i) = ls(inf.seq.glo(3))*wavl(i,1);
                    l2s(epochnum,i) = ls(inf.seq.glo(4))*wavl(i,2);
                %GAL
                elseif i<89
                    c1s(epochnum,i) = ls(inf.seq.gal(1));
                    c5s(epochnum,i) = ls(inf.seq.gal(2));
                    l1s(epochnum,i) = ls(inf.seq.gal(3))*wavl(i,1);
                    l5s(epochnum,i) = ls(inf.seq.gal(4))*wavl(i,2);
                end
            end
         end
    end
if max>epochnum
    p1s(epochnum+1:max,:) = [];
    p2s(epochnum+1:max,:) = [];
    l1s(epochnum+1:max,:) = [];
    l2s(epochnum+1:max,:) = [];
    c1s(epochnum+1:max,:) = [];
    c5s(epochnum+1:max,:) = [];
    eps(epochnum+1:max,:) = [];
    st(epochnum+1:max,:) = [];
end

obs.p1 = p1s;
obs.p2 = p2s;
obs.l1 = l1s;
obs.l2 = l2s;
obs.c1 = c1s;
obs.c5 = c5s;
obs.ep = eps;
obs.st = st;
fclose('all');
end

