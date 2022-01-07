function beautify(file,startl,endl)
% beautify the matlab source file
% 【Usage】set formatter_path, and then do following command at command window
% beautify(path_to_target_file)
% path_to_target_file : relative path to the target file from the working folder
% 
% Example : beautify("reference/TimeVaryingReference.m")
% 
% matlab_formatter.py requires chardet package. 
% 
arguments
  file string
  startl {mustBeInteger} = 1
  endl = "None"
end
formatter_path = "assets\python\matlab_formatter.py";

if strcmp(endl,"None")
  command = strcat("python ",formatter_path," ",file," --indentWidth=4 --separateBlocks=False --indentMode=-1");
  [a,o]=system(command);
else
  command = strcat("python ",formatter_path," ",file," --indentWidth=4 --startLine=",string(startl)," --endLine=",string(endl)," --separateBlocks=False --indentMode=-1");
  [a,o] = system(command);
end
end