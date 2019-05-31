function varargout = MFGRIDSIMULATOR(varargin)
% MFGRIDSIMULATOR MATLAB code for MFGRIDSIMULATOR.fig
%      MFGRIDSIMULATOR, by itself, creates a new MFGRIDSIMULATOR or raises the existing
%      singleton*.
%
%      H = MFGRIDSIMULATOR returns the handle to a new MFGRIDSIMULATOR or the handle to
%      the existing singleton*.
%
%      MFGRIDSIMULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MFGRIDSIMULATOR.M with the given input arguments.
%
%      MFGRIDSIMULATOR('Property','Value',...) creates a new MFGRIDSIMULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MFGRIDSIMULATOR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MFGRIDSIMULATOR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MFGRIDSIMULATOR

% Last Modified by GUIDE v2.5 10-Aug-2015 21:27:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MFGRIDSIMULATOR_OpeningFcn, ...
                   'gui_OutputFcn',  @MFGRIDSIMULATOR_OutputFcn, ...
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

function MFGRIDSIMULATOR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MFGRIDSIMULATOR (see VARARGIN)

% Choose default command line output for MFGRIDSIMULATOR
handles.output = hObject;
NS = str2double(get(handles.Ns,'string'));
DataPAR = cell(NS,19);
DataG = cell(NS,NS);
DataP = cell(NS,NS);

numhet = str2double(get(handles.numhet,'string'));
DataHET = cell(numhet,3); 
for i = 1:numhet
rnames{1,i} = sprintf('Heterogeneous Parameter %d',i) ;
DataHET{i,1} = sprintf('Label %d',i); 
end

rnames = cell(1,NS);
for i = 1:NS;
rnames{i} = sprintf('Population Number %d',i) ;
DataPAR{i,1} = sprintf('Label %d',i);
end
%get(handles.uitablePAR)
set(handles.uitablePAR,'RowName',rnames);
set(handles.uitablePAR,'ColumnEditable',logical(ones(1,19))); 
set(handles.uitablep,'ColumnEditable',logical(ones(1,NS)));
set(handles.uitableg,'ColumnEditable',logical(ones(1,NS)));

set(handles.uitableHET,'ColumnEditable',logical(ones(1,3)));
set(handles.uitablePAR,'Data',DataPAR) ;
set(handles.uitableHET,'Data',DataHET); 
set(handles.uitableHET,'Columnname',{'Heterogeneous Parameter','Population Index','Standard Deviation'}); 







guidata(hObject, handles);

function varargout = MFGRIDSIMULATOR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function Ns_Callback(hObject, eventdata, handles)
function Ns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function uitablePAR_CreateFcn(hObject, eventdata, handles)
function T_Callback(hObject, eventdata, handles)
function T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function dt_Callback(hObject, eventdata, handles)
function dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function plot_Callback(hObject, eventdata, handles)
disp('Running Simulation')
T = str2double(get(handles.T,'string')); %Total Time in ms
NS = str2double(get(handles.Ns,'string')); %Number of subpopulations
dt = str2double(get(handles.dt,'string')); %Time step size for Euler Integration 

DataPAR = get(handles.uitablePAR,'Data');
DataG = get(handles.uitableg,'Data');
DataP = get(handles.uitablep,'Data');
DataHET = get(handles.uitableHET,'Data'); 
hetnet = get(handles.hetnet,'value'); 


for i = 1:NS 
Np0(i) = DataPAR{i,2};
end
Np = cumsum(Np0); 
vindex = [1,Np(1:end-1)+1];
vrastindex = [];
for i = 1:NS 
vrastindex = [vrastindex,vindex(i):vindex(i)+9];  
end

Nstore = length(vrastindex); 
in = zeros(Nstore,1); %Used as a floating index per time step, determines which network has spiked
tspike = zeros(Nstore,120); % The storage matrix for spike times of the two networks 
DTspike = size(tspike);

