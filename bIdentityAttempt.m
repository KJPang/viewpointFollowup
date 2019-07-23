%function bIdentityAttempt()
clear all

ID = 'kierantest'; %1=15 2=30 3=?? degree flankers
Condition = 2; %'sizeDistance' %'presentationDelay' %'head';
tCondition = '2'; %make sure this matches; that both are changed
% output filename
filename = ['C:\kieran\honoursweirdstuff\Followup\', ID, tCondition,'.xlsx']; % CC

%stimulus parameters%
delay_frames = 120; %60 %120 %%for lab comp/timing condition
stim_durn_frames = 60; %60 %120
fix_frames = 60; %60 %120
num_images = 6;

fix_size = 5;
image_angle = [0 60 120 180 240 300]; %0:60:300; % degrees
image_dist = [75 100 100 75 100 100]; %[65 90 90 65 90 90]; %[90 140 140 90 140 140] %[105 155 155 105 155 155]; %[150 200 200 150 200 200] %[115 165 165 115 165 165]; %[150 200 200 150 200 200]; %[200 250 250 200 250 250] %fir second condition %300.*ones(1,6); % pixels

resize_factor =   .12; %.155; %.175; %.225; %.3 %for second condition
resize_factorF = .11; %.14;
j_shift = [0, 0];

h_pix = 0;
v_pix = 0;

black = [0 0 0]; % for fixation

% define response keys ...
KbName('UnifyKeyNames');
ResponseLeft = KbName('F'); % arrows
ResponseRight = KbName('J'); %
ResponseExit = KbName('P');
RestrictKeysForKbCheck([ResponseLeft ResponseRight ResponseExit]);

%randomize trial order
trialorder = [1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 6 6 6 6 6 6 6 6 6 6 7 7 7 7 7 7 7 7 7 7 8 8 8 8 8 8 8 8 8 8 9 9 9 9 9 9 9 9 9 9 10 10 10 10 10 10 10 10 10 10 11 11 11 11 11 11 11 11 11 11 12 12 12 12 12 12 12 12 12 12 13 13 13 13 13 13 13 13 13 13 14 14 14 14 14 14 14 14 14 14];
%trialorder = [1 2 3 4 5 6 7 8 9 10];
%trialorder = [1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 11 11 12 12 13 13 14 14];
trialorder = trialorder(randperm(length(trialorder)));

%setup response arrays
keypressed = [];
responsearray = [];
responsetimea = [];

%even more arrays for graphing
RRRR = [];
RRR = [];
RR = [];
RO = [];
RL = [];
RLL = [];
RLLL = [];
LRRR = [];
LRR = [];
LR = [];
LO = [];
LL = [];
LLL = [];
LLLL = [];

RRRRa = 0;
RRRa = 0;
RRa = 0;
ROa = 0;
RLa = 0;
RLLa = 0;
RLLLa = 0;
LRRRa = 0;
LRRa = 0;
LRa = 0;
LOa = 0;
LLa = 0;
LLLa = 0;
LLLLa = 0;

RRRRb = 0;
RRRb = 0;
RRb = 0;
ROb = 0;
RLb = 0;
RLLb = 0;
RLLLb = 0;
LRRRb = 0;
LRRb = 0;
LRb = 0;
LOb = 0;
LLb = 0;
LLLb = 0;
LLLLb = 0;

%other
previousring = 0;
%----------------------------------------

% Set up graphics stuff ...

warning off;
rand('state',sum(100*clock));

% % initialization stuff from ContrastModulationDemo ...
AssertOpenGL;
% Open onscreen window on screen with maximum id:
%Screen('Preference','SkipSyncTests', 1); %remove later
screenid=max(Screen('Screens'));
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
[win, winRect] = PsychImaging('OpenWindow', screenid, [], [], [], [], [], 16);

[screenWidth, screenHeight]=Screen('WindowSize', win);
SCREEN_X=screenWidth;
SCREEN_Y=screenHeight;

Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% texture containing grey screen
blank(1) = Screen('MakeTexture',win,127.*ones(SCREEN_Y, SCREEN_X));
%blank(1,1) = Screen('MakeTexture',win,128.*ones(SCREEN_X, SCREEN_Y));

%Generate alpha layer blank texture:
%images = 128.*zeros(SCREEN_X, SCREEN_Y); %768);
%images(:,:,2) = 128;
%blank4ramp = Screen('MakeTexture',win,images);

