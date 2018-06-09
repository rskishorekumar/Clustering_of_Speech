
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Unsupervised pattern discovery in speech document
% using connected componant and the Angle histogram based approach.

% Author: R Kishore Kumar
% Email : rskishorekumar@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clear;
clc;

filename1 = '../script/spkList_demo_2';
delimiter1 = '';
formatSpec1 = '%s%[^\n\r]';
fileID1 = fopen(filename1,'r');
dataArray1 = textscan(fileID1, formatSpec1, 'Delimiter', delimiter1,  'ReturnOnError', false);
fclose(fileID1);
spkList1 = dataArray1{:, 1};
clearvars filename1 delimiter1 formatSpec1 fileID1 dataArray1 ans;


for t = 1:size(spkList1,1)
    twav='../WAV/';
    twFinal=strcat(twav,spkList1(t),'.wav');
    tPost='../posterior/MFCC/';
    tpFinal=strcat(tPost,spkList1(t),'.post');
    for q = (t+1):size(spkList1,1)
        qwav='../WAV/';
        qwFinal=strcat(qwav,spkList1(q),'.wav');
        qPost='../posterior/MFCC/';
        qpFinal=strcat(qPost,spkList1(q),'.post');
        [qa1,qfs] = audioread(char(qwFinal));
        [ta1,tfs] = audioread(char(twFinal));
        lamda=0.0001;
        ud = 0.1270;
        tp1=load(char(tpFinal));
        qp1=load(char(qpFinal));
        tp3=(1-lamda)*tp1+lamda*ud;
        qp3=(1-lamda)*qp1+lamda*ud;
        D=[];
        tp4 = tp3';
        qp4 = qp3';
        D= newnomKLSDiv(tp4,qp4);
               

        BW = edge(D,'Canny');
        F = imfill(BW,'holes');
        se = strel('disk',1);
        closeBW = imclose(F,se);
        BW2 = bwareaopen(closeBW, 75);
         
 
        Frame_size = 25;  %Input: Frame-size in millisecond
        Frame_shift = 10; %Input: Frame-shift in millisecond
        window_period=Frame_size/1000;
        shift_period=Frame_shift/1000;
        [rows,cols] = size(BW2);

        B1 = imclearborder(BW2);
        %imshow(BW2);
        %imshow(img);
        se = strel('line',5,115);
        dilateddBW = imdilate(B1,se);
        img= imerode(dilateddBW,se);
        BW3 = bwareaopen(img, 180);
        
     
        imageStats = regionprops(BW3,'all');
        compNumber = size(imageStats);
        for i=1:compNumber % to compare sizes of connected components
            box1 = imageStats(i).SubarrayIdx;
            box2 = box1{1,1};
            rowstart = box2(1,1);
            box4 = size(box2);
            box5 = box2(1,box4);
            rowend = box5(1,2);
            
            box6 = box1{1,2};
            colstart = box6(1,1);
            box7 = size(box6);
            box8 = box6(1,box7);
            colend = box8(1,2);
            
            C = BW3(rowstart:rowend,colstart:colend); %first row, and second col
            Frame_size = 25;  %Input: Frame-size in millisecond
            Frame_shift = 10; %Input: Frame-shift in millisecond
            window_period=Frame_size/1000;
            shift_period=Frame_shift/1000;
            [rows,cols] = size(C);
            
            Frame_size = 25;  %Input: Frame-size in millisecond
            Frame_shift = 10; %Input: Frame-shift in millisecond
            window_period=Frame_size/1000;
            shift_period=Frame_shift/1000;
            %[rows,cols] = size(C);
            %t
            match1 = 1/qfs:shift_period:(rowend*shift_period);
            %q
            match2 = 1/qfs:shift_period:(colend*shift_period);
            [~,ang] = imgradient(C);
            %figure, imshow(ang, []), title('Gradient direction') 
            angg1 = reshape(ang, 1, []);
            B = sort(angg1);
            B1 = find(B < 0);
            B2 = B(1,1:length(B1));
            [V1,V2]=hist(B2,20);
            
            V11 = find(V2 < -130);
            TF = isempty(V11);
            if(TF==1)
                continue;
            end
            hig1 = V1(length(V11));
            hig2 = max(V1(V1<max(V1)));
            res = abs(hig1 - hig2);
            res1 = abs(rowend-rowstart);            
            if(res>=130 && res1>=62)
                 fprintf('Time match in %d is %f to %f and Time match in %d is %f to %f res %d res1 %d \n', t,match1(rowstart),match1(length(match1())),q,match2(colstart),match2(length(match2())),res,res1);
            end

        end
       
    end
end


