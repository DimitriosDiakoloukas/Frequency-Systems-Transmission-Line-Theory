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
l1 = 0.116 * lambda;
l2 = 0.183 * lambda;

% Υπολογισμός αντιστάσεων των κλαδωτών
Zstub1 = -1i * Z0 * cot(beta * l1);
Zstub2 = -1i * Z0 * cot(beta * l2);

% Υπολογισμός των μεταβαλλόμενων αντιστάσεων Ζ1 και Ζ2
Z1 = Zstub1 .* ZL ./ (Zstub1 + ZL);
Z2 = Z0 .* (Z1 + 1i * Z0 * tan(beta * d)) ./ (Z0 + 1i * Z1 .* tan(beta * d));

% Υπολογισμός αντίστασης εισόδου και συντελεστή ανάκλασης
Zin = Z2 .* Zstub2 ./ (Z2 + Zstub2);
reflection_coefficient = abs((Zin - Z0) ./ (Zin + Z0));

% Σχεδίαση αποτελεσμάτων
figure;
plot(frequencies / 10^9, reflection_coefficient, "magenta", "LineWidth", 1);
xlabel('Συχνότητα (GHz)');
ylabel('Μέτρο συντελεστή ανάκλασης');
title({'Μέτρο συντελεστή ανάκλασης συναρτήσει της συχνότητας'});
