clc;
clear;

fprintf('三维桁架单元作业算例\n\n');

run_case('算例 1', [0, 0, 0], [2, 0, 0], 200e9, 1.0e-4, [0; 0; 0; 1.0e-3; 0; 0]);
fprintf('\n');
run_case('算例 2', [0, 0, 0], [1, 2, 2], 210e9, 2.0e-4, [0; 0; 0; 1.0e-3; 2.0e-3; 2.0e-3]);

function run_case(case_name, x1, x2, E, A, de)
% 统一执行单个算例，避免重复代码
    fprintf('%s\n', case_name);

    [L, direction_cosines, Ke] = truss3d_element_stiffness(x1, x2, E, A);
    [epsilon, sigma, N] = truss3d_element_stress(x1, x2, E, A, de);
    Fe = Ke * de;

    % 任务 4：检验单元刚度矩阵性质
    report = truss3d_element_matrix_properties(Ke, x1, x2);

    fprintf('L = %.6g m\n', L);
    fprintf('方向余弦 = [%.6g, %.6g, %.6g]\n', direction_cosines);
    fprintf('Ke =\n');
    disp(Ke);
    fprintf('epsilon = %.6g\n', epsilon);
    fprintf('sigma = %.6g Pa\n', sigma);
    fprintf('N = %.6g N\n', N);
    fprintf('Fe =\n');
    disp(Fe);

    print_property_report(report);
end

function print_property_report(report)
% 输出任务 4 的检验结果
    fprintf('矩阵性质检查：\n');
    fprintf('1. 对称性：%s（误差 = %.3e）\n', tf_text(report.is_symmetric), report.symmetry_error);
    fprintf('2. 奇异性：%s（rank = %d, nullity = %d）\n', tf_text(report.is_singular), report.matrix_rank, report.nullity);
    fprintf('3. 半正定性：%s（最小特征值 = %.3e）\n', tf_text(report.is_positive_semidefinite), report.min_eigenvalue);
    fprintf('4. 零能模态仅为刚体模态：%s（刚体模态残差 = %.3e）\n', ...
        tf_text(report.is_rigid_body_only_zero_mode), report.rigid_mode_residual);
end

function text = tf_text(flag)
    if flag
        text = '满足';
    else
        text = '不满足';
    end
end
