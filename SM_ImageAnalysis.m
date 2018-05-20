%**************************************************************************
% UMASS Medical School Summer Internship
% **************************************
% Image Analysis of pixel intensities
% Purpose: Analyze image intensities of extracted images of flourescent
% dyes. Loads every frame that was extracted, calculates and plots
% average pixel intensities for square area that was cropped. Places markers
% on areas that were cropped. user only have to crop initial image for each
% small region/sample molecule used. Includes auto-detection and manual
% selection. 
% Program variables/performance made for specific type of data recorded at
% UMASS, RNA Therapeutics Institute Department.
% Program features: Mouse click for manual selection of desired area
% Keyboard selections: Spacebar for automatic selection 
%                      Enter/return for confirming selected area 
%                      delete for deleting marker inputs
%                      Scroll keys, left/right for frame scrolling through
%                      all selected files, 
%                      up/down for intensity corrections, '~' key to change
%                      from lower/upper or upper/lower limit for intensity
%                      esc for menu selection, changing initial settings
%                      '`' for changing between right/left, left/right 
%                      half of image
%**************************************************************************
% Created: Xuan Ha Nghiem, July 13, 2015
% Date Modified: July 20, 2015
% Date Modified: July 29, 2015
% Date Modified: August 10, 2015
% Date Modified: August 19, 2015
%**************************************************************************

clear all  % start of program, clear and closes all previous work on matlab
close all

format compact

%***********************Variables to be changed****************************
%***********************Variables to be changed****************************
% folder name
name_folder = 'exp008_t';

% initial loading of data
name_StartingFile = 'exp008_t';   % name of file before numbering
name_FileType = '.TIF';   % type of file used
initial_FrameNum = 1;     % initial number of the first file used
final_FrameNum = 10;     % final number of the first file used
sample_limit = 350;       % maximum sample size
num_framespersec = 25;    % rate at which the frames were extracted

% analyze image
side_of_Image = 'right';   % analyzes images on the right or left side
%                          % type input 'left' or 'right'

% intensity detection
min_pixel_radius = 1;    % minimum count of radius
max_pixel_radius = 4;    % maximum count of radius
left_sensitivity = 0.89;   % sensitivity spot detection for left side of image
right_sensitivity = 0.88;  % sensitivity spot detection for right side of image

% contrast setting
left_low = .4;      % range from [0 1] only
left_high = 1;     % contrast_high > contrast_low
right_low = .8;     % changes settings for view of left half or right half
right_high = 1;   % of image
contrast_sensitivity = .01;   % changes contrast sensitivity to changes

% changes p x l table
p = 3;
l = 2;

%***********************Variables to be changed****************************
%***********************Variables to be changed****************************

%           ************************************************

%**************************************************************************
% calculates time and contrast of image
time = (0:(final_FrameNum-initial_FrameNum))/num_framespersec;

%**************************************************************************
% initializes data set
data_title{1,sample_limit} = [];
rect_size = {};
rect_size1 = {};

%**************************************************************************
% loads extracted frames for cropping
count = 0;    % counts number of images that has been automatically cropped
add_count = 0;    % counts number of images that has been manually cropped
n = initial_FrameNum;   % stores number on file for loading
stop_count1 = 0;         % error checking, stops count of images
stop_count2 = 0;         % error checking, stops count of images
inf_loop = true;        % allows for reloading of images
print_file = true;      % stops printing error message when all missing files
%                       % have been identified

% contrast variable
contrast_switch = false;
contrast_str = num2str(contrast_sensitivity);
contrast_str_count = contrast_str(length(contrast_str));

% intensity detection variables
centers = [];
radii = [];
err_key = [];

% subplot for image and histogram
figure('name','Image Analysis')

% variables for filtering images
str = {};
filt_count = 0;
filt_type = fspecial('unsharp');
filt_on = true;

% variables for histogram analysis and auto-scrolling
hist_on = false;
scroll_on = false;

% error checking for auto scrolling
get_key = 1;

