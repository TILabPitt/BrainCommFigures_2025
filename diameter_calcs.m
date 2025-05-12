function [baseline_diam, diameter_percent_change] = diameter_calcs(r)

baseline_diam = zeros([size(r,2),1]);
diameter_percent_change = zeros([size(r,2),1]);

baseline = 3:303;
for i = 1:size(r,2)

    radius = tcdetrend(r(2:end,i));
    startbar = 500;
    endbar = 800;
    percent_change = [];
    while endbar < length(radius)-200
        %this while loop will jump 50 frames to find where the peak change is. 
        
        bar = startbar:endbar; % bar over which to average
        percent_change = [percent_change, 100*(mean(radius(bar))/mean(radius(baseline))-1)];
    
        startbar = startbar + 50;
        endbar = endbar + 50;
    
    end
    
    max_val = max(percent_change);
    min_val = min(percent_change);

    if abs(min_val) > max_val
        max_val_ind = find(percent_change == min_val);
    else
        max_val_ind = find(percent_change == max_val);
    end

    baseline_diam(i) = mean(radius(baseline));
    diameter_percent_change(i) = percent_change(max_val_ind(1));

end


    

   
    




