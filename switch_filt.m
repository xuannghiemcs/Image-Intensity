% Template for filters
%Function uses switch statement to switch filters
%

function [filt_data filt_images] = switch_filt(str,count,load_Data1)
if count > 0
    filt_images{1,count} = [];
    filt_type = fspecial('unsharp');
    switch str{1}
        case 'histeq'
            filt_data = adapthisteq(load_Data1);
        case 'imfilter'
            filt_data = imfilter(load_Data1,filt_type);
        case 'medium'
            filt_data = medfilt2(load_Data1, [6 6]);
        case 'ordfilt2'
            filt_data = ordfilt2(load_Data1,23,true(5));
        case 'wiener2'
            filt_data = wiener2(load_Data1,[5 5]);
        case 'custom'
        otherwise
    end
    filt_images{1} = filt_data;
    
    if count > 1
        for i = 2:count
            switch str{i}
                case 'histeq'
                    filt_data = adapthisteq(filt_data);
                case 'imfilter'
                    filt_data = imfilter(filt_data,filt_type);
                case 'medium'
                    filt_data = medfilt2(filt_data, [6 6]);
                case 'ordfilt2'
                    filt_data = ordfilt2(filt_data,23,true(5));
                case 'wiener2'
                    filt_data = wiener2(filt_data,[5 5]);
                case 'custom'
                   
                otherwise
            end
            filt_images{i} = filt_data;
        end
    end
    
end

end