%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main script to run whilst running the stall (The Imaged Brain)
%
% Recquires MATLAB Support Package for USB Webcams
%
% Sophie Schauman, Benjamin Tendler, Stuart Clare
% 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

global KEY_PRESSED


% Choose camera to use
camlist=webcamlist;
for n=1:length(camlist)
    fprintf("%d %s\n",n,camlist{n});
end
n=input('Select camera...');
cam = webcam(n); 

% setup window

hFigure=figure('WindowStyle','Normal','MenuBar', 'none', 'ToolBar', 'none');
set(hFigure,'WindowState','FullScreen');
set(hFigure, 'KeyPressFcn', @myKeyPressFcn);
dim  = [0,0,0.5,0.5];
han = annotation(hFigure, 'textbox', dim, 'String', '(s)etup   (f)ourier transform   (t)eaching tool (w)aves (r)eset waves  (q)uit', ...
    'VerticalAlignment', 'bottom', 'FitBoxToText', 'on', 'fontsize',18);

mode='s'; %setup

%%

while 1 % programme running - check for key presses
    
    if KEY_PRESSED == 's' %SETUP
        
        mode='s';
        
    elseif KEY_PRESSED == 'f' %FOURIER
        
        mode='f';
        
    elseif KEY_PRESSED == 't' %TEACHING
        
        mode='t';
        
    elseif KEY_PRESSED == 'w' % WAVES
        
        mode='w';
        
    elseif KEY_PRESSED == 'r' % RESET WAVES
        mode ='r';

        
    elseif KEY_PRESSED == 'g' % GRAYSCALE
        colormap gray
        
    elseif KEY_PRESSED == 'c' % COLOURMAP DEFAULT
        colormap default
        
        
    elseif KEY_PRESSED == 'q' % QUIT
        
        break;
        
    end
    
    
    if mode == 's' % SETUP
        
        % view camera to set up FOV, angle, etc..
        subplot(1,1,1)
        
        img = snapshot(cam);
        
        rgb=insertShape(img,'Rectangle',[250 85 780 550],'LineWidth',5);
        
        imagesc(rgb);
        
        drawnow
        
        % setup for waves demo
        
        if ~exist('img_var','var') % only first time
            img_var = 0;
            imp=rgb2gray(imread('Einstein_square.jpg'));
            %Set empty arrays
            imp_trunc_fft=zeros(size(imp));
            imp_trunc_img=zeros(size(imp));
            %Define spiral index of image
            spiral_mat=spiral(size(imp,1));
            %Get centre of k space by circshifting
            spiral_mat=circshift(spiral_mat,[1,1]);
            %Perform fourier transform of input data
            imp_fft=fftshift(fftn(fftshift(imp)));
            ein_loop=0;
            n=0;
        end
        
    end
    
    
    
    if mode == 'f' % FOURIER
        
        img = snapshot(cam);
        
        simg = img(85:85+550,250:250+780,:); % crop based on the rectangle in setup
        
        subplot(1,2,1)
        
        imagesc(rgb2gray(imresize(simg,0.5)))
        
        axis image;
        
        axis off;
        
        title('Camera','fontsize',30)
        
        subplot(1,2,2)
        simg=imresize(single(simg),0.5); % fewer pixels
        simg_demeaned = simg(:,:,1:2)- mean(mean(mean(simg(:,:,1:2)))); % de-mean
        simg_demeaned=simg_demeaned./max(simg_demeaned(:)); % normalise
        complex_in = single(simg_demeaned(:,:,1)) + 1i*single(simg_demeaned(:,:,2)); % red channel for real part, green channel for imaginary part
        plot_img=((fftshift(abs((ifft2(fftshift(complex_in))))))); %fourier transform
        imagesc(plot_img(round(end/2-25):round(end/2+25),round(end/2-25):round(end/2+25))) %restricted FOV for visualisation
        axis image;
        
        axis off;
        
        title('Transformed','fontsize',30)
        drawnow
        
    end
    
    
    
    if mode == 't' % TEACHING TOOL (same as fourier, but with line showing 1D FT)
        
        img = snapshot(cam);
        
        simg = img(85:85+550,250:250+780,:);
        
        subplot(1,2,1)
        
        imagesc(rgb2gray(imresize(simg,0.5)))
        hold on
        line([1,391],[138,138],'color', [1 0 0], 'linewidth', 5)
        hold off  
        axis image;
        axis off;
        
        title('Camera','fontsize',30)
        
        subplot(1,2,2)
        plot(simg(round(end/2), :,1), 'r', 'LineWidth', 5);
        ylabel('lightness')
        yticks([0,255])
        axis([0 800 0 255])
        yticklabels({'black', 'white'})
        xticks([])
        set(gca,'Position', [0.5703 0.300 0.3347 0.5])
        set(gca, 'FontSize', 24)
        drawnow
 
    end
    
    if mode == 'w' % waves
        
        %Create fourier image with single frequency component
        imp_single_fft=zeros(size(imp_fft));
        imp_single_fft(spiral_mat >= ein_loop & spiral_mat <= ein_loop+n)=imp_fft(spiral_mat >= ein_loop & spiral_mat <= ein_loop+n);
        %add fourier component to combined image
        imp_trunc_fft(spiral_mat >= ein_loop & spiral_mat <= ein_loop+n)=imp_fft(spiral_mat >= ein_loop & spiral_mat <= ein_loop+n);
        %Transform into image
        imp_trunc=abs(ifftshift(ifftn(ifftshift(imp_trunc_fft))));
        imp_single=real(ifftshift(ifftn(ifftshift(imp_single_fft))));
        %Plot image
        subplot(1,2,1);imagesc(imp_single); axis image; axis off
        title('Add this wave...','fontsize', 30)
        subplot(1,2,2);imagesc(imp_trunc);  axis image; axis off
        title('Total','fontsize', 30)
        ein_loop=ein_loop+1+n;
        %if ein_loop>=size(imp_fft,1)
        %    ein_loop=size(imp_fft,1);
        %end
        if ein_loop >= 50
            if mod(ein_loop,10) == 0
                n=n+5;
            end
        end
        w=waitforbuttonpress;
        
    end
    
    if mode == 'r' %reset waves
        if img_var==0
            imp=rgb2gray(imread('zebra.jpg'));   
        elseif img_var==1
            imp=rgb2gray(imread('smilelaugh.jpg'));  
        elseif img_var==2
            imp=rgb2gray(imread('MRI_blackandwhite.png'));  
            imp=imp(:,round(end/2-size(imp)/2):round(end/2+size(imp)/2)-1);
        elseif img_var>=3
            imp=rgb2gray(imread('Einstein_square.jpg'));
            img_var=0;
        end
        img_var=img_var+1;
        %Set empty arrays
        imp_trunc_fft=zeros(size(imp));
        imp_trunc_img=zeros(size(imp));
        %Define spiral index of image
        spiral_mat=spiral(size(imp,1));
        %Get centre of k space by circshifting
        spiral_mat=circshift(spiral_mat,[1,1]);
        %Perform fourier transform of input data
        imp_fft=fftshift(fftn(fftshift(imp)));
        ein_loop=0;
        n=0;
        KEY_PRESSED = 'w';
    end
    
end

close(gcf)
clear cam



function myKeyPressFcn(hObject, event)

global KEY_PRESSED

KEY_PRESSED = event.Character;

end