% variable for creating video
count_frame = 0;
while inf_loop
    if scroll_on == true  % scrolls through frames
        if abs(n) >= final_FrameNum - stop_count1
            stop_count1 = 0;
            n = -n;
        elseif abs(n) <= initial_FrameNum
            stop_count2 = 0;
            n = abs(n);
        end
        n = n + 1;
        get_key = get(gcf,'currentch');
        if get_key == char(27)  % press esc to stop scrolling
            n = abs(n);
            scroll_on = false;
            filt_on = true;
        end
    end
    
    % read sucessive reloads of initial image for cropping
    name_imageFile = strcat(name_StartingFile,num2str(abs(n)),name_FileType);
    
    % checks if file exists
    if exist(name_imageFile, 'file')
        loadTestingData = imread(name_imageFile); % reads and shows image,
        % plots normalized histogram of intensities
        if strcmp(side_of_Image,'left') == 1
            loadTestingData = imadjust(loadTestingData, ...
                stretchlim(loadTestingData,[left_low left_high]),[]);
            if hist_on == true
                subplot(h(1))
                a = imhist(loadTestingData(:,1:end/2));
                a = a./max(a);
                stem(a)
                subplot(h(2))
            end
            imshow(loadTestingData(:,1:end/2))
        elseif strcmp(side_of_Image,'right') == 1
            loadTestingData = imadjust(loadTestingData, ...
                stretchlim(loadTestingData,[right_low right_high]),[]);
            if hist_on == true
                subplot(h(1))
                a = imhist(loadTestingData(:,end/2:end));
                a = a./max(a);
                stem(a)
                subplot((h(2)))
            end
            imshow(loadTestingData(:,end/2:end))
        else
            error('Warning: Incorrect input of image analysis variable,side_of_Image.')
        end
        
        % places labels on graphs
        if hist_on == true
            subplot(h(1))
            ylim([0 max(a)/10])
            title('Normalized Histogram of Image Intensities')
            xlabel('Intensity')
            ylabel('Normalized Count')
            subplot((h(2)))
            title(['File ' name_StartingFile ' Image Analysis'])
        end
        
        % places markers on position cropped
        if isempty(centers) == 0
            % h = viscircles(centers,radii);
            for m = 1:count
                rectangle('Position', rect_size1{m}, 'EdgeColor','y');
                text(rect_size1{1,m}(1,1)+10,rect_size1{1,m}(1,2)+10, ...
                    sprintf('Sample %d', m),'Color','c')
            end
        end
        if add_count > 0
            for m = 1:length(rect_size)
                rectangle('Position', rect_size{m}, 'EdgeColor','y');
                text(rect_size{1,m}(1,1)+10,rect_size{1,m}(1,2)+10, ...
                    sprintf('Sample %d', count + m),'Color','g')
            end
        end
        
        if scroll_on == true
            pause(.08)
        end
        
        %count_frame = count_frame + 1;
        %F(count_frame) = getframe(gcf);
        
        % stores rectangular coordinates
        if filt_on == true
            k = waitforbuttonpress;
        else
            k = 1;
        end
        
        if k == 0 %&& isempty(centers) == 0    % selects individually regions to be analyzed
            add_count = add_count + 1;
            
            if hist_on == true
                subplot(h(2))
            end
            
            if strcmp(side_of_Image,'left') == 1
                [loadTesting_crop,rect_size{add_count}] = imcrop(loadTestingData(:,1:end/2));
            elseif strcmp(side_of_Image,'right') == 1
                [loadTesting_crop,rect_size{add_count}] = imcrop(loadTestingData(:,end/2:end));
            end
            if count + add_count >= sample_limit
                tic
                total_rect = [];
                total_rect = [rect_size1 rect_size];
                inf_loop = false;
            end
            
        elseif k == 1     % automatically selects region to be analyzed
            switch double(get(gcf,'currentch'))
                case 8 % delete key to clear markers
                    if isempty(centers) == 1 && isempty(rect_size) == 0
                        rect_size(end) = [];
                        add_count = add_count - 1;
                    else
                        centers = [];
                        radii = [];
                        count = 0;
                        rect_size1 = {};
                    end
                case 13 % enter key enables calculations of selected regions for
                    tic   % successive frames
                    total_rect = [];
                    total_rect = [rect_size1 rect_size];
                    inf_loop = false;
                case 27 % esc brings up menu settings
                    if scroll_on == false
                        display('***********************************')
                        display('       Menu: Image settings')
                        display('    file       detection')
                        display('    contrast')
                        display('    histogram  auto scroll')
                        display('***********************************')
                        prompt = 'Which setting do you want to change? ';
                        menu_str = input(prompt,'s');
                        switch menu_str
                            case 'file' % changes file variables
                                display('***********************************')
                                display('           File Settings')
                                display('***********************************')
                                display('     1. File name')
                                display('     2. Folder name')
                                display('     3. Initial/Final Frame Number')
                                display('     4. Sample Limit')
                                display('     5. Rate The Frames Were Extracted')
                                prompt = 'Select category number only. Which settings do you want to change? ';
                                file_str = input(prompt,'s');
                                switch file_str
                                    case '1'
                                        prompt = 'Name of file before numbering: ';
                                        name_StartingFile = input(prompt,'s');
                                        prompt = 'File Type: ';
                                        name_FileType = input(prompt,'s');
                                        clear k;
                                        n = initial_FrameNum;
                                        stop_count1 = 0;
                                        stop_count2 = 0;
                                    case '2'
                                        prompt = 'Folder name: ';
                                        name_folder = input(prompt,'s');
                                    case '3'
                                        prompt = 'Initial frame number: ';
                                        initial_FrameNum = input(prompt);
                                        n = initial_FrameNum;
                                        stop_count1 = 0;
                                        stop_count2 = 0;
                                        prompt = 'Final frame number: ';
                                        final_FrameNum = input(prompt);
                                        clear k;
                                    case '4'
                                        prompt = 'Sample limit: ';
                                        sample_limit = input(prompt);
                                    case '5'
                                        prompt = 'Rate the frames were extracted: ';
                                        num_framespersec = input(prompt);
                                    otherwise
                                        display('Incorrect input, enter in only the numbers shown. Variables remain unchanged.')
                                end
                                
                            case 'detection' % changes variables for automatic detection
                                display('***********************************')
                                display(' Automatic Spot Detection Settings')
                                display('***********************************')
                                display('     1. Min/Max radius estimate')
                                display('     2. Sensitivity detection range')
                                prompt = 'Select category number only. Which settings do you want to change? ';
                                file_str = input(prompt,'s');
                                switch file_str
                                    case '1'
                                        display('Recommended range for radius is 1-5 for min/max')
                                        prompt = 'Minimum radius estimate: ';
                                        min_pixel_radius = input(prompt);
                                        prompt = 'Maximum radius estimate: ';
                                        max_pixel_radius = input(prompt);
                                    case '2'
                                        display('Sensitivity detection ranges from 0-1 only')
                                        if strcmp(side_of_Image,'left') == 1
                                            prompt = 'Sensitivity detection for left side of image: ';
                                            left_sensitivity = input(prompt);
                                        elseif strcmp(side_of_Image,'right') == 1
                                            prompt = 'Sensitivity detection for right side of image: ';
                                            right_sensitivity = input(prompt);
                                        end
                                    otherwise
                                        display('Incorrect input, enter in only the numbers shown. Variables remain unchanged.')
                                end
                            case 'contrast' % changes variables for contrast settings
                                display('***********************************')
                                display('           Contrast Settings')
                                display('***********************************')
                                display('Settings ranges from 0-1 only.')
                                
                                if strcmp(side_of_Image,'left') == 1
                                    prompt = 'Lower limit contrast setting for left side: ';
                                    left_low = input(prompt);
                                    prompt = 'Upper limit contrast setting for left side: ';
                                    left_high = input(prompt);
                                elseif strcmp(side_of_Image,'right') == 1
                                    prompt = 'Lower limit contrast setting for right side: ';
                                    right_low = input(prompt);
                                    prompt = 'Upper limit contrast setting for right side: ';
                                    right_high = input(prompt);
                                end
                            case 'histogram' % turns on histogram of image intensity
                                prompt = 'Turn histogram on or off? ';
                                menu_str = input(prompt,'s');
                                if strcmp(menu_str,'on') == 1
                                    h(1) = subplot(1,2,1);
                                    h(2) = subplot(1,2,2);
                                    hist_on = true;
                                elseif strcmp(menu_str,'off') == 1
                                    if hist_on == true
                                        delete(h(1));
                                        delete(h(2));
                                        hist_on = false;
                                    end
                                end
                            case 'auto scroll' % enables automatic scrolling through frames
                                scroll_on = true;
                                filt_on = false;
                                set(gcf,'currentch',char(1))
                                err_key = char(1);
                                stop_leftright = false;
                            otherwise
                                display('Incorrect Input, enter only the categories shown.')
                        end
                    end
                case 28 % left changes to previous frame
                    if scroll_on == false
                        n = n - 1;
                        stop_count2 = 0;
                        err_key = double(get(gcf,'currentch'));
                        set(gcf,'currentch',char(49))
                        filt_on = false;
                        ans_video = 'no';
                    end
                case 29 % right changes to next frame
                    if scroll_on == false
                        n = n + 1;
                        stop_count1 = 0;
                        err_key = double(get(gcf,'currentch'));
                        set(gcf,'currentch',char(49))
                        filt_on = false;
                        ans_video ='no';
                    end
                case 30  % up arrow changes contrast
                    if scroll_on == true
                        set(gcf,'currentch',char(1))
                    end
                    if contrast_switch == true
                        if strcmp(side_of_Image,'left') == 1
                            left_low = left_low + contrast_sensitivity;
                            if left_low >= left_high
                                left_low = left_high - contrast_sensitivity;
                            end
                            display(['Left side contrast lower limit increased to ' num2str(left_low) '.'])
                        elseif strcmp(side_of_Image,'right') == 1
                            right_low = right_low + contrast_sensitivity;
                            if right_low >= right_high
                                right_low = right_high - contrast_sensitivity;
                            end
                            display(['Right side contrast lower limit increased to ' num2str(right_low) '.'])
                        end
                    else
                        if strcmp(side_of_Image,'left') == 1
                            left_high = left_high + contrast_sensitivity*.1;
                            if left_high > 1
                                left_high = 1;
                            end
                            display(['Left side contrast upper limit increased to ' num2str(left_high) '.'])
                        elseif strcmp(side_of_Image,'right') == 1
                            right_high = right_high + contrast_sensitivity*.1;
                            if right_high > 1
                                right_high = 1;
                            end
                            display(['Right side contrast upper limit increased to ' num2str(right_high) '.'])
                        end
                    end
                case 31 % down arrow changes contrast
                    if scroll_on == true
                        set(gcf,'currentch',char(1))
                    end
                    if contrast_switch == true
                        if strcmp(side_of_Image,'left') == 1
                            left_low = left_low - contrast_sensitivity;
                            if left_low < 0
                                left_low = 0;
                            end
                            display(['Left side contrast lower limit reduced to ' num2str(left_low) '.'])
                        elseif strcmp(side_of_Image,'right') == 1
                            right_low = right_low - contrast_sensitivity;
                            if right_low < 0
                                right_low = 0;
                            end
                            display(['Right side contrast lower limit reduced to ' num2str(right_low) '.'])
                        end
                    else
                        if strcmp(side_of_Image,'left') == 1
                            left_high = left_high - contrast_sensitivity*.1;
                            if left_high <= left_low
                                left_high = left_low + contrast_sensitivity*.1;
                            end
                            display(['Left side contrast upper limit reduced to ' num2str(left_high) '.'])
                        elseif strcmp(side_of_Image,'right') == 1
                            right_high = right_high - contrast_sensitivity*.1;
                            if right_high <= right_low
                                right_high = right_low + contrast_sensitivity*.1;
                            end
                            display(['Right side contrast upper limit reduced to ' num2str(right_high) '.'])
                        end
                    end
                case 32 % space key automatically finds regions to be analyzed
                    if isempty(str) == 0
                        loadTestingData = loadFilteredData;
                    end
                    loadTestingData= im2bw(loadTestingData,graythresh(loadTestingData));
                    if strcmp(side_of_Image,'left') == 1
                        [centers, radii] = imfindcircles(loadTestingData(:,1:end/2),...
                            [min_pixel_radius max_pixel_radius],'Sensitivity',left_sensitivity);
                    elseif strcmp(side_of_Image,'right') == 1
                        [centers, radii] = imfindcircles(loadTestingData(:,end/2:end),...
                            [min_pixel_radius max_pixel_radius],'Sensitivity',right_sensitivity);
                    end
                    if isempty(centers) == 0
                        count = length(centers(:,1));
                        if count + add_count >= sample_limit
                            error('Warning: Overload, Sample size has exceeded the limit.')
                        end
                    end
                case 33 % '!' key to change contrast sensitivity
                    if contrast_sensitivity < str2num(contrast_str_count)*10^-3
                        contrast_sensitivity = str2num(contrast_str_count)*10^-1
                    else
                        contrast_sensitivity = contrast_sensitivity * .1
                    end
                case 49 % '1' key for filtering images
                    if filt_on == true
                        filt_count = filt_count + 1;
                        display('***********************************')
                        display('           Types of Filters')
                        display('    histeq     imfilter     medium')
                        display('    ordfilt2   wiener2')
                        display('             ************')
                        display('           Remove Filters')
                        display('    remove     remove all')
                        display('***********************************')
                        prompt = 'Enter your prefered filter type or remove selected or all filters: ';
                        str{filt_count} = input(prompt,'s');
                        prompt = ' yes or no to show a video clip of filtered image? ';
                        ans_video = input(prompt,'s');
                    end
                    
                    filter_video(:,:,1) = loadTestingData;
                    
                    % initial filtering of image
                    if isempty(str) == 0
                        switch str{1}
                            case 'histeq'
                                loadFilteredData = adapthisteq(loadTestingData);
                            case 'imfilter'
                                loadFilteredData = imfilter(loadTestingData,filt_type);
                            case 'medium'
                                loadFilteredData = medfilt2(loadTestingData, [6 6]);
                            case 'ordfilt2'
                                loadFilteredData = ordfilt2(loadTestingData,23,true(5));
                            case 'wiener2'
                                loadFilteredData = wiener2(loadTestingData,[5 5]);
                            otherwise
                                display('Unrecognized filter input. Only enter in one of the categories shown.')
                                str(1) = [];
                                filt_count = filt_count - 1;
                        end
                        
                        if exist('loadFilteredData','var') == 1
                            filter_video(:,:,2) = loadFilteredData;
                        end
                        
                        % removes filter
                        if filt_count > 1
                            if strcmp(str(filt_count),'remove') == 1
                                str(filt_count) = [];
                                display('***********************************')
                                display('      Types of Filters Used')
                                for m = 1:filt_count - 1
                                    display([num2str(m) '. ' str{m}])
                                end
                                display('***********************************')
                                prompt = 'Remove which filter number: ';
                                remove_str = input(prompt);
                                str(remove_str) = [];
                                filt_count = filt_count - 2;
                                filter_video(:,:,remove_str+1) = [];
                            elseif strcmp(str(filt_count),'remove all') == 1
                                str = [];
                                filter_video(:,:,2) = [];
                                filt_count = 0;
                            end
                            
                            % successive filtering of image
                            filt_loop = 2;
                            while filt_loop <= filt_count
                                switch str{filt_loop}
                                    case 'histeq'
                                        loadFilteredData = adapthisteq(loadFilteredData);
                                    case 'imfilter'
                                        loadFilteredData = imfilter(loadFilteredData,filt_type);
                                    case 'medium'
                                        loadFilteredData = medfilt2(loadFilteredData, [6 6]);
                                    case 'ordfilt2'
                                        loadFilteredData = ordfilt2(loadFilteredData,23,true(5));
                                    case 'wiener2'
                                        loadFilteredData = wiener2(loadFilteredData,[5 5]);
                                    otherwise
                                        display('Unrecognized filter input. Only enter in one of the categories shown.')
                                        str(filt_loop) = [];
                                        filt_count = filt_count - 1;
                                        filt_loop = filt_loop - 1;
                                end
                                
                                filt_loop = filt_loop + 1;
                                filter_video(:,:,filt_loop) = loadFilteredData;
                                
                            end
                        end
                        if exist('loadFilteredData','var') == 1
                            final_filtered = im2bw(loadFilteredData,graythresh(loadFilteredData));
                        else
                            final_filtered = im2bw(loadTestingData,graythresh(loadTestingData));
                        end
                        
                        % display video
                        if strcmp(ans_video,'yes') == 1
                            figure
                            if strcmp(side_of_Image,'left') == 1
                                for m = 1:filt_count+1
                                    imshow(filter_video(:,1:end/2,m))
                                    %count_frame = count_frame + 1;
                                    %F(count_frame) = getframe(gcf);
                                    pause(.8)
                                end
                                imshow(final_filtered(:,1:end/2))
                                %count_frame = count_frame + 1;
                                %F(count_frame) = getframe(gcf);
                                pause(1)
                            elseif strcmp(side_of_Image,'right') == 1
                                for m = 1:filt_count+1
                                    imshow(filter_video(:,end/2:end,m))
                                    %count_frame = count_frame + 1;
                                    %F(count_frame) = getframe(gcf);
                                    pause(.8)
                                end
                                imshow(final_filtered(:,end/2:end))
                                %count_frame = count_frame + 1;
                                %F(count_frame) = getframe(gcf);
                                pause(1)
                            end
                            close
                        elseif strcmp(ans_video,'no') == 1
                        else
                            display('Incorrect answer, either yes or no only.')
                        end
                    end
                    if filt_on == false
                        filt_on = true;
                    end
                case 50 % '2' key increases contrast sensitivity
                    contrast_str_count = double(length(num2str(contrast_sensitivity)));
                    if ~(contrast_sensitivity >= 7*10^-(contrast_str_count - 2))
                        contrast_sensitivity = contrast_sensitivity + 10^-(contrast_str_count - 2)
                    end
                    contrast_str = num2str(contrast_sensitivity);
                    contrast_str_count = contrast_str(length(contrast_str));
                case 64 % '@' key decreases contrast sensitivity
                    contrast_str_count = double(length(num2str(contrast_sensitivity)));
                    if ~(contrast_sensitivity <= 10^-(contrast_str_count - 2)  + 9.9999*10^-(contrast_str_count - 1))
                        contrast_sensitivity = contrast_sensitivity - 10^-(contrast_str_count - 2)
                    end
                    contrast_str = num2str(contrast_sensitivity);
                    contrast_str_count = contrast_str(length(contrast_str));
                case 96 % '`' key to change image from left to right
                    if strcmp(side_of_Image,'left') == 1
                        side_of_Image = 'right';
                    else
                        side_of_Image = 'left';
                    end
                    set(gcf,'currentch',char(49))
                    filt_on = false;
                    ans_video = 'no';
                case 126 % '~' key to switches from high/low, low/high limit
                    if contrast_switch == true
                        contrast_switch = false;
                    else
                        contrast_switch = true;
                    end
                otherwise
            end
            
            % when file exceeds limit
            if abs(n) >= final_FrameNum
                n = final_FrameNum;    % fixes the images at final or initial position
                print_file = false;
            elseif abs(n) <= initial_FrameNum
                n = initial_FrameNum;
            end
        end
        
        % places markers on final position cropped
        if isempty(centers) == 0
            rect_size1 = [];
            % h = viscircles(centers,radii);
            for m = 1:count
                rectangle('Position', [centers(m,1) - radii(m), centers(m,2)...
                    - radii(m), 2 * radii(m), 2 * radii(m)], 'EdgeColor','y');
                text(centers(m,1) - radii(m) + 10,centers(m,2) - radii(m) + 10,...
                    sprintf('Sample %d', m),'Color','c')
                rect_size1{m} = [centers(m,1) - radii(m), centers(m,2) - radii(m),...
                    2 * radii(m), 2 * radii(m)];
            end
        end
        if add_count > 0
            for m = 1:length(rect_size)
                rectangle('Position', rect_size{m}, 'EdgeColor','y');
                text(rect_size{1,m}(1,1)+10,rect_size{1,m}(1,2)+10, ...
                    sprintf('Sample %d', count + m),'Color','g')
            end
        end
        
    else
        
        % when file does not exists
        if print_file
            warning(['Warning: File ',name_imageFile,' does not exist.'])
        end
        if exist('k', 'var') == 0
            n = n + 1;
            if n > final_FrameNum
                clear k;
                display('Warning: Folder does not contain the requested files.')
                prompt = 'Change file or frame count? ';
                menu_str = input(prompt,'s');
                switch menu_str   % prompt for change in file or initial/final frame
                    case 'file'
                        prompt = 'Name of file before numbering: ';
                        name_StartingFile = input(prompt,'s');
                        prompt = 'File Type: ';
                        name_FileType = input(prompt,'s');
                        n = initial_FrameNum;
                        stop_count1 = 0;
                        stop_count2 = 0;
                    case {'frame','frame count'}
                        prompt = 'Initial frame number: ';
                        initial_FrameNum = input(prompt);
                        n = initial_FrameNum;
                        prompt = 'Final frame number: ';
                        final_FrameNum = input(prompt);
                        stop_count1 = 0;
                        stop_count2 = 0;
                    otherwise
                        % error('Incorrect input. End program.')
                end
            end
        else
            switch err_key
                case 28  % left changes to previous frame
                    n = n - 1;
                case 29  % right changes to next frame
                    n = n + 1;
                otherwise
            end
            
            % when reading files exceeds limit
            if abs(n) >= final_FrameNum
                stop_count1 = stop_count1 + 1;
                n = abs(n) - stop_count1;    % fixes the images at final or initial position
                print_file = false;
            elseif abs(n) <= initial_FrameNum
                stop_count2 = stop_count2 + 1;
                n = n + stop_count2;
            end
        end
    end
