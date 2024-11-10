clc;
clear;

% Αρχικές παράμετροι
f0 = 5e9;                                 % Κεντρική συχνότητα (Hz)
C = physconst('LightSpeed');              % Ταχύτητα του φωτός (m/s)
lambda = C / f0;                          % Μήκος κύματος στην κεντρική συχνότητα (m)
d = lambda / 8;                           % Απόσταση μεταξύ κλαδωτών (m)

% Συχνότητες για την ανάλυση
N = 1000;
frequencies = linspace(0, 10e9, N);
lambda_freq = C ./ frequencies;
beta = 2 * pi ./ lambda_freq;

% Χαρακτηριστικές αντιστάσεις
Z0 = 50;                     % Χαρακτηριστική αντίσταση γραμμής (Ω)
ZL = 20 - 1i * 30;           % Φορτίο (Ω)

% Μήκη κλαδωτών
l11 = 0.116 * lambda;
l21 = 0.183 * lambda;
l12 = 0.365 * lambda;
l22 = 0.461 * lambda;

% Υπολογισμός αντιστάσεων των κλαδωτών
Zstub1 = -1i * Z0 * cot(beta * l11);
Zstub2 = -1i * Z0 * cot(beta * l21);

Zstub12 = -1i * Z0 * cot(beta * l12);
Zstub22 = -1i * Z0 * cot(beta * l22);

% Υπολογισμός των μεταβαλλόμενων αντιστάσεων Ζ1 και Ζ2
Z1 = Zstub1 .* ZL ./ (Zstub1 + ZL);
Z2 = Z0 .* (Z1 + 1i * Z0 * tan(beta * d)) ./ (Z0 + 1i * Z1 .* tan(beta * d));

Z12 = Zstub12 .* ZL ./ (Zstub12 + ZL);
Z22 = Z0 .* (Z12 + 1i * Z0 * tan(beta * d)) ./ (Z0 + 1i * Z12 .* tan(beta * d));

% Υπολογισμός αντίστασης εισόδου και συντελεστή ανάκλασης
Zin = Z2 .* Zstub2 ./ (Z2 + Zstub2);
reflection_coefficient = abs((Zin - Z0) ./ (Zin + Z0));

Zin2 = Z22 .* Zstub22 ./ (Z22 + Zstub22);
reflection_coefficient2 = abs((Zin2 - Z0) ./ (Zin2 + Z0));

% Σχεδίαση αποτελεσμάτων
figure;
plot(frequencies / 1e9, reflection_coefficient, 'magenta', 'LineWidth', 1); hold on;
plot(frequencies / 1e9, reflection_coefficient2, 'red', 'LineWidth', 1);
xlabel('Συχνότητα (GHz)');
ylabel('Μέτρο συντελεστή ανάκλασης');
title({'Μέτρο συντελεστή ανάκλασης συναρτήσει της συχνότητας'});
legend('reflection coefficient', 'reflection coefficient 2');
grid on;
hold off;
