clc;
clear;

% Αρχικές παράμετροι
f = 1e9; % Συχνότητα σε Hz
I = 1; % Ρεύμα 1Α
r0 = 1; % Απόσταση αναφοράς
C = physconst('LightSpeed');  % Ταχύτητα φωτός σε m/s
lambda = C / f; % Μήκος κύματος σε μέτρα
N = 8; % Αριθμός διπόλων
k = 2 * pi / lambda; % Κυματικός αριθμός

% Αποστάσεις μεταξύ των διπόλων σε μήκη κύματος
distances = [lambda / 4, lambda / 2, 3 * lambda / 4];

% Τιμές γωνιών για το οριζόντιο διάγραμμα ακτινοβολίας
theta_horizontal = pi / 2; % Γωνία θ για το οριζόντιο επίπεδο (σταθερή)
phi_horizontal = linspace(0, 2 * pi - 0.0001, 1000); % Γωνία φ για το οριζόντιο επίπεδο (μεταβαλλόμενη)

% Τιμές γωνιών για το κατακόρυφο διάγραμμα ακτινοβολίας
theta_vertical = linspace(0, 2 * pi - 0.0001, 1000); % Γωνία θ για το κατακόρυφο επίπεδο (μεταβαλλόμενη)
phi_vertical = 0; % Γωνία φ για το κατακόρυφο επίπεδο (σταθερή)

% Αριθμητικοί δείκτες των διπόλων
n = 1:N;

% Βρόχος για κάθε απόσταση
for d = distances
    
    % Υπολογισμός αποστάσεων για το οριζόντιο διάγραμμα
    r_horizontal = r0 - (N - 2 * n' + 1) * d / 2 * cos(phi_horizontal) * sin(theta_horizontal);
    % Υπολογισμός αποστάσεων για το κατακόρυφο διάγραμμα
    r_vertical = r0 - (N - 2 * n' + 1) * d / 2 * cos(phi_vertical) * sin(theta_vertical);
    
    % Υπολογισμός συνολικού πεδίου με άθροιση κατά μήκος της διάστασης των διπόλων
    E_total_horizontal = sum((60 * I / r0) * exp(-1i * k * r_horizontal) .* (cos((pi / 2) * cos(theta_horizontal)) ./ sin(theta_horizontal)), 1);
    E_total_vertical = sum((60 * I / r0) * exp(-1i * k * r_vertical) .* (cos((pi / 2)*cos(theta_vertical)) ./ sin(theta_vertical)), 1);
    
    [numerator, denominator] = rat(d / lambda);
    arithmitis = num2str(numerator);

    % 3D Στερεό διάγραμμα ακτινοβολίας
    [theta, phi] = meshgrid(linspace(0, pi, 180), linspace(0, 2*pi, 360));
    r = zeros(size(theta));
    
    for n = 1:N
        r = r + (60 * I / r0) * exp(-1i * k * (r0 - (N - 2 * n + 1) * d / 2 * cos(phi) .* sin(theta))) .* (cos((pi / 2) * cos(theta)) ./ sin(theta));
    end

    figure;
    r_abs = abs(r);
    x = r_abs .* sin(theta) .* cos(phi);
    y = r_abs .* sin(theta) .* sin(phi);
    z = r_abs .* cos(theta);
    
    surf(x, y, z, r_abs, 'EdgeColor', 'none');
    colorbar;
    title(['Στερεό διάγραμμα ακτινοβολίας, d = ', arithmitis, '\lambda', '/', num2str(denominator)]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal;
    view(3);
end
