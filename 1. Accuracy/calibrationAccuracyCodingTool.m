function data = calibrationAccuracyCodingTool
% Code written and maintained by Samuel Harding
% contact 
% sh138@mailbox.sc.edu 
% for questions / troubleshooting

%% Select Video Input
% Prompt the user to pick a video 

% first, get a list of the file formats that this system can read
fmts = VideoReader.getFileFormats();

% ask the user to pick the video they would like to work with
[videoFileName,videoFileFolder] = uigetfile(...
  fmts.getFilterSpec,...
  'Select a video file');

% make a VideoReader object to open the file
videoFile = VideoReader([videoFileFolder,videoFileName]);


%% store information to be used and output
% how many total images?
data.nImages = videoFile.NumFrames;

% which one are we looking at now?
data.currentFrame = 1;

% video frame rate
data.frameRate = videoFile.FrameRate;

% how many have we coded?
data.numberCoded = 0 ;

% which frames are coded? -- two values (one column for each click type)
data.isCoded = nan(data.nImages,2);

% how many clicks per frame?
data.nModes = 2;
data.currentMode = 1;

% store click info
data.click{1} = nan(data.nImages,2);
data.click{2} = nan(data.nImages,2);

% minimum number of frames that must be coded before you can click 'done'
data.neededFrames = 20;


%% Interface

% configure the way the different modes are shown
colors = {'red','blue','black'};
modeNames = {'Target Gaze Location','Calibrated Gaze Location (Crosshair)','Done (continue to another frame)'};

%%%%%%%%%%%%%%%%%%%%%%%%%
% % % MAKE A FIGURE % % %
%%%%%%%%%%%%%%%%%%%%%%%%%
G.f = figure(1);
clf
G.f.Units = 'normalized';
G.f.Position = [.05 .05 .9 .85];
G.f.Color = [1,1,1];
G.f.WindowKeyPressFcn = @userInput_basic_keyDown;
G.f.MenuBar = 'none';


%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % CREATE BUTTONS % % %
%%%%%%%%%%%%%%%%%%%%%%%%%%
% define button locations
buttonWidths = [.125 .125 .15];
buttonHeights = .075;

buttonGap_betweenForwardBackwards = .015;
buttonGap_betweenFrameChange = .01;
buttonGap_framesToSideButtons = .045;

buttonLeftEdge_rightSide = .5 + (buttonGap_betweenForwardBackwards/2);
buttonLeftEdge_rightSide(2) = buttonLeftEdge_rightSide + buttonWidths(1) + buttonGap_betweenFrameChange;
buttonLeftEdge_rightSide(3) = buttonLeftEdge_rightSide(2) + buttonWidths(2) + buttonGap_framesToSideButtons;

buttonLeftEdge_leftSide = 1 - buttonLeftEdge_rightSide;

buttonBottomEdge = .025;


% % % create buttons to change the frame % % %

% buttons to change frame (1 at a time)
% % previous frame
G.b.framePrev = uicontrol(...
  'Style','pushbutton',...
  'String','<html>Previous Frame<br /><center>&lt</center></html>',...
  'Parent',G.f,...
  'FontSize',20,...
  'Units','normalized',...
  'Position',...
  [buttonLeftEdge_leftSide(1)-buttonWidths(1) buttonBottomEdge buttonWidths(1) buttonHeights],...
  'Callback',{@moveTo_previousFrame,1});

% % next frame
G.b.frameNext = uicontrol(...
  'Style','pushbutton',...
  'String','<html>Next Frame<br /><center>&gt</center></html>',...
  'Parent',G.f,...
  'FontSize',20,...
  'Units','normalized',...
  'Position',...
  [buttonLeftEdge_rightSide(1) buttonBottomEdge buttonWidths(1) buttonHeights],...
  'Callback',{@moveTo_nextFrame,1});

% buttons to change frame (10 at a time)
% % -10 frames
G.b.framePrev10 = uicontrol(...
  'Style','pushbutton',...
  'String','<html>-10 Frames<br /><center>&lt&lt</center></html>',...
  'Parent',G.f,...
  'FontSize',20,...
  'Units','normalized',...
  'Position',...
  [buttonLeftEdge_leftSide(2)-buttonWidths(2) buttonBottomEdge buttonWidths(2) buttonHeights],...
  'Callback',{@moveTo_previousFrame,10});
% % + 10 frames
G.b.frameNext10 = uicontrol(...
  'Style','pushbutton',...
  'String','<html>+10 Frames<br /><center>&gt&gt</center></html>',...
  'Parent',G.f,...
  'FontSize',20,...
  'Units','normalized',...
  'Position',...
  [buttonLeftEdge_rightSide(2) buttonBottomEdge buttonWidths(2) buttonHeights],...
  'Callback',{@moveTo_nextFrame,10});

