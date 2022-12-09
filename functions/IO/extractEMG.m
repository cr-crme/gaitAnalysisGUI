function EMG = extractEMG(c3d)


EMG.Analogs = c3dAnalogs(c3d);

EMG.Events = c3dEvents(c3d);

EMG.Angles = c3dAngles(c3d);

EMG.First_frame = c3dFirstFrame(c3d);




