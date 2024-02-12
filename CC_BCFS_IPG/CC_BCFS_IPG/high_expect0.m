function x_1 = high_expect0(st)
%     l=-.01;u=.01;
    l=0;u=0;
    expect_func = expect_folder;

    x_1 = [st(1);st(2);st(3); ...
        expect_func.m_c_uniform_a(st(3)+l,st(3)+u,1); ...
        expect_func.m_s_uniform_a(st(3)+l,st(3)+u,1)];
end