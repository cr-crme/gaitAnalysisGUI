function data = rearangeIntoEvents(data, eventNames, segmentNames)

    for i = 1:length(eventNames)
        for j = 1:length(segmentNames)
            data.(eventNames{i}).(segmentNames{j}) = data.angle.(segmentNames{j})(data.stamps.(eventNames{i}).frameStamp,:);
        end
    end

end