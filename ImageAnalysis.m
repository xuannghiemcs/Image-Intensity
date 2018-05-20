% This is an unfinished program meant to track particle intensities across
% time
function varargout = ImageAnalysis(varargin)
% IMAGEANALYSIS MATLAB code for ImageAnalysis.fig
%      IMAGEANALYSIS, by itself, creates a new IMAGEANALYSIS or raises the existing
%      singleton*.
%
%      H = IMAGEANALYSIS returns the handle to a new IMAGEANALYSIS or the handle to
%      the existing singleton*.
%
%      IMAGEANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEANALYSIS.M with the given input arguments.
%
%      IMAGEANALYSIS('Property','Value',...) creates a new IMAGEANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageAnalysis

% Last Modified by GUIDE v2.5 09-Jun-2016 16:54:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ImageAnalysis_OpeningFcn, ...
    'gui_OutputFcn',  @ImageAnalysis_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ImageAnalysis is made visible.
function ImageAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageAnalysis (see VARARGIN)

% initial data
handles.load_Data = [];
handles.centers = [];
handles.rect_size = [];
handles.rect_size_manual = [];
handles.str = [];
handles.count = 0;
handles.filt_count = 0;
handles.high_val = 0;
handles.low_val = 0;
handles.filt_on = false;
handles.record_filt = false;
handles.record_image = [];
handles.count_image = 1;
handles.auto_value = 0;
handles.sensitivity_con = .01;
handles.filt_type = fspecial('unsharp');

