function [coefficients,rmse,train_x,train_y, predicted_fitness, sigma] = Auto_Model(time_series , order)
% latest data in the time_series stored in the end of the array
% coefficients: x_t = sum (b_i * x_{t-i})
% legnth_ts should : length_ts >= 2*order
    length_ts = length(time_series);
    %time_series=log(time_series); %将时间序列平滑化

%     if(length_ts < 2 * order)   
%         disp('not enough time_series data for auto_model');
%         return    
%     end

    num_of_td = length_ts - order;  % 计算可以用于训练的数据点数目，即时间序列长度减去自回归模型的阶数。

    % form the train_x
    %     train_x = zeros(num_of_td+1 , order);
    %     for index_i = 0:num_of_td               
    %         train_x(index_i+1,:) = fliplr( time_series(length_ts - index_i-order + 1 : length_ts - index_i)' );         
    %     end
    
    for index_i = 1:num_of_td
        for index_j = 1:order        
        train_x(index_i,index_j) = time_series(length_ts - index_i - index_j + 1);         
        end
    end    
    
    % form the train_y
    train_y = zeros(num_of_td , 1);    
    for index = 1:num_of_td       
        train_y(index,1) = time_series(length_ts - index + 1);        
    end
    
    % form the interpolation matrix from training data（由训练数据集形成嵌套式矩阵）

    % X*B = Y  the least square result of B is (X'*X)^-1 * X' * y    
    % det(train_x' * train_x )
    % pinv(train_x' * train_x)   
    coefficients = pinv(train_x' * train_x) * train_x' * train_y;
    
    % error = 0;
    % for index = 1:num_of_td;    
    %     error = error + ( time_series( length_ts-index-order+1  : length_ts - index ) ...
    %         * flipud(coefficients) -  time_series(length_ts - index + 1) )^2 ;     
    % end
    
    %error = sqrt( sum((train_y - train_x * coefficients).^2) / num_of_td);

    err = sum((train_y - train_x * coefficients).^2);
    tot = sum((train_y - mean(train_y)).^2);
    r_square = 1- ( err/tot );
    
    sigma = sqrt( mean( (train_y - train_x * coefficients).^2 ) / num_of_td);
    rmse = sqrt( mean( (train_y - train_x * coefficients).^2 ) );

    predicted_fitness = 0; 
    for index = 1:order    
        predicted_fitness = predicted_fitness + coefficients(index) * time_series(length_ts - index + 1);     
    end

end



