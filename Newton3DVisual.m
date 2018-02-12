
function varargout = Newton3DVisual(varargin)
% K?ytt?liittym?n alustus
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Newton3DVisual_OpeningFcn, ...
                       'gui_OutputFcn',  @Newton3DVisual_OutputFcn, ...
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


end

% --- Executes just before Newton3DVisual is made visible.
function Newton3DVisual_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for Newton3DVisual
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

end

% --- Outputs from this function are returned to the command line.
function varargout = Newton3DVisual_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

    % --- "Visualisoi!"-painikkeen toiminta.
          
    % Haetaan k?ytt?j?n antamat funktiot, aloituspiste ja tarkkuus
    f = str2func(['@(x,y)',get(handles.edit1,'String')]);
    g = str2func(['@(x,y)',get(handles.edit2,'String')]);
    x0 = [str2double(get(handles.edit3,'String'));str2double(get(handles.edit4,'String'))];
    diff = str2double(get(handles.edit5,'String'));
 
    % Asetetaan GUI:n koordinaatisto piirtokoordinaatistoksi
    axes(handles.axes1);
    
    % Piirret??n k?ytt?j?n antamat tasot
    [X,Y] = meshgrid(-2:.1:2, -1:.1:1);
    surf(X,Y,f(X,Y),'Facecolor','g'); hold on;
    surf(X,Y,g(X,Y),'Facecolor','b');
    
    % Asetetaan valonl?hteit? koordinaatistoon
    light('Position',[-1 0 0],'Style','local')          
    light('Position',[0 0 1],'Style','local') 
    light('Position',[0 0 0],'Style','local') 
       
    view(-13,35);
    
    % Katsotaan k?ytt?j?n antama "V?ri valinta"
    clr = handles.uibuttongroup1.SelectedObject.String;
    
    % Pieni p??si?ismuna :D. Vaatii kuitenkin toistettavan mp3 tiedoston.
    if (strcmp(clr, 'Macintosh+'))
        % Muuttaa tasojen v?rityst? ja laittaa musiikin soimaan.
        % Funktiokutsu kommentoitu, jotta ohjelma toimisi ilman
        % musiikkitiedostoa
        
            %playMp3('mac.mp3');
            shading interp
            colormap('colorcube');
    end
    
    % Kutsutaan p??asiallista newtonin metodi funktiota 
    HT_newtonMultiple({f,g},x0,diff,10000,hObject, eventdata, handles)
    
end


function edit1_Callback(hObject, eventdata, handles)
    % hObject    handle to edit1 (see GCBO)
end
    
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
 
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

end

function edit3_Callback(hObject, eventdata, handles)
    % hObject    handle to edit3 (see GCBO)
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
   
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

end

function edit2_Callback(hObject, eventdata, handles)
    % hObject    handle to edit2 (see GCBO)
    
end
   

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
   
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% Reset painikkeen toiminnot, tyhjent?? siis muuttuja avaruuden, konsolin
% ja koordinaatiston
    set(handles.text3,'String',num2str(0));
    set(handles.text5,'String',num2str([0,0,0]));
    clc
    cla;
    
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% Askel painikkeen toiminnot.

    % Haetaan k?ytt?j?n antamat funktiot, aloituspiste ja tarkkuus
    f = str2func(['@(x,y)',get(handles.edit1,'String')]);
    g = str2func(['@(x,y)',get(handles.edit2,'String')]);
    diff = str2double(get(handles.edit5,'String'));
    
    % Asetetaan GUI:n koordinaatisto piirtokoordinaatistoksi
    axes(handles.axes1);
    
    % Piirret??n k?ytt?j?n antamat tasot
    [X,Y] = meshgrid(-2:.1:2, -1:.1:1);
    surf(X,Y,f(X,Y),'Facecolor','g','EdgeLighting','gouraud'); hold on;
    surf(X,Y,g(X,Y),'Facecolor','b','EdgeLighting','gouraud');
    
        
    % Katsotaan k?ytt?j?n antama "V?ri valinta"
    clr = handles.uibuttongroup1.SelectedObject.String;
    
    % Pieni p??si?ismuna :D. Vaatii kuitenkin toistettavan mp3 tiedoston.
    if (strcmp(clr, 'Macintosh+'))
        % Muuttaa tasojen v?rityst? ja laittaa musiikin soimaan.
        % Funktiokutsu kommentoitu, jotta ohjelma toimisi ilman
        % musiikkitiedostoa
        
            %playMp3('mac.mp3');
            shading interp
            colormap('colorcube');
    end
  
    % Askelletaan newton funktiota. Toinen haara alustaa, toinen toimii
    % jatkoaskelten kanssa. K?ytt?liittym? pohjainen ratkaisu, josta on
    % vaikea ylpeytt? kantaa.
    
    if(strcmp(get(handles.text5,'String'),'0  0  0'))
        xval = [str2double(get(handles.edit3,'String'));str2double(get(handles.edit4,'String'))];
        xval = HT_newtonMultiple({f,g},xval,diff,1,hObject, eventdata, handles);
        set(handles.text3,'String',num2str(1)); 
        set(handles.text5,'String',num2str(xval)); 
        light('Position',[-1 0 0],'Style','local')          
        light('Position',[0 0 1],'Style','local') 
        light('Position',[0 0 2],'Style','local') 
        light('Position',[0 0 -1],'Style','local') 
        
        
    else
        xval = str2num(get(handles.text5,'String'));
        xval = xval(1:2);
        xval = HT_newtonMultiple({f,g},xval,diff,1,hObject, eventdata, handles);
        n = str2double(get(handles.text3,'String'));
        set(handles.text3,'String',num2str(n+1)); 
        set(handles.text5,'String',num2str(xval)); 
    end
    