% Choose default command line output for ImageAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImageAnalysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in filter.
function filter_Callback(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filter

handles.val = get(hObject, 'Value');
% switches between time and frequency domain for pop-up menu
switch handles.val
    case 1
        inf_loop = true;
        % Takes in input of filter
        while inf_loop
            handles.filt_count = handles.filt_count + 1;
            display('***********************************')
            display('           Types of Filters')
            display('    histeq     imfilter     medium')
            display('    ordfilt2   wiener2      custom')
            prompt = 'Enter your prefered filter type: ';
            handles.str{handles.filt_count} = input(prompt,'s');
            switch handles.str{handles.filt_count}
                case {'histeq','imfilter','medium','ordfilt2','wiener2'}
                    
                case 'custom'
                    
                    
                otherwise
                    display('Incorrect response.')
                    handles.str{handles.filt_count} = [];
                    handles.filt_count = handles.filt_count - 1;
            end
            if handles.filt_count > 0
                display('***********************************')
                display('     Types of Filters in Use')
                for m = 1:handles.filt_count
                    display([num2str(m) '. ' handles.str{m}])
                end
            end
            prompt = 'Continue filtering? Y or N: ';
            response = input(prompt,'s');
            inf_loop1 = true;
            while inf_loop1
                if strcmp(lower(response),'y')|| strcmp(lower(response),'yes')
                    inf_loop1 = false;
                elseif strcmp(lower(response),'n')|| strcmp(lower(response),'no')
                    inf_loop = false;
                    inf_loop1 = false;
                else
                    display('Incorrect response.')
                    prompt = 'Continue filtering? Y or N: ';
                    response = input(prompt,'s');
                end
            end
        end
        if handles.filt_count > 0
            display('***********************************')
            display('     Types of Filters in Use')
            for m = 1:handles.filt_count
                display([num2str(m) '. ' handles.str{m}])
            end
        end
    case 2
        
        inf_loop = true;
        while inf_loop
            % Displays type of filter used
            if handles.filt_count ~= 0
                display('***********************************')
                display('      Types of Filters Used')
                display('***********************************')
                for m = 1:handles.filt_count
                    display([num2str(m) '. ' handles.str{m}])
                end
                prompt = 'Remove which filter number: ';
                remove_str = input(prompt,'s');
                A = isstrprop(remove_str, 'digit');
                if mean(A) ~=0
                    index_A = find(A);
                    num = '';
                    for i = 1:length(index_A)
                        num = [num remove_str(index_A(i))];
                    end
                    if str2num(num) <= handles.filt_count
                        if handles.count_image == handles.filt_count
                            handles.count_image = handles.count_image - 1;
                        end
                        handles.str(str2num(num)) = [];
                        handles.filt_count = handles.filt_count - 1;
                    else
                        display('The digit entered was incorrect.')
                    end
                else
                    display('No digits were entered.')
                end
                
            else
                display('There are no filters to remove.')
                inf_loop = false;
            end
            
            if handles.filt_count ~= 0
                prompt = 'Continue removing more filters? Y or N: ';
                response = input(prompt,'s');
                inf_loop1 = true;
                while inf_loop1
                    if strcmp(lower(response),'y')|| strcmp(lower(response),'yes')
                        inf_loop1 = false;
                    elseif strcmp(lower(response),'n')|| strcmp(lower(response),'no')
                        inf_loop = false;
                        inf_loop1 = false;
                    else
                        display('Incorrect response.')
                        prompt = 'Continue filtering? Y or N: ';
                        response = input(prompt,'s');
                    end
                end
            end
        end
        if handles.filt_count > 0
            display('***********************************')
            display('     Types of Filters in Use')
            for m = 1:handles.filt_count
                display([num2str(m) '. ' handles.str{m}])
            end
        end
    case 3
        if handles.filt_count ~= 0
            prompt = 'Remove all filters used, Y or N? ';
            response = input(prompt,'s');
            if strcmp(lower(response),'y')|| strcmp(lower(response),'yes')
                handles.str = [];
                handles.filt_count = 0;
                display('***********************************')
                display('All filters has been removed.')
            elseif strcmp(lower(response),'n')|| strcmp(lower(response),'no')
                display('No filters were removed.')
            else
                display('Incorrect response.')
            end
        else
            display('No filters were used.')
        end
    otherwise
end

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in load_data.
function load_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.right_print = true;
handles.load_Data = [];
% handles.centers = [];
% handles.rect_size = [];
handles.count = 0;
handles.count_image = 1;
handles.file_location = get(handles.initial_file,'String');
handles.type = get(handles.file_type,'String');
handles.initial = str2num(get(handles.initial_frame,'String'));
handles.final = str2num(get(handles.final_frame,'String'));
handles.side_image = get(handles.side_panel,'SelectedObject');
handles.side_image = get(handles.side_image,'String');

inf_loop = true;
while inf_loop
    handles.name_imageFile = strcat(handles.file_location,...
        num2str(handles.initial),handles.type);
    if exist(handles.name_imageFile,'file')
        handles.load_Data = imread(handles.name_imageFile);
        
        load_Data1 = imadjust(handles.load_Data, ...
            stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);
        % Switches side of data
        switch char(handles.side_image)
            case 'Left Half'
                handles.initial_side = 1;
                handles.final_side = length(handles.load_Data(1,:))/2;
            case 'Right Half'
                handles.initial_side = length(handles.load_Data(1,:))/2;
                handles.final_side = length(handles.load_Data(1,:));
            case 'Middle'
                handles.initial_side = length(handles.load_Data(1,:))/4;
                handles.final_side = length(handles.load_Data(1,:))...
                    /2+length(handles.load_Data(1,:))/4;
            case 'Full'
                handles.initial_side = 1;
                handles.final_side = length(handles.load_Data(1,:));
            case 'Custom'
                
                    
            otherwise
        end
        %handles.load_Data = imadjust(handles.load_Data);
        
        
        if handles.record_filt & handles.filt_on & handles.filt_count ~=0
            load_Data1 = imadjust(handles.load_Data, ...
                stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);
            [handles.load_Data1 handles.record_image] = switch_filt(handles.str,handles.filt_count,load_Data1);
            if handles.count_image > 1
                handles.count_image = handles.count_image - 1;
            else
                handles.count_image = 1;
            end
            
            axes(handles.axes1);
            imshow(handles.record_image{handles.count_image}(:,handles.initial_side:handles.final_side))
            title(handles.str(handles.count_image))
            axes(handles.axes3);
            handles.hist_Intensities = imhist(handles.record_image{handles.count_image}(:,...
                handles.initial_side:handles.final_side));
            handles.hist_Intensities = handles.hist_Intensities./...
                max(handles.hist_Intensities);
            stem(handles.hist_Intensities)
            title('Normalized Histogram of Image Intensities')
            
        else
            axes(handles.axes1);
            imshow(load_Data1(:,handles.initial_side:handles.final_side))
            title(handles.name_imageFile)
            axes(handles.axes3);
            handles.hist_Intensities = imhist(load_Data1(:,...
                handles.initial_side:handles.final_side));
            handles.hist_Intensities = handles.hist_Intensities./...
                max(handles.hist_Intensities);
            stem(handles.hist_Intensities)
            title('Normalized Histogram of Image Intensities')
        end
        inf_loop = false;
        
        
    else
        warning(['Warning: File ',handles.name_imageFile,' does not exist.'])
        handles.initial = handles.initial + 1;
    end
    if handles.initial > handles.final
        inf_loop = false;
    end
end
if isempty(handles.load_Data) == 1
    warning('Warning: Folder does not contain the requested files.')
end

guidata(hObject, handles);

function initial_frame_Callback(hObject, eventdata, handles)
% hObject    handle to initial_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initial_frame as text
%        str2double(get(hObject,'String')) returns contents of initial_frame as a double


% --- Executes during object creation, after setting all properties.
function initial_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initial_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function final_frame_Callback(hObject, eventdata, handles)
% hObject    handle to final_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of final_frame as text
%        str2double(get(hObject,'String')) returns contents of final_frame as a double


% --- Executes during object creation, after setting all properties.
function final_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to final_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sample_limit_Callback(hObject, eventdata, handles)
% hObject    handle to sample_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sample_limit as text
%        str2double(get(hObject,'String')) returns contents of sample_limit as a double


% --- Executes during object creation, after setting all properties.
function sample_limit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sample_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sample_rate_Callback(hObject, eventdata, handles)
% hObject    handle to sample_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sample_rate as text
%        str2double(get(hObject,'String')) returns contents of sample_rate as a double


% --- Executes during object creation, after setting all properties.
function sample_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sample_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initial_file_Callback(hObject, eventdata, handles)
% hObject    handle to initial_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initial_file as text
%        str2double(get(hObject,'String')) returns contents of initial_file as a double


% --- Executes during object creation, after setting all properties.
function initial_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initial_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function file_type_Callback(hObject, eventdata, handles)
% hObject    handle to file_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_type as text
%        str2double(get(hObject,'String')) returns contents of file_type as a double


% --- Executes during object creation, after setting all properties.
function file_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function folder_name_Callback(hObject, eventdata, handles)
% hObject    handle to folder_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of folder_name as text
%        str2double(get(hObject,'String')) returns contents of folder_name as a double


% --- Executes during object creation, after setting all properties.
function folder_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to folder_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in manual_detect.
function manual_detect_Callback(hObject, eventdata, handles)
% hObject    handle to manual_detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rect_size_manual{end + 1} = getrect;
handles.minimum = str2num(get(handles.min_radius,'String'));
handles.maximum = str2num(get(handles.max_radius,'String'));
handles.sensitivity = str2num(get(handles.detect_sensitivity,'String'));
handles.sample_lim = str2num(get(handles.sample_limit,'String'));

load_Data1 = imadjust(handles.load_Data, ...
    stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);

if isempty(handles.centers) == 0
    if length(handles.centers(:,1)) > handles.sample_lim
        handles.centers(handles.sample_lim+1:end,:) = [];
        
    end
    handles.count = length(handles.centers(:,1));
    %     if handles.count + add_count >= sample_limit
    %         error('Warning: Overload, Sample size has exceeded the limit.')
    %     end
end

axes(handles.axes1);
title(handles.name_imageFile)
imshow(load_Data1(:,handles.initial_side:handles.final_side))
title(handles.name_imageFile)
% places markers on position cropped
if isempty(handles.centers) == 0
    handles.rect_size = [];
    % h = viscircles(handles.centers,handles.radii);
    for m = 1:handles.count
        rectangle('Position', [handles.centers(m,1) - handles.radii(m), handles.centers(m,2)...
            - handles.radii(m), 2 * handles.radii(m), 2 * handles.radii(m)], 'EdgeColor','y');
        text(handles.centers(m,1) - handles.radii(m) + 10,handles.centers(m,2) - handles.radii(m) + 10,...
            sprintf('Sample %d', m),'Color','c')
        handles.rect_size{m} = [handles.centers(m,1) - handles.radii(m), handles.centers(m,2) - handles.radii(m),...
            2 * handles.radii(m), 2 * handles.radii(m)];
    end
end

if isempty(handles.rect_size_manual) == 0
    for m = 1:length(handles.rect_size_manual)
        rectangle('Position', handles.rect_size_manual{m}, 'EdgeColor','y');
        text(handles.rect_size_manual{m}(1) + 10,handles.rect_size_manual{m}(2) + 10,...
            sprintf('Sample %d', m + handles.count),'Color','c')  
    end
end

guidata(hObject, handles);

function min_radius_Callback(hObject, eventdata, handles)
% hObject    handle to min_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_radius as text
%        str2double(get(hObject,'String')) returns contents of min_radius as a double


% --- Executes during object creation, after setting all properties.
function min_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_radius_Callback(hObject, eventdata, handles)
% hObject    handle to max_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_radius as text
%        str2double(get(hObject,'String')) returns contents of max_radius as a double


% --- Executes during object creation, after setting all properties.
function max_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function detect_sensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to detect_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of detect_sensitivity as text
%        str2double(get(hObject,'String')) returns contents of detect_sensitivity as a double


% --- Executes during object creation, after setting all properties.
function detect_sensitivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to detect_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function high_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to high_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.sensitivity_con = str2num(get(handles.contrast_sensitivity,'String'));
handles.high_val = get(hObject,'Value')*handles.sensitivity_con;
load_Data1 = imadjust(handles.load_Data, ...
    stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);
axes(handles.axes1);
imshow(load_Data1(:,handles.initial_side:handles.final_side))
title(handles.name_imageFile)

% places markers on position cropped
if isempty(handles.centers) == 0
    handles.rect_size = [];
    % h = viscircles(handles.centers,handles.radii);
    for m = 1:handles.count
        rectangle('Position', [handles.centers(m,1) - handles.radii(m), handles.centers(m,2)...
            - handles.radii(m), 2 * handles.radii(m), 2 * handles.radii(m)], 'EdgeColor','y');
        text(handles.centers(m,1) - handles.radii(m) + 10,handles.centers(m,2) - handles.radii(m) + 10,...
            sprintf('Sample %d', m),'Color','c')
        handles.rect_size{m} = [handles.centers(m,1) - handles.radii(m), handles.centers(m,2) - handles.radii(m),...
            2 * handles.radii(m), 2 * handles.radii(m)];
    end
end

if isempty(handles.rect_size_manual) == 0
    for m = 1:length(handles.rect_size_manual)
        rectangle('Position', handles.rect_size_manual{m}, 'EdgeColor','y');
        text(handles.rect_size_manual{m}(1) + 10,handles.rect_size_manual{m}(2) + 10,...
            sprintf('Sample %d', m + handles.count),'Color','c')  
    end
end

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function high_contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to high_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function low_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to low_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.sensitivity_con = str2num(get(handles.contrast_sensitivity,'String'));
handles.low_val = get(hObject,'Value')*handles.sensitivity_con;
load_Data1 = imadjust(handles.load_Data, ...
    stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);
axes(handles.axes1);
imshow(load_Data1(:,handles.initial_side:handles.final_side))
title(handles.name_imageFile)

% places markers on position cropped
if isempty(handles.centers) == 0
    handles.rect_size = [];
    % h = viscircles(handles.centers,handles.radii);
    for m = 1:handles.count
        rectangle('Position', [handles.centers(m,1) - handles.radii(m), handles.centers(m,2)...
            - handles.radii(m), 2 * handles.radii(m), 2 * handles.radii(m)], 'EdgeColor','y');
        text(handles.centers(m,1) - handles.radii(m) + 10,handles.centers(m,2) - handles.radii(m) + 10,...
            sprintf('Sample %d', m),'Color','c')
        handles.rect_size{m} = [handles.centers(m,1) - handles.radii(m), handles.centers(m,2) - handles.radii(m),...
            2 * handles.radii(m), 2 * handles.radii(m)];
    end
end

if isempty(handles.rect_size_manual) == 0
    for m = 1:length(handles.rect_size_manual)
        rectangle('Position', handles.rect_size_manual{m}, 'EdgeColor','y');
        text(handles.rect_size_manual{m}(1) + 10,handles.rect_size_manual{m}(2) + 10,...
            sprintf('Sample %d', m + handles.count),'Color','c')  
    end
end

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function low_contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to low_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in auto_scroll.
function auto_scroll_Callback(hObject, eventdata, handles)
% hObject    handle to auto_scroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.load_Data) == 1
    handles.load_Data = [];
    handles.file_location = get(handles.initial_file,'String');
    handles.type = get(handles.file_type,'String');
    handles.initial = str2num(get(handles.initial_frame,'String'));
    handles.final = str2num(get(handles.final_frame,'String'));