end

% saves first image of histogram and labeled data points
display(['The sample size is ' num2str(length(total_rect)) '.'])
mkdir(name_folder)
saveas(gcf,strcat(name_folder,'/',name_StartingFile,'_labeled','.fig'))

%**************************************************************************

avg_intensity = zeros(final_FrameNum - initial_FrameNum + 1,length(total_rect));
std_intensity = zeros(final_FrameNum - initial_FrameNum + 1,length(total_rect));

%**************************************************************************
% sets up data for printing of table
data_title = {'Time, sec'};

% stores strings of s and f values for table
print_s = '  %s';
print_f = ' %10f';

for n = 1:length(total_rect)
    data_title{n+1} =  ['Sample ' num2str(n)];
    print_s = [print_s ' %15s'];
    print_f = [print_f ' %15f'];
end

print_s = [print_s '\n'];
print_f = [print_f '\n'];

%**************************************************************************
% crop sucessive images with same length and width
count_colmn = 0;
for n = 1:length(total_rect)
    count_colmn = count_colmn + 1;
    count_row = 0;
    k = initial_FrameNum;
    while k < final_FrameNum + 1
        count_row = count_row + 1;
        loadTestingData_name = strcat(name_StartingFile,num2str(k),name_FileType);
        inf_loop = true;
        while inf_loop
            if exist(loadTestingData_name, 'file')
                inf_loop = false;
            else
                warning(['Warning: File ',loadTestingData_name,' does not exist.'])
                time(count_row) = -1;
                avg_intensity(count_row, count_colmn) = -1;
                std_intensity(count_row, count_colmn) = -1;
                k = k + 1;
                
                % error checking, in case file number exceeds limit
                if k == final_FrameNum + 1
                    break;
                end
                count_row = count_row + 1;
                loadTestingData_name = strcat(name_StartingFile,num2str(k),name_FileType);
            end
        end
        
        % error checking, in case file number exceeds limit
        if k == final_FrameNum + 1
            break;
        end
        
        % reads and collects data
        loadTestingData = imread(loadTestingData_name);
        if strcmp(side_of_Image,'left') == 1
            %loadTestingData = imadjust(loadTestingData, stretchlim(loadTestingData,...
            %   [left_low left_high]),[]);   % delete comments to see clip movie of images
            loadTestingData_crop = imcrop(loadTestingData(:,1:end/2),total_rect{n});
            %subplot(h(2))
            %imshow(loadTestingData_crop) % delete comments to see clip movie of images
            %subplot(h(1))
            %imhist(loadTestingData_crop);
            %count_frame = count_frame + 1;
            %F(count_frame) = getframe(gcf);
            %pause(.6)
        elseif strcmp(side_of_Image,'right') == 1
            %loadTestingData = imadjust(loadTestingData, stretchlim(loadTestingData,...
            %   [right_low right_high]),[]);   % delete comments to see clip movie of images
            loadTestingData_crop = imcrop(loadTestingData(:,end/2:end),total_rect{n});
            %subplot(h(2))
            %imshow(loadTestingData_crop)  % delete comments to see clip movie of images
            %subplot(h(1))
            %imhist(loadTestingData_crop);
            %count_frame = count_frame + 1;
            %F(count_frame) = getframe(gcf);
            %pause(.6)
        end
        
        % rearrange data
        loadTestingData_crop = reshape(loadTestingData_crop, ...
            [1, length(loadTestingData_crop(:,1))*length(loadTestingData_crop(1,:))]);
        avg_intensity(count_row, count_colmn) = mean(loadTestingData_crop);
        std_intensity(count_row, count_colmn) = std(single(loadTestingData_crop));
        k = k + 1;
    end
