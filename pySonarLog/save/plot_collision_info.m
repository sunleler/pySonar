function [f, leg_text, leg] = plot_collision_info(fname, lwidth, show_unvalid)
% clear, close all
% fname = 'collision_info20180427-125811.mat';
    load(fname)
    if ~exist('lwidth', 'var')
        lwidth = 2;
    end
    if ~exist('show_unvalid', 'var')
        show_unvalid = false;
    end
    if ~isempty(new_wps)
        new_wps = new_wps(:, 1:2);
    end
    old_wps = old_wps(:, 1:2);
    voronoi_ridge_vertices = voronoi_ridge_vertices + 1;
    voronoi_ridge_points = voronoi_ridge_points + 1;
    % voronoi_regions = voronoi_regions + 1;
    voronoi_point_region = voronoi_point_region + 1;
    voronoi_start_wp = voronoi_start_wp + 1;
    voronoi_end_wp = voronoi_end_wp + 1;
    if exist('orig_list', 'var')
        orig_list = orig_list + 1;
    end
    pos = double(pos);
    range_scale = double(range_scale);


    f = figure();
    % obstacles
    plot(voronoi_points(:, 1), voronoi_points(:, 2), 'or')
    % ylim([min(voronoi_points(:, 2)), max(voronoi_points(:, 2))]);
    % xlim([min(voronoi_points(:, 1)), max(voronoi_points(:, 1))]);
%     axis manual;
    hold on
    for i = 1:length(obstacles)
        if iscell(obstacles)
            obs = obstacles{i};
            s = size(obs);
            obs = reshape(obs, s(1), s(3));
        else
            s = size(obstacles);
            if s(1) == 1
                obs = obstacles(:, i, :, :);
                s = size(obs);
                obs = reshape(obs, s(2), s(4));
            else
                obs = obstacles(i, :, :, :);
                s = size(obs);
                obs = reshape(obs, s(2), s(4));
            end
        end
        obs = [obs; obs(1, :)];
        plot(obs(:, 1), obs(:, 2), 'r')
    end

    % Vertices and ridges
    plot(voronoi_vertices(:, 1), voronoi_vertices(:, 2), 'bo');
    for i = 1:length(voronoi_ridge_vertices)
        if any(voronoi_ridge_vertices(i, :) == 0)
            continue
        end
        valid = false;
        if connection(voronoi_ridge_vertices(i, 1), voronoi_ridge_vertices(i, 2)) ~= 0
            valid = true;
        end
        v1 = voronoi_vertices(voronoi_ridge_vertices(i, 1), :);
        v2 = voronoi_vertices(voronoi_ridge_vertices(i, 2), :);
        if valid
            plot([v1(1), v2(1)], [v1(2), v2(2)], 'b', 'LineWidth', 1.5)
        else
            if show_unvalid
                plot([v1(1), v2(1)], [v1(2), v2(2)], 'r')
            end
        end
    end

    %% paths

    old_wps_grid = ned2grid(old_wps, pos, range_scale);
    l(1) = plot(old_wps_grid(:, 1), old_wps_grid(:, 2), 'k-o', 'LineWidth', lwidth);
    
    if exist('orig_list', 'var')
        plot(voronoi_vertices(orig_list, 1), voronoi_vertices(orig_list, 2), 'm-o', 'LineWidth', 1.5);
    end
    if ~isempty(new_wps)
        if iscell(new_wps)
            new_wps = cell2mat(new_wps);
        end
        new_wps_grid = ned2grid(new_wps, pos, range_scale);
        l(2) = plot(new_wps_grid(:, 1), new_wps_grid(:, 2), '-og', 'LineWidth', lwidth);
    end
    v_start = voronoi_vertices(voronoi_start_wp, :);
    v_end = voronoi_vertices(voronoi_end_wp, :);
    l(3) = plot(v_start(1), v_start(2), 'c*', 'MarkerSize', 30);
    l(4) = plot(v_end(1), v_end(2), 'co', 'MarkerSize', 30);
    plot([0 1601 1601 0 0], [0 0 1601 1601 0], 'Color', [127, 127, 135]/255)
    
%     legend(l, {'old', 'new', 'start vertex', 'end vertex'});
    leg = l;
    leg_text = {'old', 'new', 'start vertex', 'end vertex'};
%     ax = gca;
%     outerpos = ax.OuterPosition;
%     ti = ax.TightInset; 
%     left = outerpos(1) + ti(1);
%     bottom = outerpos(2) + ti(2);
%     ax_width = outerpos(3) - ti(1) - ti(3);
%     ax_height = outerpos(4) - ti(2) - ti(4);
%     ax.Position = [left bottom ax_width ax_height];
    set(gca, 'YDir','reverse')
    axis equal; 
    axis([-6.482587482333658e+02 2.606634295180842e+03 -5.141812470715848e+02 2.052984395234135e+03]);
    %     save(f, strcat('png\',fname, '.png'));