end

inf_Loop = true;
% handles.auto_value = get(hObject,'Value')
if handles.auto_value == 1
    handles.auto_value = 0;
else
    handles.auto_value = 1;
end
guidata(hObject, handles);

while inf_Loop
    handles.auto_value
    display('1')
    pause(1)
    if handles.auto_value == 0
        handles.initial = abs(handles.initial);
        inf_Loop = false;
    end
    handles.auto_value
    display('2')
    pause(1)
    handles.name_imageFile = strcat(handles.file_location,...
        num2str(abs(handles.initial)),handles.type);
    if exist(handles.name_imageFile,'file')
        handles.load_Data = imread(handles.name_imageFile);
        handles.side_image = get(handles.side_panel,'SelectedObject');
        handles.side_image = get(handles.side_image,'String');
        switch char(handles.side_image)
            case 'Left Half'
                handles.initial_side = 1;
                handles.final_side = length(handles.load_Data(1,:))/2;
            case 'Right Half'
                handles.initial_side = length(handles.load_Data(1,:))/2;
                handles.final_side = length(handles.load_Data(1,:));
            case 'Middle'
                handles.initial_side = length(handles.load_Data(1,:))/4;
                handles.final_side = length(handles.load_Data(1,:))...
                    /2+length(handles.load_Data(1,:))/4;
            case 'Full'
                handles.initial_side = 1;
                handles.final_side = length(handles.load_Data(1,:));
            case 'Custom'
                handles.initial_side = handles.n;
                handles.final_side = handles.partition_num + handles.n;
            otherwise
        end
        
        load_Data1 = imadjust(handles.load_Data, ...
            stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);
        axes(handles.axes1);
        imshow(load_Data1(:,handles.initial_side:handles.final_side))
        title(handles.name_imageFile)
        if isempty(handles.centers) == 0
            % h = viscircles(handles.centers,handles.radii);
            for m = 1:handles.count
                rectangle('Position', handles.rect_size{m}, 'EdgeColor','y');
                text(handles.rect_size{1,m}(1,1)+10,handles.rect_size{1,m}(1,2)+10, ...
                    sprintf('Sample %d', m),'Color','c')
            end
        end
        
        if isempty(handles.rect_size_manual) == 0
            for m = 1:length(handles.rect_size_manual)
                rectangle('Position', handles.rect_size_manual{m}, 'EdgeColor','y');
                text(handles.rect_size_manual{m}(1) + 10,handles.rect_size_manual{m}(2) + 10,...
                    sprintf('Sample %d', m + handles.count),'Color','c')
            end
        end
        
        title(handles.name_imageFile)
        
        axes(handles.axes3);
        handles.hist_Intensities = imhist(load_Data1(:,...
            handles.initial_side:handles.final_side));
        handles.hist_Intensities = handles.hist_Intensities./...
            max(handles.hist_Intensities);
        stem(handles.hist_Intensities)
        title('Normalized Histogram of Image Intensities')
        pause(.2)
    else
        if handles.right_print
            warning(['Warning: File ',handles.name_imageFile,' does not exist.'])
        end
    end
    handles.initial = handles.initial + 1;
    if abs(handles.initial) >= handles.final
        handles.right_print = false;
        if isempty(handles.load_Data) == 1
            warning('Warning: Folder does not contain the requested files.')
            inf_loop = false;
        else
            handles.initial = - handles.initial;
        end
    elseif abs(handles.initial) < str2num(get(handles.initial_frame,'String'))
        handles.initial = str2num(get(handles.initial_frame,'String')) + 1;
    end
    
    %     auto_value = get(hObject,'Value');
    % handles.auto_value
    %
    %     if handles.auto_value == 0
    %         handles.initial = abs(handles.initial);
    %         inf_Loop = false;
    %     end
    
    % button_state = get(hObject,'Value');
    % if button_state == get(hObject,'Max')
    % 	handles.auto_value = 0;
    % elseif button_state == get(hObject,'Min')
    % 	handles.auto_value = 1;
    % end
    
