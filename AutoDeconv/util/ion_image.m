%% function to form ion images from HS data cube, e.g.
% ion_image(885.5499, mz, specs, size);

function [Image_dum,ppm] = ion_image(feature, mz, data, dims, plot_on_off,contrast)
    if nargin < 6, contrast = 1; end
    [ppm, ind] = min( abs(mz-feature) );
    ppm = ppm/feature*1e6;
%     data = data';
    if size(data,3) > 1
        Image_dum = data(:,:,ind);
%         Image_dum(2:2:end,:)=fliplr(Image_dum(2:2:end,:));
    else
        ion_image = data(:,ind);
        ion_image = reshape(ion_image, [dims(1) dims(2)]);

        Image_dum = ion_image;
    %% from raster scanning

        Image_dum(:,2:2:end)=flipud(Image_dum(:,2:2:end));
        


        Image_dum=rot90(Image_dum,-1);
        Image_dum(2:2:end,:)=fliplr(Image_dum(2:2:end,:));
        Image_dum=fliplr(Image_dum);
    end
    
    
    if plot_on_off == 1
        if contrast == 1
            figure;imagesc(Image_dum);colormap(jet(256));colorbar;
        else
            figure;imagesc(Image_dum);colormap(contrast); colorbar;
        end
        axis image
        title(num2str(['m/z',' ',num2str(mz(ind))]));
    end
    %     saveas(gcf,['Block',num2str(i),'_',num2str(feature),'.png'])
end