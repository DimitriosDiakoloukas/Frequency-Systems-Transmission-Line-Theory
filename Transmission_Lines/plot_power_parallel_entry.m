clearvars;
f0 = 1e9; % Συχνότητα λειτουργίας (1 GHz)
N = 201; % Αριθμός σημείων στο φάσμα συχνότητας
frequencies = linspace(0, 2e9, N); % Φάσμα συχνοτήτων
Vgrms = 1; % Τάση rms μικροκυματικής γεννήτριας
C = 2.99e-12; % Χωρητικότητα πυκνωτή (2.99 pF)
Z0 = 50; % Χαρακτηριστική αντίσταση γραμμής μετάδοσης (50 Ω)
ZL = 10 + 1i * 15; % Αντίσταση φορτίου
Zg = 50 - 1i * 40; % Εσωτερική σύνθετη αντίσταση
l = 0.04;  % Μήκος γραμμών σε μονάδες μήκους κύματος
multbl = 2 * pi * l * (frequencies / f0); % Ηλεκτρικά μήκη

% Υπολογισμός της πυκνωτικής αντίστασης και νέας αντίστασης φορτίου
XC = -1 ./ (2 * pi .* frequencies * C);
ZL = real(ZL) + 1i .* (frequencies / f0) * imag(ZL);

% Υπολογισμοί αντιστάσεων στα τμήματα
ZA = Z0 .* (ZL + 1i * Z0 .* tan(multbl)) ./ (Z0 + 1i * ZL .* tan(multbl));
Zin = (ZA .* (1i * XC)) ./ (ZA + 1i * XC);

% Υπολογισμός της ισχύος
power_parallel_entry = power_of_load(Vgrms, Zin, Zg);

plot(frequencies / 1e9, power_parallel_entry * 1e3);
hold on;
plot(frequencies  / 1e9, ones(size(frequencies / 1e9)) * 2.5, '--r'); 
hold off;
title('Ισχύς σε mW συναρτήσει της συχνότητας πυκνωτής παράλληλος σε είσοδο');
xlabel('Συχνότητα (GHz)');
ylabel('Ισχύς (mW)');