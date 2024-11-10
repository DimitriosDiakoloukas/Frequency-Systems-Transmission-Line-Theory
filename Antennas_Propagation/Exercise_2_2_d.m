clc;
clear;

% Υπολογισμός αποστάσεων hx και hy για τις τρεις περιπτώσεις
syms hx hy n m;

% Αρχικές παράμετροι
f = 1e9; % Συχνότητα σε Hz
I = 1; % Ρεύμα 1Α
C = physconst('LightSpeed'); % Ταχύτητα φωτός σε m/s
lambda = C / f; % Μήκος κύματος σε μέτρα
k = 2 * pi / lambda; % Κυματικός αριθμός
r = 1; % Απόσταση αναφοράς

% Ορισμός των γωνιών φ
phi_angles = linspace(0, 2 * pi, 1000);

% Πρώτη περίπτωση
eq11 = sqrt(2) / 2 * k * (hx + hy) == 2 * pi * n;
eq12 = sqrt(2) / 2 * k * (-hx + hy) == (2 * m + 1) * pi;
equation1 = [eq11, eq12];
solution_case1 = solve(equation1, [hx, hy]);
case_hx1 = solution_case1.hx;
case_hy1 = solution_case1.hy;

% Δεύτερη περίπτωση
eq21 = sqrt(2) / 2 * k * (hx + hy) == (2 * n + 1) * pi;
eq22 = sqrt(2) / 2 * k * (-hx + hy) == 2 * m * pi;
equation2 = [eq21, eq22];
solution_case2 = solve(equation2, [hx, hy]);
case_hx2 = solution_case2.hx;
case_hy2 = solution_case2.hy;

% Έυρος τιμών για τα n, m
range_n = -2:2;
range_m = -2:2;
num_vals = length(range_n) * length(range_m);

% Προκαταχώριση των πινάκων με μέγιστο αριθμό στοιχείων
hx1_vals = zeros(1, num_vals);
hy1_vals = zeros(1, num_vals);
hx2_vals = zeros(1, num_vals);
hy2_vals = zeros(1, num_vals);

% Μετρητές για τον αριθμό των έγκυρων λύσεων
count1 = 0;
count2 = 0;

% Λύσεις για την 1η περίπτωση για συγκεκριμένο εύρος τιμών n, m
for n_val = range_n
    for m_val = range_m
        asked_hx1 = double(subs(case_hx1, [n, m], [n_val, m_val]));
        asked_hy1 = double(subs(case_hy1, [n, m], [n_val, m_val]));
        if (asked_hx1 > 0) && (asked_hy1 > 0)
            count1 = count1 + 1;
            hx1_vals(count1) = asked_hx1;
            hy1_vals(count1) = asked_hy1;
        end
    end
end

% Λύσεις για την 2η περίπτωση για συγκεκριμένο εύρος τιμών n, m
for n_val = range_n
    for m_val = range_m
        asked_hx2 = double(subs(case_hx2, [n, m], [n_val, m_val]));
        asked_hy2 = double(subs(case_hy2, [n, m], [n_val, m_val]));
        if (asked_hx2 > 0) && (asked_hy2 > 0)
            count2 = count2 + 1;
            hx2_vals(count2) = asked_hx2;
            hy2_vals(count2) = asked_hy2;
        end
    end
end

% Αφαίρεση των μη έγκυρων (μηδενικών) τιμών από τους πίνακες
hx1_vals = hx1_vals(1:count1);
hy1_vals = hy1_vals(1:count1);
hx2_vals = hx2_vals(1:count2);
hy2_vals = hy2_vals(1:count2);

% Ταξινόμηση των τιμών
hx1_vals = sort(hx1_vals);
hy1_vals = sort(hy1_vals);
hx2_vals = sort(hx2_vals);
hy2_vals = sort(hy2_vals);

hx1_vals_unique = unique(hx1_vals, 'stable');
hy1_vals_unique = unique(hy1_vals, 'stable');
hx2_vals_unique = unique(hx2_vals, 'stable');
hy2_vals_unique = unique(hy2_vals, 'stable');

% Επιλογή των κατάλληλων τιμών για τις περιπτώσεις
min_hx = hx1_vals_unique(1);
min_hy = hy1_vals_unique(1);

next_hx = hx1_vals_unique(2);
next_hy = hy1_vals_unique(2);

fprintf('Πρώτη περίπτωση (min hx, min hy): hx = %.6f, hy = %.6f\n', min_hx, min_hy);
fprintf('Δεύτερη περίπτωση (min hx, next hy): hx = %.6f, hy = %.6f\n', min_hx, next_hy);
fprintf('Τρίτη περίπτωση (next hx, next hy): hx = %.6f, hy = %.6f\n', next_hx, next_hy);

% Υπολογισμός και σχεδίαση για τις τρεις περιπτώσεις
figure;

% Πρώτη περίπτωση (min hx, min hy)
hx = min_hx;
hy = min_hy;
E0 = abs(60 * I / r);
E_field_case1 = 2 * E0 * abs(cos(k * (hx .* cos(phi_angles) + hy .* sin(phi_angles))) - cos(k * (-hx .* cos(phi_angles) + hy .* sin(phi_angles))));

subplot(3, 2, 1);
plot(phi_angles, E_field_case1, "LineWidth", 1);
title("Διάγραμμα E συναρτήσει \phi για ελάχιστες τιμές hx και hy");
xlabel("\phi (rad)");
ylabel("E");

subplot(3, 2, 2);
polarplot(phi_angles, E_field_case1, "g", "LineWidth", 1);
title("Οριζόντιο Διάγραμμα Ακτινοβολίας για ελάχιστες τιμές hx και hy");

% Δεύτερη περίπτωση (min hx, next hy)
hx = min_hx;
hy = next_hy;
E_field_case2 = 2 * E0 * abs(cos(k * (hx .* cos(phi_angles) + hy .* sin(phi_angles))) - cos(k * (-hx .* cos(phi_angles) + hy .* sin(phi_angles))));

subplot(3, 2, 3);
plot(phi_angles, E_field_case2, "LineWidth", 1);
title("Διάγραμμα E συναρτήσει \phi για ελάχιστο hx και επόμενο hy");
xlabel("\phi (rad)");
ylabel("E");

subplot(3, 2, 4);
polarplot(phi_angles, E_field_case2, "g", "LineWidth", 1);
title("Οριζόντιο Διάγραμμα Ακτινοβολίας για ελάχιστο hx και επόμενο hy");

% Τρίτη περίπτωση (next hx, next hy)
hx = next_hx;
hy = next_hy;
E_field_case3 = 2 * E0 * abs(cos(k * (hx .* cos(phi_angles) + hy .* sin(phi_angles))) - cos(k * (-hx .* cos(phi_angles) + hy .* sin(phi_angles))));

subplot(3, 2, 5);
plot(phi_angles, E_field_case3, "LineWidth", 1);
title("Διάγραμμα E συναρτήσει \phi για επόμενες τιμές hx και hy");
xlabel("\phi (rad)");
ylabel("E");

subplot(3, 2, 6);
polarplot(phi_angles, E_field_case3, "g", "LineWidth", 1);
title("Οριζόντιο Διάγραμμα Ακτινοβολίας για επόμενες τιμές hx και hy");
