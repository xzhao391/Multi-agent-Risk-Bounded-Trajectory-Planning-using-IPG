function Draw_Multi (A1_xx,A1_xs, agent1_xx,...
    A2_xx,A2_xs, agent2_xx,...
        radius)

set(0,'DefaultAxesFontName', 'Times New Roman')
set(0,'DefaultAxesFontSize', 12)

fontsize_labels = 14;

%--------------------------------------------------------------------------
%-----------------------Simulate robots -----------------------------------
%--------------------------------------------------------------------------
x_r_1 = [];
y_r_1 = [];
x_r_2 = [];
y_r_2 = [];


r = radius;  % robot radius
ang=0:0.005:2*pi;
xp=r*cos(ang);
yp=r*sin(ang);

r_obs = 1.2;  % obstacle radius
xp_obs=r_obs*cos(ang);
yp_obs=r_obs*sin(ang);

figure('Position',[100 100 700 500]);
hold on
tic
for k = 1:size(A1_xx,2)-1
    agent1_plot = plot_robot(k,A1_xx, agent1_xx{k}, x_r_1, y_r_1, xp, yp, 1);
    agent2_plot = plot_robot(k,A2_xx, agent2_xx{k}, x_r_2, y_r_2, xp, yp, 2);

    obs1_plot = fill(0+xp_obs,1.5+yp_obs,'cyan','FaceAlpha',0.3); % plot obstacle circle  
    set(obs1_plot, 'edgecolor','none')
    obs1_plot = fill(0+xp_obs,-1.5+yp_obs,'cyan','FaceAlpha',0.3); % plot obstacle circle   
    set(obs1_plot, 'edgecolor','none')
    hold off

    axis([-1.5 1.5 -1 1])
    pause(0.1)
    h = gca;
    set(h,'xtick',[-1.5 -1 -.5 0 .5 1 1.5])
    set(h,'ytick',[-1 -.5 0 .5 1])
    h.Box = "on";
    if mod(k, 3) == 0
        saveas(gca,strcat('graph\',num2str(k),'.png'))
    end
    drawnow
    % for video generation
    F(k) = getframe(gcf); % to get the current frame
end
toc
close(gcf)
%viobj = close(aviobj)
video = VideoWriter('exp.avi','Uncompressed AVI');

video = VideoWriter('exp.avi','Motion JPEG AVI');
video.FrameRate = 5;  % (frames per second) this number depends on the sampling time and the number of frames you have
open(video)
writeVideo(video,F)
close (video)