end

guidata(hObject, handles);

% --- Executes on button press in left_button.
function left_button_Callback(hObject, eventdata, handles)
% hObject    handle to left_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.record_filt & handles.filt_on & handles.filt_count ~=0
    load_Data1 = imadjust(handles.load_Data, ...
        stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);
    [handles.load_Data1 handles.record_image] = switch_filt(handles.str,handles.filt_count,load_Data1);
    if handles.count_image > 1
        handles.count_image = handles.count_image - 1;
    else
        handles.count_image = 1;
    end
    
    axes(handles.axes1);
    imshow(handles.record_image{handles.count_image}(:,handles.initial_side:handles.final_side))
    title(handles.str(handles.count_image))
    axes(handles.axes3);
    handles.hist_Intensities = imhist(handles.record_image{handles.count_image}(:,...
        handles.initial_side:handles.final_side));
    handles.hist_Intensities = handles.hist_Intensities./...
        max(handles.hist_Intensities);
    stem(handles.hist_Intensities)
    title('Normalized Histogram of Image Intensities')
else
    handles.initial = handles.initial - 1;
    inf_loop = true;
    left_count = 0;
    while inf_loop
        if handles.initial < str2num(get(handles.initial_frame,'String'))
            handles.initial = str2num(get(handles.initial_frame,'String')) + left_count;
            left_count = left_count + 1;
        end
        handles.name_imageFile = strcat(handles.file_location,...
            num2str(abs(handles.initial)),handles.type);
        if exist(handles.name_imageFile,'file')
            handles.load_Data = imread(handles.name_imageFile);
            
            load_Data1 = imadjust(handles.load_Data, ...
                stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);
            axes(handles.axes1);
            imshow(load_Data1(:,handles.initial_side:handles.final_side))
            title(handles.name_imageFile)
            if isempty(handles.centers) == 0
                % h = viscircles(handles.centers,handles.radii);
                for m = 1:handles.count
                    rectangle('Position', handles.rect_size{m}, 'EdgeColor','y');
                    text(handles.rect_size{1,m}(1,1)+10,handles.rect_size{1,m}(1,2)+10, ...
                        sprintf('Sample %d', m),'Color','c')
                end
            end
            
            if isempty(handles.rect_size_manual) == 0
                for m = 1:length(handles.rect_size_manual)
                    rectangle('Position', handles.rect_size_manual{m}, 'EdgeColor','y');
                    text(handles.rect_size_manual{m}(1) + 10,handles.rect_size_manual{m}(2) + 10,...
                        sprintf('Sample %d', m + handles.count),'Color','c')
                end
            end
            
            axes(handles.axes3);
            handles.hist_Intensities = imhist(load_Data1(:,...
                handles.initial_side:handles.final_side));
            handles.hist_Intensities = handles.hist_Intensities./...
                max(handles.hist_Intensities);
            stem(handles.hist_Intensities)
            title('Normalized Histogram of Image Intensities')
            inf_loop = false;
        else
            warning(['Warning: File ',handles.name_imageFile,' does not exist.'])
            handles.initial = handles.initial - 1;
        end
    end
