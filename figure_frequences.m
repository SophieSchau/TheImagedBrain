clear all
%input image
imp=rgb2gray(imread('Einstein_square.jpg'));

imp_fft=fftshift(fftn(fftshift(imp)));

imp_trunc=zeros(size(imp_fft));

for k=0:size(imp_fft,1)/2-1
       imp_trunc(end/2-k:end/2+k,end/2-k:end/2+k)=imp_fft(end/2-k:end/2+k,end/2-k:end/2+k);
        imagesc(abs(ifftshift(ifftn(ifftshift(imp_trunc))))); colormap gray; axis off
        pause(0.2)
end

%[u,s,v]=svd(single(imp));

% figure;
% for k=2:size(s,1)
% s_trunc=s;
% s_trunc(k:end,k:end)=0;
% imagesc(u*s_trunc*v')
% pause(0.1)
% end