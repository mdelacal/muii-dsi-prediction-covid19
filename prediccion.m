%% BORRAR GRÁFICAS MEMORIA Y CONSOLA %%
close all, clear, clc   % cerrar ventanas graficas, borrar memoria y consola

%% CARGAR DATOS ACTUALIZADOS DESDE URL %%
url = ['https://covid19.isciii.es/resources/serie_historica_acumulados.csv'];
filename = 'datos.csv';
urlwrite(url,filename);
X = readtable('datos.csv'); % cargar datos

%% QUITAR NAN DEL CSV %%
for i = 1:height(X)
    for j = 1:width(X)
        if(j >= 3)
            t2 = X{i,j};
            if(isnan(t2))
                X{i,j}=0;         
            end
        end   
    end
end

%% EXTRAER DATOS CLM %%
X_cell=table2cell(X); % convertimos de table a cell, para tratar las variables de fechas y CCAA
X_CCAA = {};          % datos de la comunidad autónoma
X_CCAA_new = {};      % fila que se añade a los datos de la comunidad autónoma en cada iteración
CCAA = 'CM';          % comunidad autónoma elegida; CM=Castilla-La Mancha

% Extraemos los datos de la comunidad autónoma del dataset
for i = 1:height(X)
    if(strcmp(X_cell{i,1},CCAA))
        X_CCAA_new = X_cell(i,:);
        X_CCAA = [X_CCAA; X_CCAA_new];
    end
end

%% MOSTRAR DATOS %%
figure();
subplot(2,3,1)
plot([X_CCAA{:,2}],[X_CCAA{:,3}]);
str=sprintf('Casos totales %s', CCAA);
title(str);
hold on;

subplot(2,3,2)
plot([X_CCAA{:,2}],[X_CCAA{:,4}]);
str=sprintf('Hospitalizados %s', CCAA);
title(str);
hold on;

subplot(2,3,3)
plot([X_CCAA{:,2}],[X_CCAA{:,5}]);
str=sprintf('UCI %s', CCAA);
title(str);
hold on;

subplot(2,3,4)
plot([X_CCAA{:,2}],[X_CCAA{:,6}]);
str=sprintf('Fallecidos %s', CCAA);
title(str);
hold on;

subplot(2,3,5)
plot([X_CCAA{:,2}],[X_CCAA{:,7}]);
str=sprintf('Recuperados %s', CCAA);
title(str);
hold on;

figure();
plot([X_CCAA{:,2}],[X_CCAA{:,3}]);
hold on;
plot([X_CCAA{:,2}],[X_CCAA{:,7}]);
str=sprintf('Casos y recuperados %s', CCAA);
title(str);
hold on;

%% Casos nuevos diarios/semanales
[day, col] = size(X_CCAA); % obtener número de filas y columnas de los datos de la CCAA
% Diarios
new_cases_day = X_CCAA{day, 3} - X_CCAA{day-1, 3}; % nuevos casos en el último día
sprintf('Nuevos casos diarios en %s: %d', CCAA, new_cases_day) 
% Semanales
new_cases_week = X_CCAA{day, 3} - X_CCAA{day-6, 3}; % nuevos casos en la última semana
sprintf('Nuevos casos última semana en %s: %d', CCAA, new_cases_week)

% Agrupamos los nuevos casos y recuperados diarios en variables
X_CCAA_newcasesdaily = {};
X_CCAA_newrecoversdaily = {};
for i = 1:day
    if(i == 1)
        X_CCAA_newcasesdaily = [X_CCAA_newcasesdaily;X_CCAA{i,3}];
        X_CCAA_newrecoversdaily = [X_CCAA_newrecoversdaily;X_CCAA{i,7}];
    else
        X_CCAA_newcasesdaily = [X_CCAA_newcasesdaily;X_CCAA{i,3}-X_CCAA{i-1,3}];
        X_CCAA_newrecoversdaily = [X_CCAA_newrecoversdaily;X_CCAA{i,7}-X_CCAA{i-1,7}];
    end
end

%% MOSTRAR GRÁFICAS NUEVOS CASOS Y ALTAS DIARIAS
figure();
subplot(1,2,1)
plot([X_CCAA{:,2}],[X_CCAA_newcasesdaily{:,1}]);
str=sprintf('Nuevos casos diarios %s', CCAA);
title(str);
hold on;

subplot(1,2,2)
plot([X_CCAA{:,2}],[X_CCAA_newrecoversdaily{:,1}]);
str=sprintf('Nuevas altas diarias %s', CCAA);
title(str);
hold on;