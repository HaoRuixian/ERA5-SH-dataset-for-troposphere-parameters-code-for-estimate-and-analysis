function [pressure,temK,rh,ellipsoid] = inter_to_ground(ellipsoid,temK,rh,sh,pre,geoid_ground,time)
pressure = nan(360,181,37,24);
for i = 1:181*360       %point
    lat = ceil(i/360);
    lon = mod(i,360);
    if lon == 0
        lon = 360;
    end

    for j = 1:time      %time
        %判断地面位置与气压层的位置关系，后据此确定内插还是外推
        for k = 1:37
            if geoid_ground(lon,lat,j) < ellipsoid(lon,lat,k,j)
                break;
            end
        end

        level_num = numel(unique(squeeze(ellipsoid(lon,lat,:,j))));
        di = squeeze(diff(ellipsoid(lon,lat,:,j)));
        wrong = length( find(di==0) );
        diz = di(1:36);
        wrong2 = length(find(diz<0));
        if level_num < 37 || wrong > 1 || wrong2 ~= 0 % find wrong data
            pressure(lon,lat,:,j) = nan;
            temK(lon,lat,:,j) = nan;
            rh(lon,lat,:,j) = nan;
            continue
        end
        % 外推
        if k == 1
            % hum和tem都是直接线性外推
            ellipsoid_linear = squeeze(ellipsoid(lon,lat,:,j));
            temk_linear = squeeze(temK(lon,lat,:,j));
            rh_linear = squeeze(rh(lon,lat,:,j));

            temK_ls = interp1(ellipsoid_linear, temk_linear, geoid_ground(lon,lat,j), 'linear','extrap');
            rh_ls = interp1(ellipsoid_linear, rh_linear, geoid_ground(lon,lat,j), 'linear','extrap');
            % 只取37层
            temk_temp = [temK_ls; temk_linear];
            temk_temp = temk_temp(1:37);
            temK(lon,lat,:,j) = reshape( temk_temp, [1,1,37,1]);

            rh_temp = [rh_ls;rh_linear];
            rh_temp = rh_temp(1:37);
            rh(lon,lat,:,j) = reshape( rh_temp, [1,1,37,1]);

            ellipsoid_temp = [geoid_ground(lon,lat,j);ellipsoid_linear];
            ellipsoid_temp = ellipsoid_temp(1:37);
            ellipsoid(lon,lat,:,j) = reshape( ellipsoid_temp, [1,1,37,1]);

            %pre特殊，需要指数外推。指数的系数是根据virtual temperature。
            %根据gpt2w代码中的公式求取。其实后续也不会用到pre
            vt = temK(lon,lat,2,j)*(1+0.6077*sh(lon,lat,1,j));%virtual temperature, 需要比湿
            ec1 = 9.80665*0.028965/(8.3143*vt);
            dif_height_ls = geoid_ground(lon,lat,j) - ellipsoid(lon,lat,2,j);%值为负
            pre_ls = pre(k,1)*exp(-ec1*dif_height_ls);
            preassure_temp = [pre_ls; pre];
            preassure_temp = preassure_temp(1:37);
            pressure(lon,lat,:,j) = reshape( preassure_temp, [1,1,37,1]);

            %内插
        else
            %pre的内插，ec直接用相邻俩个气压层的比值
            dif_height = ellipsoid(lon,lat,k,j) - ellipsoid(lon,lat,k-1,j); %两个气压层之间的高度差
            dif_pre = pre(k,1)/pre(k-1,1);                                  %两层气压之间的比值
            ec2 = log(dif_pre)/dif_height;                                  %结果已经是负值，后续不用加负号
            dif_height_ls = geoid_ground(lon,lat,j) - ellipsoid(lon,lat,k-1,j);
            pre_ls = pre(k-1,1) * exp(ec2 * dif_height_ls);

            pre_temp = [pre_ls.'; pre(k:end,1)];
            num = numel(pre_temp);
            pressure(lon,lat,1:num,j)= pre_temp;

            % hum和tem都是直接线性内插
            ellipsoid_linear = squeeze(ellipsoid(lon,lat,:,j));
            temk_linear = squeeze(temK(lon,lat,:,j));
            rh_linear = squeeze(rh(lon,lat,:,j));

            temK_ls = interp1(ellipsoid_linear , temk_linear,geoid_ground(lon,lat,j), 'linear','extrap');
            rh_ls = interp1(ellipsoid_linear , rh_linear,geoid_ground(lon,lat,j), 'linear','extrap');

            temk_temp = [temK_ls; squeeze(temK(lon,lat,k:end,j))];
            num = numel(temk_temp);
            temK(lon,lat,1:num,j) = temk_temp;

            rh_temp = [rh_ls;  squeeze(rh(lon,lat,k:end,j))];
            num = numel(rh_temp);
            rh(lon,lat,1:num,j) = rh_temp;

            ellipsoid_temp = [geoid_ground(lon,lat,j); squeeze(ellipsoid(lon,lat,k:end,j))];
            num = numel(ellipsoid_temp);
            ellipsoid(lon,lat,1:num,j) = ellipsoid_temp;

        end
    end
end
end