end

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)

end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)

end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)

end

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)

end
%% Vertailu, tms
% Pohdintaa pohdintaa... mit? pohdintaa?

%% Funktiot
function x = HT_newtonMultiple(fn,x0,diff,rounds,hObject, eventdata, handles)
% Newton metodin yleist? muotoa noudattava funktio. 

% P??asiallinen toiminta:
% Funktioita py?ritet??n cell array:ssa ja iteroidaan matriisella ratkaistuja pisteit?.

% Muuttujien alustus
    F = cell(1,length(fn));
    J = zeros(length(fn),length(x0));
    x = x0;
    n = 0;
    s = 600;

% P??looppi. Lopetus ehtona kierrosten m??r? tai riitt?v? tarkkuus    
    while norm(s)>diff&&n<rounds
      
        l = num2cell(x');
        
        % Lasketaan matriisi J (gradientit)
        for k = 1:length(fn)
            for i = 1:length(x)
               
                % suuntavektorit
                sv = zeros(1,length(x));
                sv(i) = 1;
                
                J(k,i)= derivaatta(fn{k},x',sv);
            end
        end
        
        % Askelletaan funktiolistan l?pi ja kutsutaan
        % funktioita pistevektorilla x
        for o = 1:length(fn)
           F{1,o} = fn{1,o}(l{:});
        end
        
        % Ratkaistaan vektori s (J\F)
        s = J\[F{:}]'; 
        xh = x;
        % Ja muutetaan pistevektorin x arvoa seuraavalle iteraatiolle
        x = x - s;
        
        % P?ivitet??n k?ytt?liittym?n iteraatio laskinta ja pistett?
        if(rounds > 1)
            set(handles.text3,'String',num2str(n+1));
            set(handles.text5,'String',num2str([x(1),x(2),fn{1}(x(1),x(2))]));
        end
        
        
        % Tarkistetaan k?ytt?j?n asettamat V?ri-optiot
        clr = handles.uibuttongroup1.SelectedObject.String;
        
        if (strcmp(clr, 'Punainen'))
            colour = {'r--'};
        elseif (strcmp(clr, 'Vihre?'))
            colour = {'g--'};    
        elseif (strcmp(clr, 'Macintosh+'))
            colour = {'m--'};           
        end
       
        % Tarkistetaan visualisointitapa
        vOption = handles.uibuttongroup2.SelectedObject.String;
 
        if(strcmp(vOption, 'Tasot'))
            
            % Poistetaan aiempi piirros kuvasta.
            if(exist('tp','var'))
                delete(tp);
                delete(tp1);
            end
            
            % Tangenttitason yht?l?
            ft = @(x,y)fn{1}(xh(1),xh(2))+J(1,1)*(x-xh(1))+J(1,2)*(y-xh(2));
            ft2 = @(x,y)fn{2}(xh(1),xh(2))+J(2,1)*(x-xh(1))+J(2,2)*(y-xh(2));
            
            [X,Y] = meshgrid(-1:.1:2, -1:.1:1);
            
            % Piirret??n taso
            if(strcmp(clr, 'Macintosh+'))
               tp = surf(X,Y,ft(X,Y),'FaceColor', [rand() rand() rand()]);
               tp1 = surf(X,Y,ft2(X,Y),'FaceColor', [rand() rand() rand()]);
            else
               tp = surf(X,Y,ft(X,Y),'FaceColor', [1 0 0],'EdgeLighting','gouraud');
               tp1 = surf(X,Y,ft2(X,Y),'FaceColor', [1 0 0],'EdgeLighting','gouraud');
            end
            
        elseif(strcmp(vOption, 'Pisteet'))
            
            % Piirret??n iteroidut pisteet ja niiden v?liin "polku"
            plot3([xh(1),x(1)],[xh(2),x(2)],[fn{1}(xh(1),xh(2)),fn{1}(x(1),x(2))],...
            colour{1},'linewidth',2);
            plot3(x(1),x(2),fn{1}(x(1),x(2)),'rx','linewidth',2);
           
        end

        if(rounds ~= 1)
            pause(2)
        else
            drawnow();
        end
        
        n = n+1;
    end
    n
end

function d = derivaatta(f,p,svn)
  % Eteenp?in laskettu differenssi
   h = 0.1;
   sv= svn/norm(svn);
   k = num2cell(p+h*sv);
   l = num2cell(p);
  
   d = (f(k{:}) - f(l{:}))/h;
    
end

function playMp3(file)
% Musiikin toisto funktio.

    [y,Fs]=audioread(file);
    sound(y,Fs)
    
end
