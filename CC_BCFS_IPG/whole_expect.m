function [x_1,x_2] = whole_expect(st)
    [agent1_x1,agent1_x2] = high_expect(st(1:5));
    agent2_x1 = high_expect0(st(6:10));
    x_1 = [agent1_x1;agent2_x1];
    x_2 = agent1_x2;
end