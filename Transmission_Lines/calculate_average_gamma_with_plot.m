% Διάνυσμα βέλτιστων παραμέτρων αντεγραμμένο από το Βest στο workspace
pC = [0.233324623285834	0.0814987914311994	0.148683971676471	0.478351464493813	0.116755860940262	0.0500000000000000];
pD = [0.220636820614118	0.112301790195512	0.124848636899240	0.0851373416235074	0.0824861437150884	0.0500000000000000];
pE1 = [0.0500000000000000	0.204723075301582	0.156680130490859	0.0500000000000000	0.0500000000000000	0.0500000000000000];
pE2 = [0.151468841452053	0.0500000000000000	0.0768940232433993	0.110717086691067	0.107497835827165	0.0714498300249832];

function avg_reflection_coefficient = calculate_average_gamma_plot_C(p)
    Z0 = 50; % Χαρακτηριστική αντίσταση της γραμμής μεταφοράς
    ZL = 120 + 1i*60; % Φορτίο στο τέλος της γραμμής
    lambda = 1; % Θεωρώ το λ ίσο με 1
    
    % Ορισμός του διανύσματος κανονικοποιημένης συχνότητας
    normf = (0.01:0.01:2);
    
    % Υπολογισμός του συντελεστή ανάκλασης Γ για κάθε κανονικοποιημένη συχνότητα
    beta = 2 * pi .* normf / lambda; % Σταθερά διάδοσης για τη συχνότητα

    % Υπολογισμοί αντιστάσεων στους κλάδους και στα τμήματα
    Zd1 = Z0 .* (ZL + 1i * Z0 .* tan(beta*p(1))) ./ (Z0 + 1i * ZL .* tan(beta*p(1)));
    Zin_stub1 = -1i * Z0 ./ tan(beta*p(4));
    Zin1 = (Zin_stub1 .* Zd1) ./ (Zin_stub1 + Zd1);

    Zd2 = Z0 .* (Zin1 + 1i * Z0 .* tan(beta*p(2))) ./ (Z0 + 1i * Zin1 .* tan(beta*p(2)));
    Zin_stub2 = -1i * Z0 ./ tan(beta*p(5));
    Zin2 = (Zin_stub2 .* Zd2) ./ (Zin_stub2 + Zd2);

    Zd3 = Z0 .* (Zin2 + 1i * Z0 .* tan(beta*p(3))) ./ (Z0 + 1i * Zin2 .* tan(beta*p(3)));
    Zin_stub3 = -1i * Z0 ./ tan(beta*p(6));
    Zin_total = (Zin_stub3 .* Zd3) ./ (Zin_stub3 + Zd3);

    % Υπολογισμός του Γ και |Γ|
    reflection_coefficient = (Zin_total - Z0) ./ (Zin_total + Z0);    
    reflection_magnitudes = abs(reflection_coefficient);
   
    % Υπολογισμός του μέσου όρου του μέτρου του συντελεστή ανάκλασης
    avg_reflection_coefficient = mean(reflection_magnitudes);
    
    figure;
    plot(normf, reflection_magnitudes);
    title('Μέτρο του Συντελεστή Ανάκλασης Ερώτημα Γ');
    xlabel('Κανονικοποιημένη Συχνότητα (f/f_0)');
    ylabel('|Γ|');
    grid on;
end

function avg_reflection_coefficient = calculate_average_gamma_plot_D(p)
    Z0 = 50; % Χαρακτηριστική αντίσταση της γραμμής μεταφοράς
    ZL = 120 + 1i*60; % Φορτίο στο τέλος της γραμμής
    lambda = 1; % Θεωρώ το λ ίσο με 1
    
    % Ορισμός του διανύσματος κανονικοποιημένης συχνότητας
    normf = (0.01:0.01:2);
    
    % Υπολογισμός του συντελεστή ανάκλασης Γ για κάθε κανονικοποιημένη συχνότητα
    beta = 2 * pi .* normf / lambda; % Σταθερά διάδοσης για τη συχνότητα

    % Υπολογισμοί αντιστάσεων στους κλάδους και στα τμήματα
    Zd1 = Z0 .* (ZL + 1i * Z0 .* tan(beta*p(1))) ./ (Z0 + 1i * ZL .* tan(beta*p(1)));
    Zin_stub1 = -1i * Z0 ./ tan(beta*p(4));
    Zin1 = (Zin_stub1 .* Zd1) ./ (Zin_stub1 + Zd1);

    Zd2 = Z0 .* (Zin1 + 1i * Z0 .* tan(beta*p(2))) ./ (Z0 + 1i * Zin1 .* tan(beta*p(2)));
    Zin_stub2 = -1i * Z0 ./ tan(beta*p(5));
    Zin2 = (Zin_stub2 .* Zd2) ./ (Zin_stub2 + Zd2);

    Zd3 = Z0 .* (Zin2 + 1i * Z0 .* tan(beta*p(3))) ./ (Z0 + 1i * Zin2 .* tan(beta*p(3)));
    Zin_stub3 = -1i * Z0 ./ tan(beta*p(6));
    Zin_total = (Zin_stub3 .* Zd3) ./ (Zin_stub3 + Zd3);

    % Υπολογισμός του Γ και |Γ|
    reflection_coefficient = (Zin_total - Z0) ./ (Zin_total + Z0);    
    reflection_magnitudes = abs(reflection_coefficient);
   
    % Υπολογισμός του μέσου όρου του μέτρου του συντελεστή ανάκλασης
    avg_reflection_coefficient = mean(reflection_magnitudes);
    
    figure;
    plot(normf, reflection_magnitudes);
    title('Μέτρο του Συντελεστή Ανάκλασης Ερώτημα Δ');
    xlabel('Κανονικοποιημένη Συχνότητα (f/f_0)');
    ylabel('|Γ|');
    grid on;
