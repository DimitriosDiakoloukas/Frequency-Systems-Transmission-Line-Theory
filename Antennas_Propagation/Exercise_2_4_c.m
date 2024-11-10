clc;
clear;

% Αρχικές παράμετροι
f = 2.5e9; % Συχνότητα συντονισμού σε σύζευξη σε Hz
C = physconst('LightSpeed'); % Ταχύτητα φωτός σε m/s
d = 1.6e-3; % Πάχος υποστρώματος FR4 σε μέτρα
epsilon_r = 4.4; % Σχετική διηλεκτρική σταθερά του FR4
epsilon_r_eff = 3.3302; % Ενεργός διηλεκτρική σταθερά 
Z0 = 50; % Χαρακτηριστική αντίσταση γραμμής μικροταινίας σε Ω
tan_d = 0.044174; % Εφαπτομένη απωλειών στη συχνότητα 2.5 GHz


% Αρχική εκτίμηση για τη συχνότητα συντονισμού
initial_guess = 2.5e9;

% Λύση με χρήση της fzero
f_ans = fzero(@(val) calculate_f(val, f, C, epsilon_r, epsilon_r_eff, tan_d), initial_guess);

% Υπολογισμός νέου μήκους συντονιστή
l_resonator_new = C / (f_ans * sqrt(epsilon_r_eff)) / 2;

% Υπολογισμός νέας χωρητικότητας δικένου
C_diakeno = -1 * tan((2 * pi * f * l_resonator_new) / (C / sqrt(epsilon_r_eff))) / (Z0 * 2 * pi * f);

% Εμφάνιση αποτελεσμάτων
disp(['Μήκος συντονιστή σε μήκος κύματος λ/2: ', num2str(l_resonator_new), ' m']);
disp(['Χωρητικότητα δικένου (C): ', num2str(C_diakeno), ' F']);

function f_result = calculate_f(freq, f, C, epsilon_r, epsilon_r_eff, tan_d)
    % Υπολογισμός μήκους συντονιστή για τη δεδομένη συχνότητα
    l_resonator = C / (freq * sqrt(epsilon_r_eff)) / 2;

    % Υπολογισμός συνολικών απωλειών που είναι πρακτικά οι απώλειες του διηλεκτρικού στην περίπτωσή μας
    alpha = ((2 * pi * freq / C) * epsilon_r * (epsilon_r_eff - 1) * tan_d) / ...
            (2 * (epsilon_r - 1) * sqrt(epsilon_r_eff));

    % Υπολογισμός της εξίσωσης συντονισμού για εύρεση της συχνότητας
    f_result = tan((2 * pi * f * l_resonator) / (C / sqrt(epsilon_r_eff))) + ...
               sqrt((alpha * C) / (2 * f * sqrt(epsilon_r_eff)));
end