end
guidata(hObject, handles);

% --- Executes on button press in right_button.
function right_button_Callback(hObject, eventdata, handles)
% hObject    handle to right_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.record_filt & handles.filt_on & handles.filt_count ~=0
    load_Data1 = imadjust(handles.load_Data, ...
        stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);
    [handles.load_Data1 handles.record_image] = switch_filt(handles.str,handles.filt_count,load_Data1);
    if handles.count_image < handles.filt_count
        handles.count_image = handles.count_image + 1;
    else
        handles.count_image = handles.filt_count;
    end
    
    axes(handles.axes1);
    imshow(handles.record_image{handles.count_image}(:,handles.initial_side:handles.final_side))
    title(handles.str(handles.count_image))
    axes(handles.axes3);
    handles.hist_Intensities = imhist(handles.record_image{handles.count_image}(:,...
        handles.initial_side:handles.final_side));
    handles.hist_Intensities = handles.hist_Intensities./...
        max(handles.hist_Intensities);
    stem(handles.hist_Intensities)
    title('Normalized Histogram of Image Intensities')
else
    handles.initial = handles.initial + 1;
    inf_loop = true;
    right_count = 0;
    while inf_loop
        if handles.initial >= str2num(get(handles.final_frame,'String'));
            handles.right_print = false;
            handles.initial = str2num(get(handles.final_frame,'String')) - right_count;
            right_count = right_count + 1;
        end
        handles.name_imageFile = strcat(handles.file_location,...
            num2str(abs(handles.initial)),handles.type);
        if exist(handles.name_imageFile,'file')
            handles.load_Data = imread(handles.name_imageFile);
            
            load_Data1 = imadjust(handles.load_Data, ...
                stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);
            axes(handles.axes1);
            imshow(load_Data1(:,handles.initial_side:handles.final_side))
            title(handles.name_imageFile)
            if isempty(handles.centers) == 0
                % h = viscircles(handles.centers,handles.radii);
                for m = 1:handles.count
                    rectangle('Position', handles.rect_size{m}, 'EdgeColor','y');
                    text(handles.rect_size{1,m}(1,1)+10,handles.rect_size{1,m}(1,2)+10, ...
                        sprintf('Sample %d', m),'Color','c')
                end
            end
            
            if isempty(handles.rect_size_manual) == 0
                for m = 1:length(handles.rect_size_manual)
                    rectangle('Position', handles.rect_size_manual{m}, 'EdgeColor','y');
                    text(handles.rect_size_manual{m}(1) + 10,handles.rect_size_manual{m}(2) + 10,...
                        sprintf('Sample %d', m + handles.count),'Color','c')
                end
            end
            axes(handles.axes3);
            handles.hist_Intensities = imhist(load_Data1(:,...
                handles.initial_side:handles.final_side));
            handles.hist_Intensities = handles.hist_Intensities./...
                max(handles.hist_Intensities);
            stem(handles.hist_Intensities)
            title('Normalized Histogram of Image Intensities')
            inf_loop = false;
        else
            if handles.right_print
                warning(['Warning: File ',handles.name_imageFile,' does not exist.'])
            end
            handles.initial = handles.initial + 1;
        end
    end
