function [inf] = readrnx3(fileobs,bia)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[fid,errmsg] = fopen(fileobs);

if any(errmsg)
    error   ('OBS file has error !');
end

inf.time.last=[];
inf.time.leap = [];
inf.seq.gsort = cell(1,6);
inf.seq.rsort = cell(1,10);
inf.seq.esort = cell(1,10);
inf.seq.csort = cell(1,12);

while 1
    tline = fgetl(fid);
    tag  = strtrim(tline(61:end));
    switch tag
        case 'RINEX VERSION / TYPE'
            
            if strcmp(sscanf(tline(21:23),'%c'),'OBS')
                inf.rinex.type = sscanf(tline(21),'%c');
            else
                error   ('Obs file has errors');
            end
            
            inf.sat.system = sscanf(tline(41),'%c');
        case 'MARKER NAME'
            inf.rec.name = strtrim(tline(1:4));
        case 'REC # / TYPE / VERS'
            inf.rec.number  = strtrim(tline(1:20));
            inf.rec.type    = strtrim(tline(21:40));
            inf.rec.version = strtrim(tline(41:60));
        case 'ANT # / TYPE'
            inf.ant.number = strtrim(tline( 1:20));
            inf.ant.type   = strtrim(tline(21:40));
        
        case 'APPROX POSITION XYZ'
            inf.rec.pos= sscanf(tline(1:60),'%f',[1,3]);
       
        case 'ANTENNA: DELTA H/E/N'
            inf.ant.hen = sscanf(tline(1:60),'%f',[1,3]);
        
        case 'SYS / # / OBS TYPES'
            if strcmp(tline(1),'G') %GPS
                no = sscanf(tline(5:6),'%d');
                inf.nob.gps = no;
                if no<14
                    lst = sscanf(tline(8:60),'%s');
                else
                    l1 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l2 = sscanf(tline(8:60),'%s');
                    lst = strcat(l1,l2);%卫星数量较多时需要进行合并
                end
                inf.seq.gps = zeros(1,6);
                prior = 'PWCSLXYMNDIQX';
                % P1
                for pi = 1:13
                    if any(strfind(lst,strcat('C1',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.gsort(1) = {"C1" + s};
                        inf.seq.gps(1) = (strfind(lst,strcat('C1',prior(pi))) + 2)/3;
                        break
                    end
                end
                % P2
                for pi = 1:13
                    if any(strfind(lst,strcat('C2',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.gsort(2) = {"C2" + s};
                        inf.seq.gps(2) = (strfind(lst,strcat('C2',prior(pi))) + 2)/3;
                        break
                    end
                end
                 % P5
                for pi = 1:13
                    if any(strfind(lst,strcat('C5',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.gsort(3) = {"C5" + s};
                        inf.seq.gps(3) = (strfind(lst,strcat('C5',prior(pi))) + 2)/3;
                        break
                    end
                end
                % L1
                for pi = 1:13
                    if any(strfind(lst,strcat('L1',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.gsort(4) = {"L1" + s};
                        inf.seq.gps(4) = (strfind(lst,strcat('L1',prior(pi))) + 2)/3;
                        break
                    end
                end
                % L2
                for pi = 1:13
                    if any(strfind(lst,strcat('L2',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.gsort(5) = {"L2" + s};
                        inf.seq.gps(5) = (strfind(lst,strcat('L2',prior(pi))) + 2)/3;
                        break
                    end
                end
                % L5
                for pi = 1:13
                    if any(strfind(lst,strcat('L5',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.gsort(6) = {"L5" + s};
                        inf.seq.gps(6) = (strfind(lst,strcat('L5',prior(pi))) + 2)/3;
                        break
                    end
                end
            elseif strcmp(tline(1),'R') %GLONASS
                no = sscanf(tline(5:6),'%d');
                inf.nob.glo = no;
                if no<14
                    lst = sscanf(tline(8:60),'%s');
                else
                    l1 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l2 = sscanf(tline(8:60),'%s');
                    lst = strcat(l1,l2);
                end
                
                inf.seq.glo = zeros(1,10);
                prior = 'PCABIQX';
                % P1
                for pi = 1:7
                    if any(strfind(lst,strcat('C1',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.rsort(1) = {"C1" + s};
                        inf.seq.glo(1) = (strfind(lst,strcat('C1',prior(pi))) + 2)/3;
                        break
                    end
                end
                % P2
                for pi = 1:7
                    if any(strfind(lst,strcat('C2',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.rsort(2) = {"C2" + s};
                        inf.seq.glo(2) = (strfind(lst,strcat('C2',prior(pi))) + 2)/3;
                        break
                    end
                end
                 % P3
                for pi = 1:7
                    if any(strfind(lst,strcat('C3',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.rsort(3) = {"C3" + s};
                        inf.seq.glo(3) = (strfind(lst,strcat('C3',prior(pi))) + 2)/3;
                        break
                    end
                end
                % P1a
                for pi = 1:7
                    if any(strfind(lst,strcat('C4',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.rsort(4) = {"C4" + s};
                        inf.seq.glo(4) = (strfind(lst,strcat('C4',prior(pi))) + 2)/3;
                        break
                    end
                end
                % P2a
                for pi = 1:7
                    if any(strfind(lst,strcat('C6',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.rsort(5) = {"C6" + s};
                        inf.seq.glo(5) = (strfind(lst,strcat('C6',prior(pi))) + 2)/3;
                        break
                    end
                end
                % L1
                for pi = 1:7
                    s = prior(pi);
                    s = string(s);
                    inf.seq.rsort(6) = {"L1" + s};
                    if any(strfind(lst,strcat('L1',prior(pi))))
                        inf.seq.glo(6) = (strfind(lst,strcat('L1',prior(pi))) + 2)/3;
                        break
                    end
                end
                % L2
                for pi = 1:7
                    if any(strfind(lst,strcat('L2',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.rsort(7) = {"L2" + s};
                        inf.seq.glo(7) = (strfind(lst,strcat('L2',prior(pi))) + 2)/3;
                        break
                    end
                end
                % L3
                for pi = 1:7
                    if any(strfind(lst,strcat('L3',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.rsort(8) = {"L3" + s};
                        inf.seq.glo(8) = (strfind(lst,strcat('L3',prior(pi))) + 2)/3;
                        break
                    end
                end
                % L1a
                for pi = 1:7
                    if any(strfind(lst,strcat('L4',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.rsort(9) = {"L4" + s};
                        inf.seq.glo(9) = (strfind(lst,strcat('L4',prior(pi))) + 2)/3;
                        break
                    end
                end
                % L2a
                for pi = 1:7
                    if any(strfind(lst,strcat('L6',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.rsort(10) = {"L6" + s};
                        inf.seq.glo(10) = (strfind(lst,strcat('L6',prior(pi))) + 2)/3;
                        break
                    end
                end
            elseif strcmp(tline(1),'E') %GALILEO
                no = sscanf(tline(5:6),'%d');
                inf.nob.gal = no;
                if no<14
                    lst = sscanf(tline(8:60),'%s');
                else
                    l1 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l2 = sscanf(tline(8:60),'%s');
                    lst = strcat(l1,l2);
                end
                inf.seq.gal = zeros(1,10);
                prior1 = 'BCXAZ';
                prior5 = 'IQX';
                % P1
                for pi = 1:5
                    if any(strfind(lst,strcat('C1',prior1(pi))))
                        s = prior1(pi);
                        s = string(s);
                        inf.seq.esort(1) = {"C1" + s};
                        inf.seq.gal(1) = (strfind(lst,strcat('C1',prior1(pi))) + 2)/3;
                        break
                    end
                end
                % P5a
                for pi = 1:3
                    if any(strfind(lst,strcat('C5',prior5(pi))))
                        s = prior5(pi);
                        s = string(s);
                        inf.seq.esort(2) = {"C5" + s};
                        inf.seq.gal(2) = (strfind(lst,strcat('C5',prior5(pi))) + 2)/3;
                        break
                    end
                end
                 % P5b
                for pi = 1:3
                    if any(strfind(lst,strcat('C7',prior5(pi))))
                        s = prior5(pi);
                        s = string(s);
                        inf.seq.esort(3) = {"C7" + s};
                        inf.seq.gal(3) = (strfind(lst,strcat('C7',prior5(pi))) + 2)/3;
                        break
                    end
                end
                 % P5
                for pi = 1:3
                    if any(strfind(lst,strcat('C8',prior5(pi))))
                        s = prior5(pi);
                        s = string(s);
                        inf.seq.esort(4) = {"C8" + s};
                        inf.seq.gal(4) = (strfind(lst,strcat('C8',prior5(pi))) + 2)/3;
                        break
                    end
                end
                 % P6
                for pi = 1:5
                    if any(strfind(lst,strcat('C6',prior1(pi))))
                        s = prior1(pi);
                        s = string(s);
                        inf.seq.esort(5) = {"C6" + s};
                        inf.seq.gal(5) = (strfind(lst,strcat('C6',prior1(pi))) + 2)/3;
                        break
                    end
                end
                % L1
                for pi = 1:5
                    if any(strfind(lst,strcat('L1',prior1(pi))))
                        s = prior1(pi);
                        s = string(s);
                        inf.seq.esort(6) = {"L1" + s};
                        inf.seq.gal(6) = (strfind(lst,strcat('L1',prior1(pi))) + 2)/3;
                        break
                    end
                end
                % L5a
                for pi = 1:3
                    if any(strfind(lst,strcat('L5',prior5(pi))))
                        s = prior5(pi);
                        s = string(s);
                        inf.seq.esort(7) = {"L5" + s};
                        inf.seq.gal(7) = (strfind(lst,strcat('L5',prior5(pi))) + 2)/3;
                        break
                    end
                end
                % L5b
                for pi = 1:3
                    if any(strfind(lst,strcat('L7',prior5(pi))))
                        s = prior5(pi);
                        s = string(s);
                        inf.seq.esort(8) = {"L7" + s};
                        inf.seq.gal(8) = (strfind(lst,strcat('L7',prior5(pi))) + 2)/3;
                        break
                    end
                end
                % L5
                for pi = 1:3
                    if any(strfind(lst,strcat('L8',prior5(pi))))
                        s = prior5(pi);
                        s = string(s);
                        inf.seq.esort(9) = {"L8" + s};
                        inf.seq.gal(9) = (strfind(lst,strcat('L8',prior5(pi))) + 2)/3;
                        break
                    end
                end
                 % L6
                for pi = 1:5 
                    if any(strfind(lst,strcat('L6',prior1(pi))))
                        s = prior1(pi);
                        s = string(s);
                        inf.seq.esort(10) = {"L6" + s};
                        inf.seq.gal(10) = (strfind(lst,strcat('L6',prior1(pi))) + 2)/3;
                        break
                    end
                end
            elseif strcmp(tline(1),'C') %BEIDOU
                no = sscanf(tline(5:6),'%d');
                inf.nob.bds = no;
                if no<14
                    lst = sscanf(tline(8:60),'%s');
                else
                    l1 = sscanf(tline(8:60),'%s');
                    tline = fgetl(fid);
                    l2 = sscanf(tline(8:60),'%s');
                    lst = strcat(l1,l2);
                end
                
                inf.seq.bds = zeros(1,12);
                prior = 'DPZAIQX';
                % P1(B1C,B1A)(BDS3)
                for pi = 1:7
                    if any(strfind(lst,strcat('C1',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.csort(1) = {"C1" + s};
                        inf.seq.bds(1) = (strfind(lst,strcat('C1',prior(pi))) + 2)/3;
                    end
                end
                % P1(BDS2)(BDS3)
                for pi = 1:7
                    s = prior(pi);
                    s = string(s);
                    inf.seq.csort(2) = {"C2" + s};
                    if any(strfind(lst,strcat('C2',prior(pi))))
                        inf.seq.bds(2) = (strfind(lst,strcat('C2',prior(pi))) + 2)/3;
                    end
                end
                % P2a(BDS3)
                for pi = 1:7
                    if any(strfind(lst,strcat('C5',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.csort(3) = {"C5" + s};
                        inf.seq.bds(3) = (strfind(lst,strcat('C5',prior(pi))) + 2)/3;
                    end
                end
                % P2b(BDS2)
                for pi = 5:7
                    if any(strfind(lst,strcat('C7',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.csort(4) = {"C7" + s};
                        inf.seq.bds(4) = (strfind(lst,strcat('C7',prior(pi))) + 2)/3;
                        break
                    end
                end
                % P2b(BDS3)
                for pi = 1:3
                    if any(strfind(lst,strcat('C7',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.csort(5) = {"C7" + s};
                        inf.seq.bds(5) = (strfind(lst,strcat('C7',prior(pi))) + 2)/3;
                        break
                    end
                end
                % P3(BDS2)(BDS3)
                for pi = 1:7
                    if any(strfind(lst,strcat('C6',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.csort(6) = {"C6" + s};
                        inf.seq.bds(6) = (strfind(lst,strcat('C6',prior(pi))) + 2)/3;
                        break
                    end
                end
                % L1(B1C,B1A)(BDS3)
                for pi = 1:7
                    if any(strfind(lst,strcat('L1',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.csort(7) = {"L1" + s};
                        inf.seq.bds(7) = (strfind(lst,strcat('L1',prior(pi))) + 2)/3;
                    end
                end
                % L1(BDS2)(BDS3)
                for pi = 1:7
                    if any(strfind(lst,strcat('L2',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.csort(8) = {"L2" + s};
                        inf.seq.bds(8) = (strfind(lst,strcat('L2',prior(pi))) + 2)/3;
                    end
                end
                % L2a(BDS3)
                for pi = 1:7
                    if any(strfind(lst,strcat('L5',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.csort(9) = {"L5" + s};
                        inf.seq.bds(9) = (strfind(lst,strcat('L5',prior(pi))) + 2)/3;
                    end
                end
                % L2b(BDS2)
                for pi = 5:7
                    if any(strfind(lst,strcat('L7',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.csort(10) = {"L7" + s};
                        inf.seq.bds(10) = (strfind(lst,strcat('L7',prior(pi))) + 2)/3;
                        break
                    end
                end
                % L2b(BDS3)
                for pi = 1:3
                    if any(strfind(lst,strcat('L7',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.csort(11) = {"L7" + s};
                        inf.seq.bds(11) = (strfind(lst,strcat('L7',prior(pi))) + 2)/3;
                        break
                    end
                end
                % L3(BDS2)(BDS3)
                for pi = 1:7
                    if any(strfind(lst,strcat('L6',prior(pi))))
                        s = prior(pi);
                        s = string(s);
                        inf.seq.csort(12) = {"L6" + s};
                        inf.seq.bds(12) = (strfind(lst,strcat('L6',prior(pi))) + 2)/3;
                        break
                    end
                end
            end
        case 'INTERVAL'
            inf.time.int = sscanf(tline(1:10),'%f');
        case 'TIME OF FIRST OBS'
            inf.time.first  = sscanf(tline( 1:44),'%d',[1,6]);
            inf.time.system = sscanf(tline(45:60),'%s');
        case 'TIME OF LAST OBS'
            inf.time.last   = sscanf(tline( 1:44),'%d',[1,6]);
        case 'LEAP SECONDS'
            inf.time.leap = sscanf(tline(1:6),'%d');
        case 'END OF HEADER'
            break
    end
end

inf.time.int = 30;

if isempty(inf.time.leap)
    [~,mjd] = calmjd(inf.time.first(1),inf.time.first(2),inf.time.first(3),...
        (inf.time.first(4)*3600 + inf.time.first(5)*60 + inf.time.first(6)));
    inf.time.leap = leapsec(mjd);
    if strcmp(inf.time.system,'GPS')
        inf.time.leap = inf.time.leap - 19;
    elseif strcmp(inf.time.system,'BDS')
        inf.time.leap = inf.time.leap - 33;
    end
end

[doy] = caldoy(inf.time.first(1),inf.time.first(2),inf.time.first(3));
inf.time.doy = doy;

satnum= 152;
max = 2880;
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

inf.obs.p1s  = NaN(max,satnum);
inf.obs.p1as  = NaN(max,satnum);
inf.obs.p2s  = NaN(max,satnum);
inf.obs.p2as  = NaN(max,satnum);
inf.obs.p2bs  = NaN(max,satnum);
inf.obs.p3s  = NaN(max,satnum);
inf.obs.p5s  = NaN(max,satnum);
inf.obs.p5as  = NaN(max,satnum);
inf.obs.p5bs  = NaN(max,satnum);
inf.obs.p6s  = NaN(max,satnum);
inf.obs.l1s  = NaN(max,satnum);
inf.obs.l1as  = NaN(max,satnum);
inf.obs.l2s  = NaN(max,satnum);
inf.obs.l2as  = NaN(max,satnum);
inf.obs.l2bs  = NaN(max,satnum);
inf.obs.l3s  = NaN(max,satnum);
inf.obs.l5s  = NaN(max,satnum);
inf.obs.l5as  = NaN(max,satnum);
inf.obs.l5bs  = NaN(max,satnum);
inf.obs.l6s  = NaN(max,satnum);
inf.obs.eps  = NaN(max, 1);
% inf.obs.all2 = NaN(max,satnum,10);
% inf.obs.all3 = NaN(max,satnum,10);
% inf.obs.all4 = NaN(max,satnum,10);
c = 299792458;
inf.freq = zeros(satnum,5);
inf.wavl = zeros(satnum,5);
glok = [1 -4 5 6 1 -4 5 6 -2 -7 0 -1 -2 -7 0 -1 4 -3 3 2 4 -3 3 2 0 0];
for i=1:152
    if i<33     % GPS
        inf.freq(i,1) = 10.23*10^6*154;    %Hz L1
        inf.wavl(i,1) = c/(10.23*10^6*154);%m 波长
        inf.freq(i,2) = 10.23*10^6*120;    %Hz L2
        inf.wavl(i,2) = c/(10.23*10^6*120);%m 波长
        inf.freq(i,3) = 1176.45*10^6;    %Hz L5
        inf.wavl(i,3) = c/(1176.45*10^6);%m 波长
    elseif i<57 % GLONASS
        inf.freq(i,1) = (1602 + 0.5625*glok(i-32))*10^6;    %Hz G1
        inf.wavl(i,1) = c/((1602 + 0.5625*glok(i-32))*10^6);%m
        inf.freq(i,2) = 1600.995*10^6;    %Hz G1a
        inf.wavl(i,2) = c/(1600.995*10^6);%m
        inf.freq(i,3) = (1246 + 0.4375*glok(i-32))*10^6;    %Hz G2
        inf.wavl(i,3) = c/((1246 + 0.4375*glok(i-32))*10^6);%m
        inf.freq(i,4) = 1248.06*10^6;    %Hz G2a
        inf.wavl(i,4) = c/(1248.06*10^6);%m
        inf.freq(i,5) = 1202.025*10^6;    %Hz G3
        inf.wavl(i,5) = c/(1202.025*10^6);%m 波长
    elseif i<93 % GALILEO
        inf.freq(i,1) = 10.23*10^6*154;    %Hz E1
        inf.wavl(i,1) = c/(10.23*10^6*154);%m
        inf.freq(i,2) = 10.23*10^6*115;    %Hz E5a
        inf.wavl(i,2) = c/(10.23*10^6*115);%m
        inf.freq(i,3) = 1207.14*10^6;    %Hz E5b
        inf.wavl(i,3) = c/(1207.14*10^6);%m
        inf.freq(i,4) = 1191.795*10^6;    %Hz E5
        inf.wavl(i,4) = c/(1191.795*10^6);%m
        inf.freq(i,5) = 1278.75*10^6;    %Hz E6
        inf.wavl(i,5) = c/(1278.75*10^6);%m
    else        % BEIDOU
        inf.freq(i,1) = 10.23*10^6*152.6;    %Hz B1(BDS2,BDS3)
        inf.wavl(i,1) = c/(10.23*10^6*152.6);%m
        inf.freq(i,2) = 10.23*10^6*154;    %Hz B1(BDS3)
        inf.wavl(i,2) = c/(10.23*10^6*154);%m
        inf.freq(i,3) = 10.23*10^6*115; %Hz B2a
        inf.wavl(i,3) = c/(10.23*10^6*115);%m
        inf.freq(i,4) = 10.23*10^6*118; %Hz B2b
        inf.wavl(i,4) = c/(10.23*10^6*118);%m
        inf.freq(i,5) = 10.23*10^6*124; %Hz B3
        inf.wavl(i,5) = c/(10.23*10^6*124);%m
    end
end

epochnum = 1;
linenum  = 0; 
while ~feof(fid)
    tline = fgetl(fid);
    linenum   = linenum + 1;
    if ~isempty(tline) && strcmp(tline(1),'>') 
        nep  = sscanf(tline(3:end),'%f',[1,8]);
        inf.obs.eps(epochnum,1) = nep(4)*3600 + nep(5)*60 + nep(6); 
        for i=1:nep(8)
            tline=fgetl(fid);
%              if (size(tline,2)<64)
%                 error ('OBS file has format error!');
%              end
             linenum = linenum + 1;
            % GPS
            if strcmp(tline(1),'G')
                k = sscanf(tline(2:3),'%d'); 
                if k>32%GPS卫星共32颗
                    continue
                end
                ono = inf.nob.gps;
                lso = NaN(ono,1);
                nu  = 0; 
                for u=4:16:size(tline,2)
                    nu = nu + 1;
                    tls = sscanf(tline(u:u+13),'%f');
                    if ~isempty(tls)
                        lso(nu,1) = tls;
                    end
                end
%                 cell={p1s,p2s,p5s,l1s,l2s,l5s};
%                 for i=1:3
%                     cell{g}(epochnum,k)=lso(inf.seq.gps(g));
%                 end
%                 for a=4:6
%                     cell{g}(epochnum,k)=lso(inf.seq.gps(g))* wavl(k,1);
%                 end
                for g=1:3
                    switch g
                        case 1
                            if inf.seq.gps(g) ~= 0
                                a = inf.seq.gsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('CSLXPWYM',b);
                                inf.obs.p1s(epochnum,k)=lso(inf.seq.gps(g)) - bia.gps.c(k,1,c);
                            end
                        case 2
                            if inf.seq.gps(g) ~= 0
                                a = inf.seq.gsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('DSLXPWYM',b);
                                inf.obs.p2s(epochnum,k)=lso(inf.seq.gps(g)) - bia.gps.c(k,2,c);
                            end
                        case 3
                            if inf.seq.gps(g) ~= 0
                                a = inf.seq.gsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQX',b);
                                inf.obs.p5s(epochnum,k)=lso(inf.seq.gps(g)) - bia.gps.c(k,3,c);
                            end
                    end
                end
                 for g=4:6
                    switch g
                        case 4
                            if inf.seq.gps(g) ~= 0
                                a = inf.seq.gsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('CSLXPWYM',b);
                                inf.obs.l1s(epochnum,k)=lso(inf.seq.gps(g))* inf.wavl(k,1) - bia.gps.l(k,1,c);
                            end
                        case 5
                            if inf.seq.gps(g) ~= 0
                                a = inf.seq.gsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('DSLXPWYM',b);
                                inf.obs.l2s(epochnum,k)=lso(inf.seq.gps(g))* inf.wavl(k,2) - bia.gps.l(k,2,c);
                            end
                        case 6
                            if inf.seq.gps(g) ~= 0
                                a = inf.seq.gsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQX',b);
                                inf.obs.l5s(epochnum,k)=lso(inf.seq.gps(g))* inf.wavl(k,3) - bia.gps.l(k,3,c);
                            end
                    end
                end
 
                
            % GLONASS
             elseif strcmp(tline(1),'R')
                 k   = 32 + sscanf(tline(2:3),'%d'); 
                 q = k - 32;
                 if k>56
                     continue
                end
                ono = inf.nob.glo;              
                lso = NaN(ono,1);
                nu  = 0; 
                for u=4:16:size(tline,2)
                    nu = nu + 1;
                    tls = sscanf(tline(u:u+13),'%f');
                    if ~isempty(tls)
                        lso(nu,1) = tls;
                    end
                end
                % store the data
                for g=1:5
                    switch g
                        case 1
                            if inf.seq.glo(g) ~= 0
                                a = inf.seq.rsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('CP',b);
                                inf.obs.p1s(epochnum,k)=lso(inf.seq.glo(g)) - bia.glo.c(q,1,c);
                            end
                        case 2
                            if inf.seq.glo(g) ~= 0
                                a = inf.seq.rsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('CP',b);
                                inf.obs.p2s(epochnum,k)=lso(inf.seq.glo(g)) - bia.glo.c(q,3,c);
                            end
                        case 3
                            if inf.seq.glo(g) ~= 0
                                a = inf.seq.rsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQX',b);
                                inf.obs.p3s(epochnum,k)=lso(inf.seq.glo(g)) - bia.glo.c(q,5,c);
                            end
                        case 4
                            if inf.seq.glo(g) ~= 0
                                a = inf.seq.rsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('ABX',b);
                                inf.obs.p1as(epochnum,k)=lso(inf.seq.glo(g)) - bia.glo.c(q,2,c);
                            end
                        case 5
                            if inf.seq.glo(g) ~= 0
                                a = inf.seq.rsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('ABX',b);
                                inf.obs.p2as(epochnum,k)=lso(inf.seq.glo(g)) - bia.glo.c(q,4,c);
                            end
                    end
                end
                 for g=6:10
                    switch g
                        case 6
                            if inf.seq.glo(g) ~= 0
                                a = inf.seq.rsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('CP',b);
                                inf.obs.l1s(epochnum,k)=lso(inf.seq.glo(g))* inf.wavl(k,1) - bia.glo.l(q,1,c);
                            end
                        case 7
                            if inf.seq.glo(g) ~= 0
                                a = inf.seq.rsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('CP',b);
                                inf.obs.l2s(epochnum,k)=lso(inf.seq.glo(g))* inf.wavl(k,3) - bia.glo.l(q,3,c);
                            end
                        case 8
                            if inf.seq.glo(g) ~= 0
                                a = inf.seq.rsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQX',b);
                                inf.obs.l3s(epochnum,k)=lso(inf.seq.glo(g))* inf.wavl(k,5) - bia.glo.l(q,5,c);
                            end
                        case 9
                            if inf.seq.glo(g) ~= 0
                                a = inf.seq.rsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('ABX',b);
                                inf.obs.l1as(epochnum,k)=lso(inf.seq.glo(g))* inf.wavl(k,2) - bia.glo.l(q,2,c);
                            end
                        case 10
                            if inf.seq.glo(g) ~= 0
                                a = inf.seq.rsort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('ABX',b);
                                inf.obs.l2as(epochnum,k)=lso(inf.seq.glo(g))* inf.wavl(k,4) - bia.glo.l(q,4,c);
                            end
                    end
                 end
            % GALILEO
            elseif strcmp(tline(1),'E')
                k   = 56 + sscanf(tline(2:3),'%d');
                q = k - 56;
                if k>92
                    continue
                end
                ono = inf.nob.gal;               
                lso = NaN(ono,1);
                nu  = 0; 
                o = size(tline,2)-16;
%                 for
%                 u=4:16:size(tline,2)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for u=4:16:o
                    nu = nu + 1;
                    tls = sscanf(tline(u:u+13),'%f');
                    if ~isempty(tls)
                        lso(nu,1) = tls;
                    end
                end
                for g=1:5
                    switch g
                        case 1
                            if inf.seq.gal(g) ~= 0
                                a = inf.seq.esort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('ABCXZ',b);
                                inf.obs.p1s(epochnum,k)=lso(inf.seq.gal(g)) - bia.gal.c(q,1,c);
                            end
                        case 2
                            if inf.seq.gal(g) ~= 0
                                a = inf.seq.esort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQX',b);
                                inf.obs.p5as(epochnum,k)=lso(inf.seq.gal(g)) - bia.gal.c(q,2,c);
                            end
                        case 3
                            if inf.seq.gal(g) ~= 0
                                a = inf.seq.esort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQX',b);
                                inf.obs.p5bs(epochnum,k)=lso(inf.seq.gal(g)) - bia.gal.c(q,3,c);
                            end
                         case 4
                            if inf.seq.gal(g) ~= 0
                                a = inf.seq.esort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQX',b);
                                inf.obs.p5s(epochnum,k)=lso(inf.seq.gal(g)) - bia.gal.c(q,4,c);
                            end
                         case 5
                            if inf.seq.gal(g) ~= 0
                                a = inf.seq.esort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('ABCXZ',b);
                                inf.obs.p6s(epochnum,k)=lso(inf.seq.gal(g)) - bia.gal.c(q,5,c);
                            end
                    end
                end
                for g=6:10
                    switch g
                        case 6
                            if inf.seq.gal(g) ~= 0
                                a = inf.seq.esort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('ABCXZ',b);
                                inf.obs.l1s(epochnum,k)=lso(inf.seq.gal(g))* inf.wavl(k,1) - bia.gal.l(q,1,c);
                            end
                        case 7
                            if inf.seq.gal(g) ~= 0
                                a = inf.seq.esort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQX',b);
                                inf.obs.l5as(epochnum,k)=lso(inf.seq.gal(g))* inf.wavl(k,2) - bia.gal.l(q,2,c);
                            end
                        case 8
                            if inf.seq.gal(g) ~= 0
                                a = inf.seq.esort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQX',b);
                                inf.obs.l5bs(epochnum,k)=lso(inf.seq.gal(g))* inf.wavl(k,3) - bia.gal.l(q,3,c);
                            end
                         case 9
                            if inf.seq.gal(g) ~= 0
                                a = inf.seq.esort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQX',b);
                                inf.obs.l5s(epochnum,k)=lso(inf.seq.gal(g))* inf.wavl(k,4) - bia.gal.l(q,4,c);
                            end
                         case 10
                            if inf.seq.gal(g) ~= 0
                                a = inf.seq.esort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('ABCXZ',b);
                                inf.obs.l6s(epochnum,k)=lso(inf.seq.gal(g))* inf.wavl(k,5) - bia.gal.l(q,5,c);
                            end
                    end
                end
            % BEIDOU
            elseif strcmp(tline(1),'C')
                k   = 92 + sscanf(tline(2:3),'%d');
                q = k - 92;
                if k>152
                    continue
                end
                ono = inf.nob.bds;              
                lso = NaN(ono,1);
                nu  = 0; 
                for u=4:16:size(tline,2)
                    nu = nu + 1;
                    tls = sscanf(tline(u:u+13),'%f');
                    if ~isempty(tls)
                        lso(nu,1) = tls;
                    end
                end
                for g=1:6
                    switch g
                        case 1
                            if inf.seq.bds(g) ~= 0
                                a = inf.seq.csort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('DPXA',b);
                                inf.obs.p1s(epochnum,k)=lso(inf.seq.bds(g)) - bia.bds.c(q,2,c);
                            end
                        case 2
                            if inf.seq.bds(g) ~= 0
                                a = inf.seq.csort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQX',b);
                                inf.obs.p1as(epochnum,k)=lso(inf.seq.bds(g)) - bia.bds.c(q,1,c);
                            end
                        case 3
                            if inf.seq.bds(g) ~= 0
                                a = inf.seq.csort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('DPX',b);
                                inf.obs.p2as(epochnum,k)=lso(inf.seq.bds(g)) - bia.bds.c(q,3,c);
                            end
                        case 4
                            if inf.seq.bds(g) ~= 0
                                a = inf.seq.csort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQXDPZ',b);
                                inf.obs.p2bs(epochnum,k)=lso(inf.seq.bds(g)) - bia.bds.c(q,4,c);
                            end
                        case 5
                            if inf.seq.bds(g) ~= 0
                                a = inf.seq.csort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQXDPZ',b);
                                inf.obs.p2bs(epochnum,k)=lso(inf.seq.bds(g)) - bia.bds.c(q,4,c);
                            end
                        case 6
                            if inf.seq.bds(g) ~= 0
                                a = inf.seq.csort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQXA',b);
                                inf.obs.p3s(epochnum,k)=lso(inf.seq.bds(g)) - bia.bds.c(q,5,c);
                            end
                    end
                end
                for g=7:12
                    switch g
                        case 7
                            if inf.seq.bds(g) ~= 0
                                a = inf.seq.csort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('DPXA',b);
                                inf.obs.l1s(epochnum,k)=lso(inf.seq.bds(g))* inf.wavl(k,2) - bia.bds.l(q,2,c);
                            end
                        case 8
                            if inf.seq.bds(g) ~= 0
                                a = inf.seq.csort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQX',b);
                                inf.obs.l1as(epochnum,k)=lso(inf.seq.bds(g))* inf.wavl(k,1) - bia.bds.l(q,1,c);
                            end
                        case 9
                            if inf.seq.bds(g) ~= 0
                                a = inf.seq.csort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('DPX',b);
                                inf.obs.l2as(epochnum,k)=lso(inf.seq.bds(g))* inf.wavl(k,3) - bia.bds.l(q,3,c);
                            end
                        case 10
                            if inf.seq.bds(g) ~= 0
                                a = inf.seq.csort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQXDPZ',b);
                                inf.obs.l2bs(epochnum,k)=lso(inf.seq.bds(g))* inf.wavl(k,4) - bia.bds.l(q,4,c);
                            end
                        case 11
                            if inf.seq.bds(g) ~= 0
                                a = inf.seq.csort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQXDPZ',b);
                                inf.obs.l2bs(epochnum,k)=lso(inf.seq.bds(g))* inf.wavl(k,4) - bia.bds.l(q,4,c);
                            end
                        case 12
                            if inf.seq.bds(g) ~= 0
                                a = inf.seq.csort{g};
                                a = char(a);
                                b = strtrim(a(3));
                                c = strfind('IQXA',b);
                                inf.obs.l3s(epochnum,k)=lso(inf.seq.bds(g))* inf.wavl(k,5) - bia.bds.l(q,5,c);
                            end
                    end
                end
            end
        end
        epochnum=epochnum+1;
    end
end
                
if max>epochnum
    inf.obs.p1s(epochnum+1:max,:) = [];
    inf.obs.p1as(epochnum+1:max,:) = [];
    inf.obs.p2s(epochnum+1:max,:) = [];
    inf.obs.p2as(epochnum+1:max,:) = [];
    inf.obs.p3s(epochnum+1:max,:) = [];
    inf.obs.p5s(epochnum+1:max,:) = [];
    inf.obs.p5as(epochnum+1:max,:) = [];
    inf.obs.p5bs(epochnum+1:max,:) = [];
    inf.obs.p6s(epochnum+1:max,:) = [];
    inf.obs.l1s(epochnum+1:max,:) = [];
    inf.obs.l1as(epochnum+1:max,:) = [];
    inf.obs.l2s(epochnum+1:max,:) = [];
    inf.obs.l2as(epochnum+1:max,:) = [];
    inf.obs.l3s(epochnum+1:max,:) = [];
    inf.obs.l5s(epochnum+1:max,:) = [];
    inf.obs.l5as(epochnum+1:max,:) = [];
    inf.obs.l5bs(epochnum+1:max,:) = [];
    inf.obs.l6s(epochnum+1:max,:) = [];
    inf.obs.eps(epochnum+1:max,:) = [];
end

fclose('all');
end