% % % additional buttons % % %
% buttons to clear a frame
G.b.frameClear = uicontrol(...
  'Style','pushbutton',...
  'String','Clear Frame',...
  'Parent',G.f,...
  'FontSize',20,...
  'Units','normalized',...
  'Position',...
  [buttonLeftEdge_leftSide(3)-buttonWidths(3) buttonBottomEdge buttonWidths(3) buttonHeights],...
  'Callback',@userInput_clearFrame,...
  'Enable','on');

G.b.done = uicontrol(...
  'Style','pushbutton',...
  'String','Done!',...
  'Parent',G.f,...
  'FontSize',20,...
  'Units','normalized',...
  'Position',...
  [buttonLeftEdge_rightSide(3) buttonBottomEdge buttonWidths(3) buttonHeights],...
  'Callback',@done,...
  'Enable','off');


% % % various display text % % %
% Current Frame:
G.t.textFrame = uicontrol(...
  'Style','text',...
  'String','Current Frame:',...
  'Units','normalized',...
  'Position',[buttonLeftEdge_leftSide(3)-buttonWidths(3) .91 .15 .04],...
  'FontSize',20);
% Current Time:
G.t.textTime = uicontrol(...
  'Style','text',...
  'String','Current Time:',...
  'Units','normalized',...
  'Position',[buttonLeftEdge_leftSide(3)-buttonWidths(3) .955 .15 .04],...
  'FontSize',20);

% % % editable frame indicator
G.t.currentFrame = uicontrol(...
  'Style','edit',...
  'String','1',...
  'Units','normalized',...
  'Position',[buttonLeftEdge_leftSide(3)-buttonWidths(3) + .15 + .01...
  .91 .1 .04],...
  'FontSize',20,...
  'Callback',@userInput_edit_frame);

% % % display current time
G.t.currentTime = uicontrol(...
  'Style','text',...
  'String','Time: ()',...
  'Units','normalized',...
  'Position',[buttonLeftEdge_leftSide(3)-buttonWidths(3) + .15 + .01...
  .955 .1 .04],...
  'FontSize',16);

% instructions above mode
G.t.instructionText = uicontrol(...
  'Style','text',...
  'String','Click to indicate:',...
  'Units','normalized',...
  'Position',[.3 .955 .4 .04],...
  'ForegroundColor','black',...
  'FontSize',20,...
  'HorizontalAlignment','center');

% show current mode
G.t.currentMode = uicontrol(...
  'Style','text',...
  'String',modeNames{1},...
  'Units','normalized',...
  'Position',[.3 .91 .4 .05],...
  'ForegroundColor',colors{1},...
  'FontSize',24,...
  'HorizontalAlignment','center');

% show how many frames have been coded
G.t.codedFrames = uicontrol(...
  'Style','text',...
  'String','Coded Frames: 0',...
  'Units','normalized',...
  'Position',[.75 .91 .15 .05],...
  'ForegroundColor','black',...
  'FontSize',20);

% % % create the image axes
% image axes
G.a = axes(...
  'Parent',G.f,...
  'Units','normalized',...
  'Position',[.01,buttonBottomEdge + buttonHeights + .01,...
  .98,.90 - (buttonBottomEdge + buttonHeights + .01)],...
  'Box','on');
hold on


% display a blank image
IM = ones(1,1,3);
data.IM = imshow(IM);


%% Open the figure and wait until it is closed
image_updateImage

figure(G.f)
waitfor(G.f)


%% functions

%%%%%%%%%%%%%%%%%
% % % image % % %
%%%%%%%%%%%%%%%%%
  function image_updateImage()
    % load the current image
    thisFrame = videoFile.read(data.currentFrame);
    delete(data.IM);
    data.IM = imshow(thisFrame,'InitialMagnification','fit');
    axis image

    % show the current frame & time
    textUpdate_frameNumber
    textUpdate_HMS

    % set the callback
    data.IM.ButtonDownFcn = @userInput_basic_clickedAxes;

    % show existing markers
    marker_initialize
    marker_showAll

    % set the current mode
    data.currentMode = 1;

    % set the mode display
    textUpdate_operateMode
  end