end
guidata(hObject, handles);

function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when selected object is changed in side_panel.
function side_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in side_panel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if hObject == handles.left_half
    handles.initial_side = 1;
    handles.final_side = length(handles.load_Data(1,:))/2;
elseif hObject == handles.right_half
    handles.initial_side = length(handles.load_Data(1,:))/2;
    handles.final_side = length(handles.load_Data(1,:));
elseif hObject == handles.middle_half
    handles.initial_side = length(handles.load_Data(1,:))/4;
    handles.final_side = length(handles.load_Data(1,:))...
        /2+length(handles.load_Data(1,:))/4;
elseif hObject == handles.full
    handles.initial_side = 1;
    handles.final_side = length(handles.load_Data(1,:));
elseif hObject == handles.custom
    handles.initial_side = handles.n;
    handles.final_side = handles.partition_num + handles.n;
end

load_Data1 = imadjust(handles.load_Data, ...
    stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);

axes(handles.axes1);
imshow(load_Data1(:,handles.initial_side:handles.final_side))
title(handles.name_imageFile)
axes(handles.axes3);
handles.hist_Intensities = imhist(load_Data1(:,...
    handles.initial_side:handles.final_side));
handles.hist_Intensities = handles.hist_Intensities./...
    max(handles.hist_Intensities);
stem(handles.hist_Intensities)
title('Normalized Histogram of Image Intensities')

guidata(hObject, handles);


