% Funktionerne til eksamen 2021
classdef exam_funcs
    methods(Static)
        
        % covariance matrix
        function covariance_matrix = covariance_matrix(X)
            % husk at det skal være n=antal rækker eller kolonner
            n = size(X,1);
            covariance_matrix = 1/n *(X)*(X');
        end
  
        function b = CameraBDistance(f,g)
            g = 1000*g;
            b = -f*g/(f - g);  
        end
            
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
            H=H/360;

            %Saturation
            S=1- (3./(sum(im,3)+0.000001)).*min(im,[],3);


            %Intensity
            I=sum(im,3)./3;


            %HSI
            HSI=zeros(size(im));
            HSI(:,:,1)=H;
            HSI(:,:,2)=S;
            HSI(:,:,3)=I;
            
            
        end
        
        
        function GmappedI= GammaMap(I,gammaval)
            Itemp = double(I);
            scale = ((Itemp/255).^gammaval)*255;
            scale = round(scale);
            GmappedI = scale;
            %GmappedI = uint8(scale);
        end
       
            
        
        
        
        
    end
end
    