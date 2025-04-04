function new_POS = DD_prediction(Problem,partNum,kneeS,POSArr)
% 输入的参数：
% partNum：拐点和子空间的总数
% kneeS：预估计的拐点
% POSArr：上一时刻每个拐点对应子空间的个体

% 自定义diffusion model的超参
Time_Step = 100;
beta = 0.0001;
sigema_m = 1;
% alpha = linspace(1-beta,beta^2,Time_Step); 
alpha = ((cos(linspace(0,pi,Time_Step))+1)/2 + 1e-3) * (1 - 1e-3) / (1 + 1e-3); % cos调度
subpace_X = cell(1,partNum);
noise = 0.1;

    % 获得下一时刻的解
    for partNo = 1 : partNum
        
        X = POSArr{partNo};
        density_type = "KDE";
        
        for t = Time_Step : -10 : 2        
            alpha_t = alpha(t);     % 当前时间步的alpha值
            alpha_tp = alpha(t-1);  % 上一时间步的alpha值

            sigema = sigema_m * sqrt((1 - alpha_tp) / (1 - alpha_t) * (1 - alpha_t / alpha_tp)) * noise;

            Fit = fit_mapping(X*1.25,kneeS(:,partNo));        % 调用函数映射函数，主要对个体的密度估计

            % 根据当前拐点对应子空间的个体估计x0,并以预估计拐点为目标点
            x0 = estimate(X, alpha_t, Fit,density_type);          % 获得的解区间范围为[0,1]    
            
            eps = (X-sqrt(alpha_t) .* x0) / sqrt(1-alpha_t);      
            x_next = sqrt(alpha_tp)*x0 + sqrt(1-alpha_tp-sigema^2)*eps + sigema*rand(size(X,1),1);  % 获取当前子空间中下一时刻的个体位置
            
            X = x_next;
        end
        X = repair(x_next,Problem); % 预测的初始种群个体的边界处理
        subpace_X{1,partNo} = X; 
    end
    % 生成的所有拐点附近的新解
     All_x = cat(2,subpace_X{1,1:partNum});        
     new_POS = All_x;
     
end
%% 计算采样个体的概率密度
function Fit = fit_mapping(pos,knee)
  %% 高斯分布
   std = 0.5;  % 拐点标准差
   mu = knee;
%    std = diag(cov(pos));

   for i = 1 : size(pos,2)
        distance(1,i) = norm(pos(:,i)-mu,2);
   end 
   Fit = exp(-distance ./ (2*std^2));   %  1/sqrt(2*pi*std^2) * 

%    Fit = (distance < std); 
%    covariance_matrix = eye(size(knee,1)) * (std ^ 2);
% %    max_prob = mvnpdf(mu, mu, covariance_matrix);
%    density = mvnpdf(pos', mu', covariance_matrix);
%    Fit = density';
   %% 平滑方法，防止异常值
   Fit = max(min(Fit,1),1e-5);  % 将Fit限制在指定范围内，获得是1*a的矩阵。
   l2_factor = 0.1; % 设置L2正则化因子
   l2_norm_squared = sum(Fit.^2, 2);
   Fit = Fit .* exp(-1 * l2_norm_squared * l2_factor);
   
%    temperature=1.0;
%    power = -Fit / temperature;   % 温度控制映射平滑性，温度越高，映射越平缓
%    power = power - max(power) + 5; % 避免数值溢出（数值稳定性技巧）
%    Fit = exp(power);
end

%% 通过采样点(子空间中所有个体)估计x0   保证x0的区间范围在[0,1]
function x0 = estimate(pos, alpha, Fit, density_type)
    mu = sqrt(alpha) * pos;       % 计算当前子空间中个体的均值和方差
    sigma = sqrt(1 - alpha);
    
     % 计算pos每列与mu每列之间的距离
    distance = zeros(size(pos,2),size(mu,2));
    for i = 1:size(pos,2)
        for j = 1:size(mu,2)
            distance(i, j) = norm(pos(:, i) - mu(:, j), 2);
        end
    end
%     1/sqrt(2*pi*sigma^2) *
    gaussion_prob =   exp(- (distance.^2) ./ (2 * sigma^2));    % 计算高斯分布概率密度函数 
    
    if density_type == "uniform"
        prob_xt = ones(1, size(pos,2)) / size(pos,2);            % 计算当前时间步每个个体的概率，假设是均匀分布。     
    elseif density_type == "KDE"
        [d,n] = size(pos);
        bandwidth = 1.06 * std(pos(:)) * n^(-1/5); 
        distances = pdist2(pos', pos').^2; % 使用 pdist2 计算距离矩阵
        % 计算高斯核矩阵
        kernel_matrix = exp(-distances / (2 * bandwidth^2));
        % 计算每个数据点的概率密度
        pdf_values = sum(kernel_matrix, 2) / (n * (2 * pi)^(d/2) * bandwidth^d);
        prob_xt = pdf_values;
    end
    
    prob = (Fit + 1e-9) .* (gaussion_prob+ 1e-9) ./ (prob_xt + 1e-9);   % 计算所有采样点的概率
    z = sum(prob,2);                                            % 采样点概率求和，便于后面归一化
    for q = 1 : size(prob,1)
        for k = 1 : size(pos,1)
          weighte(k,q) = prob(q,:) * pos(k,:)';
        end
    end
%     weighted_sum = prob .* pos; 
    x0 = weighte ./(z' + 1e-9);
end

function init_solution = repair(init_solution,Problem)
        VarMin=Problem.XLow;
        VarMax=Problem.XUpp;
        for j=1:size(init_solution,2)
            for i=1:size(init_solution,1)
                init_solution(i,j) = min(max(init_solution(i,j),VarMin(i)), VarMax(i));
%                 init_solution(i,j) = init_solution(i,j)*(VarMax(i)-VarMin(i))+VarMin(i);
            end
        end
end