clc;
clear;

% Αρχικές παράμετροι
f = 10e9; % Συχνότητα σε Hz
C = physconst('LightSpeed'); % Ταχύτητα φωτός σε m/s
a = 2.286e-2; % Πλάτος κυματοδηγού σε μέτρα
b = 1.016e-2; % Ύψος κυματοδηγού σε μέτρα
h0 = 120 * pi; % Χαρακτηριστική αντίσταση του κενού
d1 = 1.5e-3; % Πάχος του δείγματος διηλεκτρικού σε μέτρα
d2 = 3e-3; % Πάχος του δεύτερου δείγματος διηλεκτρικού (2*d1) σε μέτρα
L = 6e-2; % Μήκος του κυματοδηγού σε μέτρα
mu0 = 4 * pi * 1e-7; % Μαγνητική διαπερατότητα του κενού
epsilon0 = 8.854e-12; % Διηλεκτρική σταθερά του κενού
Zin1 = 4.9678 + 1i * 43.9439; % Σύνθετη αντίσταση για πάχος d1
Zin2 = 108.5347 + 1i * 202.0158; % Σύνθετη αντίσταση για πάχος d2

% Υπολογισμός της συχνότητας αποκοπής του κυματοδηγού
fc = C / (2 * a);

% Αρχική εκτίμηση για τις άγνωστες παραμέτρους
initial_guess = 0.1; % Αρχική εκτίμηση για το γ*d

% Επίλυση του συστήματος εξισώσεων χρησιμοποιώντας fsolve
gamma_solution = fsolve(@(val) waveguide_equations(val, h0, f, fc, C, d1, d2, L, Zin1, Zin2), initial_guess);

% Εξαγωγή των alpha και beta από τη λύση
alpha_d = abs(real(gamma_solution)) / d1; % Υπολογισμός της σταθεράς απόσβεσης (alpha_d) από το πραγματικό μέρος του gamma (σταθεράς διάδοσης)
beta1 = abs(imag(gamma_solution)) / d1; % Υπολογισμός της σταθεράς διάδοσης (beta1) από το φανταστικό μέρος του gamma (σταθεράς διάδοσης)

% Υπολογισμός της σχετικής διηλεκτρικής σταθεράς και της εφαπτομένης των απωλειών
kc = pi / a; % Κυματικός αριθμός αποκοπής
omega = 2 * pi * f; % Κυκλική συχνότητα

% Η σχετική διηλεκτρική σταθερά (epsilon_r) υπολογίζεται από τη σταθερά διάδοσης (beta1) και τον κυματικό αριθμό αποκοπής (kc)
epsilon_r = (beta1^2 + kc^2) / (omega^2 * mu0 * epsilon0); 

% Ο κυματικός αριθμός στο υλικό
k = sqrt(omega^2 * mu0 * epsilon0 * epsilon_r); 

% Η εφαπτομένη των απωλειών (tan_d) υπολογίζεται από τη σταθερά απόσβεσης (alpha_d) και τη σταθερά διάδοσης (beta1)
tan_d = (2 * alpha_d * beta1) / k^2;

% Εμφάνιση αποτελεσμάτων
fprintf('Σχετική διηλεκτρική σταθερά (ϵr): %.4f\n', epsilon_r);
fprintf('Γωνία απωλειών (tan(δ)): %.4f\n', tan_d);


% Συνάρτηση που ορίζει το σύστημα εξισώσεων για το fsolve
function F = waveguide_equations(g_d, h0, f, fc, C, d1, d2, L, Zin1, Zin2)
    % Υπολογισμός της χαρακτηριστικής αντίστασης του κυματοδηγού
    Z0 = h0 / sqrt(1 - (fc / f)^2);
    
    % Υπολογισμός της σταθεράς φάσης στο κενό
    beta0 = 2 * pi * f / C * sqrt(1 - (fc / f)^2);

    % Εξισώσεις για τις σύνθετες κυματικές αντιστάσεις 
    ZA1 = Z0 * (Zin1 - 1i * Z0 * tan(beta0 * (L - d1))) / (Z0 - 1i * Zin1 * tan(beta0 * (L - d1)));
    ZA2 = Z0 * (Zin2 - 1i * Z0 * tan(beta0 * (L - d2))) / (Z0 - 1i * Zin2 * tan(beta0 * (L - d2)));

    % Ορισμός της εξίσωσης για επίλυση
    F = tanh(g_d)^2 - (2 * (ZA1 / ZA2) - 1);
end