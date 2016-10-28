%% Visualizing EBSD data with sharp textures
% How visualize texture gradients within grains
%
%% Open in Editor
%
%% Contents
%

%% 
% Using specialized orientation mappings is particularly useful when
% visualizing sharp data. Let us consider the following data set which
% restricts to the calcite phase

plotx2east
mtexdata sharp

ebsd = ebsd('calcite');

oM = ipdfHSVOrientationMapping(ebsd);

close all;
plot(ebsd,oM.orientation2color(ebsd.orientations))

%%
% and have a look into the 100 inverse pole figure.

% compute the positions in the inverse pole figure
h = ebsd.orientations .\ vector3d.X;
h = project2FundamentalRegion(h);

% compute the azimuth angle in degree
color = h.rho ./ degree;

plotIPDF(ebsd.orientations,vector3d.X,'property',color,'MarkerSize',3,'grid')
mtexColorbar

%%
% We see that all individual orientations are clustered around azimuth
% angle 115 degrees with some outliers at 125 and 130 degree. In order to
% increase the contrast for the main group, we restrict the color range from
% 110 degree to 120 degree.

caxis([110 120]);

% by the following lines we colorcode the outliers in purple.
cmap = colormap;
cmap(end,:) = [1 0 1]; % make last color purple
cmap(1,:) = [1 0 1];   % make first color purple
colormap(cmap)

%%
% The same colorcoding we can now apply to the EBSD map.

% plot the data with the customized color
plot(ebsd,color)

% set scaling of the angles to 110 - 120 degree
caxis([110 120]);

% colorize outliers in purple.
cmap = colormap;
cmap(end,:) = [1 0 1];
cmap(1,:) = [1 0 1];
colormap(cmap)

%% Sharpening the default colorcoding
% Next, we want to apply the same ideas as above to the default MTEX
% color mapping, i.e. we want to stretch the colors such that they cover
% just the orientations of interest. 

oM = ipdfHSVOrientationMapping(ebsd.CS.properGroup);

% To this end, we first compute the inverse pole figure direction such that
% the mean orientation is just at the gray spot of the inverse pole figure
oM.inversePoleFigureDirection = mean(ebsd.orientations,'robust') * oM.whiteCenter;

close all;
plot(ebsd,oM.orientation2color(ebsd.orientations))

%% 
% We observe that the orientation map is almost completely gray, except for
% the  outliers which appears black. Next, we use the option |maxAngle| to
% increase contrast in the grayish part

oM.maxAngle = 7.5*degree;
plot(ebsd,oM.orientation2color(ebsd.orientations))

%%
% You may play around with the option |maxAngle| to obtain better
% results. As for interpretation keep in mind that white color represents
% the mean orientation and the color becomes more saturated and later dark
% as the orientation to color diverges from the mean orientation.
%
% Let's have a look at the corresponding color map.

plot(oM,'resolution',0.25*degree)

% TODO: Check this!!!
%hold on
%plotIPDF(ebsd.orientations,'points',10,'MarkerSize',1,'MarkerFaceColor','w','MarkerEdgeColor','w')
%hold off
%%
% observe how in the inverse pole figure the orientations are scattered
% closely around the white center. Together with the fact that the
% transition from white to color is quite rapidly, this gives a high
% contrast.


%% 
% Another example is when analyzing the orientation distribution within
% grains

mtexdata forsterite
ebsd = ebsd('indexed');

% segment grains
[grains,ebsd.grainId] = calcGrains(ebsd);

% find largest grains
largeGrains = grains(grains.grainSize > 800)

ebsd = ebsd(largeGrains(1))

%%
% When plotting one specific grain with its orientations we see that they
% all are very similar and, hence, get the same color

% plot a grain 
close all
plot(largeGrains(1).boundary,'linewidth',2)
hold on
plot(ebsd,ebsd.orientations)
hold off

%%
% when applying the option sharp MTEX colors the mean orientation as white
% and scales the maximum saturation to fit the maximum misorientation
% angle. This way deviations of the orientation within one grain can be
% visualized. 

% plot a grain 
plot(largeGrains(1).boundary,'linewidth',2)
hold on
oM = ipdfHSVOrientationMapping(ebsd);
oM.inversePoleFigureDirection = mean(ebsd.orientations) * oM.whiteCenter;
oM.maxAngle = 2*degree;
plot(ebsd,oM.orientation2color(ebsd.orientations))
hold off

%%

ebsd = ebsd.gridify

plot(ebsd,abs(ebsd.gradientX))
plot(ebsd,abs(ebsd.gradientY))
