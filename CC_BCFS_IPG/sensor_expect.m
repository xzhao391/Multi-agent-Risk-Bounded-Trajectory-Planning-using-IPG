function [r,r2,l,l2,l3,l4,c,c2,c3,c4,s,s2,s3,s4,c2s2,c2s,s2c,cs] = sensor_expect(theta,l,r)
    expect_func = expect_folder;
    upper=r+.02; lower=r-.02;
    r = expect_func.uniform(lower,upper,1);
    r2 = expect_func.uniform(lower,upper,2);

    upper=l+.02;lower=l-.02;
    l = expect_func.uniform(lower,upper,1);
    l2 = expect_func.uniform(lower,upper,2);
    l3 = expect_func.uniform(lower,upper,3);
    l4 = expect_func.uniform(lower,upper,4);
    
    upper=theta+.02;lower=theta-.02;
    c=expect_func.m_c_uniform_a(lower,upper,1);
    c2=expect_func.m_c_uniform_a(lower,upper,2);
    c3=expect_func.m_c_uniform_a(lower,upper,3);
    c4=expect_func.m_c_uniform_a(lower,upper,4);
    
    s=expect_func.m_s_uniform_a(lower,upper,1);
    s2=expect_func.m_s_uniform_a(lower,upper,2);
    s3=expect_func.m_s_uniform_a(lower,upper,3);
    s4=expect_func.m_s_uniform_a(lower,upper,4);
    
    c2s2 = expect_func.m_cs_u(lower, upper, 2, 2);
    c2s = expect_func.m_cs_u(lower, upper, 2, 1);
    s2c = expect_func.m_cs_u(lower, upper, 1, 2);
    cs = expect_func.m_cs_u(lower, upper, 1, 1);
end