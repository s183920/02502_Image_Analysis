% Funktionerne til eksamen 2021
classdef exam_funcs
    methods(Static)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  PCA STUFF                         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % covariance matrix
        function covariance_matrix = covariance_matrix(X)
            % husk at det skal være n=antal rækker eller kolonner
            n = size(X,1);
            covariance_matrix = 1/n *(X)*(X');
        end
  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  CAMERA STUFF                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function b = CameraBDistance(f,g)
            g = 1000*g;
            b = -f*g/(f - g);  
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              COLOR REPRESENTATIONS                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
        hsi
        function  HSI = RGB_to_HSI(im)
            %Represent the RGB image in [0 1] range
            im=double(im)/255;

            R=im(:,:,1);
            G=im(:,:,2);
            B=im(:,:,3);

            %Hue
            numi=1/2*((R-G)+(R-B));
            denom=((R-G).^2+((R-B).*(G-B))).^0.5;

            %To avoid divide by zero exception add a small number in the denominator
            H=acosd(numi./(denom+0.000001));

            %If B>G then H= 360-Theta
            H(B>G)=360-H(B>G);

            %Normalize to the range [0 1]
            %H=H/360;

            %Saturation
            S=1- (3./(sum(im,3)+0.000001)).*min(im,[],3);


            %Intensity (rescale to be between 0 and 255)
            I=sum(im,3)./3.*255;


            %HSI
            HSI=zeros(size(im));
            HSI(:,:,1)=H;
            HSI(:,:,2)=S;
            HSI(:,:,3)=I;
            
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  MAPPINGS                          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
        function GmappedI= GammaMap(I,gammaval)
            Itemp = double(I);
            scale = ((Itemp/255).^gammaval)*255;
            scale = round(scale);
            GmappedI = scale;
            %GmappedI = uint8(scale);
        end
        
        function I_gray = GrayMap(I, vmind, vmaxd)
            % function to perform a linear gray level mapping (also called
            % histogram stretching
            vmin = min(I, [], "all");
            vmax = max(I, [], "all");
            I_gray = (vmaxd-vmind)/(vmax-vmin)*(I-vmin)+vmind;
        end
        
        function I_log = LogMap(I)
            c = 255/log(1+max(I, [], "all"));
            I_log = c*log(1+I);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               GEOMETRIC TRANFORMATIONS             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
        
        function rotate2d = rotate2d(point,theta)
            % point = x,y,
            % exempel com kolonne ([x y]')
            % theta skal være i grader 
            R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
            rotate2d = R * point;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                INTERPOLATION STUFF                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        
        function BilinearInterpolation = BilinearInterpolation(point, X, Y, V)
            
            dx = point(1)-X(1);
            dy = point(2)-Y(1);
            
            BilinearInterpolation = V(1)*(1-dx)*(1-dy)...
                + V(2)*(dx)*(1-dy)...
                + V(3)*(1-dx)*(dy)...
                + V(4)*(dx*dy);
              % Se opgave 4 i test exam Exam_answers.mlx  
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  PLOT STUFF                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        function imagegrid(h,imsize)
        % Call: imagegrid(h,imsize)
        % h is handle to the axes. Normally just send gca
        % imsize is the size of the image. Normally just send size(I)
          set(h,'xtick',1.5:imsize(1)+.5,'ytick',1.5:imsize(2)+.5,...
            'XTickLabel','',...
            'YTickLabel','',...
            'xcolor','r', 'ycolor', 'r','GridLineStyle','-')
          grid on,axis image
        end
        
        function imshow_binary(img)
            imshow(img, 'InitialMagnification', 'fit') 
            pixelgrid
        end
        
        function show_filter(SE)
            exam_funcs.imshow_binary(SE.Neighborhood)
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           IMAGES AS GRAPHS                         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        
        function [cost, path] = OptPath(I)
            % finds optimal path of image using dynamic programming
            I = padarray(I', 1, 256)';
            [H, W] = size(I);
            path = zeros(1, H);
            [cost, idx] = min(I(H,:));
            path(H) = idx-1;
            for j = H-1:-1:1
                idx_range = idx-1 : idx+1;
                [c, i] = min(I(j, idx_range));
                cost = cost + c;

                if i == 1
                    idx = idx - 1;
                elseif i == 3
                    idx = idx + 1;
                end
                path(j) = idx-1;
            end
        end
        
           
        
    end
end
    