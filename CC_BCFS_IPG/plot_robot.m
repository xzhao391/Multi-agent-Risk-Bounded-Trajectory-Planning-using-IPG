function agent_plot = plot_robot(k,A1_xx, agent_xx, x_r_1, y_r_1, xp, yp, agent_num)
    switch agent_num 
        case 1
            color = 'r';
            line_color = '--r';
            sr = sqrt(15);
        case 2
            color = 'b';
            line_color = '--b';
            sr = sqrt(3);
        case 3
            color = 'k';
            line_color = 'k';
        case 4
            color = 'g';
            line_color = 'g';           
    end
    line_width = 1.5;
    h_t = 0.14; w_t=0.09; % triangle parameters
    x1 = A1_xx(1,k,1); y1 = A1_xx(2,k,1); th1 = A1_xx(3,k,1);
    x_r_1 = [x_r_1 x1];
    y_r_1 = [y_r_1 y1];
    x1_tri = [ x1+h_t*cos(th1), x1+(w_t/2)*cos((pi/2)-th1), x1-(w_t/2)*cos((pi/2)-th1)];%,x1+(h_t/3)*cos(th1)];
    y1_tri = [ y1+h_t*sin(th1), y1-(w_t/2)*sin((pi/2)-th1), y1+(w_t/2)*sin((pi/2)-th1)];%,y1+(h_t/3)*sin(th1)];

    plot(x_r_1,y_r_1,'-r','linewidth',line_width);hold on % plot exhibited trajectory
    a=fill(x1_tri, y1_tri, color); % plot robot position
    a.EdgeColor = color;
    c = fill(x1+.05*xp,y1+.05*yp,color,'FaceAlpha',0.7);
    c.EdgeColor = color;
%     b = fill(x1+sr*xp,y1+sr*yp,color,'FaceAlpha',0.03);
%     b.EdgeColor = "none";
    agent_plot = plot(x1+xp,y1+yp,color); % plot robot circle 
    hold on
    plot(A1_xx(1,1:k),A1_xx(2,1:k),color,'LineWidth',1.2)
    plot(agent_xx(1,:),agent_xx(2,:),line_color,'LineWidth',1.2)
end