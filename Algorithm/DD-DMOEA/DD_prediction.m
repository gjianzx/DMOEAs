function new_POS = DD_prediction(Problem,partNum,kneeS,POSArr)
% ����Ĳ�����
% partNum���յ���ӿռ������
% kneeS��Ԥ���ƵĹյ�
% POSArr����һʱ��ÿ���յ��Ӧ�ӿռ�ĸ���

% �Զ���diffusion model�ĳ���
Time_Step = 100;
beta = 0.0001;
sigema_m = 1;
% alpha = linspace(1-beta,beta^2,Time_Step); 
alpha = ((cos(linspace(0,pi,Time_Step))+1)/2 + 1e-3) * (1 - 1e-3) / (1 + 1e-3); % cos����
subpace_X = cell(1,partNum);
noise = 0.1;

    % �����һʱ�̵Ľ�
    for partNo = 1 : partNum
        
        X = POSArr{partNo};
        density_type = "KDE";
        
        for t = Time_Step : -10 : 2        
            alpha_t = alpha(t);     % ��ǰʱ�䲽��alphaֵ
            alpha_tp = alpha(t-1);  % ��һʱ�䲽��alphaֵ

            sigema = sigema_m * sqrt((1 - alpha_tp) / (1 - alpha_t) * (1 - alpha_t / alpha_tp)) * noise;

            Fit = fit_mapping(X*1.25,kneeS(:,partNo));        % ���ú���ӳ�亯������Ҫ�Ը�����ܶȹ���

            % ���ݵ�ǰ�յ��Ӧ�ӿռ�ĸ������x0,����Ԥ���ƹյ�ΪĿ���
            x0 = estimate(X, alpha_t, Fit,density_type);          % ��õĽ����䷶ΧΪ[0,1]    
            
            eps = (X-sqrt(alpha_t) .* x0) / sqrt(1-alpha_t);      
            x_next = sqrt(alpha_tp)*x0 + sqrt(1-alpha_tp-sigema^2)*eps + sigema*rand(size(X,1),1);  % ��ȡ��ǰ�ӿռ�����һʱ�̵ĸ���λ��
            
            X = x_next;
        end
        X = repair(x_next,Problem); % Ԥ��ĳ�ʼ��Ⱥ����ı߽紦��
        subpace_X{1,partNo} = X; 
    end
    % ���ɵ����йյ㸽�����½�
     All_x = cat(2,subpace_X{1,1:partNum});        
     new_POS = All_x;
     
end
%% �����������ĸ����ܶ�
function Fit = fit_mapping(pos,knee)
  %% ��˹�ֲ�
   std = 0.5;  % �յ��׼��
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
   %% ƽ����������ֹ�쳣ֵ
   Fit = max(min(Fit,1),1e-5);  % ��Fit������ָ����Χ�ڣ������1*a�ľ���
   l2_factor = 0.1; % ����L2��������
   l2_norm_squared = sum(Fit.^2, 2);
   Fit = Fit .* exp(-1 * l2_norm_squared * l2_factor);
   
%    temperature=1.0;
%    power = -Fit / temperature;   % �¶ȿ���ӳ��ƽ���ԣ��¶�Խ�ߣ�ӳ��Խƽ��
%    power = power - max(power) + 5; % ������ֵ�������ֵ�ȶ��Լ��ɣ�
%    Fit = exp(power);
end

%% ͨ��������(�ӿռ������и���)����x0   ��֤x0�����䷶Χ��[0,1]
function x0 = estimate(pos, alpha, Fit, density_type)
    mu = sqrt(alpha) * pos;       % ���㵱ǰ�ӿռ��и���ľ�ֵ�ͷ���
    sigma = sqrt(1 - alpha);
    
     % ����posÿ����muÿ��֮��ľ���
    distance = zeros(size(pos,2),size(mu,2));
    for i = 1:size(pos,2)
        for j = 1:size(mu,2)
            distance(i, j) = norm(pos(:, i) - mu(:, j), 2);
        end
    end
%     1/sqrt(2*pi*sigma^2) *
    gaussion_prob =   exp(- (distance.^2) ./ (2 * sigma^2));    % �����˹�ֲ������ܶȺ��� 
    
    if density_type == "uniform"
        prob_xt = ones(1, size(pos,2)) / size(pos,2);            % ���㵱ǰʱ�䲽ÿ������ĸ��ʣ������Ǿ��ȷֲ���     
    elseif density_type == "KDE"
        [d,n] = size(pos);
        bandwidth = 1.06 * std(pos(:)) * n^(-1/5); 
        distances = pdist2(pos', pos').^2; % ʹ�� pdist2 ����������
        % �����˹�˾���
        kernel_matrix = exp(-distances / (2 * bandwidth^2));
        % ����ÿ�����ݵ�ĸ����ܶ�
        pdf_values = sum(kernel_matrix, 2) / (n * (2 * pi)^(d/2) * bandwidth^d);
        prob_xt = pdf_values;
    end
    
    prob = (Fit + 1e-9) .* (gaussion_prob+ 1e-9) ./ (prob_xt + 1e-9);   % �������в�����ĸ���
    z = sum(prob,2);                                            % �����������ͣ����ں����һ��
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