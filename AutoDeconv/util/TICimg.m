function [TIC_image] = TICimg(input,dims,plot_on_off,mask,filter)
    TIC_image = TIC(input);
    TIC_image = reshape(TIC_image,[dims(1) dims(2)]);
    if nargin < 4
        mask = ones(dims(1),dims(2));
        filter = 0;
    end    
    TIC_image = TIC_image.*mask;
    TIC_image = TIC_image';
    if filter == 1
        TIC_image = imnlmfilt(TIC_image);
        TIC_image = medfilt2(TIC_image);
    end
    if plot_on_off
        figure,imagesc(TIC_image);axis image;colormap('magma')
    end
end