%%%%%%%%%%%%%%%%%%%
% % % markers % % %
%%%%%%%%%%%%%%%%%%%
  function marker_initialize
    for mm = 1:data.nModes
      G.mouse{mm} = text(nan,nan,'+',...
        'Color',colors{mm},...
        'FontSize',48,...
        'HorizontalAlignment','center',...
        'VerticalAlignment','middle',...
        'PickableParts','none');
    end

  end

  function marker_showAll
    for mm = 1:data.nModes
      marker_show(mm)
    end
  end

  function marker_show(mm)
    thisClick = data.click{mm}(data.currentFrame,:);
    G.mouse{mm}.Position(1:2) = thisClick;
  end

%%%%%%%%%%%%%%%%%%%%%%%%
% % % status texts % % %
%%%%%%%%%%%%%%%%%%%%%%%%
  function textUpdate_frameNumber
    G.t.currentFrame.String = [num2str(data.currentFrame)];
  end

  function textUpdate_HMS
    timeInSeconds = seconds(data.currentFrame * (1/data.frameRate));
    [H,M,S] = hms(timeInSeconds);
    G.t.currentTime.String = string(datetime(0,0,0,H,M,S,'Format','mm:ss.SSSS'));
  end

  function textUpdate_operateMode
    G.t.currentMode.String = modeNames{data.currentMode};
    G.t.currentMode.ForegroundColor = colors{data.currentMode};

    if data.currentMode == 3
      G.t.instructionText.String = '';
    else
      G.t.instructionText.String = 'Click to indicate:';
    end
  end

  function textUpdate_numberCodedFrames
    nCoded = nan(1,data.nModes);
    for mm = 1:data.nModes
      nCoded(mm) = sum(all(~isnan(data.click{mm}),2));
    end
    totalCoded = min(nCoded);
    data.numberCoded = totalCoded;

    G.t.codedFrames.String = ['Coded Frames: ' num2str(totalCoded)];

    if totalCoded >= data.neededFrames
      G.b.done.Enable = 'on';
    end
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % edit functions % % %
%%%%%%%%%%%%%%%%%%%%%%%%%%
  function userInput_edit_frame(H,O)
    % check that they typed a number
    userInput_string = H.String;
    userInput_double = str2double(userInput_string);
    if ~isnan(userInput_double)
      % everything is okay
      % move to this frame
      data.currentFrame = max(1,...
        min(data.nImages,userInput_double));

      image_updateImage
    end

  end

%%%%%%%%%%%%%%%%%%%%%%%%
% % % change frame % % %
%%%%%%%%%%%%%%%%%%%%%%%%
  function moveTo_previousFrame(H,O,nFrames)
    % make sure it doesn't underflow
    data.currentFrame = max(1,data.currentFrame-nFrames);

    % show the new image
    image_updateImage
  end

  function moveTo_nextFrame(H,O,nFrames)
    % make sure it doesn't overflow the number of frames
    data.currentFrame = min(data.nImages,data.currentFrame+nFrames);

    % show the new image
    image_updateImage
  end

%%%%%%%%%%%%%%%%%%%%%
% % % misc fcns % % %
%%%%%%%%%%%%%%%%%%%%%

  function userInput_clearFrame(H,O)
    for mm = 1:data.nModes
      data.click{mm}(data.currentFrame,:) = nan;
    end

    data.currentMode = 1;
    textUpdate_operateMode

    % update coded frame counter
    textUpdate_numberCodedFrames

    % redraw cleared markers
    marker_showAll

  end

  function mode_goToNextMode
    data.currentMode = min(data.nModes + 1,data.currentMode + 1);
  end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % capture inputs % % %
%%%%%%%%%%%%%%%%%%%%%%%%%%

  function userInput_basic_keyDown(H,O)
    pressedKey = O.Key;

    switch pressedKey
      % move one frame forward
      case {'rightarrow','d','k'}
        moveTo_nextFrame(H,O,1)
      % move one frame backwards
      case {'leftarrow','s','j'}
        moveTo_previousFrame(H,O,1)


      % move ten frames forward
      case {'f','l'}
        moveTo_nextFrame(H,O,10)
      % move ten frames backwards
      case {'a','h'}
        moveTo_previousFrame(H,O,10)
    end
  end


  function userInput_basic_clickedAxes(H,O)

    if data.currentMode <= data.nModes
      data.click{data.currentMode}(data.currentFrame,:) = ...
        [O.IntersectionPoint(1),O.IntersectionPoint(2)];

      marker_show(data.currentMode)
      mode_goToNextMode
      textUpdate_operateMode

    end

    % update coded frame counter
    textUpdate_numberCodedFrames

  end


%%%%%%%%%%%%%%%%%%%%
% % % finished % % %
%%%%%%%%%%%%%%%%%%%%
  function done(H,O)
    close(G.f)
  end


end