% --- Executes on button press in delete.
function delete_Callback(hObject, eventdata, handles)
% hObject    handle to delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inf_loop = true;
while inf_loop
    if isempty(handles.rect_size_manual) == 0 || isempty(handles.centers) == 0
        
        if handles.count == 1
            handles.rect_size(1) = [];
            handles.centers(1,:) = [];
            handles.radii(1) = [];
            handles.count = 0;
        elseif length(handles.rect_size_manual) == 1
            handles.rect_size_manual(1) = [];
        else
            display('Enter one of the following commands only. ')
            display('A number for single deletion')
            display('1:2 for interval deletion. ')
            display('1,2,... for discontinuous deletion. ')
            display('delete all to delete all sample points')
            prompt = 'Delete which sample number(s)? ';
            response = input(prompt,'s');
            response(response==' ') = [];
            A = isstrprop(response, 'digit');
            if mean(A) == 1
                num = str2num(response);
                if num <= handles.count & num > 0
                    handles.rect_size(num) = [];
                    handles.centers(num,:) = [];
                    handles.radii(num) = [];
                    handles.count = handles.count - 1;
                elseif num <= handles.count + length(handles.rect_size_manual) & num > 0
                    handles.rect_size_manual(num-handles.count) = [];
                end
            elseif mean(A) == 0
                if strcmp(lower(response),'deleteall') || strcmp(lower(response),'all')
                    handles.rect_size = [];
                    handles.rect_size_manual = [];
                    handles.centers = [];
                    handles.radii = [];
                    handles.count = 0;
                    inf_loop = false;
                else
                    display('Incorrect response')
                end
            else
                split_response = strsplit(response,',');
                count_delete = 0;
                order_num = [];
                order_other = [];
                for i = 1:length(split_response)
                    if mean(isstrprop(split_response{i}, 'digit')) == 1
                        order_num(i) = str2num(split_response{i});
                    else
                        order_other{end+1} = split_response{i};
                    end
                end
                
                if isempty(order_num) == 0
                    order_num = sort(order_num,'descend');
                    order_num = num2str(order_num);
                    order_num = strsplit(order_num,' ');
                end
                
                split_response = [];
                split_response = [order_num order_other];
                
                for i = 1:length(split_response)
                    if mean(isstrprop(split_response{i}, 'digit')) == 1
                        num = str2num(split_response{i}); % - count_delete
                        if num <= handles.count & num > 0
                            handles.rect_size(num) = [];
                            handles.centers(num,:) = [];
                            handles.radii(num) = [];
                            handles.count = length(handles.centers(:,1));
                        elseif num <= handles.count + length(handles.rect_size_manual) & num > handles.count
                            handles.rect_size_manual(num-handles.count) = [];
                        end
                    else
                        [left_colon right_colon] = strread(split_response{i}, '%s %s', 'delimiter',':');
                        if mean(isstrprop(left_colon{1}, 'digit')) == 1 & mean(isstrprop(right_colon{1}, 'digit')) == 1
                            if max(str2num(left_colon{1}),str2num(right_colon{1})) <= handles.count & ...
                                    min(str2num(left_colon{1}),str2num(right_colon{1})) >= 1
                                handles.rect_size(min(str2num(left_colon{1}),...
                                    str2num(right_colon{1})):max(str2num(left_colon{1}),str2num(right_colon{1}))) = [];
                                handles.centers(min(str2num(left_colon{1}),...
                                    str2num(right_colon{1})):max(str2num(left_colon{1}),str2num(right_colon{1})),:) = [];
                                handles.radii(min(str2num(left_colon{1}),...
                                    str2num(right_colon{1})):max(str2num(left_colon{1}),str2num(right_colon{1}))) = [];
                                handles.count = length(handles.centers(:,1));
                                count_delete = count_delete + max(str2num(left_colon{1}),...
                                    str2num(right_colon{1})) - min(str2num(left_colon{1}),str2num(right_colon{1}));
                            elseif max(str2num(left_colon{1}),str2num(right_colon{1})) <= ...
                                    handles.count + length(handles.rect_size_manual) & ...
                                    min(str2num(left_colon{1}),str2num(right_colon{1})) >= handles.count
                                handles.rect_size_manual(min(str2num(left_colon{1}),...
                                    str2num(right_colon{1}))-handles.count:max(...
                                    str2num(left_colon{1}),str2num(right_colon{1}))-handles.count) = [];
                            elseif max(str2num(left_colon{1}),str2num(right_colon{1})) > handles.count ...
                                    & min(str2num(left_colon{1}),str2num(right_colon{1})) <= handles.count
                                handles.rect_size(min(str2num(left_colon{1}),str2num(right_colon{1})):end) = [];
                                handles.centers(min(str2num(left_colon{1}),str2num(right_colon{1})):end,:) = [];
                                handles.radii(min(str2num(left_colon{1}),str2num(right_colon{1})):end) = [];
                                handles.rect_size_manual(1:max(str2num(left_colon{1}),...
                                    str2num(right_colon{1}))-handles.count) = [];
                                handles.count = length(handles.centers(:,1));
                                count_delete = count_delete + max(str2num(left_colon{1}),...
                                    str2num(right_colon{1})) - min(str2num(left_colon{1}),str2num(right_colon{1}));
                            else
                                display('Interval range out of bound.')
                            end
                        else
                            display('Incorrect input.')
                        end
                    end
                end
            end
            
            
        end
        
        axes(handles.axes1);
        load_Data1 = imadjust(handles.load_Data, ...
            stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);
        imshow(load_Data1(:,handles.initial_side:handles.final_side))
        title(handles.name_imageFile)
        
        % places markers on position cropped
        if isempty(handles.centers) == 0
            handles.rect_size = [];
            % h = viscircles(handles.centers,handles.radii);
            for m = 1:length(handles.centers(:,1))
                rectangle('Position', [handles.centers(m,1) - handles.radii(m), handles.centers(m,2)...
                    - handles.radii(m), 2 * handles.radii(m), 2 * handles.radii(m)], 'EdgeColor','y');
                text(handles.centers(m,1) - handles.radii(m) + 10,handles.centers(m,2) - handles.radii(m) + 10,...
                    sprintf('Sample %d', m),'Color','c')
                handles.rect_size{m} = [handles.centers(m,1) - handles.radii(m), ...
                    handles.centers(m,2) - handles.radii(m),2 * handles.radii(m), 2 * handles.radii(m)];
            end
        end
        
        if isempty(handles.rect_size_manual) == 0
            for m = 1:length(handles.rect_size_manual)
                rectangle('Position', handles.rect_size_manual{m}, 'EdgeColor','y');
                text(handles.rect_size_manual{m}(1) + 10,handles.rect_size_manual{m}(2) + 10,...
                    sprintf('Sample %d', m + handles.count),'Color','c')
            end
        end
        
        
        if isempty(handles.rect_size_manual) == 0 || isempty(handles.centers) == 0
            inf_loop1 = true;
            while inf_loop1
                prompt = 'Continue deleting sample points? Y or N: ';
                response = input(prompt,'s');
                if strcmp(lower(response),'y')|| strcmp(lower(response),'yes')
                    inf_loop1 = false;
                elseif strcmp(lower(response),'n')|| strcmp(lower(response),'no')
                    inf_loop = false;
                    inf_loop1 = false;
                else
                    display('Incorrect response.')
                end
            end
            
        else
            display('There are no other sample points to delete. ')
            inf_loop = false;
        end
        
        
    else
        display('There are no sample points to delete. ')
        inf_loop = false;   
    end
end


guidata(hObject, handles);


% --- Executes on button press in preview.
function preview_Callback(hObject, eventdata, handles)
% hObject    handle to preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of preview
status = get(hObject,'Value');
load_Data1 = imadjust(handles.load_Data, ...
    stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);
if status == 1
    handles.record_filt = true;
    if handles.filt_count ~=0 & handles.filt_on
        [handles.load_Data1 handles.record_image] = switch_filt(handles.str,handles.filt_count,load_Data1);
        axes(handles.axes1);
        imshow(handles.record_image{handles.count_image}(:,handles.initial_side:handles.final_side))
        title(handles.str(handles.count_image))
        axes(handles.axes3);
        handles.hist_Intensities = imhist(handles.record_image{handles.count_image}(:,...
            handles.initial_side:handles.final_side));
        handles.hist_Intensities = handles.hist_Intensities./...
            max(handles.hist_Intensities);
        stem(handles.hist_Intensities)
        title('Normalized Histogram of Image Intensities')
        
    else
        axes(handles.axes1);
        imshow(load_Data1(:,handles.initial_side:handles.final_side))
        title(handles.name_imageFile)
        axes(handles.axes3);
        handles.hist_Intensities = imhist(load_Data1(:,...
            handles.initial_side:handles.final_side));
        handles.hist_Intensities = handles.hist_Intensities./...
            max(handles.hist_Intensities);
        stem(handles.hist_Intensities)
        title('Normalized Histogram of Image Intensities')
        display('No filters were used.')
    end
    
