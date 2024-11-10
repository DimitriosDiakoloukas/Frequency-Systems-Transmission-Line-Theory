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
    
    % Σχεδίαση διαγραμμάτων σε υποδιαγράμματα
    figure;
    
    % Οριζόντιο διάγραμμα ακτινοβολίας
    subplot(1, 2, 1);
    polarplot(phi_horizontal, abs(E_total_horizontal), "LineWidth", 1);
    [numerator, denominator] = rat(d / lambda);
    arithmitis = num2str(numerator);
    title(['Οριζόντιο διάγραμμα ακτινοβολίας, d = ', arithmitis, 'λ', '/', num2str(denominator)]);
    
    % Κατακόρυφο διάγραμμα ακτινοβολίας
    subplot(1, 2, 2);
    polarplot(theta_vertical, abs(E_total_vertical), "LineWidth", 1);
    title(['Κατακόρυφο διάγραμμα ακτινοβολίας, d = ', arithmitis, 'λ', '/', num2str(denominator)]);
end