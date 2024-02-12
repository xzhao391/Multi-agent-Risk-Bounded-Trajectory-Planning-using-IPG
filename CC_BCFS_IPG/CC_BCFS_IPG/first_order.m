function out = first_order(st,con,T)
    import casadi.*
    m_wv = 0;
    expect_func = expect_folder;
    v=con(1);
    omega=con(2);
    l = 0;
    u = 0;
%     l = 0;
%     u = 0;
    a = T*(v+m_wv);
    c = cos(T*omega)*expect_func.m_c_uniform_a(l*T,u*T,1)...
        -sin(T*omega)*expect_func.m_s_uniform_a(l*T,u*T,1); %m_c
    s = cos(T*omega)*expect_func.m_s_uniform_a(l*T,u*T,1)...
        +sin(T*omega)*expect_func.m_c_uniform_a(l*T,u*T,1); %m_s
    out = SX.sym('X',5);
    out(1) = st(1)+a*st(4);
    out(2) = st(2)+a*st(5);
    out(3) = st(3)+T*omega;
    out(4) = c*st(4)-s*st(5);
    out(5) = s*st(4)+c*st(5);
end