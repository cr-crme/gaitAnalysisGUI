function out = derive(val, dt)
    
    out = nan(size(val));
    out(2:end-1,:) = (val(3:end,:) - val(1:end-2,:)) / (2*dt);

end