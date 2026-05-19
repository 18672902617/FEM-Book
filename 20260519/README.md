# MATLAB R2021b 圆周率计算说明

运行 ‘pi.m’ 会基于图中有限元离散近似思路，使用内接正n边形周长

`pi_n = n * sin(pi / n)`

计算圆周率，并输出：

- `pi_results.csv`：数值结果表
- `pi_results.txt`：文本结果
- `pi_convergence.png`：右上角风格的误差双对数图
- `pi_convergence.fig`：MATLAB 图窗文件

脚本同时给出直接逼近的收敛斜率和 Wynn-ε 外推后的收敛斜率。
