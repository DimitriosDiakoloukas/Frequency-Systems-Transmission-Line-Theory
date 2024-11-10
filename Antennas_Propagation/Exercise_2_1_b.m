clc;
clear;

% Δεδομένα
f = 10e9; % Συχνότητα σε Hz
C = physconst('LightSpeed'); % Ταχύτητα του φωτός σε m/s
a = 2.286e-2; % Πλάτος κυματοδηγού σε m
b = 1.016e-2; % Ύψος κυματοδηγού σε m
d = 1.5e-3; % Πάχος δείγματος σε m
L = 6e-2; % Μήκος κυματοδηγού σε m
Zin = 4.9678 + 1i*43.9439; % Μέτρηση κυματικής αντίστασης
h0 = 120*pi; % Κυματική αντίσταση του μέσου

% Αρχικές εκτιμήσεις
initial_guess = [4.5, 0.02];

% Ορισμός της επιλογής για τη χρήση Levenberg-Marquardt αλγορίθμου για
% διαχείρηση μη τετραγωνικού συστήματος
options = optimoptions('fsolve', 'Algorithm', 'levenberg-marquardt');

% Επίλυση μέσω fsolve με τις επιλογές
sol = fsolve(@(vals) waveguide_equations(vals, f, C, a, d, L, Zin, h0), initial_guess, options);

% Ορισμός της συνάρτησης από την οποία θα προκύψουν τα εr και tanδ
function F = waveguide_equations(vals, f, C, a, d, L, Zin, h0)
    epsilon_r = vals(1);
    tan_d = vals(2);

    % Χωρίς διηλεκτρικό
    % Συχνότητα αποκοπής επικρατέστερου (ΤΕ10 για ορθογωνικό) σε Hz
    fC = C / (2 * pi) * (pi / a); 
    Z0 = h0 / (sqrt(1 - (fC / f)^2));
    beta0 = 2 * pi * f / C * sqrt(1 - (fC / f)^2);

    % Αντίσταση εισόδου του βραχυκυκλωμένου διηλεκτρικού τμήματος
    ZA = Z0 * (Zin - 1i * Z0 * tan(beta0 * (L - d))) / (Z0 - 1i * Zin * tan(beta0 * (L - d))); 
    
    % Με διηλεκτρικό
    Z1 = h0 / sqrt((epsilon_r - epsilon_r * tan_d * 1i) - (fC / f)^2);
    beta = 2 * pi * f / C * sqrt((epsilon_r - epsilon_r * tan_d * 1i) - (fC / f)^2);
    k = 2 * pi * f / C * sqrt(epsilon_r - epsilon_r * tan_d * 1i);
    gamma = (k^2) * tan_d / (2 * beta) + 1i * beta;

    F = Z1 * tanh(gamma * d) - ZA;
end

disp(['Σχετική διηλεκτρική σταθερά (ϵr): ', num2str(sol(1))])
fprintf('Γωνία απωλειών (tan(δ)): %.4f\n', sol(2));


