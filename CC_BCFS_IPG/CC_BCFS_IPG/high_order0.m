function x_1out = high_order0(x_1,con,T)
    import casadi.*
    mv = 0;
    expect_func = expect_folder;
    v=con(1);
    omega=con(2);

    l = 0;
    u = 0;
    
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
end