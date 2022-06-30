
function X_adj = adjust_data(X,C)

I = size(X,1);
J = size(X,2);
X_adj = X;
for j = 1:J
    [~,~,r] = regress(X(:,j),[ones(I,1) C]);
    X_adj(:,j) = r;
end

end