%somewhere, compare 7.5 30 and cut out smallest effect
%make sure lab comps dont break anything

%function ploteverything

%ID = 'K';
load('identityC1')
load('identityC2')
load('identityC3')


colors = [0 0 0.7; 0.7 0 0; 0 0 0; 0.7 0 0]; % b,r,k,g
axes('ColorOrder',colors)

init_params = [0 1 0];
x = [-5 -3 -1 0 1 3 5];


%rightplot = [0 0 0; 0 0 0.1; 0.25 0.1 0.35; 0.45 0.5 0.5; 0.65 0.9 0.9; 1 1 1; 1 1 1];
%leftplot = [0 0 0; 0 0 0; 0.2 0 0.25; 0.4 0.5 0.45; 0.6 1 0.8; 1 1 1; 1 1 1];

rightplot = [RRRRa RRRRb RRRRc; RRRa RRRb RRRc; RRa RRb RRc; ROa ROb ROc; RLa RLb RLc; RLLa RLLb RLLc; RLLLa RLLLb RLLLc];
leftplot = [LRRRa LRRRb LRRRc; LRRa LRRb LRRc; LRa LRb LRc; LOa LOb LOc; LLa LLb LLc; LLLa LLLb LLLc; LLLLa LLLLb LLLLc];
controlplot = [(rightplot(:,3)+leftplot(:,3))/2];

%%First Figure
subplot(1,2,2)
params = nlinfit(x,rot90(rightplot(:,1)),'logistic3',init_params);
plot(min(x):.1:max(x),logistic3(params,min(x):.1:max(x)),'b-')
hold on
params = nlinfit(x,rot90(rightplot(:,2)),'logistic3',init_params);
plot(min(x):.1:max(x),logistic3(params,min(x):.1:max(x)),'m-')
params = nlinfit(x,rot90(rightplot(:,3)),'logistic3',init_params);
plot(min(x):.1:max(x),logistic3(params,min(x):.1:max(x)),'r-')
plot(x,rightplot, ':o')
hold off
title('rightFlankers')
line([-10 10], [0.5 0.5], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');
line([0 0], [-10 10], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');
xlim([-5 5]);
ylim([-0.1 1.1]);
ax = gca;
ax.XTick = [-5 -3 -1 0 1 3 5];
ax.YTick = [0 0.2 0.4 0.6 0.8 1.0];
ax.XTickLabel = ({'RRR', 'RR', 'R', '0', 'L', 'LL', 'LLL'});

subplot(1,2,1)
params = nlinfit(x,rot90(leftplot(:,1)),'logistic3',init_params);
plot(min(x):.1:max(x),logistic3(params,min(x):.1:max(x)), 'b-')
hold on
params = nlinfit(x,rot90(leftplot(:,2)),'logistic3',init_params)
plot(min(x):.1:max(x),logistic3(params,min(x):.1:max(x)), 'm-')
params = nlinfit(x,rot90(leftplot(:,3)),'logistic3',init_params);
plot(min(x):.1:max(x),logistic3(params,min(x):.1:max(x)), 'r-')
plot(x,leftplot, ':o')
hold off
title('leftFlankers')
ylabel (ID)
line([-10 10], [0.5 0.5], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');
line([0 0], [-10 10], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');
xlim([-5 5]);
ylim([-0.1 1.1]);
ax = gca;
ax.XTick = [-5 -3 -1 0 1 3 5];
ax.YTick = [0 0.2 0.4 0.6 0.8 1.0];
ax.XTickLabel = ({'RRR', 'RR', 'R', '0', 'L', 'LL', 'LLL'});
legend({'15','7.5','0(C)'}, 'location', 'southeast');


%%Second Figure

figure
subplot(1,2,1)
params = nlinfit(x,rot90(rightplot(:,1)),'logistic3',init_params)
plot(min(x):.1:max(x),logistic3(params,min(x):.1:max(x)),'b-')
rightp1 = params;
hold on
params = nlinfit(x,rot90(leftplot(:,1)),'logistic3',init_params)
plot(min(x):.1:max(x),logistic3(params,min(x):.1:max(x)),'r-')
leftp1 = params;
params = nlinfit(x,rot90(controlplot),'logistic3',init_params)
controlp = params;
plot(min(x):.1:max(x),logistic3(params,min(x):.1:max(x)),'g-')
line([-10 10], [0.5 0.5], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');
line([0 0], [-10 10], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');
hold off
title ((rightp1 - leftp1)/2);
ylabel (ID)
xlim([-5 5]);
ylim([-0.1 1.1]);
ax = gca;
ax.XTick = [-5 -3 -1 0 1 3 5];
ax.YTick = [0 0.2 0.4 0.6 0.8 1.0];
ax.XTickLabel = ({'RRR', 'RR', 'R', '0', 'L', 'LL', 'LLL'});
legend({'Right','Left','Control'}, 'location', 'southeast');

subplot(1,2,2)
params = nlinfit(x,rot90(rightplot(:,2)),'logistic3',init_params)
plot(min(x):.1:max(x),logistic3(params,min(x):.1:max(x)),'b-')
rightp2 = params;
hold on
params = nlinfit(x,rot90(leftplot(:,2)),'logistic3',init_params)
plot(min(x):.1:max(x),logistic3(params,min(x):.1:max(x)),'r-')
leftp2 = params;
params = nlinfit(x,rot90(controlplot),'logistic3',init_params)
plot(min(x):.1:max(x),logistic3(params,min(x):.1:max(x)),'g-')
line([-10 10], [0.5 0.5], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');
line([0 0], [-10 10], 'Color', [0.5 0.5 0.5], 'LineStyle', '--');
hold off
title((rightp2 - leftp2)/2);
xlabel (controlp)
xlim([-5 5]);
ylim([-0.1 1.1]);
ax = gca;
ax.XTick = [-5 -3 -1 0 1 3 5];
ax.YTick = [0 0.2 0.4 0.6 0.8 1.0];
ax.XTickLabel = ({'RRR', 'RR', 'R', '0', 'L', 'LL', 'LLL'});