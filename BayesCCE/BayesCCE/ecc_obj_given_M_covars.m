
function [f,g] = ecc_obj_given_M_covars(O,L,P,M,V,B,alpha,sigma2,C)

d = size(P,2);
n = size(O,2);
t = size(O,1);
k = size(V,2);
p = size(C,2);

Z = M*V'*P';
Y = L*B*C';

% Calculate the objective
f = (0.5/sigma2) * sum(sum(Z.^2 + Y.^2 - 2.*O.*Z - 2.*O.*Y + 2.*Z.*Y)) - sum(sum(log(V'*P').*(alpha-1)));

% Calculate the gradient
delta_V = zeros(d,k);
delta_B = zeros(d,p);
for x = 1:d
    for y = 1:k
        W = repmat(M(:,y),1,n).*[repmat(P(:,x),1,t)]';
		delta_V(x,y) = (0.5/sigma2)*sum(sum( 2.*W.*Z - 2.*O.*W +2.*W.*Y )) - sum((alpha(y,:)-1.*P(:,x)') ./ [P*V(:,y)]');
    end
end
for x = 1:d
    for y = 1:p
        W = repmat(L(:,x),1,n).*repmat(C(:,y),1,t)';
        delta_B(x,y) = (0.5/sigma2)*sum(sum( 2.*W.*Y - 2.*O.*W +2.*W.*Z));
    end
end

% Flatten the matrices to get the gradient
g = [reshape(delta_V,d*k,1); reshape(delta_B,d*p,1)];

end