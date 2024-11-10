clearvars;

% Παράμετροι κυκλώματος
f0 = 1e9; % Συχνότητα λειτουργίας (1 GHz)
Z0 = 50; % Χαρακτηριστική αντίσταση γραμμής μετάδοσης (50 Ω)
ZL = 100; % Αντίσταση φορτίου (100 Ω)
C = 2e-12; % Χωρητικότητα πυκνωτή (2 pF)
N = 201; % Πλήθος σημείων στο φάσμα συχνοτήτων
frequencies = linspace(0, 4*f0, N); % Φάσμα συχνοτήτων
dB_threshold = -40; % Κατώφλι σε dB

% Μήκη γραμμών μεταφοράς προς μήκος κύματος
l1 = 0.32; 
l2 = 0.24;
l3 = 0.1;

% Προετοιμασία πινάκων για τις τιμές των |Γ|
Gamma_magnitude_in = zeros(1, N);

for i = 1:N
    f = frequencies(i);
    
    % Υπολογισμός της πυκνωτικής αντίστασης
    XC = -1 / (2*pi*f*C);
    
    % Ηλεκτρικά μήκη
    multbl1 = l1 * 2 * pi * (f / f0);
    multbl2 = l2 * 2 * pi * (f / f0);
    multbl3 = l3 * 2 * pi * (f / f0);
    
    % Υπολογισμός της εισερχόμενης αντίστασης Zin
    Zin1 = Z0 * (ZL + 1i*Z0*tan(multbl1)) / (Z0 + 1i*ZL*tan(multbl1));
    Zin1 = Zin1 + 1i*XC;
    Zin2 = Z0 * (Zin1 + 1i*Z0*tan(multbl2)) / (Z0 + 1i*Zin1*tan(multbl2));
    Zin3 = -1i * Z0 * cot(multbl3);
    Zin = 1 / (1/Zin2 + 1/Zin3);
    
    % Υπολογισμός του Γ στην είσοδο
    Gamma_in = (Zin - Z0) / (Zin + Z0);
    Gamma_dB = 20 * log10(abs(Gamma_in));
    
    if Gamma_dB < dB_threshold
        Gamma_dB = dB_threshold;
    end
    
    Gamma_magnitude_in(i) = abs(Gamma_in);
end

% Σχεδιασμός των αποτελεσμάτων (dB και Nominal) σε μία εικόνα με δύο subplots
figure;

% Πρώτο subplot για το μέτρο συντελεστή αντανάκλασης σε dB
subplot(2,1,1); 
plot(frequencies / 1e9, 20*log10(Gamma_magnitude_in)); % Μετατροπή σε dB
title('Μέτρο συντελεστή αντανάκλασης (dB) συναρτήσει της συχνότητας');
xlabel('Συχνότητα (GHz)');
ylabel('Μέτρο συντελεστή αντανάκλασης (dB)');

% Δεύτερο subplot για το μέτρο συντελεστή αντανάκλασης Nominal
subplot(2,1,2);
plot(frequencies / 1e9, Gamma_magnitude_in); 
title('Μέτρο συντελεστή αντανάκλασης Nominal συναρτήσει της συχνότητας');
xlabel('Συχνότητα (GHz)');
ylabel('Μέτρο συντελεστή αντανάκλασης Nominal');