else
    handles.record_filt = false;
    axes(handles.axes1);
    imshow(load_Data1(:,handles.initial_side:handles.final_side))
    title(handles.name_imageFile)
    axes(handles.axes3);
    handles.hist_Intensities = imhist(load_Data1(:,...
        handles.initial_side:handles.final_side));
    handles.hist_Intensities = handles.hist_Intensities./...
        max(handles.hist_Intensities);
    stem(handles.hist_Intensities)
    title('Normalized Histogram of Image Intensities')
end

guidata(hObject, handles);

% --- Executes on selection change in filter.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filter


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in filter_on.
function filter_on_Callback(hObject, eventdata, handles)
% hObject    handle to filter_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filter_on
status = get(hObject,'Value');
if status == 1
    handles.filt_on = true;
else
    handles.filt_on = false;
end

load_Data1 = imadjust(handles.load_Data, ...
    stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);

if handles.filt_on == false
    axes(handles.axes1);
    imshow(load_Data1(:,handles.initial_side:handles.final_side))
    title(handles.name_imageFile)
    axes(handles.axes3);
    handles.hist_Intensities = imhist(load_Data1(:,...
        handles.initial_side:handles.final_side));
    handles.hist_Intensities = handles.hist_Intensities./...
        max(handles.hist_Intensities);
    stem(handles.hist_Intensities)
    title('Normalized Histogram of Image Intensities')
elseif handles.filt_on & handles.record_filt & handles.filt_count ~=0
    [handles.load_Data1 handles.record_image] = switch_filt(handles.str,handles.filt_count,load_Data1);
    axes(handles.axes1);
    imshow(handles.record_image{handles.count_image}(:,handles.initial_side:handles.final_side))
    title(handles.str(handles.count_image))
    axes(handles.axes3);
    handles.hist_Intensities = imhist(handles.record_image{handles.count_image}(:,...
        handles.initial_side:handles.final_side));
    handles.hist_Intensities = handles.hist_Intensities./...
        max(handles.hist_Intensities);
    stem(handles.hist_Intensities)
    title('Normalized Histogram of Image Intensities')
end
guidata(hObject, handles);


function contrast_sensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to contrast_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of contrast_sensitivity as text
%        str2double(get(hObject,'String')) returns contents of contrast_sensitivity as a double


% --- Executes during object creation, after setting all properties.
function contrast_sensitivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contrast_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in auto_detect.
function auto_detect_Callback(hObject, eventdata, handles)
% hObject    handle to auto_detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.minimum = str2num(get(handles.min_radius,'String'));
handles.maximum = str2num(get(handles.max_radius,'String'));
handles.sensitivity = str2num(get(handles.detect_sensitivity,'String'));
handles.sample_lim = str2num(get(handles.sample_limit,'String'));

load_Data1 = imadjust(handles.load_Data, ...
    stretchlim(handles.load_Data,[handles.low_val 1 - handles.high_val]),[]);

if handles.filt_on
    [handles.load_Data1 handles.record_image] = switch_filt(handles.str,handles.filt_count,load_Data1);
    load_Data2 = im2bw(handles.load_Data1);
    [handles.centers, handles.radii] = imfindcircles(load_Data2(:,handles.initial_side:handles.final_side),...
        [handles.minimum handles.maximum],'Sensitivity',handles.sensitivity);
else
    [handles.centers, handles.radii] = imfindcircles(im2bw(load_Data1(:,handles.initial_side:handles.final_side)),...
        [handles.minimum handles.maximum],'Sensitivity',handles.sensitivity);
end

if isempty(handles.centers) == 0
    if length(handles.centers(:,1)) > handles.sample_lim
        handles.centers(handles.sample_lim+1:end,:) = [];
    end
    handles.count = length(handles.centers(:,1));
    %     if handles.count + add_count >= sample_limit
    %         error('Warning: Overload, Sample size has exceeded the limit.')
    %     end
end

axes(handles.axes1);
title(handles.name_imageFile)
imshow(load_Data1(:,handles.initial_side:handles.final_side))
title(handles.name_imageFile)

% places markers on position cropped
if isempty(handles.centers) == 0
    handles.rect_size = [];
    % h = viscircles(handles.centers,handles.radii);
    for m = 1:handles.count
        rectangle('Position', [handles.centers(m,1) - handles.radii(m), handles.centers(m,2)...
            - handles.radii(m), 2 * handles.radii(m), 2 * handles.radii(m)], 'EdgeColor','y');
        text(handles.centers(m,1) - handles.radii(m) + 10,handles.centers(m,2) - handles.radii(m) + 10,...
            sprintf('Sample %d', m),'Color','c')
        handles.rect_size{m} = [handles.centers(m,1) - handles.radii(m), handles.centers(m,2) - handles.radii(m),...
            2 * handles.radii(m), 2 * handles.radii(m)];
    end
end

if isempty(handles.rect_size_manual) == 0
    for m = 1:length(handles.rect_size_manual)
        rectangle('Position', handles.rect_size_manual{m}, 'EdgeColor','y');
        text(handles.rect_size_manual{m}(1) + 10,handles.rect_size_manual{m}(2) + 10,...
            sprintf('Sample %d', m + handles.count),'Color','c')  
    end
end

guidata(hObject, handles);

% --- Executes on button press in mult_track.
function mult_track_Callback(hObject, eventdata, handles)
% hObject    handle to mult_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in one_track.
function one_track_Callback(hObject, eventdata, handles)
% hObject    handle to one_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
