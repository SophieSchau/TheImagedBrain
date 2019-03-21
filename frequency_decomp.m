clear all
%%
%Define key pressed
global KEY_PRESSED
 
%%
%input image
imp=rgb2gray(imread('Einstein_square.jpg'));
 
%%
%Set empty arrays
imp_trunc_fft=zeros(size(imp));
imp_trunc_img=zeros(size(imp));
 
%Define spiral index of image
spiral_mat=spiral(size(imp,1));
%Get centre of k space by circshifting
spiral_mat=circshift(spiral_mat,[1,1]);
 
%Perform fourier transform of input data
imp_fft=fftshift(fftn(fftshift(imp)));
 
%%
hFigure=figure('WindowStyle','Normal','MenuBar', 'none', 'ToolBar', 'none'); colormap gray; axis off,  
%set(hFigure,'WindowState','FullScreen');
set(hFigure, 'KeyPressFcn', @myKeyPressFcn);
dim  = [0,0,0.5,0.5];
 
mode_='0'
str=''
 
%loop through entire array pixel by pixel
k=1;
n=0;
while 1
        if KEY_PRESSED == 'e'
            mode_ = 'e';
        end
        if strcmp(str,'c')==1
            mode_ = 'c';
        end
        if strcmp(str,'r')==1
            mode_='r';
        end
        if KEY_PRESSED == 'r'
            mode_='r';
        end
        
        if mode_ == 'r';
            n=10;
            %Create fourier image with single frequency component
            imp_single_fft=zeros(size(imp_fft));
            imp_single_fft(spiral_mat >= k+n & spiral_mat <= k+n)=imp_fft(spiral_mat >= k+n & spiral_mat <= k+n);
            %add fourier component to combined image
            imp_trunc_fft(spiral_mat >= k & spiral_mat <= k+n)=imp_fft(spiral_mat >= k & spiral_mat <= k+n);
            %Transform into image
            imp_trunc=abs(ifftshift(ifftn(ifftshift(imp_trunc_fft))));
            imp_single=real(ifftshift(ifftn(ifftshift(imp_single_fft))));
            %Plot image
            subplot(1,2,1);imagesc(imp_single)
            subplot(1,2,2);imagesc(imp_trunc)
            k=k+1+n 
        elseif mode_ == 'e';
            %Create fourier image with single frequency component
            imp_single_fft=zeros(size(imp_fft));
            imp_single_fft(spiral_mat >= k & spiral_mat <= k+n)=imp_fft(spiral_mat >= k & spiral_mat <= k+n);
            %add fourier component to combined image
            imp_trunc_fft(spiral_mat >= k & spiral_mat <= k+n)=imp_fft(spiral_mat >= k & spiral_mat <= k+n);
            %Transform into image
            imp_trunc=abs(ifftshift(ifftn(ifftshift(imp_trunc_fft))));
            imp_single=real(ifftshift(ifftn(ifftshift(imp_single_fft))));
            %Plot image
            subplot(1,2,1);imagesc(imp_single)
            subplot(1,2,2);imagesc(imp_trunc)
            while 1
                str = input('','s');
                if strcmp(str,'r')==1 || strcmp(str,'c')==1 || isempty(str)
                    break
                end
            end
            k=k+1+n         
        elseif mode_ == 'c';
            %Create fourier image with single frequency component
            imp_single_fft=zeros(size(imp_fft));
            imp_single_fft(spiral_mat >= k & spiral_mat <= k+n)=imp_fft(spiral_mat >= k & spiral_mat <= k+n);
            %add fourier component to combined image
            imp_trunc_fft(spiral_mat >= k & spiral_mat <= k+n)=imp_fft(spiral_mat >= k & spiral_mat <= k+n);
            %Transform into image
            imp_trunc=abs(ifftshift(ifftn(ifftshift(imp_trunc_fft))));
            imp_single=real(ifftshift(ifftn(ifftshift(imp_single_fft))));
            %Plot image
            subplot(1,2,1);imagesc(imp_single); colormap gray
            subplot(1,2,2);imagesc(imp_trunc); colormap gray
            axis image
            pause(0.1)
            k=k+1+n 
        end          
 
                
        drawnow
        
end
 
 
function myKeyPressFcn(hObject, event)
 
    global KEY_PRESSED
 
    KEY_PRESSED = event.Character;
 
end