Np = [0,Np];
N = Np(end); 
for i = 1:NS
C(Np(i)+1:Np(i+1),1) = DataPAR{i,3}; %Conuctance
vt(Np(i)+1:Np(i+1),1) = DataPAR{i,4}; %threshold potential
vr(Np(i)+1:Np(i+1),1) = DataPAR{i,5}; %rest potential
vpeak(Np(i)+1:Np(i+1),1) = DataPAR{i,6}; %spike peak
vreset(Np(i)+1:Np(i+1),1) = DataPAR{i,7}; %spike reset
khigh(Np(i)+1:Np(i+1),1) = DataPAR{i,8}; %khigh
klow(Np(i)+1:Np(i+1),1) = DataPAR{i,9}; %klow
a(Np(i)+1:Np(i+1),1) = DataPAR{i,10}; %reciprocal of adapt time constant
b(Np(i)+1:Np(i+1),1) = DataPAR{i,11}; %resonance variable
d(Np(i)+1:Np(i+1),1) = DataPAR{i,12}; %adaptation jump current magnitude
I(Np(i)+1:Np(i+1),1) = DataPAR{i,13}; %Applied Current
Er(Np(i)+1:Np(i+1),1) = DataPAR{i,14}; %Reversal Potential
alpha(Np(i)+1:Np(i+1),1) = DataPAR{i,15}; %Reversal Potential
beta(Np(i)+1:Np(i+1),1) = DataPAR{i,16}; %Reversal Potential
tbar(Np(i)+1:Np(i+1),1) = DataPAR{i,17}; %Reversal Potential
Tmax(Np(i)+1:Np(i+1),1) = DataPAR{i,18}; %Reversal Potential
Tsyn(Np(i)+1:Np(i+1),1) = DataPAR{i,19}; %Reversal Potential
end


if hetnet == 1
numhet = str2double(get(handles.numhet,'string'));
DataHET = get(handles.uitableHET,'Data'); 
for i = 1:numhet 
    DataHET{i,1}
    DataHET{i,2}
    DataHET{i,3}
cmd1 =  sprintf('%s(Np(%d)+1:Np(%d+1),1)= %s(Np(%d)+1:Np(%d+1)) + %5.5f*randn(Np0(%d),1)',DataHET{i,1},DataHET{i,2},DataHET{i,2},DataHET{i,1},DataHET{i,2},DataHET{i,2},DataHET{i,3},DataHET{i,2})
eval(cmd1) 
end
end




for i = 1:NS
    for j = 1:NS 
   G(Np(i)+1:Np(i+1),Np(j)+1:Np(j+1))= DataG{i,j};
   P(Np(i)+1:Np(i+1),Np(j)+1:Np(j+1))= DataP{i,j};
   R = rand(-Np(i)+Np(i+1),-Np(j)+Np(j+1));
   P(Np(i)+1:Np(i+1),Np(j)+1:Np(j+1)) = (P(Np(i)+1:Np(i+1),Np(j)+1:Np(j+1))-R>0);
    end