% define raised cosine temporal window
pdc = 1;
cont = pdc.*ones(1,stim_durn_frames); % initialize to peak dot contrast (defined above)
win_length = stim_durn_frames/2;     % define window length
cont(1:win_length) = pdc.*0.5.*(1-cos(pi*(1:win_length)./win_length)); % ramp up
cont(end:-1:end-win_length+1) = cont(1:win_length); % ... and down
% keep an eye on timing ...
%vbl = zeros(1,stim_durn_frames);

%----------------------------------

HideCursor;

% Prompt for key press to start ...
%Screen('Blendfunction', win, GL_ONE, GL_ZERO);
Screen('FillRect', win, [128 128 128 0], [], 1);
%Screen('DrawTexture', win, blankTextures(1), [], [], [], 0);
Screen('DrawTexture',win, blank(1,1), [], [], [], 0);
DrawFormattedText(win, 'On each trial, indicate whether the centre face is oriented toward the left or right.\n\nPress F for the left; press J for the right.', 'center', 'center');
Screen('Flip',win);

% Wait for any button press to start ...
keypress = 0;
while ~keypress
    [keypress, keysecs,keyCode] = KbCheck;
end

% Show Initial Fixation
%Screen('DrawTexture',win, blank(1,1));
for fix=1:fix_frames
    Screen('DrawTexture', win, blank(1), [], [], [], 0);
    Screen('DrawDots', win, [(SCREEN_X-fix_size)/2 (SCREEN_Y-fix_size)/2], fix_size, [0, 0, 0],[0,0],1);
    Screen('Flip',win);
end

% Wait to flush out starting key press
Screen(win, 'WaitBlanking', 30);

FlushEvents('keyDown')
beep;

% %=
% something = imread(['C:\kieran\honoursweirdstuff\zawhy.bmp']);
% thing = Screen('MakeTexture',win,something);
% for i = 1:60
%     Screen('DrawTexture', win, thing, [], [], [], 0, []);
%     Screen('Flip', win);
% end

%----------------------------------------

%num_stim = num_trials*num_psi;
%ResponseArray = zeros(num_stim,6); %4);
%psi_order = Shuffle(ceil([1:num_stim]./num_trials));
%usedtochoosefaces = randperm(6);
vector_pos = [cos(image_angle.*pi/180).*image_dist; sin(image_angle.*pi/180).*image_dist]';

