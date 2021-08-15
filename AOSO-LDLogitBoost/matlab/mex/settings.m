%% OpenCV 
% root dir
dir_root = '"D:\opencv"';
% dir
cvinc2 = fullfile('D:\opencv\build\include');
linkdird = fullfile('D:\opencv\build\x64\vc12\lib');
linkdir = fullfile('D:\opencv\build\x64\vc12\lib');
% 
lib2d = 'opencv_world300d';
lib2 = 'opencv_world300';
%% source codes
dir_src = '../../src/';
%% options
tmpld = '-I%s -I%s -L%s -l%s';
opt_cmdd = sprintf(tmpld,...
  dir_src,...
  cvinc2,...
  linkdird,lib2d);
%% string template
tmpl = '-I%s -I%s -L%s -l%s';
opt_cmd = sprintf(tmpld,...
  dir_src,...
  cvinc2,...
  linkdir,lib2);