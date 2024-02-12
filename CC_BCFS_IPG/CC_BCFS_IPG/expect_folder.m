classdef expect_folder
    methods
        function out = uniform_char_func(obj,t,l,u)
            if t == 0
                out = 1;
            else 
                out = (exp(i*t*u)-exp(i*t*l)) / (i*t*(u - l));
            end
        end

        function out = m_c_uniform_a(obj,l,u,a)
            if l==u
                out = cos(u)^a;
            else
                out = 0;
                for k = 0 : a 
                    out = out + nchoosek(a,k)*obj.uniform_char_func(2*k-a,l,u);
                end
                out = out/(2^a);
            end
            out = real(out);
        end

       function out = m_s_uniform_a(obj,l,u,a)
           if l ==u
               out = sin(u)^a;
           else
            out = 0;
            for k = 0 : a 
                out = out + (-1)^(a-k)*nchoosek(a,k)*obj.uniform_char_func(2*k-a,l,u);
            end
            out = out*(-i/2)^a;
           end
           out = real(out);
       end

       function out = m_cs_u(obj,l, u, a1, a2) %a1 cos, a2 sin
           if l==u
               out = cos(u)^a1*sin(u)^a2;
           else
                out = 0;
                for k1 = 0 : a1
                    for k2 = 0 : a2
                        out = out + nchoosek(a1,k1)*nchoosek(a2,k2)*(-1)^(a2-k2)*obj.uniform_char_func(2*(k1 + k2)-a1-a2,l,u);
                    end
                end
                out = out*((-1i)^a2)/(2^(a1+a2));
           end
           out = real(out);
        end

%         function out = m_xs_u(obj,l, u , a1, a2)
%             out = 0;
%             for k = 0 : a2
%                 out = out + nchoosek(a2,k)*(-1)^(a2-k)*obj.de_char_uniform(l, u, a1, 2*k-a2);
%             end
%             out = out/((i^(a1+a2))*(2^a2));
%         end
%         
%         function out = m_xc_u(obj,l, u , a1, a2)
%             out = 0;
%             for k = 0 : a2
%                 out = out + nchoosek(a2,k)*obj.de_char_uniform(l, u, a1, 2*k-a2);
%             end
%             out = out/((i^a1)*(2^a2));
%         end

        function out = uniform(obj,l,u,i)
            if l == u
                out = u^i;
            else
                out = (1/(u-l))*((u^(i+1) - l^(i+1))/(i+1));
            end
        end

        function out = de_char_uniform(obj,l, u, a1, val)
            syms t
            f = (exp(i*t*u)-exp(i*t*l)) / (i*t*(u - l));
            df = diff(f,t,a1);
            out = round(subs(df,t,val),4);
        end

    end
end