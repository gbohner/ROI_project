% MAKE SURE you compile the .c files first by running mexAll.m. 

% load mean20130303_H92_009.mat
% load Jen_data_5X_contrast
load Jen_data_5X_BW
% load Jen_data_10X
% replace orig_Im with any mean image from a GCaMP6 - 2x experiment
orig_Im = y; 

% pre-learned model parameters. model.W contains the templates.
% load model_GCaMP6_2x.mat 
load model_Jen_20140710_5xBW.mat
% load model_Jen_20140711_10x.mat
% load model_Jen_20140710_5xBW


% If ops.Nextract = 0, the model is calibrated to extract the number of cells it thinks are
% present in the image. If ops.Nextract>0, it extracts exactly that many
% elements from the image (both cell contours and dendrite fragments). 
% The calibrated default for model_GCaMP6_2x is about 600. 
ops.Nextract = 1000;

% Returns elem with all identified template locations
% at elem.ix and elem.iy, and with the element types at elem.map. Also
% returns the normalized image that was used to run the inference
[elem, norm_Im, dLL] = run_inference(orig_Im, model, ops);

% for comparisons with other segmentations retain only the cell map in 
% elem_model
elem_model = elem;
valid = (elem.map==model.cell_map);
elem_model.ix(~valid) = [];
elem_model.iy(~valid) = [];
%% and here is one way to look at the results overlaid on an image

% selects which of the maps to look at. By default take the cell_map.
% change this to 1 (or 2) to see the locations for the dendrite fragments
which_map = model.cell_map;  

% select only elements from that map
valid = (elem.map==which_map);

% can replace with the mean image, orig_Im
Im = norm_Im;

figure('outerposition',[0 0 1000 1000])
thresh = -550;
last_cell = find(dLL(1:model.KS:end)>thresh,1,'first');

% sig = nanstd(Im(:)); mu = nanmean(Im(:)); M1= mu - 4*sig; M2= mu + 12*sig;
% imagesc(Im, [M1 M2])
% colormap('gray')
imshow(orig_Im(1:1030,:));
hold on
plot(elem.iy(1:last_cell), elem.ix(1:last_cell), 'xg', 'Linewidth', 1, 'MarkerSize', 3)

axis off


