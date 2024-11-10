clearvars;

% Παράμετροι κυκλώματος
Z0 = 50;       % Αντίσταση κύριας γραμμής
Z1 = 101.6;    % Αντίσταση τμήματος 1
Z2 = 101.6;    % Αντίσταση τμήματος 2
Zstub1 = 98.45;% Αντίσταση κλαδιού 1
Zstub2 = 43.6; % Αντίσταση κλαδιού 2
Zstub3 = 98.45;% Αντίσταση κλαδιού 3
f0 = 1e9;      % Συχνότητα λειτουργίας (1 GHz)
N = 201;      % Αριθμός σημείων στο φάσμα συχνότητας
frequencies = linspace(0, 3e9, N); % Φάσμα συχνοτήτων
l = 1/8;       % Μήκος γραμμών σε μονάδες μήκους κύματος
multbl = 2 * pi * l * (frequencies / f0); % Ηλεκτρικά μήκη

% Υπολογισμοί αντιστάσεων στους κλάδους και στα τμήματα
Zin_stub3 = -1i * Zstub3 ./ tan(multbl);
ZL2 = (Zin_stub3 .* Z0) ./ (Zin_stub3 + Z0);
Zin2 = Z2 * (ZL2 + 1i * Z2 * tan(multbl)) ./ (Z2 + 1i * ZL2 .* tan(multbl));

Zin_stub2 = -1i * Zstub2 ./ tan(multbl);
ZL1 = (Zin_stub2 .* Zin2) ./ (Zin_stub2 + Zin2);
Zin1 = Z1 * (ZL1 + 1i * Z1 * tan(multbl)) ./ (Z1 + 1i * ZL1 .* tan(multbl));

Zin_stub1 = -1i * Zstub1 ./ tan(multbl);
Zin_total = (Zin_stub1 .* Zin1) ./ (Zin_stub1 + Zin1);

% Υπολογισμός συντελεστή αντανάκλασης και SWR
Gamma = (Zin_total - Z0) ./ (Zin_total + Z0);
Gamma_dB = 20 * log10(abs(Gamma));
Gamma_dB(Gamma_dB < -60) = -60; % Όριο για το |Γ| σε dB
SWR = (1 + abs(Gamma)) ./ (1 - abs(Gamma));
SWR(SWR > 10) = 10; % Όριο για το SWR

% Διαγράμματα
figure;
subplot(2,1,1);
plot(frequencies / 1e9, Gamma_dB);
title('Μέτρο συντελεστή αντανάκλασης (dB) συναρτήσει της συχνότητας');
xlabel('Συχνότητα (GHz)');
ylabel('Μέτρο συντελεστή αντανάκλασης (dB)');

subplot(2,1,2);
plot(frequencies / 1e9, SWR);
title('SWR σε συνάρτηση της συχνότητας');
xlabel('Συχνότητα (GHz)');
ylabel('SWR');
ylim([1 inf]);

