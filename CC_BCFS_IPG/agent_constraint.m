function con1 = agent_constraint(agent1_x1,dir,mid_point)
    x=agent1_x1(1); y=agent1_x1(2);
    mid_x = mid_point(1); mid_y = mid_point(2); 
    dir_x = dir(1); dir_y = dir(2);
    g1 = (x-mid_x)*dir_x+(y-mid_y)*dir_y;
    con1 = g1;
end