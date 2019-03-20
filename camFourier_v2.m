%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main script to run whilst running the stall (The Imaged Brain)
%
% Sophie Schauman, Benjamin Tendler, Stuart Clare
% 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

global KEY_PRESSED



hFigure=figure('WindowStyle','Normal','MenuBar', 'none', 'ToolBar', 'none');

% set(hFigure,'WindowState','FullScreen');



set(hFigure, 'KeyPressFcn', @myKeyPressFcn);



dim  = [0,0,0.5,0.5];

han = annotation(hFigure, 'textbox', dim, 'String', '(s)etup   (f)ourier transform   (t)eaching tool   (q)uit', ...
 'VerticalAlignment', 'bottom', 'FitBoxToText', 'on', 'fontsize',18);



mode='s'

cam = webcam('HUE HD Camera #2'); %Specify camera by name



while 1

   if KEY_PRESSED == 's'

       mode='s'

   elseif KEY_PRESSED == 'f'

       mode='f'

   elseif KEY_PRESSED == 't'

       mode='t'

   elseif KEY_PRESSED == 'q' % QUIT

       break;

   end



   if mode == 's' % SETUP

       subplot(1,1,1)

       img = snapshot(cam);

       rgb=insertShape(img,'Rectangle',[250 85 780 550],'LineWidth',5);

       imagesc(rgb);

       drawnow

   end



   if mode == 'f' % FOURIER

       img = snapshot(cam);

       simg = img(85:85+550,250:250+780,:);

       subplot(1,2,1)

       imagesc(rgb2gray(imresize(simg,0.5)))

       axis image;

       axis off;

       title('Image','fontsize',30)

       subplot(1,2,2)
       simg=imresize(single(simg),0.5);
       simg_demeaned = simg(:,:,1:2)- mean(mean(mean(simg(:,:,1:2))));
       simg_demeaned=simg_demeaned./max(simg_demeaned(:));
       complex_in = single(simg_demeaned(:,:,1)) + 1i*single(simg_demeaned(:,:,2));
       plot_img=((fftshift(abs((ifft2(fftshift(complex_in)))))));
       imagesc(plot_img(round(end/2-25):round(end/2+25),round(end/2-25):round(end/2+25)))
       axis image;

       axis off;

       title('Waves','fontsize',30)
       drawnow

   end



   if mode == 't' % TEACHING TOOL

       img = snapshot(cam);

       simg = img(85:85+550,250:250+780,:);

       subplot(2,2,1)

       imagesc(rgb2gray(imresize(simg,0.5)))
       hold on 
       line([1,391],[138,138],'color', [1 0 0], 'linewidth', 5)
       hold off

       axis image;

       axis off;

       title('Image','fontsize',30)

       subplot(2,2,2)
       simg=imresize(single(simg),0.5);
       simg_demeaned = simg(:,:,1:2)- mean(mean(mean(simg(:,:,1:2))));
       simg_demeaned=simg_demeaned./max(simg_demeaned(:));
       complex_in = single(simg_demeaned(:,:,1)) + 1i*single(simg_demeaned(:,:,2));
       plot_img=((fftshift(abs((ifft2(fftshift(complex_in)))))));
       imagesc(plot_img(round(end/2-25):round(end/2+25),round(end/2-25):round(end/2+25)))
       axis image;

       axis off;
       
       hold on 
       line([1,51],[26,26],'color', [1 0 0], 'linewidth', 5)
       hold off

       title('Waves','fontsize',30)
       
       
       
       subplot(2,2,3)
       plot(simg(round(end/2), :,1), 'r', 'LineWidth', 5);
       drawnow
       
       subplot(2,2,4)
       plot(plot_img(round(end/2),round(end/2-25):round(end/2+25)), 'r', 'LineWidth', 5);
       drawnow


   end

end

close(gcf)
clear cam



function myKeyPressFcn(hObject, event)

   global KEY_PRESSED

   KEY_PRESSED = event.Character;

end
