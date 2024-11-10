clc;
clear;

% Αρχικές παράμετροι
f = 1e9; % Συχνότητα σε Hz
I = 1; % Ρεύμα 1Α
C = physconst('LightSpeed'); % Ταχύτητα φωτός σε m/s
lambda = C / f; % Μήκος κύματος σε μέτρα
N = 8; % Αριθμός διπόλων
k = 2 * pi / lambda; % Κυματικός αριθμός
r0 = 1; % Απόσταση αναφοράς

% Αποστάσεις μεταξύ των διπόλων σε μήκη κύματος
distances = [lambda / 4, lambda / 2, 3 * lambda / 4];

% Γωνιακά βήματα για τον υπολογισμό
dtheta = pi / 180;
dphi = pi / 180;
[theta, phi] = meshgrid(0:dtheta:pi, 0:dphi:2*pi);

% Βρόχος για κάθε απόσταση
for d = distances
    % Υπολογισμός αποστάσεων για κάθε δίπολο
    r = zeros(size(theta, 1), size(theta, 2), N);
    for n = 1:N
        r(:, :, n) = r0 + (N - 2 * n + 1) * d / 2 * cos(phi) .* sin(theta);
    end
    
    % Υπολογισμός συνολικού πεδίου
    E = zeros(size(theta));
    for n = 1:N
        E = E + (60 * I / r0) * exp(-1i * k * r(:, :, n)) .* (cos((pi / 2) * cos(theta)) ./ (sin(theta) + 1e-10));
    end
    
    % Υπολογισμός πυκνότητας ισχύος
    U = abs(E).^2;

    % Ολοκλήρωμα της πυκνότητας ισχύος για όλη την επιφάνεια
    Prad = sum(sum(U .* sin(theta))) * dtheta * dphi;
    
    % Υπολογισμός της κατευθυντικότητας
    Umax = max(max(U));
    D = (4 * pi * Umax) / Prad;
    
    % Θεωρητική κατευθυντικότητα
    D_theoretical = 2 * N * d / lambda;
    
    % Εμφάνιση αποτελεσμάτων
    fprintf('Για d = %.2fλ:\n', d / lambda);
    fprintf('  Υπολογισμένη κατευθυντικότητα: D = %.2f\n', D);
    fprintf('  Θεωρητική κατευθυντικότητα: D = %.2f\n\n', D_theoretical);
end
