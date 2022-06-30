
function [f,g] = ecc_obj_given_M(O,L,P,M,V,B,alpha,sigma2)

d = size(P,2);
n = size(O,2);
t = size(O,1);
k = size(V,2);

Z = M*V'*P';

% Calculate the objective
f = (0.5/sigma2) * sum(sum(Z.^2 - 2.*O.*Z)) - sum(sum(log(V'*P').*(alpha-1)));

% Calculate the gradient
delta_V = zeros(d,k);

for x = 1:d
    for y = 1:k
        W = repmat(M(:,y),1,n).*[repmat(P(:,x),1,t)]';
		delta_V(x,y) = (0.5/sigma2)*sum(sum( 2.*W.*Z - 2.*O.*W)) - sum(((alpha(y,:)-1).*P(:,x)') ./ [P*V(:,y)]');
    end
end
% Flatten the matrices to get the gradient
g = reshape(delta_V,d*k,1);

end