for i = 1:length(trialorder)
       
    % initialise reaction timer
    FlushEvents('keyDown');
    keyIsDown = 0;
    responseStartTime = GetSecs;  % RT measured from onset of test image
    
    Screen('WaitBlanking', win);
    
    %randomize identities
    usedtochoosering = randperm(6);
    usedtochoosefaces = randperm(6);
    whichway = 1; %randperm(2);
    flipIntervals = 1; %randperm(2);
    
    %jitter parameters
    h_shift = randperm(2);
    v_shift = randperm(2);
    while isequal(h_shift,v_shift) == 1
        h_shift = randperm(2);
        v_shift = randperm(2);
    end
    h_pix = j_shift(h_shift(1));
    v_pix = j_shift(v_shift(1));
    
    %cant get same identity twice in a row
    while previousring == usedtochoosering(1)
        usedtochoosering = randperm(6);
    end
    
    %more identity stuff
    if Condition == 1
        for n = 1:num_images
            if usedtochoosering(1) == 1
                [I, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Face1.png']);
            elseif usedtochoosering(1) == 2
                [I, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Face2.png']);
            elseif usedtochoosering(1) == 3
                [I, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Face3.png']);
            elseif usedtochoosering(1) == 4
                [I, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Face4.png']);
            elseif usedtochoosering(1) == 5
                [I, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Face5.png']);
            elseif usedtochoosering(1) == 6
                [I, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Face6.png']);
            end

            if usedtochoosering(1) == 1
                [J, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Gace1.png']);
            elseif usedtochoosering(1) == 2
                [J, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Gace2.png']);
            elseif usedtochoosering(1) == 3
                [J, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Gace3.png']);
            elseif usedtochoosering(1) == 4
                [J, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Gace4.png']);
            elseif usedtochoosering(1) == 5
                [J, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Gace5.png']);
            elseif usedtochoosering(1) == 6
                [J, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Gace6.png']);
            end

            I(:, :, 4) = alpha;
            J(:, :, 4) = alpha;
            stim(n) = Screen('MakeTexture',win,I);
            flop(n) = Screen('MakeTexture',win,J);

            %position identities
            if usedtochoosering(1) > 3
                dest_rect(n,:) = [(SCREEN_X/2) SCREEN_Y/2 (SCREEN_X/2) SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
                dest_rect_shift(n,:) = [(SCREEN_X/2) (SCREEN_Y/2)+v_pix (SCREEN_X/2) (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
                dest_rect2(n,:) = [(SCREEN_X/2)+2500 SCREEN_Y/2 (SCREEN_X/2)+2500 SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
                dest_rect_shift2(n,:) = [(SCREEN_X/2)+2500 (SCREEN_Y/2)+v_pix (SCREEN_X/2)+2500 (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
            else
                dest_rect(n,:) = [(SCREEN_X/2) SCREEN_Y/2 (SCREEN_X/2) SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
                dest_rect_shift(n,:) = [(SCREEN_X/2) (SCREEN_Y/2)+v_pix (SCREEN_X/2) (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
                dest_rect2(n,:) = [(SCREEN_X/2)+2500 SCREEN_Y/2 (SCREEN_X/2)+2500 SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
                dest_rect_shift2(n,:) = [(SCREEN_X/2)+2500 (SCREEN_Y/2)+v_pix (SCREEN_X/2)+2500 (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
            end
        end
    elseif Condition == 2
        for n = 1:num_images
            if usedtochoosering(1) == 1
                [I, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Hace1.png']);
            elseif usedtochoosering(1) == 2
                [I, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Hace2.png']);
            elseif usedtochoosering(1) == 3
                [I, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Hace3.png']);
            elseif usedtochoosering(1) == 4
                [I, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Hace4.png']);
            elseif usedtochoosering(1) == 5
                [I, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Hace5.png']);
            elseif usedtochoosering(1) == 6
                [I, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Hace6.png']);
            end
            
            if usedtochoosering(1) == 1
                [J, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Iace1.png']);
            elseif usedtochoosering(1) == 2
                [J, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Iace2.png']);
            elseif usedtochoosering(1) == 3
                [J, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Iace3.png']);
            elseif usedtochoosering(1) == 4
                [J, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Iace4.png']);
            elseif usedtochoosering(1) == 5
                [J, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Iace5.png']);
            elseif usedtochoosering(1) == 6
                [J, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\Ring\Iace6.png']);
            end
            
            I(:, :, 4) = alpha;
            J(:, :, 4) = alpha;
            stim(n) = Screen('MakeTexture',win,I);
            flop(n) = Screen('MakeTexture',win,J);
            
            %position identities
            if usedtochoosering(1) > 3
                dest_rect(n,:) = [(SCREEN_X/2) SCREEN_Y/2 (SCREEN_X/2) SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
                dest_rect_shift(n,:) = [(SCREEN_X/2) (SCREEN_Y/2)+v_pix (SCREEN_X/2) (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
                dest_rect2(n,:) = [(SCREEN_X/2)+2500 SCREEN_Y/2 (SCREEN_X/2)+2500 SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
                dest_rect_shift2(n,:) = [(SCREEN_X/2)+2500 (SCREEN_Y/2)+v_pix (SCREEN_X/2)+2500 (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
            else
                dest_rect(n,:) = [(SCREEN_X/2) SCREEN_Y/2 (SCREEN_X/2) SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
                dest_rect_shift(n,:) = [(SCREEN_X/2) (SCREEN_Y/2)+v_pix (SCREEN_X/2) (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
                dest_rect2(n,:) = [(SCREEN_X/2)+2500 SCREEN_Y/2 (SCREEN_X/2)+2500 SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
                dest_rect_shift2(n,:) = [(SCREEN_X/2)+2500 (SCREEN_Y/2)+v_pix (SCREEN_X/2)+2500 (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF + [vector_pos(n,1) vector_pos(n,2) vector_pos(n,1) vector_pos(n,2)];
            end
        end
    end
    
    %ensure identities are the same, make equal if separate identities
    
    while usedtochoosering(1) ~= usedtochoosefaces(1)
        usedtochoosefaces(1) = usedtochoosering(1);
    end
    
    %even more face stuff, picks the target angles
    if usedtochoosefaces(1) == 1
        [appl, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude1\CEF1_h', '1.0', '.bmp']);
    elseif usedtochoosefaces(1) == 2
        [appl, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude2\CEF2_h', '1.0', '.bmp']);
    elseif usedtochoosefaces(1) == 3
        [appl, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude3\CEF3_h', '1.0', '.bmp']);
    elseif usedtochoosefaces(1) == 4
        [appl, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude4\CEM1_h', '1.0', '.bmp']);
    elseif usedtochoosefaces(1) == 5
        [appl, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude5\CEM2_h', '1.0', '.bmp']);
    elseif usedtochoosefaces(1) == 6
        [appl, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude6\CEM3_h', '1.0', '.bmp']);
    end
    
    if usedtochoosefaces(1) == 1
        [banan, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude1\CEF1_h', '3.0', '.bmp']);
    elseif usedtochoosefaces(1) == 2
        [banan, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude2\CEF2_h', '3.0', '.bmp']);
    elseif usedtochoosefaces(1) == 3
        [banan, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude3\CEF3_h', '3.0', '.bmp']);
    elseif usedtochoosefaces(1) == 4
        [banan, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude4\CEM1_h', '3.0', '.bmp']);
    elseif usedtochoosefaces(1) == 5
        [banan, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude5\CEM2_h', '3.0', '.bmp']);
    elseif usedtochoosefaces(1) == 6
        [banan, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude6\CEM3_h', '3.0', '.bmp']);
    end
    
    if usedtochoosefaces(1) == 1
        [orang, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude1\CEF1_h', '-1.0', '.bmp']);
    elseif usedtochoosefaces(1) == 2
        [orang, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude2\CEF2_h', '-1.0', '.bmp']);
    elseif usedtochoosefaces(1) == 3
        [orang, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude3\CEF3_h', '-1.0', '.bmp']);
    elseif usedtochoosefaces(1) == 4
        [orang, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude4\CEM1_h', '-1.0', '.bmp']);
    elseif usedtochoosefaces(1) == 5
        [orang, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude5\CEM2_h', '-1.0', '.bmp']);
    elseif usedtochoosefaces(1) == 6
        [orang, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude6\CEM3_h', '-1.0', '.bmp']);
    end
    
    if usedtochoosefaces(1) == 1
        [grap, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude1\CEF1_h', '-3.0', '.bmp']);
    elseif usedtochoosefaces(1) == 2
        [grap, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude2\CEF2_h', '-3.0', '.bmp']);
    elseif usedtochoosefaces(1) == 3
        [grap, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude3\CEF3_h', '-3.0', '.bmp']);
    elseif usedtochoosefaces(1) == 4
        [grap, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude4\CEM1_h', '-3.0', '.bmp']);
    elseif usedtochoosefaces(1) == 5
        [grap, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude5\CEM2_h', '-3.0', '.bmp']);
    elseif usedtochoosefaces(1) == 6
        [grap, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude6\CEM3_h', '-3.0', '.bmp']);
    end
    
    if usedtochoosefaces(1) == 1
        [mang, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude1\CEF1_h', '0.0', '.bmp']);
    elseif usedtochoosefaces(1) == 2
        [mang, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude2\CEF2_h', '0.0', '.bmp']);
    elseif usedtochoosefaces(1) == 3
        [mang, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude3\CEF3_h', '0.0', '.bmp']);
    elseif usedtochoosefaces(1) == 4
        [mang, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude4\CEM1_h', '0.0', '.bmp']);
    elseif usedtochoosefaces(1) == 5
        [mang, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude5\CEM2_h', '0.0', '.bmp']);
    elseif usedtochoosefaces(1) == 6
        [mang, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude6\CEM3_h', '0.0', '.bmp']);
    end
    
    if usedtochoosefaces(1) == 1
        [cherr, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude1\CEF1_h', '5.0', '.bmp']);
    elseif usedtochoosefaces(1) == 2
        [cherr, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude2\CEF2_h', '5.0', '.bmp']);
    elseif usedtochoosefaces(1) == 3
        [cherr, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude3\CEF3_h', '5.0', '.bmp']);
    elseif usedtochoosefaces(1) == 4
        [cherr, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude4\CEM1_h', '5.0', '.bmp']);
    elseif usedtochoosefaces(1) == 5
        [cherr, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude5\CEM2_h', '5.0', '.bmp']);
    elseif usedtochoosefaces(1) == 6
        [cherr, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude6\CEM3_h', '5.0', '.bmp']);
    end
    
    if usedtochoosefaces(1) == 1
        [berr, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude1\CEF1_h', '-5.0', '.bmp']);
    elseif usedtochoosefaces(1) == 2
        [berr, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude2\CEF2_h', '-5.0', '.bmp']);
    elseif usedtochoosefaces(1) == 3
        [berr, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude3\CEF3_h', '-5.0', '.bmp']);
    elseif usedtochoosefaces(1) == 4
        [berr, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude4\CEM1_h', '-5.0', '.bmp']);
    elseif usedtochoosefaces(1) == 5
        [berr, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude5\CEM2_h', '-5.0', '.bmp']);
    elseif usedtochoosefaces(1) == 6
        [berr, ~, alpha] = imread(['C:\kieran\honoursweirdstuff\dude6\CEM3_h', '-5.0', '.bmp']);
    end
      
    theface = Screen('MakeTexture',win,appl);
    theflip = Screen('MakeTexture',win,orang);
    theface2 = Screen('MakeTexture',win,banan);
    theflip2 = Screen('MakeTexture',win,grap);
    theneutral = Screen('MakeTexture',win,mang);
    theextra = Screen('MakeTexture',win,cherr);
    theextra2 = Screen('MakeTexture',win,berr);    
    
    %position faces%
    if usedtochoosefaces(1) > 3
        dest2rect = [(SCREEN_X/2) SCREEN_Y/2 (SCREEN_X/2) SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor;
        dest2rect_shift = [(SCREEN_X/2) (SCREEN_Y/2)+v_pix (SCREEN_X/2) (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor;
        dest2rect2 = [(SCREEN_X/2)+2500 SCREEN_Y/2 (SCREEN_X/2)+2500 SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor;
        dest2rect_shift2 = [(SCREEN_X/2)+2500 (SCREEN_Y/2)+v_pix (SCREEN_X/2)+2500 (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor;
    else
        dest2rect = [(SCREEN_X/2) SCREEN_Y/2 (SCREEN_X/2) SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF;
        dest2rect_shift = [(SCREEN_X/2) (SCREEN_Y/2)+v_pix (SCREEN_X/2) (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF; 
        dest2rect2 = [(SCREEN_X/2)+2500 SCREEN_Y/2 (SCREEN_X/2)+2500 SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF;
        dest2rect_shift2 = [(SCREEN_X/2)+2500 (SCREEN_Y/2)+v_pix (SCREEN_X/2)+2500 (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF;       
    end
%     if usedtochoosefaces(1) > 3
%         dest2rect = [(SCREEN_X/2)-250 SCREEN_Y/2 (SCREEN_X/2)-250 SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor;
%         dest2rect_shift = [(SCREEN_X/2)-250 (SCREEN_Y/2)+v_pix (SCREEN_X/2)-250 (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor;
%         dest2rect2 = [(SCREEN_X/2)+250 SCREEN_Y/2 (SCREEN_X/2)+250 SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor;
%         dest2rect_shift2 = [(SCREEN_X/2)+250 (SCREEN_Y/2)+v_pix (SCREEN_X/2)+250 (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factor;
%     else
%         dest2rect = [(SCREEN_X/2)-250 SCREEN_Y/2 (SCREEN_X/2)-250 SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF;
%         dest2rect_shift = [(SCREEN_X/2)-250 (SCREEN_Y/2)+v_pix (SCREEN_X/2)-250 (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF;
%         dest2rect2 = [(SCREEN_X/2)+250 SCREEN_Y/2 (SCREEN_X/2)+250 SCREEN_Y/2] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF;
%         dest2rect_shift2 = [(SCREEN_X/2)+250 (SCREEN_Y/2)+v_pix (SCREEN_X/2)+250 (SCREEN_Y/2)+v_pix] + [-size(I,2)/2+1 -size(I,1)/2+1 size(I,2)/2 size(I,1)/2].*resize_factorF;
%     end

    
    % Hold blank for a while to give processor a chance to catch up ...!
    %Screen(win, 'WaitBlanking', 60);
    
    
    %this trial isnt visible
    %antialiasing degrades precise timings on the first trial for some
    %reason
    % why??
    %strange way of resolving but it works, trial covered by grey screen is
    %shown first
    Screen('DrawDots', win, [(SCREEN_X-fix_size)/2 (SCREEN_Y-fix_size)/2], fix_size, black,[0,0],1);
    vbl1 = Screen('Flip', win);
    %vbl_old = vbl1;
    % show image for set duration
    if whichway(1) == 1
        for jj=1:10
            Screen('DrawTexture', win, theface, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, stim, [], dest_rect', [], 0, cont(jj));
            Screen('DrawTexture', win, blank(1), [], [], [], 0);
            Screen('DrawDots', win, [(SCREEN_X-fix_size)/2 (SCREEN_Y-fix_size)/2], fix_size, black,[0,0],1);
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif whichway(1) == 2
        for jj=1:10
            Screen('DrawTexture', win, theflip, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, flop, [], dest_rect', [], 0, cont(jj));
            Screen('DrawTexture', win, blank(1), [], [], [], 0);
            Screen('DrawDots', win, [(SCREEN_X-fix_size)/2 (SCREEN_Y-fix_size)/2], fix_size, black,[0,0],1);
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    end
    %Screen('DrawTexture', win, blank(1), [], [], [], 0);
    Screen('DrawDots', win, [(SCREEN_X-fix_size)/2 (SCREEN_Y-fix_size)/2], fix_size, black,[0,0],1);
    vbl2 = Screen('Flip', win);
    
    %durn1 = vbl2-vbl1
    
    % ------------
    
    %vbl1 = Screen('Flip', win);
    %vbl_old = vbl1;

    %stimulus presentation
    % show image for set duration
    %trial order is weird (1-5 RRR RR RO RL RLL) (6-10 LRR LR LO LL LLL)
    %(11-14 RRRR RLLL LRRR LLLL)
    Screen('DrawDots', win, [(SCREEN_X-fix_size)/2 (SCREEN_Y-fix_size)/2], fix_size, black,[0,0],1);
    if trialorder(i) == 1
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theface2, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, stim, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 2
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theface, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, stim, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 3
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theneutral, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, stim, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 4
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theflip, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, stim, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 5
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theflip2, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, stim, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 6
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theface2, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, flop, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 7
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theface, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, flop, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 8
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theneutral, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, flop, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 9
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theflip2, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, flop, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 10
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theflip2, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, flop, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 11
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theextra, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, stim, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 12
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theextra2, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, stim, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 13
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theextra, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, flop, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    elseif trialorder(i) == 14
        for jj=1:stim_durn_frames
            Screen('DrawTexture', win, theextra2, [], dest2rect, [], 0, cont(jj));
            Screen('DrawTextures', win, flop, [], dest_rect', [], 0, cont(jj));
            vbl_new = Screen('Flip',win); %,vbl_old+(1/120));
            %vbl_old = vbl_new;
        end
    end
    
    %Screen('DrawTexture', win, blank(1), [], [], [], 0);
    Screen('DrawDots', win, [(SCREEN_X-fix_size)/2 (SCREEN_Y-fix_size)/2], fix_size, black,[0,0],1);
    vbl2 = Screen('Flip', win);
    
    durn1 = vbl2-vbl1 % should be stim_durn_frames + 1 ...
    
    % ---------------------------
    
    usedtochoosefaces(1)
    usedtochoosering(1)
    
    % Collect response
    while ~keyIsDown
        [keyIsDown, keysecs,keyCode] = KbCheck;
    end
    beep;
    
    if keyIsDown
        if keyCode(ResponseLeft)
            Response = 0; %1;
            ResponseTime = keysecs - responseStartTime; % time in msecs
        elseif keyCode(ResponseRight)
            Response = 1; %0;
            ResponseTime = keysecs - responseStartTime; % time in msecs
        elseif keyCode(ResponseExit)
            % break out of program if p is pressed
            Screen('CloseAll');
            warning on;
            clear hidecursor;
            crash_out_here;
        end
    end
    
    responsetimea = [responsetimea, ResponseTime];
    
    % Hold blank for a while ...
    Screen('DrawTexture', win, blank(1), [], [], [], 0);
    Screen('Flip',win);
            
    Screen(win, 'WaitBlanking', 120);
    
    % ... then display fixation
    Screen('DrawDots', win, [(SCREEN_X-fix_size)/2 (SCREEN_Y-fix_size)/2], fix_size, black,[0,0],1);
    Screen('Flip',win);
    
    Screen(win, 'WaitBlanking', 60);
    
    %if the left (F) key is pressed
    if Response == 0 % CC - recoded responses
        if trialorder(i) == 1
            responsearray = [responsearray, 1];
            RRR = [RRR, 1];
        elseif trialorder(i) == 2
            responsearray = [responsearray, 1];
            RR = [RR, 1];
        elseif trialorder(i) == 3
            responsearray = [responsearray, 1];
            RO = [RO, 1];
        elseif trialorder(i) == 4
            responsearray = [responsearray, 1];
            RL = [RL, 1];
        elseif trialorder(i) == 5
            responsearray = [responsearray, 1];
            RLL = [RLL, 1];
        elseif trialorder(i) == 6
            LRR = [LRR, 1];
            responsearray = [responsearray, 0];
        elseif trialorder(i) == 7
            responsearray = [responsearray, 0];
            LR = [LR, 1];
        elseif trialorder(i) == 8
            responsearray = [responsearray, 0];
            LO = [LO, 1];
        elseif trialorder(i) == 9
            responsearray = [responsearray, 0];
            LL = [LL, 1];
        elseif trialorder(i) == 10
            responsearray = [responsearray, 0];
            LLL = [LLL, 1];
        elseif trialorder(i) == 11
            responsearray = [responsearray, 1];
            RRRR = [RRRR, 1];
        elseif trialorder(i) == 12
            responsearray = [responsearray, 1];
            RLLL = [RLLL, 1];
        elseif trialorder(i) == 13
            responsearray = [responsearray, 0];
            LRRR = [LRRR, 1];
        elseif trialorder(i) == 14
            responsearray = [responsearray, 0];
            LLLL = [LLLL, 1];
        end
        keypressed = [keypressed, 0];
    %if the right (J) key is pressed
    elseif Response == 1
        if trialorder(i) == 1
            responsearray = [responsearray, 0];
            RRR = [RRR, 0];
        elseif trialorder(i) == 2
            responsearray = [responsearray, 0];
            RR = [RR, 0];
        elseif trialorder(i) == 3
            responsearray = [responsearray, 0];
            RO = [RO, 0];
        elseif trialorder(i) == 4
            responsearray = [responsearray, 0];
            RL = [RL, 1];
        elseif trialorder(i) == 5
            responsearray = [responsearray, 0];
            RLL = [RLL, 0];
        elseif trialorder(i) == 6
            responsearray = [responsearray, 1];
            LRR = [LRR, 0];
        elseif trialorder(i) == 7
            responsearray = [responsearray, 1];
            LR = [LR, 0];
        elseif trialorder(i) == 8
            responsearray = [responsearray, 1];
            LO = [LO, 0];
        elseif trialorder(i) == 9
            responsearray = [responsearray, 1];
            LL = [LL, 0];
        elseif trialorder(i) == 10
            responsearray = [responsearray, 1];
            LLL = [LLL, 0];
        elseif trialorder(i) == 11
            responsearray = [responsearray, 0];
            RRRR = [RRRR, 0];
        elseif trialorder(i) == 12
            responsearray = [responsearray, 0];
            RLLL = [RLLL, 0];
        elseif trialorder(i) == 13
            responsearray = [responsearray, 1];
            LRRR = [LRRR, 0];
        elseif trialorder(i) == 14
            responsearray = [responsearray, 1];
            LLLL = [LLLL, 0];
        end
        keypressed = [keypressed, 1];
    end
    
    previousring = usedtochoosering(1);
    % write stimulus & response details to ResponseArray ...
    %running_a_hat = sum(a*ptl(:,:,psi)); % this is just for saving ...
    %ResponseArray(t,:) = [psi, x(min_level(psi)), Response, ResponseTime, running_a_hat, (flipIntervals(1)-1)];
    
    
end % end of stuff done every trial

%add stuff up
if Condition == 1   
    for j = 1:length(RRR)
        RRRRa = RRRRa + RRRR(j);
        RRRa = RRRa + RRR(j);
        RRa = RRa + RR(j);
        ROa = ROa + RO(j);
        RLa = RLa + RL(j);
        RLLa = RLLa + RLL(j);
        RLLLa = RLLLa + RLLL(j);
        LRRRa = LRRRa + LRRR(j);
        LRRa = LRRa + LRR(j);
        LRa = LRa + LR(j);
        LOa = LOa + LO(j);
        LLa = LLa + LL(j);
        LLLa = LLLa + LLL(j);
        LLLLa = LLLLa + LLLL(j);
    end
    RRRRa = RRRRa / length(RRR);
    RRRa = RRRa / length(RRR);
    RRa = RRa / length(RRR);
    ROa = ROa / length(RRR);
    RLa = RLa / length(RRR);
    RLLa = RLLa / length(RRR);
    RLLLa = RLLLa / length(RRR);
    LRRRa = LRRRa / length(RRR);
    LRRa = LRRa / length(RRR);
    LRa = LRa / length(RRR);
    LOa = LOa / length(RRR);
    LLa = LLa / length(RRR);
    LLLa = LLLa / length(RRR);
    LLLLa = LLLLa / length(RRR);
    
elseif Condition == 2  
    for j = 1:length(RRR)
        RRRRb = RRRRb + RRRR(j);
        RRRb = RRRb + RRR(j);
        RRb = RRb + RR(j);
        ROb = ROb + RO(j);
        RLb = RLb + RL(j);
        RLLb = RLLb + RLL(j);
        RLLLb = RLLLb + RLLL(j);
        LRRRb = LRRRb + LRRR(j);
        LRRb = LRRb + LRR(j);
        LRb = LRb + LR(j);
        LOb = LOb + LO(j);
        LLb = LLb + LL(j);
        LLLb = LLLb + LLL(j);
        LLLLb = LLLLb + LLLL(j);
    end
    RRRRb = RRRRb / length(RRR);
    RRRb = RRRb / length(RRR);
    RRb = RRb / length(RRR);
    ROb = ROb / length(RRR);
    RLb = RLb / length(RRR);
    RLLb = RLLb / length(RRR);
    RLLLb = RLLLb / length(RRR);
    LRRRb = LRRRb / length(RRR);
    LRRb = LRRb / length(RRR);
    LRb = LRb / length(RRR);
    LOb = LOb / length(RRR);
    LLb = LLb / length(RRR);
    LLLb = LLLb / length(RRR);
    LLLLb = LLLLb / length(RRR);
    
end

% write ResponseArray to file ...

if Condition == 1
    xdoc = [RRRR; RRR; RR; RO; RL; RLL; RLLL; LRRR; LRR; LR; LO; LL; LLL; LLLL];
    xprob = [RRRRa, RRRa, RRa, ROa, RLa, RLLa, RLLLa, LRRRa, LRRa, LRa, LOa, LLa, LLLa, LLLLa];
    xcomba = [(RRRRa+LRRRa)/2, (RRRa+LRRa)/2, (RRa+LRa)/2, (ROa+LOa)/2, (RLa+LLa)/2, (RLLa+LLLa)/2, (RLLLa+LLLLa)/2];
elseif Condition == 2
    xdoc = [RRRR; RRR; RR; RO; RL; RLL; RLLL; LRRR; LRR; LR; LO; LL; LLL; LLLL];
    xprob = [RRRRb, RRRb, RRb, ROb, RLb, RLLb, RLLLb, LRRRb, LRRb, LRb, LOb, LLb, LLLb, LLLLb];
    xcombb = [(RRRRb+LRRRb)/2, (RRRb+LRRb)/2, (RRb+LRb)/2, (ROb+LOb)/2, (RLb+LLb)/2, (RLLb+LLLb)/2, (RLLLb+LLLLb)/2];
end

xdoc = rot90(xdoc);
xdoc = flipud(xdoc);
xdocprint = array2table(xdoc,'VariableNames',{'RRRR', 'RRR', 'RR', 'RO', 'RL', 'RLL', 'RLLL', 'LRRR', 'LRR', 'LR', 'LO', 'LL', 'LLL', 'LLLL'});
xprobprint = array2table(xprob,'VariableNames',{'RRRR', 'RRR', 'RR', 'RO', 'RL', 'RLL', 'RLLL', 'LRRR', 'LRR', 'LR', 'LO', 'LL', 'LLL', 'LLLL'});
if Condition == 1
    xcombprint = array2table(xcomba,'VariableNames',{'RRR', 'RR', 'R', 'O', 'L', 'LL', 'LLL'});
elseif Condition == 2
    xcombprint = array2table(xcombb,'VariableNames',{'RRR', 'RR', 'R', 'O', 'L', 'LL', 'LLL'});
end
xtrialorder = array2table(flipud(rot90(trialorder)),'VariableNames', {'Stimulus'});
xresponseorder = array2table(flipud(rot90(responsearray)),'VariableNames', {'Response'});
xkeyorder = array2table(flipud(rot90(keypressed)),'VariableNames', {'keyPressed'});
xrtimeorder = array2table(flipud(rot90(responsetimea)),'VariableNames', {'responseTime'});


writetable([xdocprint; xprobprint], filename)
writetable([xtrialorder xresponseorder xkeyorder xrtimeorder], filename, 'Range', 'P1:S500')
writetable(xcombprint, filename, 'Range', 'T1:Z500')

%save graphing variables
if Condition == 1
    save('identityC1', 'ID', 'RRRRa', 'RRRa', 'RRa', 'ROa', 'RLa', 'RLLa', 'RLLLa', 'LRRRa', 'LRRa', 'LRa', 'LOa', 'LLa', 'LLLa', 'LLLLa', 'xcomba')
elseif Condition == 2
    save('identityC2', 'RRRRb', 'RRRb', 'RRb', 'ROb', 'RLb', 'RLLb', 'RLLLb', 'LRRRb', 'LRRb', 'LRb', 'LOb', 'LLb', 'LLLb', 'LLLLb', 'xcombb')
end

%ending message
for jj=1:stim_durn_frames
    Screen('TextSize',win,20);
    Screen('TextStyle',win,0);
    DrawFormattedText(win,'This portion of the study is now complete\n\nPlease call a researcher to proceed.',...
        'center',420,black,[],[],[],1.65);
    Screen('Flip',win,[],[],[],1); %display on screen
end

keypress = 0;
while ~keypress
    [keypress, ~,~] = KbCheck;
end

% return to command window ...
ShowCursor;
Screen('CloseAll');

warning on;
clear HideCursor;