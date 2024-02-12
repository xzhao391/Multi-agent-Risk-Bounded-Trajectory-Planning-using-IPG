function [x_1out, x_2out] = high_order(x_1,x_2,con,T)
    import casadi.*
    mv = 0;
    expect_func = expect_folder;
    v=con(1);
    omega=con(2);

    l = -.01;
    u = .01;
    
    a = T*(v+mv);
    c = cos(T*omega)*expect_func.m_c_uniform_a(l*T,u*T,1)...
        -sin(T*omega)*expect_func.m_s_uniform_a(l*T,u*T,1); %m_c
    s = cos(T*omega)*expect_func.m_s_uniform_a(l*T,u*T,1)...
        +sin(T*omega)*expect_func.m_c_uniform_a(l*T,u*T,1); %m_s
    
    x_1out = SX.sym('x_1out',5);
    x_1out(1) = x_1(1)+a*x_1(4);
    x_1out(2) = x_1(2)+a*x_1(5);
    x_1out(3) = x_1(3)+T*omega;
    x_1out(4) = c*x_1(4)-s*x_1(5);
    x_1out(5) = s*x_1(4)+c*x_1(5);

    c0 = cos(T*omega); s0 = sin(T*omega); 
    mc = expect_func.m_c_uniform_a(l*T,u*T,1);
    mc2 = expect_func.m_c_uniform_a(l*T,u*T,2);
    ms = expect_func.m_s_uniform_a(l*T,u*T,1);
    ms2 = expect_func.m_s_uniform_a(l*T,u*T,2);
    mcs = expect_func.m_cs_u(l*T,u*T, 1, 1);
    mv2 = expect_func.uniform(l*T,u*T,2);
    ac=a*c; 
    as=a*s; 
    cs=c0^2*mcs - mcs*s0^2 + c0*mc2*s0 - c0*ms2*s0;
    c2=mc2*c0^2 - 2*mcs*c0*s0 + ms2*s0^2;
    s2=ms2*c0^2 + 2*mcs*c0*s0 + mc2*s0^2; 
    a2=T^2*v^2 + 2*mv*T^2*v + mv2*T^2;
    x_2out = SX.sym('x_2out',10);
    %     1    2     3   4   5     6    7      8      9    10
    % x_2(x^2,xcos,xsin,y^2,ycos,ysin,cos^2,cos*sin,sin^2, xy)
    x_2out(1) = x_2(1) + 2*a*x_2(2) + (a2)*x_2(7);
    x_2out(2) = c*x_2(2) - s*x_2(3) + ac*x_2(7) - as*x_2(8);
    x_2out(3) = s*x_2(2) + c*x_2(3) + as*x_2(7) + ac*x_2(8);

    x_2out(4) = x_2(4) + 2*a*x_2(6) + (a2)*x_2(9);
    x_2out(5) = c*x_2(5) - s*x_2(6) + ac*x_2(8) - as*x_2(9);
    x_2out(6) = s*x_2(5) + c*x_2(6) + as*x_2(8) + ac*x_2(9);
    
    x_2out(7) = c2*x_2(7) - 2*cs*x_2(8) + s2*x_2(9);
    x_2out(8) = cs*x_2(7) + (c2-s2)*x_2(8) - cs*x_2(9);
    x_2out(9) = s2*x_2(7) + 2*cs*x_2(8) + c2*x_2(9);
    x_2out(10) = x_2(10)+a*x_2(3)+a*x_2(5)+a2*x_2(8);
end