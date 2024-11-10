function P = power_of_load(Vgrms, Zin, Zg)
    P = (Vgrms.^2) .* (real(Zin) ./ ((real(Zin) + real(Zg)).^2 + (imag(Zin) + imag(Zg)).^2));
end