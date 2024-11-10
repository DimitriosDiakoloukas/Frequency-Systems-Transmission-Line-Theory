clearvars;

% Παράμετροι κυκλώματος
Z0 = 50; % Αντίσταση κύριας γραμμής
ZH = 150; % Αντίσταση υψηλής
ZL = 20; % Αντίσταση χαμηλής
f0 = 1e9; % Συχνότητα λειτουργίας (1 GHz)
N = 201; % Αριθμός σημείων στο φάσμα συχνοτήτας
frequencies = linspace(0, 2e9, N); % Φάσμα συχνοτήτων

% Ηλεκτρικά μήκη σε μοίρες
bl1 = 21.903;
bl2 = 31.426;
bl3 = 37.720;
bl4 = 31.426;
bl5 = 21.903;

% Μετατροπή ηλεκτρικών μηκών σε φάσεις σε ραδιανούς
bl_rad = 2 * pi * (frequencies / f0) / 360;
tan_bl1 = tan(bl_rad * bl1);
tan_bl2 = tan(bl_rad * bl2);
tan_bl3 = tan(bl_rad * bl3);
tan_bl4 = tan(bl_rad * bl4);
tan_bl5 = tan(bl_rad * bl5);

% Υπολογισμοί εισερχόμενων αντιστάσεων στα τμήματα
Zin_l5 = ZH .* (Z0 + 1i * ZH .* tan_bl5) ./ (ZH + 1i * Z0 .* tan_bl5);
Zin_l4 = ZL .* (Zin_l5 + 1i * ZL .* tan_bl4) ./ (ZL + 1i * Zin_l5 .* tan_bl4);
Zin_l3 = ZH .* (Zin_l4 + 1i * ZH .* tan_bl3) ./ (ZH + 1i * Zin_l4 .* tan_bl3);
Zin_l2 = ZL .* (Zin_l3 + 1i * ZL .* tan_bl2) ./ (ZL + 1i * Zin_l3 .* tan_bl2);
Zin_l1 = ZH .* (Zin_l2 + 1i * ZH .* tan_bl1) ./ (ZH + 1i * Zin_l2 .* tan_bl1);

% Υπολογισμός του συντελεστή αντανάκλασης και SWR
Gamma = (Zin_l1 - Z0) ./ (Zin_l1 + Z0);
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
