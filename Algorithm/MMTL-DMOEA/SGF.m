function phi = SGF(Q,Pt,d)
    Pt = Pt(:,1:d);
    QPt = Q'*Pt;
    [V1,V2,V,Gam,Sig] = gsvd(QPt(1:d,:), QPt(d+1:end,:));
    V2 = -V2(:,1:d);
    theta = real(acos(diag(Gam))); % theta is real in theory. Imaginary part is due to the computation issue.
    phi = [];
    for k = 0.1:0.2:0.9
        phi = [phi Q(:,1:d)*V1*diag(cos(k.*theta))+Q(:,d+1:end)*V2*diag(sin(k.*theta))];
    end
end