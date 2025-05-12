function tcC1 = applynewmap(stk,reg_mask,map1)

nstim=map1.map_parms(1);
nskp=map1.map_parms(2);
noff=map1.stim_parms(3);
nimtr=map1.stim_parms(2);
ntr=map1.stim_parms(1);
nkeep=0;
bim_ii=[1:nstim-1];
aim_ii=nskp+[1:nstim-1];

tcC1=getStkMaskTC(stk,reg_mask);

tcC1.atc_all=(reshape(tcC1.atc([1:nimtr*ntr]+noff-nkeep,:,1),[nimtr ntr size(tcC1.atc,2) size(tcC1.atc,3)]));
tcC1.atc_a=squeeze(mean(tcC1.atc_all,2));
tcC1.atc_ans=tcC1.atc_a./repmat(mean(tcC1.atc_a(1:ntr,:,:),1),[nimtr 1 1]);

% figure;
% plot([1:length(tcC1.atc_ans)],tcC1.atc_ans,...
%     bim_ii,ones(size(bim_ii))*min(tcC1.atc_ans),...
%     aim_ii,ones(size(aim_ii))*max(tcC1.atc_ans))
% ylabel('Avg. Amplitude')


atc_new = 100*(tcC1.atc_ans-1);
figure;
plot([0.1:0.1:length(tcC1.atc_ans)/10]-2,smooth(smooth(atc_new)),...
    'LineWidth',4,'color','black'),%,xlim([-2,16]),
%xticks([-2 0 2 4 6])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',16)
b = get(gca,'YTickLabel');
set(gca,'YTickLabel',b,'fontsize',16)
ylabel('GCaMP % Change','FontSize',20)
xlabel('Time (s)','FontSize',20)


tcC1.max_amp=max(tcC1.atc_ans(5:length(tcC1.atc_ans)));
finder=find(tcC1.atc_ans==tcC1.max_amp);
aim_9=[finder-4:finder+4];
tcC1.avg_amp_9=mean(tcC1.atc_ans(aim_9));
tcC1.avg_amp_stim=mean(tcC1.atc_ans(aim_ii))
tcC1.atc_new = atc_new;