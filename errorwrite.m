function [f] = errorwrite(filename, data, header)
    
    file_id = fopen(filename, 'w'); %open file for writing
    fprintf(file_id, header);       %write the header
    fclose(file_id);                %close file
    
    dlmwrite(filename, data, '-append'); %append the data
end