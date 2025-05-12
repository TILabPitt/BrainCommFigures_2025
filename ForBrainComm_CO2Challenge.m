%% 
% For fig 3 and 4

show(avgim_seq(:,:,2)) % channel 3 is OIS BOLD, channel 2 is OIS CBV

%% Grab time series average for only brain tissue

red=3;
BOLD_data = squeeze(data(:,:,red,:));
green=2;
cbv_data = squeeze(data(:,:,green,:));

% Make mask that is only brain tissue, ignore probe as well

circle_mask = selectMask(cbv_data(:,:,10));
cbv_circle = cbv_data.*circle_mask;
bold_circle = BOLD_data.*circle_mask;

% create vessel seg map from k means clustering. You might have to iterate
% between 3-7 clusters based on segmentation. For this representative
% image, 7 clusters will work
im = imsegkmeans(im2single(homocorOIS(cbv_circle(:,:,10),1)),7);
figure, imagesc(im)

% manually enter the channel on "im" that corresponds to vessels. In this
% representative image, it is channel = 4 

inpt=4;
vessel_mask = im == inpt;

bold_vesselmasked = bold_circle.*~vessel_mask;
cbv_vesselmasked = cbv_circle.*~vessel_mask;


for i = 1:size(bold_vesselmasked,3)
    im_bold = bold_vesselmasked(:,:,i);
    im_cbv = cbv_vesselmasked(:,:,i);
    tmpim_bold(i) = mean(im_bold(find(im_bold)));
    tmpim_cbv(i) = mean(im_cbv(find(im_cbv)));
end
figure,
plot(tmpim_bold)

figure,
plot(tmpim_cbv)

%% Now that we have time series, we need to detrend and clean fluctuations

tseries_bold = tcdetrend(tmpim_bold',1,[1 300 2000 2200]);
tseries_cbv = tcdetrend(tmpim_cbv',1,[1 300 2000 2200]);

[yy,ff]=fermi1d(tseries_bold,1,1,1,0.1);
new_tseries_bold = 100*((yy/mean(yy(1:300)))-1);

figure,plot([0.1:0.1:length(new_tseries_bold(50:end-20))/10]-30,smooth(new_tseries_bold(50:end-20),100),'LineWidth',5,'color','black')
xlim([-31, 190])
xticks([-30:30:200])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',16)
b = get(gca,'YTickLabel');
set(gca,'YTickLabel',b,'fontsize',16)
ylabel('OIS BOLD % Change','FontSize',30)
xlabel('Time (s)','FontSize',30)

[yy_cbv,ff]=fermi1d(tseries_cbv,1,1,1,0.1);
new_tseries_cbv = 100*((yy_cbv/mean(yy_cbv(1:300)))-1);
figure,plot([0.1:0.1:length(new_tseries_cbv(50:end-20))/10]-30,smooth(new_tseries_cbv(50:end-20),100),'LineWidth',5,'color','black')
xlim([-31, 190])
xticks([-30:30:200])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',16)
b = get(gca,'YTickLabel');
set(gca,'YTickLabel',b,'fontsize',16)
ylabel('OIS CBV % Change','FontSize',30)
xlabel('Time (s)','FontSize',30)




%% Now do diameter calculations

im = cbv_data(:,:,1250);
[sIm, yout, ROIs] = manyRadROIs(im,1);
[r,rs]=calcRadius6(cbv_data,yout);
plot(r)

radius = diam_quickview(im,ROIs,r,1); % for each radius you calculated, manually inspect tseries and label artery/vein

t = r;
t(1:100,:)=[];
y1 = tcdetrend(t(:,1),1,[200 400 2000 2100]);
y2 = tcdetrend(t(:,2),1,[200 400 2000 2100]);
y3 = tcdetrend(t(:,3),1,[200 400 2000 2100]);
y4 = tcdetrend(t(:,4),1,[200 400 2000 2100]);
y5 = tcdetrend(t(:,5),1,[200 400 2000 2100]);
y6 = tcdetrend(t(:,6),1,[200 400 2000 2100]);
atc_new1=100*(y1/mean(y1(1:300))-1);
atc_new2=100*(y2/mean(y2(1:300))-1);
atc_new3=100*(y3/mean(y3(1:300))-1);
atc_new4=100*(y4/mean(y4(1:300))-1);
atc_new5=100*(y5/mean(y5(1:300))-1);
atc_new6=100*(y6/mean(y6(1:300))-1);

fig = figure;
subplot(611), plot([0.1:0.1:length(atc_new1)/10],atc_new1,'LineWidth',3),set(gca,'xtick',[],'FontSize',14)
title('Diameter 1')
subplot(612), plot([0.1:0.1:length(atc_new2)/10],atc_new2,'LineWidth',3),set(gca,'xtick',[],'FontSize',14)
title('Diameter 2')
subplot(613), plot([0.1:0.1:length(atc_new3)/10],atc_new3,'LineWidth',3),set(gca,'xtick',[],'FontSize',14)
title('Diameter 3')
subplot(614), plot([0.1:0.1:length(atc_new4)/10],atc_new4,'LineWidth',3),set(gca,'xtick',[],'FontSize',14)
title('Diameter 4')
subplot(615), plot([0.1:0.1:length(atc_new5)/10],atc_new5,'LineWidth',3),set(gca,'xtick',[],'FontSize',14)
title('Diameter 5')
subplot(616), plot([0.1:0.1:length(atc_new6)/10],atc_new6,'LineWidth',3),set(gca,'xtickMode', 'auto','FontSize',14)
title('Diameter 6')
han=axes(fig,'visible','off');
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Diameter % Change','FontSize',20 );
xlabel(han,'Time (seconds)','FontSize',20 );

