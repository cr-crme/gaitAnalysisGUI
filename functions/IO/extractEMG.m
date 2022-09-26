function EMG = extractEMG(c3d)


EMG.Analogs = btkGetAnalogs(c3d);

EMG.Events = btkGetEvents(c3d);

EMG.Angles = btkGetAngles(c3d);

EMG.First_frame = btkGetFirstFrame(c3d);




