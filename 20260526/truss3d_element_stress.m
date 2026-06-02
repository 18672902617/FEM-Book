function [epsilon, sigma, N] = truss3d_element_stress(x1, x2, E, A, de)
%TRUSS3D_ELEMENT_STRESS 计算三维桁架单元的应变、应力和轴力。
%   x1, x2: 节点坐标 [x, y, z]
%   E: 弹性模量
%   A: 截面面积
%   de: 节点位移向量 [u1, v1, w1, u2, v2, w2]
%   return: 轴向应变 epsilon、应力 sigma、轴力 N

    x1 = validate_coordinate(x1, 'x1');
    x2 = validate_coordinate(x2, 'x2');
    validateattributes(E, {'numeric'}, {'real', 'scalar', 'positive'}, mfilename, 'E');
    validateattributes(A, {'numeric'}, {'real', 'scalar', 'positive'}, mfilename, 'A');
    validateattributes(de, {'numeric'}, {'real', 'vector', 'numel', 6}, mfilename, 'de');
    de = de(:);

    % 先由几何关系得到单元方向和长度
    delta = x2 - x1;
    L = norm(delta);
    if L == 0
        error('两个节点坐标不能重合。');
    end

    n = delta / L;

    % B 矩阵给出轴向应变与节点位移之间的线性关系
    B = (1 / L) * [-n.', n.'];
    epsilon = B * de;
    sigma = E * epsilon;
    N = A * sigma;
end

function x = validate_coordinate(x, name)
    validateattributes(x, {'numeric'}, {'real', 'vector', 'numel', 3}, mfilename, name);
    x = x(:);
end
