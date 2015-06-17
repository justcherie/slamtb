function [Rob,Trj,Frm,Fac] = addKeyFrame(Rob,Trj,Frm,Fac,factorRob, factorType)

% Add frame to trajectory
[Trj,Frm,Fac] = addFrmToTrj(...
    Trj,...
    Frm,...
    Fac);

% Update new frame with Rob info
[Rob, Frm(Trj.head)] = rob2frm(...
    Rob,...
    Frm(Trj.head));

% Create motion factor
fac = find([Fac.used] == false, 1, 'first');

switch factorType
    
    case 'absolute'
    [Frm(Trj.head), Fac(fac)] = makeAbsFactor(...
        Frm(Trj.head), ...
        Fac(fac), ...
        factorRob);
    
    case 'motion'
        head_old = mod(Trj.head - 2, Trj.maxLength) + 1;
        [Frm(head_old), Frm(Trj.head), Fac(fac)] = makeMotionFactor(...
            Frm(head_old), ...
            Frm(Trj.head), ...
            Fac(fac), ...
            factorRob);
        
    otherwise
        error('??? Unknown or invalid factor type ''%s''.', facType)
end

