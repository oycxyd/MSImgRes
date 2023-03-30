function [res, blur,inds] = calculate_mtf(edges)
    blur = [];
    res = [];
    inds = [];
    for i = 1:length(edges)
    % for i = 1:1
        lsf = gradient(edges{i});
        % figure,plot(lsf)
    %     [~,xc] = max(lsf);
        xc = round(length(lsf)/2);
        [FitResults, GOF]=peakfit([lsf],0,0,1,1,0,10,0,0,0,0);

        if FitResults(2) > xc
    %         xc = round(FitResults(2) + 2);
            xc = xc+2;
        else
            xc = xc+2;
        end
%         ibar = mean(lsf(xc:end));
        x = 1:length(lsf);
        lsf_theoretical = FitResults(3)*exp(-((x-FitResults(2)).^2)/(2*FitResults(4)^2));
        % esf_theoretical = gradiant(
    %     figure,plot([lsf' lsf_theoretical'])

        mtf_data = abs((fft(lsf)));
    %     figure,plot(mtf_data)
        mtf_gauss = abs((fft(lsf_theoretical)));
    %     figure,plot(mtf_gauss)

        f = 2*(-(length(mtf_data)-1)/2:(length(mtf_data)-1)/2)/length(mtf_data);
        f_new = resample(f(xc:end),100,1);
        mtf_new = interp1(f(xc:end),mtf_gauss(xc:end),f_new);
        % figure,plot(mtf_data)
        noise = lsf-lsf_theoretical;
        nps = abs(fftshift(fft(noise)));

        [~, x2] = min( abs(mtf_new-ones([1 length(f_new)])*mean(nps)) );
        f_cutoff_gauss = f_new(x2);

        if abs(GOF(2))> 0.4
            blur = [blur; FitResults(4)];
            res = [res; f_cutoff_gauss];
            inds = cat(2,inds,i);
        end
    %     figure,plot([mtf_new' (ones([1 length(f_new)])*mean(nps))'])
    end
%     figure,plot(2*10./res);
end