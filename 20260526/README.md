# 三维桁架单元作业说明

## 文件说明

- `truss3d_element_stiffness.m`：计算单元长度、方向余弦和刚度矩阵 `Ke`
- `truss3d_element_stress.m`：计算应变 `epsilon`、应力 `sigma` 和轴力 `N`
- `truss3d_element_matrix_properties.m`：检验单元刚度矩阵的对称性、奇异性、半正定性和刚体模态特性
- `run_homework_examples.m`：运行作业要求的两个算例

## 运行环境

- MATLAB R2021b

## 运行方法

1. 打开 MATLAB。
2. 将当前文件夹切换到本作业文件夹。
3. 在命令行输入：

```matlab
run_homework_examples
```

## 输出内容

脚本会输出两个规定算例的结果，包括：

- 单元长度 `L`
- 方向余弦
- 刚度矩阵 `Ke`
- 应变 `epsilon`
- 应力 `sigma`
- 轴力 `N`
- 节点力向量 `Fe = Ke * de`
- 单元刚度矩阵的性质检查结果
