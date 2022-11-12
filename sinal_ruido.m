sem12_sinal_fid = fopen('sat_data/sem12_sinal.txt');
sem12_ruido_fid = fopen('sat_data/sem12_ruido.txt');
forecast = readtable('forecast_new2.csv');
forecast.Var1 = forecast.Var1 + forecast.Var2;
forecast_all = readtable('Forecast.csv');
forecast_rain = readtable('rain_data.csv');
forecast_rain = table2array(forecast_rain);

t1 = datetime(2022,9,30,1,0,0);
%t1 = t1 + hours(0:23);
t2 = datetime(2022,10,31,21,0,0);
datas_forecast = t1:hours(1):t2;
%datas_forecast = datetime(forecast{:,1}, 'Format', 'dd-MMM-yyyy');
%datas_forecast = datas_forecast + hours(0:23);
datas_forecast.Format = 'dd-MMM-yyyy HH';
datas_forecast = transpose(datas_forecast);
%datas_forecast(:,2) = [];
%datas_forecast = reshape(datas_forecast, [], 1);

sem12_datas = textscan(sem12_sinal_fid, '%s', 'delimiter', '\n');
sem12_datas = sem12_datas{1};

sem12_ruido = textscan(sem12_ruido_fid, '%s', 'delimiter', '\n');
sem12_ruido = sem12_ruido{1};

extract_vec = sem12_datas;
sem12_datas = extractBefore(sem12_datas, 20);
sem12_sinal = extractAfter(extract_vec, 20);
sem12_ruido = extractAfter(sem12_ruido, 20);
sem12_datas = datetime(sem12_datas, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
sem12_datas_short = datetime(sem12_datas, 'Format', 'dd-MMM-yyyy HH');
sem12_sinal = str2double(sem12_sinal);
sem12_ruido = str2double(sem12_ruido);
% 
% figure('NumberTitle', 'off', 'Name', 'Sinal e Ruído - Semana 12')
% hold on
% plot(sem12_datas, sem12_sinal)
% plot(sem12_datas, sem12_ruido)
% legend('Sinal', 'Ruído')
% 

sem23_sinal_fid = fopen('sat_data/sem23_sinal.txt');
sem23_ruido_fid = fopen('sat_data/sem23_ruido.txt');

sem23_datas = textscan(sem23_sinal_fid, '%s', 'delimiter', '\n');
sem23_datas = sem23_datas{1};

sem23_ruido = textscan(sem23_ruido_fid, '%s', 'delimiter', '\n');
sem23_ruido = sem23_ruido{1};

extract_vec = sem23_datas;
sem23_datas = extractBefore(sem23_datas, 20);
sem23_sinal = extractAfter(extract_vec, 20);
sem23_ruido = extractAfter(sem23_ruido, 20);
sem23_datas = datetime(sem23_datas, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
sem23_datas_short = datetime(sem23_datas, 'Format', 'dd-MMM-yyyy HH');
sem23_sinal = str2double(sem23_sinal);
sem23_ruido = str2double(sem23_ruido);
% 
% figure('NumberTitle', 'off', 'Name', 'Sinal e Ruído - Semana 23')
% hold on
% plot(sem23_datas, sem23_sinal)
% plot(sem23_datas, sem23_ruido)
% legend('Sinal', 'Ruído')
% 
% 
% 
sem29_sinal_fid = fopen('sat_data/sem29_sinal.txt');
sem29_ruido_fid = fopen('sat_data/sem29_ruido.txt');

sem29_datas = textscan(sem29_sinal_fid, '%s', 'delimiter', '\n');
sem29_datas = sem29_datas{1};

sem29_ruido = textscan(sem29_ruido_fid, '%s', 'delimiter', '\n');
sem29_ruido = sem29_ruido{1};

extract_vec = sem29_datas;
sem29_datas = extractBefore(sem29_datas, 20);
sem29_sinal = extractAfter(extract_vec, 20);
sem29_ruido = extractAfter(sem29_ruido, 20);
sem29_datas = datetime(sem29_datas, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
sem29_datas_short = datetime(sem29_datas, 'Format', 'dd-MMM-yyyy HH');
sem29_sinal = str2double(sem29_sinal);
sem29_ruido = str2double(sem29_ruido);
% 
% figure('NumberTitle', 'off', 'Name', 'Sinal e Ruído - Semana 29')
% hold on
% plot(sem29_datas, sem29_sinal)
% plot(sem29_datas, sem29_ruido)
% legend('Sinal', 'Ruído')
% 
% 
figure(2)
title('Forecast - Rain')
hold on
plot(datas_forecast, forecast_rain)
plot(sem12_datas_short, sem12_sinal)
plot(sem23_datas_short, sem23_sinal)
plot(sem29_datas_short, sem29_sinal)