end

function avg_reflection_coefficient = calculate_average_gamma_plot_E1(p)
    Z0 = 50; % Χαρακτηριστική αντίσταση της γραμμής μεταφοράς
    ZL = 20 + 1i*30; % Φορτίο στο τέλος της γραμμής
    lambda = 1; % Θεωρώ το λ ίσο με 1
    
    % Ορισμός του διανύσματος κανονικοποιημένης συχνότητας
    normf = (0.01:0.01:2);
    
    % Υπολογισμός του συντελεστή ανάκλασης Γ για κάθε κανονικοποιημένη συχνότητα
    beta = 2 * pi .* normf / lambda; % Σταθερά διάδοσης για τη συχνότητα

    % Υπολογισμοί αντιστάσεων στους κλάδους και στα τμήματα
    Zd1 = Z0 .* (ZL + 1i * Z0 .* tan(beta*p(1))) ./ (Z0 + 1i * ZL .* tan(beta*p(1)));
    Zin_stub1 = -1i * Z0 ./ tan(beta*p(4));
    Zin1 = (Zin_stub1 .* Zd1) ./ (Zin_stub1 + Zd1);

    Zd2 = Z0 .* (Zin1 + 1i * Z0 .* tan(beta*p(2))) ./ (Z0 + 1i * Zin1 .* tan(beta*p(2)));
    Zin_stub2 = -1i * Z0 ./ tan(beta*p(5));
    Zin2 = (Zin_stub2 .* Zd2) ./ (Zin_stub2 + Zd2);

    Zd3 = Z0 .* (Zin2 + 1i * Z0 .* tan(beta*p(3))) ./ (Z0 + 1i * Zin2 .* tan(beta*p(3)));
    Zin_stub3 = -1i * Z0 ./ tan(beta*p(6));
    Zin_total = (Zin_stub3 .* Zd3) ./ (Zin_stub3 + Zd3);

    % Υπολογισμός του Γ και |Γ|
    reflection_coefficient = (Zin_total - Z0) ./ (Zin_total + Z0);    
    reflection_magnitudes = abs(reflection_coefficient);
   
    % Υπολογισμός του μέσου όρου του μέτρου του συντελεστή ανάκλασης
    avg_reflection_coefficient = mean(reflection_magnitudes);
    
    figure;
    plot(normf, reflection_magnitudes);
    title('Μέτρο του Συντελεστή Ανάκλασης Ερώτημα Ε1');
    xlabel('Κανονικοποιημένη Συχνότητα (f/f_0)');
    ylabel('|Γ|');
    grid on;
end

function avg_reflection_coefficient = calculate_average_gamma_plot_E2(p)
    Z0 = 50; % Χαρακτηριστική αντίσταση της γραμμής μεταφοράς
    ZL = 180 - 1i*200; % Φορτίο στο τέλος της γραμμής
    lambda = 1; % Θεωρώ το λ ίσο με 1
    
    % Ορισμός του διανύσματος κανονικοποιημένης συχνότητας
    normf = (0.01:0.01:2);
    
    % Υπολογισμός του συντελεστή ανάκλασης Γ για κάθε κανονικοποιημένη συχνότητα
    beta = 2 * pi .* normf / lambda; % Σταθερά διάδοσης για τη συχνότητα

    % Υπολογισμοί αντιστάσεων στους κλάδους και στα τμήματα
    Zd1 = Z0 .* (ZL + 1i * Z0 .* tan(beta*p(1))) ./ (Z0 + 1i * ZL .* tan(beta*p(1)));
    Zin_stub1 = -1i * Z0 ./ tan(beta*p(4));
    Zin1 = (Zin_stub1 .* Zd1) ./ (Zin_stub1 + Zd1);

    Zd2 = Z0 .* (Zin1 + 1i * Z0 .* tan(beta*p(2))) ./ (Z0 + 1i * Zin1 .* tan(beta*p(2)));
    Zin_stub2 = -1i * Z0 ./ tan(beta*p(5));
    Zin2 = (Zin_stub2 .* Zd2) ./ (Zin_stub2 + Zd2);

    Zd3 = Z0 .* (Zin2 + 1i * Z0 .* tan(beta*p(3))) ./ (Z0 + 1i * Zin2 .* tan(beta*p(3)));
    Zin_stub3 = -1i * Z0 ./ tan(beta*p(6));
    Zin_total = (Zin_stub3 .* Zd3) ./ (Zin_stub3 + Zd3);

    % Υπολογισμός του Γ και |Γ|
    reflection_coefficient = (Zin_total - Z0) ./ (Zin_total + Z0);    
    reflection_magnitudes = abs(reflection_coefficient);
   
    % Υπολογισμός του μέσου όρου του μέτρου του συντελεστή ανάκλασης
    avg_reflection_coefficient = mean(reflection_magnitudes);
    
    figure;
    plot(normf, reflection_magnitudes);
    title('Μέτρο του Συντελεστή Ανάκλασης Ερώτημα E2');
    xlabel('Κανονικοποιημένη Συχνότητα (f/f_0)');
    ylabel('|Γ|');
    grid on;
end

average_gamma = calculate_average_gamma_plot_C(pC);
disp(average_gamma);

average_gamma = calculate_average_gamma_plot_D(pD);
disp(average_gamma);

average_gamma = calculate_average_gamma_plot_E1(pE1);
disp(average_gamma);

average_gamma = calculate_average_gamma_plot_E2(pE2);
disp(average_gamma);