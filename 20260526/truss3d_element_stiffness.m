function [L, direction_cosines, Ke] = truss3d_element_stiffness(x1, x2, E, A)
%TRUSS3D_ELEMENT_STIFFNESS 计算三维桁架单元刚度矩阵。
%   x1, x2: 节点坐标 [x, y, z]
%   E: 弹性模量
%   A: 截面面积
%   return: 单元长度 L、方向余弦 [cx, cy, cz]、刚度矩阵 Ke

    x1 = validate_coordinate(x1, 'x1');
    x2 = validate_coordinate(x2, 'x2');
    validateattributes(E, {'numeric'}, {'real', 'scalar', 'positive'}, mfilename, 'E');
    validateattributes(A, {'numeric'}, {'real', 'scalar', 'positive'}, mfilename, 'A');

    % 计算单元轴线方向与长度
    delta = x2 - x1;
    L = norm(delta);
    if L == 0
        error('两个节点坐标不能重合。');
    end

    n = delta / L;
    direction_cosines = n.';

    % n*n^T 为方向投影矩阵，对应全局坐标中的轴向刚度分配
    projection = n * n.';
    Ke = (E * A / L) * [projection, -projection; -projection, projection];
end

function x = validate_coordinate(x, name)
    validateattributes(x, {'numeric'}, {'real', 'vector', 'numel', 3}, mfilename, name);
    x = x(:);
end
