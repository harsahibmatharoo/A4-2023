% Read the data from the 'wastewater.xlsx' file
data = readtable('wastewater.xlsx');

% Split the data into training and testing sets
training_data = data(1:19, 2:8);
training_labels = data(1:19, 9);
testing_data = data(20:26, 2:8);
testing_labels = data(20:26, 9);

% Define the number of components for the PLS model
num_components = 3;

% Perform PLS using the NIPALS algorithm
[T, P, W, C, B, var_exp] = nipalspls(table2array(training_data), table2array(training_labels), num_components);

% Convert the training labels to an array
training_labels_array = table2array(training_labels);

% Initialize the R^2 array for each component
pls_r2 = zeros(1, num_components);

% Calculate the R^2 values for each component
for i = 1:num_components
    % Select the first i components
    T_sub = T(:, 1:i);
    B_sub = B(1:i);
    C_sub = C(:, 1:i);
    
    % Compute the predicted values using the PLS model
    Y_pred = T_sub * (diag(B_sub) * C_sub');
    
    % Calculate the R^2 value for the model with i components
    r2 = 1 - (sum((training_labels_array - Y_pred).^2, 'all') / sum((training_labels_array - mean(training_labels_array)).^2, 'all'));
    
    % Store the R^2 value in the array
    pls_r2(i) = r2;
end

% Display the results for each component
for i = 1:num_components
    fprintf('Component %d:\n', i);
    fprintf('w*:\n');
    disp(W(:, i)); % Display the weight vector for the i-th component
    fprintf('p:\n');
    disp(P(:, i)); % Display the loading vector for the i-th component
    fprintf('c:\n');
    disp(C(:, i)); % Display the regression coefficient for the i-th component
    fprintf('R^2: %f\n\n', pls_r2(i)); % Display the R^2 value for the i-th component
end
