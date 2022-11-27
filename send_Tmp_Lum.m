Xmess=[];
Sdirectory='';
sensed_data=table;

writeChId = 1957469; 
writeKey = 'Z5NNDS7WFIE6US1X';

lum_tmp_data=[];
%Please check the correct port according to serial arduino use
id_com='COM3';
id = instrfind('port', id_com) ;
delete(id);
clear id;
s = serial(id_com,'Terminator','CR');
fopen(s);
Xmess=sprintf('Serial State= %s Tranfert=%s',s.status,s.TransferStatus);
display(Xmess,'');

Timeout=30;

%line = fgetl(s);
%line

th=hour(datetime('now'));
line=fgetl(s);
%isempty(line)
j=1;
while s.BytesAvailable>0
    %s.timeout
    
    
    reading = fgetl(s);
    analog_lum=str2double(reading);
    fgetl(s);
    reading=fgetl(s);
    val_lum=str2double(reading);

    meas=fscanf(s);    
    reading=fscanf(s);
    analog_tmp=str2double(reading);
    meas=fscanf(s);
    meas=fscanf(s);
    meas=fscanf(s);
    reading=fscanf(s);
    val_tmp_c=str2double(reading);
    meas=fscanf(s);
    meas=fscanf(s);
    meas=fscanf(s);
    Xmess=sprintf('analog_Lum= %f lum=%f(Lumen) analog_tmp= %f tmp=%f(c)',analog_lum,val_lum,analog_tmp,val_tmp_c);
    display(Xmess,'');
    meas=fscanf(s);
    
    tStamp = datetime('now');
    response = thingSpeakWrite(writeChId,[analog_lum,val_lum,analog_tmp,val_tmp_c],'Fields',[1,2,3,4],'Writekey',writeKey,'TimeStamps',tStamp,'Timeout',Timeout);
    pause(15);
    warning('off','all');
    sensed_data.Analog_lum{j,1}=analog_lum;
    sensed_data.Val_lum{j,1}=val_lum;
    sensed_data.Analog_Temp{j,1}=analog_tmp;
    sensed_data.Val_Temp_c{j,1}=val_tmp_c;
    warning('on','all');
    j=j+1;
    th_new=hour(datetime('now'));
    if(th_new>th)
        t=datetime('now','Format','dd-MMM-y HH ');
        str=datestr(t);
        newStr = strrep(str,':','-');
        Sdirectory='./Data_lum_tmp';
        [~,MESSAGE,~] =mkdir(Sdirectory);
        Xdisp = strcat(Sdirectory,'/data_',newStr);        
        %disp(Xdisp);
        save(Xdisp,'sensed_data');
        Xdisp = strcat('Save base in ',Xdisp);
        display(Xdisp,'');
        
        sensed_data=[];
        j=1;
        th=hour(datetime('now'));        
    end
    %isempty(line)
end

t=datetime('now','Format','dd-MMM-y HH-mm-ss ');
str=datestr(t);
newStr = strrep(str,':','-');
Sdirectory='./Data_lum_tmp';
[~,MESSAGE,~] =mkdir(Sdirectory);
Xdisp = strcat(Sdirectory,'/data_',newStr)
%disp(Xdisp);
save(Xdisp,'sensed_data');
Xdisp = strcat('Save base in ',Xdisp);
display(Xdisp,'');



fclose(s);
delete(s);
clear s;