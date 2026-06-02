function report = truss3d_element_matrix_properties(Ke, x1, x2)
%TRUSS3D_ELEMENT_MATRIX_PROPERTIES 检验单元刚度矩阵的基本性质。
%   检查内容：
%   1. 对称性
%   2. 奇异性
%   3. 半正定性
%   4. 零能模态是否只由刚体模态构成

    validateattributes(Ke, {'numeric'}, {'real', 'size', [6, 6]}, mfilename, 'Ke');
    x1 = validate_coordinate(x1, 'x1');
    x2 = validate_coordinate(x2, 'x2');

    delta = x2 - x1;
    L = norm(delta);
    if L == 0
        error('两个节点坐标不能重合。');
    end

    n = delta / L;
    Ke_sym = 0.5 * (Ke + Ke.');

    % 用矩阵范数衡量对称误差
    symmetry_tol = 1.0e-10 * max(1, norm(Ke, 'fro'));
    symmetry_error = norm(Ke - Ke.', 'fro');
    is_symmetric = symmetry_error <= symmetry_tol;

    % 用特征值判断半正定性与奇异性
    eigenvalues = sort(real(eig(Ke_sym)), 'ascend');
    eigen_tol = 1.0e-10 * max(1, max(abs(eigenvalues)));
    matrix_rank = rank(Ke_sym, eigen_tol);
    nullity = size(Ke_sym, 1) - matrix_rank;
    is_singular = matrix_rank < size(Ke_sym, 1);
    is_positive_semidefinite = min(eigenvalues) >= -eigen_tol;

    % 构造 3 个平移刚体模态与 2 个转动刚体模态
    [perp1, perp2] = build_perpendicular_basis(n);
    rigid_modes = [ ...
        1, 0, 0, 0,        0; ...
        0, 1, 0, 0,        0; ...
        0, 0, 1, 0,        0; ...
        1, 0, 0, perp1(1), perp2(1); ...
        0, 1, 0, perp1(2), perp2(2); ...
        0, 0, 1, perp1(3), perp2(3)];

    rigid_mode_rank = rank(rigid_modes, eigen_tol);
    rigid_mode_residual = norm(Ke_sym * rigid_modes, 'fro');
    rigid_tol = 1.0e-10 * max(1, norm(Ke_sym, 'fro')) * norm(rigid_modes, 'fro');

    % 若零空间维数为 5，且这 5 个刚体模态都在零空间内，则零能模态仅为刚体模态
    is_rigid_body_only_zero_mode = ...
        (rigid_mode_rank == 5) && ...
        (nullity == 5) && ...
        (rigid_mode_residual <= rigid_tol);

    report = struct( ...
        'is_symmetric', is_symmetric, ...
        'symmetry_error', symmetry_error, ...
        'symmetry_tolerance', symmetry_tol, ...
        'is_singular', is_singular, ...
        'matrix_rank', matrix_rank, ...
        'nullity', nullity, ...
        'is_positive_semidefinite', is_positive_semidefinite, ...
        'min_eigenvalue', min(eigenvalues), ...
        'eigenvalues', eigenvalues, ...
        'rigid_mode_rank', rigid_mode_rank, ...
        'rigid_mode_residual', rigid_mode_residual, ...
        'rigid_mode_tolerance', rigid_tol, ...
        'is_rigid_body_only_zero_mode', is_rigid_body_only_zero_mode);
end

function [perp1, perp2] = build_perpendicular_basis(n)
% 选取两个与单元轴线垂直的单位向量，用于构造转动刚体模态
    [~, index] = min(abs(n));
    ref = zeros(3, 1);
    ref(index) = 1;

    perp1 = cross(n, ref);
    perp1 = perp1 / norm(perp1);
    perp2 = cross(n, perp1);
    perp2 = perp2 / norm(perp2);
end

function x = validate_coordinate(x, name)
    validateattributes(x, {'numeric'}, {'real', 'vector', 'numel', 3}, mfilename, name);
    x = x(:);
end
