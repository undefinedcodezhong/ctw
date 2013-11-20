% Demo file for aligning kitchen sequence using CTW.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-20-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

clear variables;
prSet(4);

%% src parameter
act = 'cabinet';
subIdx = [1 2];
rann = 'y';
feats = {'XQ', 'XQ'};
parPca = st('d', .99);

%% algorithm parameter
parDtw = st('dp', 'c');
parCtw = st('th', 0, 'debg', 'n');
parCca = st('d', .8, 'lams', .6);

%% src
wsSrc = kitAliSrc(act, subIdx, rann, 'svL', 2);
%aliT = wsSrc.aliT;

%% data
wsData = kitAliData(wsSrc, 'svL', 2);
pFss = wsData.pFss;
Xs = {wsData.XQs{1}, wsData.XQs{2}};

%% utw (initialization)
aliUtw = utw(Xs, [], []);

%% dtw
aliDtw = dtw(Xs, [], parDtw);

%% ctw
aliCtw = ctw(Xs, aliDtw, [], parCtw, parCca, parDtw);

%% show sequence
rows = 1; cols = 3;
axs = iniAx(3, rows, cols, [300 * rows, 300 * cols]);

parPca = st('d', 2, 'homo', 'n');
parMk = st('mkSiz', 2, 'lnWid', 1, 'ln', '-');
parAx = st('mar', .1, 'ang', [30 80], 'tick', 'n');

XX0s = pcas(Xs, parPca);
shs(XX0s, parMk, parAx, 'ax', axs{1, 1});
title('Original');

Ys = gtwTra(homoX(Xs), aliCtw, parCca, parDtw);
YYs = pcas(Ys, parPca);
shs(YYs, parMk, parAx, 'ax', axs{1, 2});
title('CTW');

shAlis({aliDtw, aliCtw}, 'legs', {'dtw', 'ctw'}, 'ax', axs{1, 3});
hold on;
plot([1, 831], [496 496], '--k');
plot([597, 597], [1 779], '--k');

%% show keyframe
lNew = 10;
rows = 2; cols = lNew;
Ax = iniAx(5, rows, cols, [80 * rows, 100 * cols], 'wGap', .1, 'hGap', .1);
shMocAliFr(wsSrc, wsData, aliCtw, lNew, Ax, 'all', 'n');
