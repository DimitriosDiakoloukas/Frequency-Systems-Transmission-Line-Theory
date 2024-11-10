clc;
clear;

% Αρχικές παράμετροι
f = 2.5e9; % Συχνότητα σε Hz
C = physconst('LightSpeed'); % Ταχύτητα φωτός σε m/s
lambda0 = C / f; % Μήκος κύματος στον αέρα σε μέτρα
d = 1.6e-3; % Πάχος υποστρώματος FR4 σε μέτρα
epsilon_r = 4.4; % Σχετική διηλεκτρική σταθερά FR4
Q = 25; % Συντελεστής ποιότητας
Z0 = 50; % Χαρακτηριστική αντίσταση γραμμής μικροταινίας

% Υπολογισμός πλάτους συντονιστή 
A = (Z0 / 60) * sqrt((epsilon_r + 1) / 2) + ((epsilon_r - 1) / (epsilon_r + 1)) * (0.23 + 0.11 / epsilon_r);
B = (60 * pi^2) / (Z0 * sqrt(epsilon_r));

if A > 1.52
    % Υπολογισμός πλάτους μικροταινίας για A > 1.52
    W_pros_d = 8 * exp(A) / (exp(2 * A) - 2);
else
    % Υπολογισμός πλάτους μικροταινίας για A <= 1.52
    W_pros_d = (2 / pi) * (B - 1 - log(2 * B - 1) + ((epsilon_r - 1) / (2 * epsilon_r)) * (log(B - 1) + 0.39 - 0.61 / epsilon_r));
end

W = W_pros_d * d; % Πλάτος μικροταινίας σε μέτρα
disp(['Πλάτος μικροταινίας (W): ', num2str(W), ' m']);

% Υπολογισμός ενεργούς διηλεκτρικής σταθεράς 
if W_pros_d > 1
    % Υπολογισμός παράγοντα F για W_d > 1
    F = 1 / (sqrt(1 + 12 * d / W));
else
    % Υπολογισμός παράγοντα F για W_d <= 1
    F = (1 / (sqrt(1 + 12 * d / W))) + 0.04 * (1 - W_pros_d)^2;
end

% Υπολογισμός ενεργούς διηλεκτρικής σταθεράς
epsilon_r_eff = ((epsilon_r + 1) / 2) + ((epsilon_r - 1) / 2) * F;
disp(['Ενεργός διηλεκτρική σταθερά (εr,eff): ', num2str(epsilon_r_eff)]);

% Υπολογισμός μήκους συντονιστή (λ/2)
l_resonator = lambda0 / sqrt(epsilon_r_eff) / 2;
disp(['Μήκος συντονιστή (l_resonator): ', num2str(l_resonator), ' m']);

% Υπολογισμός (β)
beta = (2 * pi * f / C) * sqrt(epsilon_r_eff);

% Υπολογισμός απωλειών (α = αd)
alpha_total = beta / (2 * Q); % Συνολικές απώλειες
disp(['Απώλειες (α): ', num2str(alpha_total)]);

% Οι συνολικές απώλειες είναι όσο και οι απώλειες του διηλεκτρικού
alpha_dielectric = alpha_total;
tan_d = alpha_dielectric * 2 * sqrt(epsilon_r_eff) * (epsilon_r - 1) / ...
    ((2 * pi * f / C) * epsilon_r * (epsilon_r_eff - 1));

disp(['Εφαπτομένη απωλειών στη συχνότητα 2.5 GHz: ', num2str(tan_d)]);

% Συνάρτηση για την εξίσωση συντονισμού
frequency_equation = @(val) resonance_equation(val, l_resonator, C, epsilon_r_eff, alpha_total);

% Αρχική εκτίμηση για τη συχνότητα συντονισμού
initial_guess = 2.5e9;

% Λύση με χρήση της fzero
frequency_solution = fzero(frequency_equation, initial_guess);
disp(['Συχνότητα συντονισμού (frequency_resonator): ', num2str(frequency_solution / 1e9), ' GHz']);

% Υπολογισμός χωρητικότητας δικένου
C_diakeno = -1 * tan((2 * pi * frequency_solution * l_resonator) / (C / sqrt(epsilon_r_eff))) / (Z0 * 2 * pi * frequency_solution);
disp(['Χωρητικότητα δικένου (C): ', num2str(C_diakeno), ' F']);

% Συνάρτηση για την εξίσωση συντονισμού
function res = resonance_equation(freq, l_resonator, C, epsilon_r_eff, alpha)
    term1 = tan((2 * pi * freq * l_resonator) / (C / sqrt(epsilon_r_eff)));
    term2 = sqrt((alpha * C) / (2 * freq * sqrt(epsilon_r_eff))); 
    res = term1 + term2; 
end
