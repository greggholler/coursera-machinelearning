function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost and gradient of regularized linear 
%               regression for a particular choice of theta.
%
%               You should set J to the cost and grad to the gradient.
%

J = (1 / (2 * m)) * sum(((X * theta) - y) .^ 2);

% Regularize
J = J .+ ((lambda / (2 * m)) * sum(theta(2:end) .^ 2));



%
% Calculate the gradient
delta = zeros(size(theta));
h_theta = zeros(size(theta));
grad = zeros(size(theta));

for j = 1:length(theta)
    for i = 1:m
        h_theta = (X(i,:) * theta);
        delta(j) = delta(j) + (h_theta - y(i)) * X(i,j)';
    end
end

% Fold back into theta

% Handle theta(0)
grad(1) = (1 / m) * delta(1);

for j = 2:length(theta)
    grad(j) = ((1 / m) * delta(j)) + ((lambda / m) * theta(j));
end








% =========================================================================

%grad = grad(:);

end
