%%%

%% Please cite:

% "Near-lifespan mesoscopic optical imaging of cerebrovascular function
% reveals age and sex differences in preclinical Alzheimers Disease
% model". Noah Schweitzer et al. Brain Communications

%%

load('20220223mouse_lass11_forBrainComm.mat')

% channel 2 is GCaMP, channel 3 is OIS CBV, channel 1 is OIS BOLD 

show(avgim_seq(:,:,2))

% Get averages per pixel based on stimulation parameters

map = myOISmap1b(data_intc(:,:,2,:),[20 160 25],[18,25,1],'x0.5')

% Make threshold to segment mask around whisker barrel region
thresh = map.map>0.6*max(map.map(:));
show(thresh)

% Segment mask, grab top 100 pixels in whisker barrel region

manual_mask = selectMask(thresh);

thresh_mask = manual_mask.*thresh;
thresh_mask_vals = thresh_mask.*map.map;
top100_whiskermap = thresh_mask_vals >= min(maxk(thresh_mask_vals(:),100));

show(top100_whiskermap)

tcC1 = applynewmap(data_intc(:,:,2,:),top100_whiskermap,map) % enter channel of interest and top100 mask to get average time series



%% 
% make average time series figures

nstim=20;
nskp=25;
ntr=20;
nimtr=160;
noff=50;
nkeep=25;

adata = mean(reshape(data_intc(:,:,2,[1:nimtr*ntr]+noff-nkeep),...
    size(data,1),size(data,2),nimtr,ntr),4); %for GCaMP

subim = mean(adata,3);
adata_norm = adata-subim;
minim = min(adata_norm(:));
maxim=max(adata_norm(:));

figure,
imshow(adata_norm(:,:,35),[minim,maxim])
set(gca,'position',[0 0 1 1])
hold on;
visboundaries(top100_whiskermap, 'Color', 'r','LineWidth',1.25);
hold off;
set(gca,'position',[0 0 1 1])

