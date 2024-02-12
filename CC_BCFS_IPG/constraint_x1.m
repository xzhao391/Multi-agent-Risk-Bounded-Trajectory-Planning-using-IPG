function [con1,con2] = constraint_x1(agent1_x1,agent1_x2,g)
    delta = .9;
    actual = sqrt(1-delta);    
    x=agent1_x1(1); y=agent1_x1(2);
    x2 = agent1_x2(1); y2 = agent1_x2(4); xy = agent1_x2(10); 
    g1_constant = g(1); g1_x = g(2); g1_y = g(3);
    g2_constant = g(4); g2_x = g(5); g2_y = g(6);
    g2_xy = g(7); g2_x2 = g(8); g2_y2 = g(9);
    g1 = g1_constant + g1_x*x + g1_y*y;
    g2 = g2_constant + g2_x*x + g2_y*y + g2_xy*xy + g2_x2*x2 + g2_y2*y2;
    con1 = 4/9*(g2-g1^2)-(1-actual)*g2;
    con2 = g1;
end