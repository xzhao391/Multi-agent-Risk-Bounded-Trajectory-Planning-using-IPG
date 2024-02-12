classdef agent_up
    properties
      args
      solver
      x1
      N
      T
      xx
      U
      g
      X
      obj_func
      P
      mpciter
      radius
    end
    methods
        function obj = agent_up(radius,N,T,x1)
            import casadi.*
            obj.radius = radius;
            obj.xx(:,1) = x1; % xx contains the history of states
            obj.N=N;
            obj.T = T;
            obj.x1 = x1;
            obj.mpciter = 0;
            
            v_max = 0.6; v_min = -v_max;
            omega_max = pi/2; omega_min = -omega_max;
            
            n_states = 10;
            n_controls = 4;

            obj.X = SX.sym('X',n_states,(N+1));
            obj.U = SX.sym('U',n_controls,N); % Decision variables (controls)

            obj.P = SX.sym('P',166);
            target = obj.P(11:20);
            agent1_x1 = obj.P(1:5);
            agent2_x1 = obj.P(6:10);
            agent1_x2 = obj.P(21:30);
            agent2_x2 = obj.P(31:40);
            agent1_x3 = obj.P(41:60);
            agent2_x3 = obj.P(61:80);
            agent1_x4 = obj.P(81:113);
            agent2_x4 = obj.P(114:146);
            dir_agent12 = obj.P(147:148); mid_agent12 = obj.P(149:150);
            dir_obs1_agent1 = obj.P(151:152); mid_obs1_agent1 = obj.P(153:154);
            dir_obs2_agent1 = obj.P(155:156); mid_obs2_agent1 = obj.P(157:158);
            dir_obs1_agent2 = obj.P(159:160); mid_obs1_agent2 = obj.P(161:162);
            dir_obs2_agent2 = obj.P(163:164); mid_obs2_agent2 = obj.P(165:166);

            agent_size = 2;
            obj.obj_func = 0; % Objective function
            
            Q = diag([2 1.5 .05 0 0 2 1.5 .05 0 0]);
            R = diag([0 0 0 0]); % weighing matrices (controls)   

            obj.g = [obj.X(:,1)-obj.P(1:10)]; % initial condition constraints        
            
            for k = 1:N %cost & D
                pos = obj.X(:,k);  con = obj.U(:,k);
                obj.obj_func = obj.obj_func+(pos-target)'*Q*(pos-target) + con'*R*con; % calculate obj
                next_pos = whole_first(pos,con,obj.T);
                obj.g = [obj.g; obj.X(:,k+1)-next_pos]; % compute constraints
                obj.obj_func = obj.obj_func + 1*exp(-.2*con(1));
                d_ij = (obj.X(1,k)-obj.X(6,k))^2 + (obj.X(2,k)-obj.X(7,k))^2;
                obj.obj_func = obj.obj_func + .1*exp(.1*(5*radius^2-d_ij));
            end

            for k = 1:N+1 %collision avoidance constraint
                [con1,con2,con3] = agent_constraint(agent1_x1,agent1_x2,dir_agent12,mid_agent12);
                obj.g = [obj.g; con1;con2;con3];
                [con4,con5,con6] = obs_constraint(agent1_x1,agent1_x2,dir_obs1_agent1,mid_obs1_agent1);
                obj.g = [obj.g; con4;con5;con6];
                [con7,con8,con9] = obs_constraint(agent1_x1,agent1_x2,dir_obs2_agent1,mid_obs2_agent1);
                obj.g = [obj.g; con7;con8;con9];
                [con10,con11,con12] = obs_constraint(agent2_x1,agent2_x2,dir_obs1_agent2,mid_obs1_agent2);
                obj.g = [obj.g; con10;con11;con12];
                [con13,con14,con15] = obs_constraint(agent2_x1,agent2_x2,dir_obs2_agent2,mid_obs2_agent2);
                obj.g = [obj.g; con13;con14;con15];

                if k < N+1
                    con = obj.U(:,k);
                    [agent1_x1,agent1_x2,agent1_x3,agent1_x4] = high_order(agent1_x1,agent1_x2,agent1_x3,agent1_x4,con(1:2),T);
                    [agent2_x1,agent2_x2,agent2_x3,agent2_x4] = high_order0(agent2_x1,agent2_x2,agent2_x3,agent2_x4,con(3:4),T);
                end
            end

            %make the decision variable one column  vector
            OPT_variables = [reshape(obj.X,10*(obj.N+1),1);reshape(obj.U,4*obj.N,1)];
            
            nlp_prob = struct('f', obj.obj_func, 'x', OPT_variables, 'g', obj.g, 'p', obj.P);
            opts = struct;
            opts.ipopt.max_iter = 2000;
            opts.ipopt.print_level =0;
            opts.print_time = 0;
            opts.ipopt.acceptable_tol =1e-8;
            opts.ipopt.acceptable_obj_change_tol = 1e-6;
            
            obj.solver = nlpsol('solver', 'ipopt', nlp_prob,opts);

            args = struct;
            args.lbg(1:5*agent_size*(N+1)) = 0;  % -1e-20  % Equality constraints
            args.ubg(1:5*agent_size*(N+1)) = 0;  % 1e-20   % Equality constraints
            
            args.lbg(5*agent_size*(N+1)+1 : 5*agent_size*(N+1)+ 3*5*(N+1)) = -inf; % inequality constraints
            args.ubg(5*agent_size*(N+1)+1 : 5*agent_size*(N+1)+ 3*5*(N+1)) = 0; % inequality constraints

            args.lbx(1:5:5*agent_size*(N+1),1) = -inf; %state x lower bound
            args.ubx(1:5:5*agent_size*(N+1),1) = inf; %state x upper bound
            args.lbx(2:5:5*agent_size*(N+1),1) = -inf; %state y lower bound
            args.ubx(2:5:5*agent_size*(N+1),1) = inf; %state y upper bound
            args.lbx(3:5:5*agent_size*(N+1),1) = -inf; %state theta lower bound
            args.ubx(3:5:5*agent_size*(N+1),1) = inf; %state theta upper bound
            args.lbx(4:5:5*agent_size*(N+1),1) = -inf;
            args.ubx(4:5:5*agent_size*(N+1),1) = inf;
            args.lbx(5:5:5*agent_size*(N+1),1) = -inf;
            args.ubx(5:5:5*agent_size*(N+1),1) = inf;
            % 
            args.lbx(5*agent_size*(N+1)+1:2:5*agent_size*(N+1)+2*agent_size*N,1) = v_min; %v lower bound
            args.ubx(5*agent_size*(N+1)+1:2:5*agent_size*(N+1)+2*agent_size*N,1) = v_max; %v upper bound
            args.lbx(5*agent_size*(N+1)+2:2:5*agent_size*(N+1)+2*agent_size*N,1) = omega_min; %omega lower bound
            args.ubx(5*agent_size*(N+1)+2:2:5*agent_size*(N+1)+2*agent_size*N,1) = omega_max; %omega upper bound
            obj.args = args;
        end

        function obj = search(obj, other, target)
            [dir_agent12, mid_agent12] = dir_mid(obj,other,obj.x1,1);
            [dir_obs1_agent1, mid__obs1_agent1] = dir_mid(obj,[0;1.5],obj.x1,0);
            [dir_obs2_agent1, mid_obs2_agent1] = dir_mid(obj,[0;-1.5],obj.x1,0);
            [dir_obs1_agent2, mid_obs1_agent2] = dir_mid(obj,[0;1.5],other,0);
            [dir_obs2_agent2, mid_obs2_agent2] = dir_mid(obj,[0;-1.5],other,0);
            obj.x1(6:10) = other;
            [x_1_exp,x_2_exp,x_3_exp,x_4_exp] = whole_expect(obj.x1);
            obj.args.p =[x_1_exp; target; x_2_exp; x_3_exp; x_4_exp; dir_agent12; mid_agent12;
                dir_obs1_agent1; mid__obs1_agent1; dir_obs2_agent1; mid_obs2_agent1;
                dir_obs1_agent2; mid_obs1_agent2; dir_obs2_agent2; mid_obs2_agent2];
            sol = obj.solver('lbx', obj.args.lbx, 'ubx', obj.args.ubx,...
                'lbg', obj.args.lbg, 'ubg', obj.args.ubg,'p',obj.args.p);
            u = reshape(full(sol.x(10*(obj.N+1)+1:end))',4,obj.N); % get controls only from the solution
            obj.x1 = whole_shift(obj.x1, u, obj.T);
            obj.mpciter = obj.mpciter+1;
            obj.xx(:,obj.mpciter+1) = obj.x1;
        end

        function [dir,mid_point] = dir_mid(obj,other,own,is_agent)
            relative_position = other(1:2) - own(1:2);
            l = norm(relative_position);
            cos_t = relative_position(1)/l; sin_t = relative_position(2)/l; 
            dir = [cos_t; sin_t];
            if is_agent
                mid_point = (l/2-obj.radius)*dir+own(1:2);
            else
                mid_point = (l-obj.radius-1.2)*dir+own(1:2);
            end
        end
    end
end 