function vars = mmat_to_mfile_all(matFileName, mFileName)
% Converts a .mat file into a readable and executable .m file.
% Supports nested double, logical, char, cell, and struct variables.
% Example usage: mat_to_mfile_all('file.mat', 'file_data.m');

    if nargin < 2
        [~, name, ~] = fileparts(matFileName);
        mFileName = [name '.m'];
    end

    % Load data from .mat file
    data = load(matFileName);
    vars = fieldnames(data);

    % Open target .m file
    fid = fopen(mFileName, 'w');
    if fid == -1
        error('Unable to open file %s for writing', mFileName);
    end

    fprintf(fid, '%% Automatically generated from %s\n\n', matFileName);

    % Process each variable
    for i = 1:length(vars)
        writeVariable(fid, vars{i}, data.(vars{i}));
    end

    fclose(fid);
    fprintf('✅ Successfully written to %s\n', mFileName);
end

function writeVariable(fid, varName, varValue, indent)
    if nargin < 4
        indent = '';
    end

    if isnumeric(varValue) || islogical(varValue)
        valStr = mat2str(varValue, 6);
        fprintf(fid, '%s%s = %s;\n\n', indent, varName, valStr);

    elseif ischar(varValue)
        fprintf(fid, '%s%s = ''%s'';\n\n', indent, varName, varValue);

    elseif iscell(varValue)
        cellStr = cellToString(varValue, indent);
        fprintf(fid, '%s%s = %s;\n\n', indent, varName, cellStr);

    elseif isstruct(varValue)
        s = varValue;
        fieldnames_s = fieldnames(s);
        for idx = 1:numel(s)
            structPrefix = sprintf('%s(%d)', varName, idx);
            for j = 1:numel(fieldnames_s)
                f = fieldnames_s{j};
                subVal = s(idx).(f);
                fullName = sprintf('%s.%s', structPrefix, f);
                writeVariable(fid, fullName, subVal, indent);
            end
        end

    else
        fprintf(fid, '%s%% %s = <unsupported data type: %s>\n\n', indent, varName, class(varValue));
    end
end

function out = cellToString(cellVal, indent)
    out = '{';
    for i = 1:size(cellVal, 1)
        rowStr = '';
        for j = 1:size(cellVal, 2)
            elem = cellVal{i, j};
            if isnumeric(elem) || islogical(elem)
                elemStr = mat2str(elem, 6);
            elseif ischar(elem)
                elemStr = ['''' elem ''''];
            else
                elemStr = sprintf('%% <cell element of type %s not expanded>', class(elem));
            end
            rowStr = [rowStr, elemStr];
            if j < size(cellVal, 2)
                rowStr = [rowStr, ', '];
            end
        end
        out = [out, rowStr];
        if i < size(cellVal, 1)
            out = [out, '; '];
        end
    end
    out = [out, '}'];
end

function cleanread_mat_to_mfile_all(input_file, vars_to_keep)
  % Check if the input file exists
    if ~exist(input_file, 'file')
        error('File not found: %s', input_file);
    end

    % Try to read the content of the file
    try
        % Read the content of the file as text
        fid = fopen(input_file, 'rt');
        file_content = fread(fid, '*char')';
        fclose(fid);

         if isempty(file_content)
            error('File is empty or content could not be read: %s', input_file);
        end
        % Clean non-ASCII characters (if needed)
        file_content = regexprep(file_content, '[^\x00-\x7F]', '');


        % Write the cleaned content into a temporary file
        clean_file = 'temp_cleaned_file.m';
        fid = fopen(clean_file, 'wt');
        fwrite(fid, file_content);
        fclose(fid);

        % Now load variables from the temporary file into the workspace
        run(clean_file); % This executes the code in the temporary file
        disp('variables now in workspace:');
        whos;
        % vars_in_workspace = who;
        % vars_to_clear = setdiff(vars_in_workspace, vars_to_keep);
        % clear(vars_to_clear{:});
        % Optionally, delete the temporary file after loading variables
        % disp('variables now in workspace:');
        % whos;
        delete(clean_file);
        % fprintf('Variables loaded into the workspace from: %s\n', clean_file);

    catch ME
        error('Error reading or processing the file: %s', ME.message);
    end

end