end
P = sparse(P); 
G = G.*P; %Synaptic Coupling Matrix 
G = sparse(G); 
for i = 1:N 
GR(i,:) = G(i,:).*(Er'); 
end
GR = sparse(GR); 


v = vreset + (vpeak-vreset).*rand(N,1); v_ = v; 
u = zeros(N,1); 
g = zeros(N,1);
A = zeros(N,1); 
S = zeros(N,1); 
Tsp = zeros(N,1);
Trp = zeros(N,1); 



vrec = zeros(T/dt,2*NS);
urec = zeros(T/dt,2*NS); 
vrec(1,1:NS) = v(vindex)';
urec(1,1:NS) = u(vindex)';
srec(1,1:NS) = 0; 




nspike = 0; 
tspike = zeros(10^6,2); 

ISI = zeros(N,1); minISI = T*ones(N,1); maxISI = zeros(N,1); 
tns = zeros(N,1); nspike = zeros(N,1); 
tic
 for i = 1:T/dt %simulating the network for a set value of parameters 
k = khigh.*(v>vt) + klow.*(v<=vt); %The switching k's are used for more realistic networks.  

%integrate the ODE for v using forward Euler 
v = v + dt*(( k.*(v-vr).*(v-vt) - u + I + A - v.*g)./C);  % v(t) = v(t-1)+dt*v'(t-1)
%integrate the ODE for u(t) using forward euler 
u = u + dt*(a.*(b.*(v_-vr)-u)); 

%--------------------------------------------------------



dt*i 

% %------------------------------------------------------------------
S = S + dt*(-beta.*S + alpha.*Trp.*(1-S)); 
Tsp = Tsp + (v>vpeak).*(dt*i-Tsp);
Trp =  Tmax.*(dt*i>=Tsp).*(Tsp+tbar>dt*i);
g = G*S;
A = GR*S; 


ISI = ISI + (dt*i - tns - ISI).*(v>=vpeak); 
tns = tns + (dt*i-tns).*(v>=vpeak);
nspike = nspike + (v>=vpeak); 
 
if dt*i>T/2 
minISI = minISI + (ISI - minISI).*(ISI<minISI);
maxISI = maxISI + (ISI - maxISI).*(ISI>maxISI); 
end


% 
spikeindex =  find(v>=vpeak); 
zeta = length(spikeindex); 

tspike(nspike+1:nspike+zeta,:) = [spikeindex,dt*i+0*spikeindex]; 
nspike = nspike + zeta; 



%---------------Resets and removing self coupling----------------
u = u + d.*(v>vpeak);  %implements set u to u+d if v>vpeak, component by component. 
v = v+(vreset-v).*(v>vpeak); %implements v = c if v>vpeak add 0 if false, add c-v if true, v+c-v = c
v_ = v;  % sets v(t-1) = v for the next itteration of loop

    
vrec(i+1,1:NS) = v(vindex'); 
urec(i+1,1:NS) = u(vindex'); 

for m = 1:NS
   vrec(i+1,NS+m) = mean(v(Np(m)+1:Np(m+1),1));
   srec(i+1,m) = mean(S(Np(m)+1:Np(m+1),1));
   urec(i+1,NS+m) = mean(u(Np(m)+1:Np(m+1),1));
end

 end
toc
size(v)

figure(1)
title('Moments')
subplot(2,1,1)
plot(0:dt:T,srec(:,1:NS),'LineWidth',1), hold on 
ylabel('S variable')
legend(DataPAR{:,1})
subplot(2,1,2)
plot(0:dt:T,urec(:,NS+1:2*NS)), hold on 
%plot(0:dt:T,urec)
%plot(0:dt:T,urec(:,1:NS),'LineWidth',1), hold on
legend(DataPAR{:,1})
ylabel('W variable') 


figure(32)
title('Sample Neuron from Each Subpopulation')
subplot(2,1,1)
plot(0:dt:T,vrec(:,1:NS)) 
ylabel('Voltage variable')
legend(DataPAR{:,1})
subplot(2,1,2)
plot(0:dt:T,urec(:,1:NS)) 
ylabel('Adaptation Variable')
legend(DataPAR{:,1})

figure(24)
title('Rasterplot')
nspike;
tspike = tspike(1:nspike,:); 

spiketime = tspike(:,2);
neuronindex = tspike(:,1);
[neuronindex,i] = sortrows(neuronindex);
spiketime = spiketime(i); 


 
%plot(spiketime,neuronindex,'k.','MarkerSize',0.5);
cmap = hsv(NS); 
 for i = 1:NS  
  
 y = neuronindex(neuronindex(:,1)<=Np(i+1)); 
 x = spiketime(neuronindex(:,1)<=Np(i+1));
 x = x(y>Np(i)); 
 y = y(y>Np(i)); 
 plot(x,y,'.','MarkerSize',3,'Color',cmap(i,:)), hold on 
 end
 legend(DataPAR(:,1))


 xlabel('Time (ms)')
ylabel('Neuron Index')




guidata(hObject, handles);


function MF_Callback(hObject, eventdata, handles)
% hObject    handle to MF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Running Simulation')
T = str2double(get(handles.T,'string')); %Total Time in ms
NS = str2double(get(handles.Ns,'string')); %Number of subpopulations
dt = str2double(get(handles.dt,'string')); %Time step size for Euler Integration 

DataPAR = get(handles.uitablePAR,'Data');
DataG = get(handles.uitableg,'Data');
DataP = get(handles.uitablep,'Data');
M = 1000; 
hetnet = get(handles.hetnet,'value'); 
for i = 1:NS
 Np(i,1) = DataPAR{i,2}; 
C(i,1) = DataPAR{i,3}; %Conuctance
vt(i,1) = DataPAR{i,4}; %threshold potential
vr(i,1) = DataPAR{i,5}; %rest potential
vpeak(i,1) = DataPAR{i,6}; %spike peak
vreset(i,1) = DataPAR{i,7}; %spike reset
khigh(i,1) = DataPAR{i,8}; %khigh
klow(i,1) = DataPAR{i,9}; %klow
a(i,1) = DataPAR{i,10}; %reciprocal of adapt time constant
b(i,1) = DataPAR{i,11}; %resonance variable
d(i,1) = DataPAR{i,12}; %adaptation jump current magnitude
I{i,1} = DataPAR{i,13}; %Applied Current
Er(i,1) = DataPAR{i,14}; %Reversal Potential
alpha(i,1) = DataPAR{i,15}; %Reversal Potential
beta(i,1) = DataPAR{i,16}; %Reversal Potential
tbar(i,1) = DataPAR{i,17}; %Reversal Potential
Tmax(i,1) = DataPAR{i,18}; %Reversal Potential
Tsyn(i,1) = DataPAR{i,19}; %Reversal Potentia
end


if hetnet == 1;
numhet = str2double(get(handles.numhet,'string'));
DataHET = get(handles.uitableHET,'Data'); 
for i = 1:numhet 
cmd1 =  sprintf('%s{%d,1}= %s{%d,1} + %5.5f*randn(%d,1);',DataHET{i,1},DataHET{i,2},DataHET{i,1},DataHET{i,2},DataHET{i,3},M)
eval(cmd1) 
end
end



for i = 1:NS
    for j = 1:NS
   G(i,j) = Np(j,1)*DataG{i,j}; 
   P(i,j) = DataP{i,j}; 
    end
end


S = zeros(NS,1); 
w = zeros(NS,1); 


% tic
% [t,y] = ode45(@(t,y) ONEIZNETWORKQSSAD2(C,klow,khigh,vt,vreset,vpeak,vr,a,d,Tmax,G.*P,I,Er,alpha,beta,tbar,NS,t,y),[0,T],[S,w]);
% toc
M = 1000;
for i = 1:NS 
vint(:,i) = vreset(i,1) + (vpeak(i,1)-vreset(i,1))*rand(1,M);  
end
%  tic
%  [t2,y2] = ode45(@(t,y) ONEIZNETWORKQSSAD3(vint,C,klow,khigh,vt,vreset,vpeak,vr,a,d,Tmax,G.*P,I,Er,alpha,beta,tbar,NS,t,y),[0,T],[S,w]);
%  toc

%  tic
%  [t2,y2] = ode45(@(t,y) ONEIZNETWORKQSSAD4(vint,C,klow,khigh,vt,vreset,vpeak,vr,a,d,Tmax,G.*P,I,Er,alpha,beta,tbar,NS,t,y),[0,T],[S,w]);
%  toc

  tic
  [t2,y2] = ode45(@(t,y) ONEIZNETWORKQSSAD7(C,klow,khigh,vt,vreset,vpeak,vr,a,d,Tmax,G.*P,I,Er,alpha,beta,tbar,NS,t,y),0:0.2:T,[S,0*S,w]);
  toc
% 
% figure(2)
% subplot(2,1,1)
% plot(t2,y2(:,1:NS),'LineWidth',2), hold on 
% ylabel('S Variable')
% legend(DataPAR{:,1})
% 
% 
% subplot(2,1,2)
% plot(t2,y2(:,2*NS+1:3*NS),'LineWidth',2), hold on 
% ylabel('W Variable')
% legend(DataPAR{:,1}) 


figure(1)
subplot(2,1,1)
plot(t2,y2(:,1:NS),'k','LineWidth',2), hold on 
ylabel('S Variable')
subplot(2,1,2)
plot(t2,y2(:,2*NS+1:3*NS),'k','LineWidth',2), hold on 
ylabel('W Variable')



function rungrid_Callback(hObject, eventdata, handles)
% PARSTRING = get(handles.uitablePAR,'ColumnName');
% PARSTRING{end+1,1} = 'g_{syn}';
% PARSTRING{end+1,1} = 'P';
% siz = length(PARSTRING);

par1 = get(handles.par1,'string');
par2 = get(handles.par2,'string');

Npar1max = str2double(get(handles.Npar1,'string'));
Npar2max = str2double(get(handles.Npar2,'string'));
par1min = str2double(get(handles.minpar1,'string'));
par2min = str2double(get(handles.minpar1,'string'));
par1max = str2double(get(handles.maxpar1,'string'));
par2max = str2double(get(handles.maxpar2,'string'));



T = str2double(get(handles.T,'string')); %Total Time in ms
NS = str2double(get(handles.Ns,'string')); %Number of subpopulations
dt = str2double(get(handles.dt,'string')); %Time step size for Euler Integration 

DataPAR = get(handles.uitablePAR,'Data');
DataG = get(handles.uitableg,'Data');
DataP = get(handles.uitablep,'Data');
DataHET = get(handles.uitableHET,'Data'); 

hetnet = get(handles.hetnet,'value'); 
%% Run the mean-field system 
for i = 1:NS
 Np(i,1) = DataPAR{i,2}; 
C(i,1) = DataPAR{i,3}; %Conuctance
vt(i,1) = DataPAR{i,4}; %threshold potential
vr(i,1) = DataPAR{i,5}; %rest potential
vpeak(i,1) = DataPAR{i,6}; %spike peak
vreset(i,1) = DataPAR{i,7}; %spike reset
khigh(i,1) = DataPAR{i,8}; %khigh
klow(i,1) = DataPAR{i,9}; %klow
a(i,1) = DataPAR{i,10}; %reciprocal of adapt time constant
b(i,1) = DataPAR{i,11}; %resonance variable
d(i,1) = DataPAR{i,12}; %adaptation jump current magnitude
I{i,1} = DataPAR{i,13}; %Applied Current


Er(i,1) = DataPAR{i,14}; %Reversal Potential
alpha(i,1) = DataPAR{i,15}; %Reversal Potential
beta(i,1) = DataPAR{i,16}; %Reversal Potential
tbar(i,1) = DataPAR{i,17}; %Reversal Potential
Tmax(i,1) = DataPAR{i,18}; %Reversal Potential
Tsyn(i,1) = DataPAR{i,19}; %Reversal Potentia
end





I

TOT = Npar1max*Npar2max; 

z = 0; 
h = waitbar(0,'Please Wait');
REC = cell(Npar1max,Npar2max);
VREC = cell(Npar1max,Npar2max)
tic 


M = 1000;
GLOBRAND = randn(M,1);  

numhet = str2double(get(handles.numhet,'string'));
DataHET = get(handles.uitableHET,'Data'); 



for Npar1 = 1:Npar1max
  for Npar2 = 1:Npar2max    
      
      for i = 1:NS
   I{i,1} = DataPAR{i,13}; 
    for j = 1:NS
   G(i,j) = DataG{i,j}; 
   P(i,j) = DataP{i,j}; 
    end
end

      
z = z + 1; 
waitbar(z/TOT); 
S = zeros(NS,1); 
w = zeros(NS,1);
% These commands change the current point on the mesh     
cmd1 = sprintf('%s = par1min + (par1max-par1min)*((Npar1-1)/(Npar1max-1))', get(handles.par1,'string')); %Set the first parameter to it's particular meshpoint 
cmd2 = sprintf('%s = par2min + (par2max-par2min)*((Npar2-1)/(Npar2max-1))', get(handles.par2,'string')); %Set the second parameter to its meshpoint 

eval(cmd1) %Evaluate the cmds above to determine parameter values 
eval(cmd2)       
VREC{Npar1,Npar2} = [eval(sprintf('%s', get(handles.par1,'string'))),eval(sprintf('%s', get(handles.par2,'string')))];


for i = 1:NS
    for j = 1:NS
   G(i,j) = Np(j,1)*G(i,j); 
    end
end

if hetnet == 1
for i = 1:numhet 
cmd1 =  sprintf('%s{%d,1}= %s{%d,1} + %5.5f*GLOBRAND;',DataHET{i,1},DataHET{i,2},DataHET{i,1},DataHET{i,2},DataHET{i,3});
eval(cmd1) 
end
end


  [t,y] = ode45(@(t,y) ONEIZNETWORKQSSAD7(C,klow,khigh,vt,vreset,vpeak,vr,a,d,Tmax,G.*P,I,Er,alpha,beta,tbar,NS,t,y),0:1:T,[S,0*S,w]);

 
timesim = toc;
if mod(z,100) == 1; 
Timerem =timesim*(1-z/TOT)/(z/TOT); 
sprintf('Time Remaining in Simulation is %5.1f Seconds',Timerem)
end


for i = 1:NS 
REC{Npar1,Npar2} = [t,y]; 
end

end
end
save(sprintf('%s.mat',get(handles.filename,'string')),'REC','VREC','DataG','DataPAR','DataP','par1','par2','DataHET')
timesim




function opengrid_Callback(hObject, eventdata, handles)

uiopen
NS = length(DataG);
V = size(VREC); 
Npar1max = V(1); 
Npar2max = V(2); 
ps = str2double(get(handles.peakfinders,'string')); 
for i = 1:NS %loop over each subpopulation
for Npar1 = 1:Npar1max
  for Npar2 = 1:Npar2max    
X(Npar1,Npar2) = VREC{Npar1,Npar2}(1,1); 
Y(Npar1,Npar2) = VREC{Npar1,Npar2}(1,2); 
TIME = REC{Npar1,Npar2}(:,1); %the time variable of the simulation
W = REC{Npar1,Npar2}(:,2*NS+i); %the adaptation variable for the simulaiton 
[peakLoc] = peakfinder(W,ps); %the location of the peaks in the adaptation variable 
TIME = TIME(peakLoc); %the location of the peaks in the time vaiable 
if length(peakLoc)>2;  %if there are more then two peaks 
Frequency(Npar1,Npar2,i) = 1000./mean(TIME(2:end)-TIME(1:end-1)); %compute the period as the mean time between peaks 
else 
Frequency(Npar1,Npar2,i) = 0;   
end
  end
end
figure(i+59)
%subplot(NS,2,sub2ind([NS,2],i,1))
Z = Frequency(:,:,i) + (1e-5)*rand(Npar1max,Npar2max); 
if max(max(Z))<1e-3 
contourf(X,Y,Z,'EdgeColor','none')
else
     contourf(X,Y,Z)
end 

caxis([0,8])
% xlabel(par1,'interpreter','LaTeX');
% ylabel(par2,'interpreter','LaTeX'); 
% title(DataPAR{i,1})
colorbar
ax = gca;
ax.YTick = 0:100:600;
ax.XTick = 0:0.02:0.1;
set(gca,'FontSize',17)
%  figure(10)
%  subplot(2,NS,i)
%  contourf(X,Y,Frequency(:,:,i) + (1e-10)*rand(Npar1max,Npar2max))
%  xlabel(par1,'interpreter','LaTeX');
%  ylabel(par2,'interpreter','LaTeX'); 
%  title(DataPAR{i,1})
%  colorbar
 handles.VREC = VREC;
 handles.REC = REC; 
 handles.dapar = DataPAR;
end
guidata(hObject, handles);




function rasterplot_Callback(hObject, eventdata, handles)
figure(60)
handles.VREC;
handles.REC;
w = 0;
V = size(handles.VREC); 
ps = str2double(get(handles.peakfinders,'string')); 
M = size(handles.REC); 
zeta = size(M); 

zeta = size(handles.dapar);
NS = zeta(1); 


Npar1max = V(1); 
Npar2max = V(2);
par1min = handles.VREC{1,1}(1,1);
par2min = handles.VREC{1,1}(1,2);
par1max = handles.VREC{V(1),V(2)}(1,1);
par2max = handles.VREC{V(1),V(2)}(1,2);
cmap = hsv(NS);
while w == 0
w = waitforbuttonpress;
figure(60)
[X,Y] = ginput(1)
 
xindex = round((Npar1max-1)*(X-par1min)/(par1max-par1min))+1;
yindex = round((Npar2max-1)*(Y-par2min)/(par2max-par2min))+1;
size(handles.REC{xindex,yindex})
    figure(10)
%     size(handles.REC{xindex,yindex}(:,1)) 
%     size(handles.REC{xindex,yindex}(:,8))
plot(handles.REC{xindex,yindex}(:,1),handles.REC{xindex,yindex}(:,2*NS+2:3*NS+1)), hold on 
 Time =  handles.REC{xindex,yindex}(:,1);
legend(handles.dapar(:,1)); 



for i = 1:NS
 W = handles.REC{xindex,yindex}(:,2*NS+1+i);
 [peakLoc] = peakfinder(W,ps);
 ylabel('$\langle w(t)\rangle$','Interpreter','LaTeX') 
 plot(Time(peakLoc),W(peakLoc),'k*'), hold on 
 TIME = Time(peakLoc); 
 FREQ =  1000./mean(TIME(2:end)-TIME(1:end-1))
 
end
hold off 
end












function updatetable_Callback(hObject, eventdata, handles)
 NS = str2double(get(handles.Ns,'string'));
 
 D = get(handles.uitablePAR,'Data');
 E = get(handles.uitablep,'Data'); 
 F = get(handles.uitableg,'Data');
 m = size(D);
 v = m(2); 
 m = m(1);
 DataPAR = cell(NS,19); 

DataG = cell(NS,NS);
DataP = cell(NS,NS);

  if m<NS 
 DataPAR(1:m,:) = D;
 DataG(1:m,1:m) = F;
 DataP(1:m,1:m) = E; 
  end
  



rnames = cell(1,NS);
for i = 1:NS;
rnames{i} = sprintf('Population Number %d',i);
DataPAR{i,1} = sprintf('Label %d',i);
end
set(handles.uitablePAR,'Data',DataPAR);
set(handles.uitableg,'Data',DataP);
set(handles.uitablep,'Data',DataG);
set(handles.uitablePAR,'RowName',rnames);
set(handles.uitablep,'ColumnEditable',logical(ones(1,NS)));
set(handles.uitableg,'ColumnEditable',logical(ones(1,NS)));








function save_Callback(hObject, eventdata, handles)
DataPAR = get(handles.uitablePAR,'Data');
DataG = get(handles.uitableg,'Data');
DataP = get(handles.uitablep,'Data');
DataHET = get(handles.uitableHET,'Data');

uisave({'DataPAR','DataG','DataP','DataHET'}) 




function Load_Callback(hObject, eventdata, handles)
uiload 

set(handles.uitablePAR,'Data',DataPAR);
set(handles.uitableg,'Data',DataG);
set(handles.uitablep,'Data',DataP);










function par1_Callback(hObject, eventdata, handles)
function par1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ind1_Callback(hObject, eventdata, handles)
function ind1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ind1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function minpar1_Callback(hObject, eventdata, handles)
function minpar1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minpar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function maxpar1_Callback(hObject, eventdata, handles)
function maxpar1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxpar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Npar1_Callback(hObject, eventdata, handles)
function Npar1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Npar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function par2_Callback(hObject, eventdata, handles)
function par2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ind2_Callback(hObject, eventdata, handles)
function ind2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ind2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function minpar2_Callback(hObject, eventdata, handles)
function minpar2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minpar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function maxpar2_Callback(hObject, eventdata, handles)
function maxpar2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxpar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Npar2_Callback(hObject, eventdata, handles)
function Npar2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Npar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function rmf_Callback(hObject, eventdata, handles)
function filename_Callback(hObject, eventdata, handles)
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function peakfinders_Callback(hObject, eventdata, handles)
function peakfinders_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peakfinders (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiload 
FD = size(DataPAR); 
NS = FD(1); 
set(handles.Ns,'String',NS); 


rnames = cell(1,NS);
for i = 1:NS;
rnames{i} = sprintf('Population Number %d',i);
%DataPAR{i,1} = sprintf('Label %d',i);
end
set(handles.uitablePAR,'Data',DataPAR);
set(handles.uitableg,'Data',DataP);
set(handles.uitablep,'Data',DataG);
set(handles.uitablePAR,'RowName',rnames);
set(handles.uitablep,'ColumnEditable',logical(ones(1,NS)));
set(handles.uitableg,'ColumnEditable',logical(ones(1,NS)));

set(handles.uitableg,'Data',DataG);
set(handles.uitablep,'Data',DataP);
 
if exist('par1')==1
set(handles.par1,'string',par1)
end
if exist('par2')==1
set(handles.par2,'string',par2) 
end
if exist('VREC')==1 
    D = size(VREC); 
    set(handles.Npar1,'string',D(1));
    set(handles.Npar2,'string',D(2)); 
    set(handles.minpar1,'string',VREC{1,1}(1,1));
    set(handles.minpar2,'string',VREC{1,1}(1,2));
    set(handles.maxpar1,'string',VREC{D(1),D(2)}(1,1));
    set(handles.maxpar2,'string',VREC{D(1),D(2)}(1,2));
end

if exist('DataHET')==1, 
    SDA = size(DataHET); 
    set(handles.uitableHET,'Data',DataHET)
    set(handles.numhet,'String',SDA(1));
    set(handles.hetnet,'value',1); 
 end




function hetnet_Callback(hObject, eventdata, handles)

function numhet_Callback(hObject, eventdata, handles)
function numhet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numhet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in UpdateHET.
function UpdateHET_Callback(hObject, eventdata, handles)
numhet = str2double(get(handles.numhet,'string'))
DataHET = cell(numhet,3); 
for i = 1:numhet
rnames{1,i} = sprintf('Heterogeneous Parameter %d',i) ;
DataHET{i,1} = sprintf('Label %d',i); 
end
set(handles.uitableHET,'ColumnEditable',logical(ones(1,3)));
set(handles.uitableHET,'Data',DataHET); 
set(handles.uitableHET,'Columnname',{'Heterogeneous Parameter','Population Index','Standard Deviation'}); 


% --- Executes during object deletion, before destroying properties.
function uitablePAR_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to uitablePAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
