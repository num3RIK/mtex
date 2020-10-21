function q = cube2quat(XYZ)

% transformation of cubochoric representation of rotations into
%   representation as unit quaternions
% the transformation is done by first going from cubochoric to homochoric
%   representation (cube2ball) and then further to the representation as unit
%   quaternions (InvLambert) 
% 
% Input:    XYZ (dimension (N,3) array) - cubochoric coordinates (X,Y,Z) of N points of the cube
% Output:   q   (dimension (N,4) array) - coordniates of N unit quaternions

xyz = cube2ball(XYZ);
q   = InvLambert(xyz);

end