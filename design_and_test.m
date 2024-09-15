%% Plant
% Create 's'
s = tf('s');

% System parameters
m = 10;
k = 0.5;

% System transfer function
G = 1/(s*(m*s+k));

%% Controller synthesis - loop shaping - loopsyn command

% alpha specifies the tradeoff between performance and robustness in the interval [0,1].
% Smaller alpha favors performance (mixsyn design) and larger alpha favors robustness (ncfsyn design).
alpha = [0.1, 0.5, 0.9];

% Preallocate arrays for storage
K = cell(size(alpha));
CL = cell(size(alpha));
gamma = cell(size(alpha));
info = cell(size(alpha));
results = cell(size(alpha));

% Desired transfer function (setpoint to output)
tau = 0.2;
Td = 1/(tau*s+1)^2;

% Calculate Ld using Td
% Ld = Td/(1-Td)
Ld = 1/(tau^2*s^2 + 2*tau*s);

% Loop through configurations
for i = 1:length(alpha)

    % Compute K using loopsyn loop shaping
    [K{i}, CL{i}, gamma{i}, info{i}] = loopsyn(G, Ld, alpha(i));

    % Find K's transfer function
    K_tf = tf(K{i})

    % Open loop function's Bode diagram to check stability margins
    figure;
    margin(K_tf*G); % Plot Bode diagram with gain and phase margins
    set(findall(gcf,'type','line'),'LineWidth',2);
    grid on;

    % Step response in closed loop between 0 and 10 sec
    t = 0:0.01:10;  % Time vector from 0 to 10 seconds
    [y, t] = step(CL{i}, t);
    
    % Store results for later plotting
    results{i}.z = timeseries(y, t);
    results{i}.r = timeseries(ones(size(t)), t);  % Reference input (step)
    
    % Calculate control effort (force)
    u = lsim(K{i}, results{i}.r.Data - y, t);
    results{i}.F = timeseries(u, t);
    
    % Plot step response
    figure;
    subplot(2,1,1);
    plot(t, y, 'LineWidth', 2);
    hold on;
    plot(t, ones(size(t)), '--k', 'LineWidth', 1);
    hold off;
    title(['Closed-Loop Step Response (alpha = ', num2str(alpha(i)), ')']);
    ylabel('Position (m)');
    grid on;
    
    subplot(2,1,2);
    plot(t, u, 'LineWidth', 2);
    title('Control Effort');
    xlabel('Time (s)');
    ylabel('Force (N)');
    grid on;

end

%% Plotting Results

% Plot Bode diagrams
figure;
bode(Ld);
hold on;
for i = 1:length(alpha)
    bode(K{i}*G);
end
hold off;
legend(['Ideal (Ld)', arrayfun(@(x) ['Alpha = ' num2str(x)], alpha, 'UniformOutput', false)]);
title('Bode Diagram: Ideal vs Designed Controllers');
grid on;
set(findall(gcf,'type','line'),'LineWidth',2);

% Plot step responses
figure;
t = 0:0.01:10;
[y_ideal, t_ideal] = step(Td, t);
plot(t_ideal, y_ideal, 'k--', 'LineWidth', 2);
hold on;
for i = 1:length(alpha)
    plot(results{i}.z.Time, results{i}.z.Data, 'LineWidth', 1.5);
end
hold off;
legend(['Ideal (Td)', arrayfun(@(x) ['Alpha = ' num2str(x)], alpha, 'UniformOutput', false)]);
title('Step Response: Ideal vs Designed Controllers');
xlabel('Time (s)');
ylabel('Position (m)');
grid on;