function [a,o] = beautify(file,startl,endl)
% beautify the matlab source file
% 【Usage】set formatter_path, and then do following command at command window
% beautify(path_to_target_file)
% path_to_target_file : relative path to the target file from the working folder
% 
% Example : beautify("reference/TIME_VARYING_REFERENCE.m")
% 
% matlab_formatter.py requires chardet package. 
% install python3.8 at Microsoft Store 
% matlab>> system("pip3.8 install chardet")
arguments
  file string = "initialize"
  startl {mustBeInteger} = 1
  endl = "None"
end
formatter_path = "assets\python\matlab_formatter.py";
if strcmp(file,"initialize")
   [a,~]=system("pip3.8 install chardet");
   if a~=0
       disp("install python3.8 from Microsoft store");
   else
       disp("ready to beautify: beautify('file_name')");
   end
end

if strcmp(endl,"None")
  command = strcat("python3.8 ",formatter_path," ",file," --indentWidth=2 --separateBlocks=False --indentMode=-1");
  [a,o]=system(command);
else
  command = strcat("python3.8 ",formatter_path," ",file," --indentWidth=2 --startLine=",string(startl)," --endLine=",string(endl)," --separateBlocks=False --indentMode=-1");
  [a,o] = system(command);
end
end