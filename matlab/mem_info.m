function mem_mb = mem_info()
    fid = fopen('/proc/self/status','r');
    mem_mb = NaN;
    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, 'VmRSS:')
            val = sscanf(line, 'VmRSS: %d kB');
            mem_mb = val / 1024;
            break;
        end
    end
    fclose(fid);
end