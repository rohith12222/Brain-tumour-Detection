I=imread("Brain 2.jpeg");%input image
imshow(I);
[ht, wd, co]=size(I);%preprocessing
if co<3
A=imadjust(I,[0.5 0.8],[]);
else
A=imadjust(rgb2gray(I),[0.5 0.8],[]);
end
figure,imshow(A);

to=imresize(A,[256,256]);%Thresholding operation
t0=60;
th=t0+((max(A(:))+min(A(:)))./2);
for i=1:1:size(A,1)
for j=1:1:size(A,2)
if A(i,j)>th
 to(i,j)=1;
else
 to(i,j)=0;
end 
end
end
label=bwlabel(to);%Morphological operation
stats=regionprops(logical(to),'Solidity','Area','BoundingBox');
density=[stats.Solidity];
area=[stats.Area];
high_dense_area=density>0.6;
max_area=max(area(high_dense_area));
tumor_label=find(area==max_area);
tumor=ismember(label,tumor_label);
if max_area>150
 figure;
 title('Bounding Box','FontSize',20);
 imshow(tumor)
 title('tumor alone','FontSize',20);
else 
 h = msgbox('No Tumor!!','status'); 
%disp('no tumor');
return;
end
box = stats(tumor_label);%%Detection using Box
wantedBox = box.BoundingBox;
figure
imshow(A);

hold on;
rectangle('Position',wantedBox,'EdgeColor','y');
hold off;
dilationAmount = 5;
rad = floor(dilationAmount);
[r,c] = size(tumor);
filledImage = imfill(tumor, 'holes');
for i=1:r
for j=1:c
 x1=i-rad;
 x2=i+rad;
 y1=j-rad;
 y2=j+rad;
if x1<1
 x1=1;
end
if x2>r
 x2=r;
end
if y1<1
 y1=1;
end
if y2>c
 y2=c;
end
 erodedImage(i,j) = min(min(filledImage(x1:x2,y1:y2)));
end
end
title('eroded image','FontSize',20);
figure
imshow(erodedImage);
tumorOutline=tumor; 
tumorOutline(erodedImage)=0; 
figure;   
imshow(tumorOutline); 
title('Tumor Outline','FontSize',20); 
rgb = A(:,:,[1 1 1]); %% Highlighting the tumor
red = rgb(:,:,1); 
red(tumorOutline)=255; 
green = rgb(:,:,2); 
green(tumorOutline)=0; 
blue = rgb(:,:,3); 
blue(tumorOutline)=0; 
tumorOutlineInserted(:,:,1) = red;  
tumorOutlineInserted(:,:,2) = green;  
tumorOutlineInserted(:,:,3) = blue; 
figure 
imshow(tumorOutlineInserted); 
title('Detected Tumor','FontSize',20);