clear all
%%
%This will generate the fourier transform image to be used with the
%projector!
%%
%Define path to image
path_img='';
%Define downsampling factor
ds=0.5;
%%
%Load in image and convert to double
img=double(imread(path_img));
%Convert to grayscale
if ndims(img) == 3
    img=rgb2gray(img);
end
%Downsample image
img=imresize(img,ds);
%%
%Demean input
img_demeaned = img - mean(img(:));
%%
%Perform fourier transform
fft_img = fftshift(fft2(fftshift(img_demeaned)));
%%
%Convert from complex to real and imaginary channels
output=zeros([size(fft_img),3]);
output(:,:,1)=real(fft_img);
output(:,:,2)=imag(fft_img);
%%
%Remove negative offset, leaving third channel blank. Can you think of a
%good use for the third channel?
output(:,:,1:2)=output(:,:,1:2)-min(output(:));
%Normalise
output(:,:,1:2)=output(:,:,1:2)/max(output(:));
%%
%plot image
figure;imagesc(output); axis off;