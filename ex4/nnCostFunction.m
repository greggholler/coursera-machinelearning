function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%





% Add ones to the X data matrix
X = [ones(m, 1) X];

K = num_labels;
delta1 = zeros(size(Theta1));
delta2 = zeros(size(Theta2));

for i = 1:m
    % Convert y to a vector of binary values
    binY = zeros(num_labels,1);
    binY(y(i)) = 1;

    % -----------------------------
    % Calculate h

    % Calculate hidden layer
    a = zeros(size(Theta2, 2) - 1);

    a = sigmoid(Theta1 * X(i,:)');

    % Add bias unit to a
    a = [1;a];

    % Calculate output layer
    h = sigmoid(Theta2 * a);
    % -----------------------------

    % -----------------------------
    % calculate gradients
    d3 = zeros(num_labels,1);
    d3 = h - binY;
    
    d2 = zeros(size(Theta2, 2), 1);
    %d2 = (Theta2'(2:size(Theta2,1)) * d3) .* sigmoidGradient(Theta1 * X(i,:)');
    temp = Theta2' * d3;
    d2 = temp(2:size(temp,1)) .* sigmoidGradient(Theta1 * X(i,:)');
    %d2 = (Theta2' * d3) .* sigmoidGradient(Theta1 * X(i,:)');

    %D2 = D2 + (d3 * a');

    % Update error    
    delta2 = delta2 + (d3 * a');
    delta1 = delta1 + (d2 * X(i,:));


    % -----------------------------
    % Update cost
    J = J + sum( (-binY .* log(h)) - ((1 - binY) .* log(1 - (h))));

end

J = (1 / m) * J;
Theta2_grad = (1 / m) * delta2;
Theta1_grad = (1 / m) * delta1;

% regularize cost function
t1 = t2 = 0;

for j = 1:size(Theta1,1)
    for k = 2:size(Theta1,2)
        t1 = t1 + Theta1(j,k) ^ 2;
    end
end

for j = 1:size(Theta2,1)
    for k = 2:size(Theta2,2)
        t2 = t2 + Theta2(j,k) ^ 2;
    end
end

J = J + (lambda / (2 * m)) * (t1 + t2);

% regularize gradient
Theta1_grad(:,(2:end)) = Theta1_grad(:,(2:end)) .+ ((lambda / m) * Theta1(:,(2:end)));
Theta2_grad(:,(2:end)) = Theta2_grad(:,(2:end)) .+ ((lambda / m) * Theta2(:,(2:end)));


% -------------------------------------------------------------

% =========================================================================


% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