end

% removes -1 from the data
time(time == -1) = [];
avg_intensity(all(avg_intensity == -1,2),:) = [];
std_intensity(all(std_intensity == -1,2),:) = [];

%**************************************************************************
% prints and save table of average values
avg_data = [num2cell(time)' num2cell(avg_intensity)];
avg_data = vertcat(data_title,avg_data);
fileID = fopen(strcat(name_folder,'/',name_StartingFile,'_avg','.txt'),'w');
fprintf(fileID,print_s,avg_data{1,:});
for n = 2:length(avg_data(:,1))
    fprintf(fileID,print_f,avg_data{n,:});
end

fclose(fileID);

%**************************************************************************
% prints and save table of standard deviation values
std_data = [num2cell(time)' num2cell(std_intensity)];
std_data = vertcat(data_title,std_data);
fileID = fopen(strcat(name_folder,'/',name_StartingFile,'_std','.txt'),'w');
fprintf(fileID,print_s,std_data{1,:});
for n = 2:length(std_data(:,1))
    fprintf(fileID,print_f,std_data{n,:});
end

fclose(fileID);

%**************************************************************************
% display data in p x l subplots
k = length(total_rect)/l;
figure('name','Sample Data')
count = 0;
file_num = 1;
for n = 1:length(total_rect)
    count = count + 1;
    if mod(count,p * l + 1) == 0
        saveas(gcf,strcat(name_folder,'/',name_StartingFile, ...
            num2str(file_num),'-',num2str(n-1),'.fig'))
        %count_frame = count_frame + 1;
        %F(count_frame) = getframe(gcf);
        file_num = file_num + p * l;
        figure('name','Sample Data')
        count = 1;
    end
    subplot(p,l,count)
    plot(time,avg_intensity(:,n),'k')
    title(sprintf('Sample %d', n))
    xlabel('Time(s)')
    ylabel('Average Intensities Across Time')
    if n == length(total_rect)
        saveas(gcf,strcat(name_folder,'/',name_StartingFile, ...
            num2str(file_num),'-',num2str(n),'.fig'))
        %count_frame = count_frame + 1;
        %F(count_frame) = getframe(gcf);
    end
end
toc
%**************************************************************************