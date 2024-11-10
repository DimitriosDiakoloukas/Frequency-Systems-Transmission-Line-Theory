function avg_reflection_coefficient = calculate_average_gamma(p)
    Z0 = 50; % Χαρακτηριστική αντίσταση της γραμμής μεταφοράς
    ZL = 120 + 1i*60; % Φορτίο στο τέλος της γραμμής
    lambda = 1; % Θεωρώ το λ ίσο με 1
    
    % Ορισμός του διανύσματος κανονικοποιημένης συχνότητας
    normf = (0.5:0.01:1.5);
    
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
end
