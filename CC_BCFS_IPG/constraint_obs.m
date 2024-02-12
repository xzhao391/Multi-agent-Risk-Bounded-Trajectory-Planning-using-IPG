function [con1,con2,con3] =constraint_obs(agent1_x1,agent1_x2,p_agent)
    delta = .2;
    actual = sqrt(1-delta);
    x=agent1_x1(1); y=agent1_x1(2);
    x2 = agent1_x2(1); y2 = agent1_x2(4); xy = agent1_x2(10); 
    r=p_agent(1); r2=p_agent(2);l=p_agent(3); l2=p_agent(4);
    l3=p_agent(5); l4=p_agent(6); c=p_agent(7); c2=p_agent(8);
    c3=p_agent(9); c4=p_agent(10); s=p_agent(11); s2=p_agent(12);
    s3=p_agent(13); s4=p_agent(14); c2s2=p_agent(15); c2s=p_agent(16);
    s2c=p_agent(17); cs=p_agent(18); x_pos=p_agent(19) ;y_pos=p_agent(20);
    g1 = (c2*l)/5 - c2*l2 + (l*s2)/5 - l2*s2 + c2*l*r + c*l*x - c*l*x_pos + l*r*s2 + l*s*y - l*s*y_pos;
    g2 = (c4*l2)/25 - (2*c4*l3)/5 + c4*l4 + (2*c2s2*l2)/25 - (4*c2s2*l3)/5 + 2*c2s2*l4 + (l2*s4)/25 - (2*l3*s4)/5 + l4*s4 + c2*l2*x_pos^2 + l2*s2*y_pos^2 + (2*c4*l2*r)/5 - 2*c4*l3*r + c4*l2*r2 + (4*c2s2*l2*r)/5 - 4*c2s2*l3*r + 2*c2s2*l2*r2 + (2*c3*l2*x)/5 + c2*l2*x2 - 2*c3*l3*x - (2*c3*l2*x_pos)/5 + 2*c3*l3*x_pos + 2*cs*l2*xy + (2*c2s*l2*y)/5 - 2*c2s*l3*y - (2*c2s*l2*y_pos)/5 + 2*c2s*l3*y_pos + (2*l2*r*s4)/5 - 2*l3*r*s4 + l2*r2*s4 + (2*l2*s2c*x)/5 - 2*l3*s2c*x - (2*l2*s2c*x_pos)/5 + 2*l3*s2c*x_pos + (2*l2*s3*y)/5 + l2*s2*y2 - 2*l3*s3*y - (2*l2*s3*y_pos)/5 + 2*l3*s3*y_pos + 2*c3*l2*r*x - 2*c3*l2*r*x_pos + 2*c2s*l2*r*y - 2*c2s*l2*r*y_pos - 2*c2*l2*x*x_pos - 2*cs*l2*x*y_pos - 2*cs*l2*x_pos*y + 2*cs*l2*x_pos*y_pos + 2*l2*r*s2c*x - 2*l2*r*s2c*x_pos + 2*l2*r*s3*y - 2*l2*r*s3*y_pos - 2*l2*s2*y*y_pos;
    con1 = 4/9*(g2-g1^2)-(1-actual)*g2;
    con2 = g1;
    con3 = 5/8*g2-g1^2;
end