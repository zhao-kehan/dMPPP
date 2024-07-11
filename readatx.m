function [atx] = readatx(fileatx,inf)
%UNTITLED2 此处显示有关此函数的摘要
%有些精密卫星星历已经进行了PCV改正（仅卫星），需要看一下
[fid,errmsg] = fopen(fileatx);

if any(errmsg)
    error   ('ATX file has error');
end

sat_neu = zeros(152,3,5);
rcv_neu = zeros(1,3,18);
sat_pcv = zeros(152,5,19);
rcv_pcv = zeros(18,73,19);

linenum=0;
while ~feof(fid)
    tline = fgetl(fid);
    linenum = linenum + 1;
    tag = strtrim(tline(61:end));
    if strcmp(tag,'START OF ANTENNA')%天线部分开始
        tline = fgetl(fid);
        linenum = linenum + 1;
        tag = strtrim(tline(61:end));
%         if strcmp(tag,'ZEN1 / ZEN2 / DZEN')
%             zen1 = strtrim(tline(6:8));
%             zen2 = strtrim(tline(11:14));
%             dzen = strtrim(tline(18:20));
%             num = ((zen2-zen1)/dzen)+1;
%         end
        %GPS卫星天线
        if strcmp(tag,'TYPE / SERIAL NO') && strcmp(tline(21),'G')
            sat_no = sscanf(tline(22:23),'%d');
            if sat_no>32
                continue
            end
            while ~strcmp(tag,'END OF ANTENNA')
                tline = fgetl(fid);
                linenum = linenum + 1;
                tag = strtrim(tline(61:end));
                if strcmp(tag,'ZEN1 / ZEN2 / DZEN')
                    zen1 = sscanf(tline(6:8),'%d');
                    zen2 = sscanf(tline(11:14),'%d');
                    dzen = sscanf(tline(18:20),'%d');
                    num = ((zen2-zen1)/dzen);
                end
                if strcmp(tag,'DAZI')
                    d = sscanf(tline(6:8),'%f');
                end
                %一个频率的开始
                if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'G01')
                    if d ~= 0
                        continue
                    end
                    frq_no = 1; %L1
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'G02')
                    if d ~= 0
                        continue
                    end
                    frq_no = 2; %L2
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'G05')
                    if d ~= 0
                        continue
                    end
                    frq_no = 3; %L5
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                end
            end
        %GLONASS卫星天线
        elseif strcmp(tag,'TYPE / SERIAL NO') && strcmp(tline(21),'R')
            sat_no = 32 + sscanf(tline(22:23),'%d');
            if sat_no>56 
                continue
            end
            while ~strcmp(tag,'END OF ANTENNA')
                tline = fgetl(fid);
                linenum = linenum + 1;
                tag = strtrim(tline(61:end));
                if strcmp(tag,'ZEN1 / ZEN2 / DZEN')
                    zen1 = sscanf(tline(6:8),'%d');
                    zen2 = sscanf(tline(11:14),'%d');
                    dzen = sscanf(tline(18:20),'%d');
                    num = ((zen2-zen1)/dzen);
                end
                if strcmp(tag,'DAZI')
                    d = sscanf(tline(6:8),'%f');
                end
                if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'R01')
                    if d ~= 0
                        continue
                    end
                    frq_no = 1; %G1
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'R02')
                    if d ~= 0
                        continue
                    end
                    frq_no = 2; %G2
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                end
            end
        %Galileo卫星天线
        elseif strcmp(tag,'TYPE / SERIAL NO') && strcmp(tline(21),'E')
            sat_no = 56 + sscanf(tline(22:23),'%d');
            if sat_no>92
                continue
            end
            while ~strcmp(tag,'END OF ANTENNA')
                tline = fgetl(fid);
                linenum = linenum + 1;
                tag = strtrim(tline(61:end));
                if strcmp(tag,'ZEN1 / ZEN2 / DZEN')
                    zen1 = sscanf(tline(6:8),'%d');
                    zen2 = sscanf(tline(11:14),'%d');
                    dzen = sscanf(tline(18:20),'%d');
                    num = ((zen2-zen1)/dzen);
                end
                if strcmp(tag,'DAZI')
                    d = sscanf(tline(6:8),'%f');
                end
                if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E01')
                    if d ~= 0
                        continue
                    end
                    frq_no = 1; %E1
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E05')
                    if d ~= 0
                        continue
                    end
                    frq_no = 2; %E5a
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E07')
                    if d ~= 0
                        continue
                    end
                    frq_no = 3; %E5b
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E08')
                    if d ~= 0
                        continue
                    end
                    frq_no = 4; %E5
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E06')
                    if d ~= 0
                        continue
                    end
                    frq_no = 5; %E6
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                end
            end
        %BDS卫星天线
        elseif strcmp(tag,'TYPE / SERIAL NO') && strcmp(tline(21),'C')
            sat_no = 92 + sscanf(tline(22:23),'%d');
            if sat_no>152
                continue
            end
            while ~strcmp(tag,'END OF ANTENNA')
                tline = fgetl(fid);
                linenum = linenum + 1;
                tag = strtrim(tline(61:end));
                if strcmp(tag,'ZEN1 / ZEN2 / DZEN')
                    zen1 = sscanf(tline(6:8),'%d');
                    zen2 = sscanf(tline(11:14),'%d');
                    dzen = sscanf(tline(18:20),'%d');
                    num = ((zen2-zen1)/dzen);
                end
                if strcmp(tag,'DAZI')
                    d = sscanf(tline(6:8),'%f');
                end
                if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C01')
                    if d ~= 0
                        continue
                    end
                    frq_no = 1; %B1c
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C02')
                    if d ~= 0
                        continue
                    end
                    frq_no = 2; %B1
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C05')
                    if d ~= 0
                        continue
                    end
                    frq_no = 3; %B2a
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C06')
                    if d ~= 0
                        continue
                    end
                    frq_no = 4; %B3
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C07')
                    if d ~= 0
                        continue
                    end
                    frq_no = 5; %B2
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        for i=(zen1/dzen)+1:(zen1/dzen)+1+num
                            sat_pcv(sat_no,frq_no,i) = sscanf(tline(12+(i-1)*8:16+(i-1)*8),'%f');
                        end
                    end
                end
            end
        %接收机天线
        elseif strcmp(tag,'TYPE / SERIAL NO') && strcmp(strtrim(tline(1:20)),inf.ant.type)
            while ~strcmp(tag,'END OF ANTENNA')
                tline = fgetl(fid);
                linenum = linenum + 1;
                tag = strtrim(tline(61:end));
                if strcmp(tag,'DAZI')
                    dazi = sscanf(tline(6:8),'%d');
                end
                if strcmp(tag,'ZEN1 / ZEN2 / DZEN')
                    Zen1 = sscanf(tline(6:8),'%d');
                    Zen2 = sscanf(tline(11:14),'%d');
                    Dzen = sscanf(tline(18:20),'%d');
                    Num = ((Zen2-Zen1)/Dzen);
                end
                if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'G01')
                    frq_no = 1; %L1
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                        tline = fgetl(fid);
                        linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'G02')
                    frq_no = 2; %L2
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'G05')
                    frq_no = 3; %L5
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'R01')
                    frq_no = 4; %G1
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'R02')
                    frq_no = 5; %G2
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E01')
                    frq_no = 6; %E1
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E05')
                    frq_no = 7; %E5a
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                    elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E07')
                    frq_no = 8; %E5b
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E08')
                    frq_no = 9; %E5
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E06')
                    frq_no = 10; %E6
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C01')
                    frq_no = 11; %B1c
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C02')
                    frq_no = 12; %B1
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C05')
                    frq_no = 13; %B2a
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C06')
                    frq_no = 14; %B3
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C07')
                    frq_no = 15; %B2
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        rcv_neu(1,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    if strcmp(tline(4:8),'NOAZI')
                         tline = fgetl(fid);
                         linenum = linenum + 1;
                        for x = 1:360/dazi+1
                            for y = (Zen1/Dzen)+1:(Zen1/Dzen)+1+Num
                                rcv_pcv(frq_no,x,y) = sscanf(tline(12+(y-1)*8:16+(y-1)*8),'%f');
                            end
                            tline = fgetl(fid);
                            linenum = linenum + 1;
                        end
                    end
                end
            end
        end
    else
        continue
    end
end

atx.sat.neu = sat_neu./1000;
atx.rcv.neu = rcv_neu./1000;
atx.sat.pcv = sat_pcv./1000;
atx.rcv.pcv = rcv_pcv./1000;
atx.rcv.DAZI = dazi;
atx.rcv.DZEN = Dzen;

fclose('all');

end

