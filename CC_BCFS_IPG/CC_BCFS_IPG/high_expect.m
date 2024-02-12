function [x_1,x_2] = high_expect(st)
    l=0;u=0;
    expect_func = expect_folder;
    x_1 = [st(1);st(2);st(3); ...
        expect_func.m_c_uniform_a(st(3)+l,st(3)+u,1); ...
        expect_func.m_s_uniform_a(st(3)+l,st(3)+u,1)];
    %      1    2   3    4    5   6     7       8     9   10
    %x_2 (x^2,xcos,xsin,y^2,ycos,ysin,cos^2,cos*sin,sin^2,xy)
    x2 = expect_func.uniform(st(1)+l,st(1)+u,2);
    xcos = st(1)*expect_func.m_c_uniform_a(st(3)+l,st(3)+u,1); %E[x]*E[cos]
    xsin = st(1)*expect_func.m_s_uniform_a(st(3)+l,st(3)+u,1); %E[x]*E[sin]
    y2 = expect_func.uniform(st(2)+l,st(2)+u,2);
    ycos = st(2)*expect_func.m_c_uniform_a(st(3)+l,st(3)+u,1);
    ysin = st(2)*expect_func.m_s_uniform_a(st(3)+l,st(3)+u,1); 
    cos2 = expect_func.m_c_uniform_a(st(3)+l,st(3)+u,2);
    cossin = expect_func.m_cs_u(st(3)+l,st(3)+u, 1, 1);
    sin2 = expect_func.m_s_uniform_a(st(3)+l,st(3)+u,2);
    xy = st(1)*st(2);
    x_2= [x2;xcos;xsin;y2;ycos;ysin;cos2;cossin;sin2;xy];

    x_2 = real(x_2);
end