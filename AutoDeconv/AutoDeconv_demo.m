clc; clear all; close all;

%% Load images
files=dir('Test images\*.png');
filenames = {files.name};
filenames = natsortfiles(filenames);

counter1 = waitbar(0,'loading raw images...');
specs_raw = [];
for i = 1:length(filenames)
    waitbar(i/length(filenames), counter1);
%     disp(i)
    filename = filenames{i};
    image = im2double(imread(['Test images\',filename]));
    image = sum(image,3)/3;
    dims = size(image);
%     specs_res(:,i) = image(:)*peak_I(i);
    specs_raw(:,i) = image(:); 
end
close(counter1);

%% Perform auto-deconv operation
deconv_images = [];
blurs = [];
new_blurs = [];

tic
counter2 = waitbar(0,'auto-deconving...');
for i = 1:size(specs_raw,2)
    waitbar(i/size(specs_raw,2), counter2);
    mz = 1:size(specs_raw,2);
    image = ion_image(mz(i),mz,specs_raw,dims,0,'magma');
    try
        [J,blur,new_blur] = AutoDeconv(image);
    catch
        warning([(filenames{i}),' was not deconvolvable!'])
    end
    deconv_images = cat(3,deconv_images,J);
    blurs(i) = mean(blur);
    new_blurs(i) = mean(new_blur);
end
close(counter2);
toc

%% display & save output
TIC_image_res = sum(deconv_images,3);
TIC_image_raw = TICimg(specs_raw,dims,0);
figure
subplot(1,2,1)
imagesc(TIC_image_raw);axis image;colormap('magma')
title('RAW')

subplot(1,2,2)
imagesc(TIC_image_res);axis image;colormap('magma')
title('DECONVOLVED')

counter3 = waitbar(0,'converting to images...');
if exist('output_images','dir')==0
    mkdir('output_images')
end
for i = 1:length(mz)
    waitbar(i/length(mz), counter3);
    Img = deconv_images(:,:,i);
    Img = Img/max(Img(:));
    rgb = cat(3,Img,Img,Img);
    I_name = filenames{i};
    imwrite(rgb,['output_images\',I_name,'.png'])
end
close(counter3);
