%This project is licensed under the terms of the Creative Commons CC BY-NC-ND 4.0 license.

function [field_cs] = plot_2D(u, CSs, NODES_X, NODES_Y, NODES_Z, plot_title, field_idx1, field_idx2)

% Reshapes a one dimensional field array into a 3 dimensional matrix with
% length (NODES_X, NODES_Y, NODES_Z and generates a 2D color plot for a
% chosen cross-section (CS).
map = 'colormaps.plasma';

numNodes = NODES_X*NODES_Y*NODES_Z;

field = u(field_idx1:field_idx2,:);

%Calc magnitude of specified field
mag = zeros(1, numNodes);
if size(field, 1) == 1
    % plot a scalar fied directly
    mag(:) = field(1:numNodes);
else
    % plot the magnitude of a vector field
    for i=1:numNodes
        mag(i) = norm(field(:,i));
    end
end
%Reshape 1D array to 3D array for plotting
field_cs = reshape(mag, NODES_X, NODES_Y, NODES_Z);

for CS = CSs
    clearvars v
    FigX = figure;

    %Choose cross section for plotting
    switch lower(CS )
        case 'x'
            plot_title_cs = strcat(plot_title, ' (X-Cross-Section)');
            v(:,:) = field_cs(floor(NODES_X)/2,:,:);
            v = permute(v, [2 1]);
            x_range = 1:NODES_Y;
            x_label = 'y (nodes)';
            y_range = 1:NODES_Z;
            y_label = 'z (nodes)';
        case 'y'
            plot_title_cs = strcat(plot_title, ' (Y-Cross-Section)');
            v(:,:) = field_cs(:,floor(NODES_Y)/2,:);
            v = permute(v, [2 1]);
            x_range = 1:NODES_X;
            x_label = 'x (nodes)';
            y_range = 1:NODES_Z;
            y_label = 'z (nodes)';
        case 'z'
            plot_title_cs = strcat(plot_title, ' (Z-Cross-Section)');
            v(:,:) = field_cs(:,:,floor(NODES_Z)/2)';
            x_range = 1:NODES_X;
            x_label = 'x (nodes)';
            y_range = 1:NODES_Y;
            y_label = 'y (nodes)';
    end
    hX = pcolor(x_range',y_range',v);

    set(hX, 'EdgeColor', 'none');
    c = colorbar;
    colormap(map)
    xlabel(x_label)
    ylabel(y_label)
    title(plot_title_cs)
    pbaspect([1 1 1])

    shading interp;
end
end
