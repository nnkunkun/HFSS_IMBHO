# 代码、数据与天线工程文件说明 / README for Code, Data, and Antenna Engineering Files

生成日期 / Generated on: 2026-06-06

本文档用于解释 `整理_代码数据天线工程` 文件夹中各类内容的用途、相互关系和推荐使用方式。该目录整体上是一个“HFSS 天线仿真数据生成 + MATLAB 数据处理 + BHO/多目标优化实验”的工程整理包。

This document explains the purpose, relationship, and recommended usage of the contents in the `整理_代码数据天线工程` folder. Overall, the folder is an organized project package for "HFSS antenna simulation data generation + MATLAB data processing + BHO / multi-objective optimization experiments".

## 1. 总体结构 / Overall Structure

| 顶层目录 / Top-level folder | 主要内容 / Main contents | 作用 / Purpose |
| --- | --- | --- |
| `代码文件` | MATLAB 脚本、BHO 优化算法、CEC2020 测试代码、HFSS 天线数据加载与优化代码 | 用于生成参数样本、自动调用/读取 HFSS 仿真结果、构建代理优化问题、运行优化算法和输出分析结果 |
| `数据文件` | Dipole、Patch、Vivaldi、Yagi 的仿真 CSV、MAT、XLSX、PNG 结果，以及 BHO/CEC2020 实验数据 | 保存参数扫描、S11、增益、方向图、标量指标、汇总表和优化实验输出 |
| `天线工程文件` | HFSS/AEDT 工程文件 `.aedt` 及其 `.aedtresults` 求解结果目录 | 保存真实天线模型、仿真设置、网格、求解器中间文件和电磁仿真结果 |

Scanned summary:

| Folder | File count | Approx. size | Major file types |
| --- | ---: | ---: | --- |
| `代码文件` | 2597 | 8.15 MB | `.m`, `.mexw64`, `.cpp`, `.asv` |
| `数据文件` | 7522 | 254.4 MB | `.csv`, `.txt`, `.mat`, `.png`, `.xlsx`, `.dat`, `.ogg` |
| `天线工程文件` | 7933 | 1919.43 MB | `.aedt`, `.tmp`, `.mfsapip`, `.sd`, `.adp`, `.su`, `.stats`, `.ngmesh` |

## 2. 工程主线 / Project Workflow

中文说明：

本目录的工作流可以理解为五个阶段：

1. 在 HFSS/AEDT 中建立天线模型，例如偶极子、贴片、Vivaldi 和准八木天线。
2. 使用 MATLAB 脚本生成参数组合，常见方式是拉丁超立方采样。
3. 通过脚本驱动 HFSS 扫描不同结构参数，并导出 S11、增益、方向图等结果。
4. 将导出的 CSV 结果整理成汇总表、MAT 文件和图像。
5. 使用 BHO、NSGA-II、MOEA/D、NSGA-III、RVEA 等算法在数据集或代理模型上做单目标、多目标和多目标工程优化。

English explanation:

The workflow can be understood as five stages:

1. Build antenna models in HFSS/AEDT, such as dipole, patch, Vivaldi, and quasi-Yagi antennas.
2. Generate parameter combinations with MATLAB scripts, commonly by Latin hypercube sampling.
3. Drive HFSS parameter sweeps through scripts and export S11, gain, radiation pattern, and other results.
4. Process exported CSV files into summary tables, MAT files, and figures.
5. Run BHO, NSGA-II, MOEA/D, NSGA-III, RVEA, and related algorithms on the datasets or surrogate models for single-objective, bi-objective, tri-objective, and many-objective antenna optimization.

## 3. `代码文件` 说明 / Explanation of `代码文件`

### 3.1 `代码文件\BHO_yuan`

中文说明：

`BHO_yuan` 是算法和优化实验的核心代码区，主要包含三部分：

| 子目录 / 文件 | 作用 |
| --- | --- |
| `BHO_cec2020` | 面向 CEC2020 或多峰多目标基准函数的 BHO 算法测试与对比代码 |
| `BHO_hfss_antennas` | 把真实 HFSS 天线数据封装成优化问题，并运行 HFSS-BHO 或其他多目标算法的核心工程代码 |
| `external` | 外部算法/测试平台，例如 PlatEMO 和 2020 multimodal multi-objective benchmark，用于算法基线对比 |

English explanation:

`BHO_yuan` is the core algorithm and optimization experiment area. It mainly contains:

| Subfolder / file | Purpose |
| --- | --- |
| `BHO_cec2020` | BHO tests and comparisons on CEC2020 or multimodal multi-objective benchmark functions |
| `BHO_hfss_antennas` | Core engineering code that converts HFSS antenna datasets into optimization problems and runs HFSS-BHO or baseline multi-objective algorithms |
| `external` | External algorithm or benchmark packages, such as PlatEMO and the 2020 multimodal multi-objective benchmark, used for baseline comparisons |

### 3.2 `BHO_cec2020`

中文说明：

`BHO_cec2020` 用于验证 BHO 算法在标准数学测试问题上的性能。它不直接依赖 HFSS 天线工程，而是用于算法层面的基准测试。

| 子目录 / 文件 | 作用 |
| --- | --- |
| `BHO - Evaluation Count Version` | 以函数评价次数为预算的版本，适合与其他优化算法公平比较，因为优化算法常以评价次数为主要成本 |
| `BHO - Iteration Count Version` | 以迭代次数为预算的版本，适合理解算法迭代过程 |
| `cec2020` | CEC2020 相关测试函数、基线算法和 MEX 文件 |
| `BHO.m` | BHO 算法入口或兼容封装 |
| `BHO_multiobjective_core.m` | 多目标 BHO 的核心实现 |
| `run_cec2020_mmo_study.m` | 运行 CEC2020 多峰多目标实验 |
| `run_cec2020_mmo_ablation_study.m` | 运行消融实验，用于分析不同模块对算法表现的影响 |
| `compute_mo_metrics.m` | 计算多目标指标，例如 HV、IGD、Spread、Spacing 等 |
| `export_cec2020_mmo_report.m` | 导出实验报告或汇总结果 |
| `plot_cec2020_visualizations.m` | 绘制 CEC2020 实验图 |

English explanation:

`BHO_cec2020` is used to validate the BHO algorithm on standard mathematical benchmark problems. It is not directly tied to the HFSS antenna projects; instead, it supports algorithm-level benchmarking.

| Subfolder / file | Purpose |
| --- | --- |
| `BHO - Evaluation Count Version` | Version using function evaluation count as the budget, suitable for fair algorithm comparison |
| `BHO - Iteration Count Version` | Version using iteration count as the budget, useful for understanding iterative behavior |
| `cec2020` | CEC2020 test functions, baseline algorithms, and MEX files |
| `BHO.m` | BHO entry point or compatibility wrapper |
| `BHO_multiobjective_core.m` | Core implementation of multi-objective BHO |
| `run_cec2020_mmo_study.m` | Runs CEC2020 multimodal multi-objective experiments |
| `run_cec2020_mmo_ablation_study.m` | Runs ablation studies to analyze the effect of algorithm modules |
| `compute_mo_metrics.m` | Computes multi-objective metrics such as HV, IGD, Spread, and Spacing |
| `export_cec2020_mmo_report.m` | Exports experiment reports or summary results |
| `plot_cec2020_visualizations.m` | Generates CEC2020 experiment figures |

### 3.3 `BHO_hfss_antennas`

中文说明：

`BHO_hfss_antennas` 是把天线仿真数据转换为优化问题的核心。它把 Dipole、Patch、Vivaldi、Yagi 四类天线数据分别定义为 P1-P4 问题，并使用 IDW 等代理/映射方法减少直接调用 HFSS 的成本。

| 子目录 / 文件 | 作用 |
| --- | --- |
| `main_hfss_antenna_demo.m` | 快速演示入口 |
| `run_hfss_antenna_study.m` | 主实验入口；运行四个 HFSS 天线优化问题并输出结果 |
| `startup_hfss_paths.m` | 设置 MATLAB 路径，保证算法、数据、问题和工具函数可被调用 |
| `algorithms` | HFSS-BHO、单目标/多目标运行器、代理细化和 PlatEMO 基线调用 |
| `data` | 数据加载器，把 CSV/MAT 汇总数据转换成统一 `dataset` 结构 |
| `problems` | 问题定义器，把数据集封装为 P1-P4 优化问题 |
| `utils` | 指标计算、S11 带宽计算、HPBW 计算、非支配筛选、IDW 预测、结果导出和绘图 |

English explanation:

`BHO_hfss_antennas` is the core code that converts antenna simulation datasets into optimization problems. It defines Dipole, Patch, Vivaldi, and Yagi as P1-P4 problems and uses surrogate or mapping methods such as IDW to reduce the cost of direct HFSS calls.

| Subfolder / file | Purpose |
| --- | --- |
| `main_hfss_antenna_demo.m` | Quick demo entry point |
| `run_hfss_antenna_study.m` | Main experiment entry point for the four HFSS antenna optimization problems |
| `startup_hfss_paths.m` | Sets MATLAB paths so algorithms, data loaders, problems, and utilities are available |
| `algorithms` | HFSS-BHO runners, single/multi-objective optimization logic, surrogate refinement, and PlatEMO baselines |
| `data` | Dataset loaders that convert CSV/MAT summary data into unified `dataset` structures |
| `problems` | Problem builders that wrap datasets into P1-P4 optimization problems |
| `utils` | Metric computation, S11 bandwidth, HPBW calculation, non-dominated sorting, IDW prediction, result export, and plotting |

### 3.4 `代码文件\Dipole`, `Patch`, `Vivaldi`, `Yagi`

中文说明：

这四个目录是按天线类型组织的 MATLAB 自动化仿真/数据生成脚本。它们的结构相似，通常位于各自的 `DATA` 子目录内。

| 脚本 | 作用 |
| --- | --- |
| `main_parameter_sweep.m` / `main_parameter_sweep_fixed.m` | 参数扫描主程序，负责组织采样、调用 HFSS、读取结果并记录进度 |
| `main_vivaldi_parameter_sweep.m` | Vivaldi 天线专用参数扫描主程序 |
| `generate_param_combinations.m` | 生成参数组合 |
| `latin_hypercube_sampling.m` | 拉丁超立方采样，用于在参数空间中较均匀地选择仿真样本 |
| `run_hfss_simulation.m` | 调用 HFSS/AEDT 执行单次仿真 |
| `generate_export_script.m` | 生成 HFSS 导出脚本，用于把 S11、增益或方向图数据导出为 CSV |
| `read_hfss_csv.m` | 读取 HFSS 导出的 CSV |
| `record_simulation_results.m` | 记录每次仿真的参数、输出文件和成功状态 |
| `initialize_results_log.m` | 初始化结果日志 |
| `add_gain_to_existing_results.m` | 给已有结果补充增益字段或增益曲线 |
| `regenerate_combined_with_gain.m` | 重新生成包含增益的综合结果表 |
| `verify_exported_files.m` | 检查导出的 CSV 是否存在、格式是否满足后续处理需求 |
| `visualize_lhs_sampling.m` | 绘制采样分布图 |

English explanation:

These four folders contain MATLAB automation scripts for simulation and data generation, grouped by antenna type. Their structures are similar and the scripts are usually stored in each antenna's `DATA` subfolder.

| Script | Purpose |
| --- | --- |
| `main_parameter_sweep.m` / `main_parameter_sweep_fixed.m` | Main parameter sweep program; coordinates sampling, HFSS calls, result reading, and progress logging |
| `main_vivaldi_parameter_sweep.m` | Vivaldi-specific parameter sweep entry point |
| `generate_param_combinations.m` | Generates parameter combinations |
| `latin_hypercube_sampling.m` | Latin hypercube sampling for more uniform sample coverage in the parameter space |
| `run_hfss_simulation.m` | Calls HFSS/AEDT to run one simulation |
| `generate_export_script.m` | Generates HFSS export scripts for S11, gain, or radiation-pattern CSV output |
| `read_hfss_csv.m` | Reads CSV files exported by HFSS |
| `record_simulation_results.m` | Records simulation parameters, output files, and success status |
| `initialize_results_log.m` | Initializes result logs |
| `add_gain_to_existing_results.m` | Adds gain fields or gain curves to existing results |
| `regenerate_combined_with_gain.m` | Rebuilds combined result tables with gain data |
| `verify_exported_files.m` | Checks whether exported CSV files exist and meet processing requirements |
| `visualize_lhs_sampling.m` | Plots sampling distribution figures |

## 4. `数据文件` 说明 / Explanation of `数据文件`

### 4.1 数据文件的总体作用 / Overall purpose of data files

中文说明：

`数据文件` 保存的是仿真和优化所依赖的数据资产。它既包含每次 HFSS 仿真的原始曲线，也包含清洗后的曲线、标量指标、汇总表、MATLAB 进度文件和可视化图片。该目录通常是算法实验最常访问的数据来源。

English explanation:

`数据文件` stores the data assets used by simulation and optimization. It includes raw curves from each HFSS simulation, cleaned curves, scalar metrics, summary tables, MATLAB progress files, and visualization images. This folder is usually the main data source for algorithm experiments.

### 4.2 天线数据目录 / Antenna data folders

| 目录 / Folder | 主要内容 / Main contents | 作用 / Purpose |
| --- | --- | --- |
| `数据文件\Dipole\DATA` | `Dipole results`, `lhs_sampling_distribution.png`, `parameter_distributions.png` | 偶极子天线参数扫描结果、采样分布图、参数分布图 |
| `数据文件\Patch\DATA` | `Patch results`, `lhs_sampling_distribution.png`, `parameter_distributions.png` | 贴片天线参数扫描结果、采样和参数分布图 |
| `数据文件\Vivaldi\DATA` | `Vivaldi results`, `lhs_sampling_distribution.png`, `parameter_distributions.png` | Vivaldi 宽带天线参数扫描结果、采样和参数分布图 |
| `数据文件\Yagi\DATA` | `Yagi results`, `lhs_sampling_distribution.png`, `parameter_distributions.png` | 准八木天线参数扫描结果、采样和参数分布图 |

### 4.3 常见结果文件 / Common result files

中文说明：

不同天线的数据文件命名不完全相同，但整体含义一致：

| 文件模式 / File pattern | 作用 |
| --- | --- |
| `sim_001_S11.csv`, `SIM001_S11.csv` | 单次仿真的 S11 频率响应曲线 |
| `sim_001_Gain.csv`, `SIM001_Gain.csv` | 单次仿真的增益曲线 |
| `sim_001_GainPhi0.csv`, `sim_001_GainPhi90.csv` | Yagi 等方向图相关数据中不同切面的增益曲线 |
| `sim_001_patterns.csv` | 方向图数据，通常包含角度、切面和增益 |
| `sim_001_scalar_metrics.csv` | 单次仿真的标量指标，例如主瓣增益、旁瓣电平、HPBW、中心频点 S11 等 |
| `sim_001_four_objectives.csv` | Yagi 等多目标问题中的四目标数值 |
| `sim_001_combined_results.csv` | 单次仿真的参数、频率曲线和指标合并结果 |
| `all_simulations_combined.csv` | 所有仿真的综合数据表，是后续数据加载器常用的输入 |
| `all_s11_data.csv`, `all_gain_data.csv`, `all_simulations_s11.csv`, `all_simulations_patterns.csv` | 所有仿真的某一类曲线汇总 |
| `final_simulation_log.csv`, `simulation_progress.csv`, `successful_simulations.csv` | 仿真日志、进度记录和成功仿真列表 |
| `final_simulation_log.xlsx`, `summary_metrics.xlsx` | Excel 形式的汇总结果，便于人工查看 |
| `progress.mat`, `final_results.mat`, `summary_metrics.mat` | MATLAB 保存的进度、最终结果和汇总指标 |
| `lhs_sampling_distribution.png`, `parameter_distributions.png` | 采样质量和参数分布可视化图片 |

English explanation:

File names vary slightly across antenna types, but their meanings are consistent:

| File pattern | Purpose |
| --- | --- |
| `sim_001_S11.csv`, `SIM001_S11.csv` | S11 frequency response from one simulation |
| `sim_001_Gain.csv`, `SIM001_Gain.csv` | Gain curve from one simulation |
| `sim_001_GainPhi0.csv`, `sim_001_GainPhi90.csv` | Gain curves for different radiation-pattern cuts, especially in Yagi data |
| `sim_001_patterns.csv` | Radiation-pattern data, usually including angle, cut name, and gain |
| `sim_001_scalar_metrics.csv` | Scalar metrics for one simulation, such as main gain, side-lobe level, HPBW, and S11 at the center frequency |
| `sim_001_four_objectives.csv` | Four-objective values for many-objective problems such as Yagi |
| `sim_001_combined_results.csv` | Combined parameters, frequency curves, and metrics for one simulation |
| `all_simulations_combined.csv` | Combined table for all simulations; commonly used by data loaders |
| `all_s11_data.csv`, `all_gain_data.csv`, `all_simulations_s11.csv`, `all_simulations_patterns.csv` | Aggregated curve data across all simulations |
| `final_simulation_log.csv`, `simulation_progress.csv`, `successful_simulations.csv` | Simulation logs, progress records, and successful simulation lists |
| `final_simulation_log.xlsx`, `summary_metrics.xlsx` | Excel summaries for manual inspection |
| `progress.mat`, `final_results.mat`, `summary_metrics.mat` | MATLAB progress, final result, and summary metric files |
| `lhs_sampling_distribution.png`, `parameter_distributions.png` | Figures for sampling quality and parameter distributions |

### 4.4 `数据文件\BHO_yuan`

中文说明：

`数据文件\BHO_yuan` 保存与 BHO 算法实验相关的结果数据。它包括 CEC2020 基准实验数据、外部算法数据，以及从 Dipole、Patch、Vivaldi、Yagi 天线数据派生出的优化实验结果。

English explanation:

`数据文件\BHO_yuan` stores data related to BHO algorithm experiments. It includes CEC2020 benchmark results, external algorithm data, and optimization experiment outputs derived from the Dipole, Patch, Vivaldi, and Yagi antenna datasets.

## 5. `天线工程文件` 说明 / Explanation of `天线工程文件`

中文说明：

`天线工程文件` 是 HFSS/AEDT 工程的原始模型和求解结果位置。这里的 `.aedt` 文件是可在 Ansys Electronics Desktop / HFSS 中打开的工程文件，`.aedtresults` 文件夹保存对应工程的求解结果和中间文件。

English explanation:

`天线工程文件` contains the original HFSS/AEDT engineering models and solver outputs. The `.aedt` files can be opened in Ansys Electronics Desktop / HFSS, and the `.aedtresults` folders store solver results and intermediate files for the corresponding projects.

| 天线目录 / Antenna folder | 工程文件 / Project files | 作用 / Purpose |
| --- | --- | --- |
| `Dipole` | `WireDipole_ATK.aedt`, `yuan.aedt` | 偶极子天线 HFSS 工程及其结果 |
| `Patch` | `EllipticalProbe_ATK.aedt` | 贴片/探针馈电相关天线 HFSS 工程及其结果 |
| `Vivaldi` | `Vivaldi_ATK.aedt` | Vivaldi 宽带天线 HFSS 工程及其结果 |
| `Yagi` | `Quasi_Yagi_ATK.aedt`, `Quasi_Yagi_ATK.before_objective_outputs.aedt` | 准八木天线 HFSS 工程及目标输出前版本 |

常见 HFSS 结果文件类型：

| 文件类型 / File type | 作用 / Purpose |
| --- | --- |
| `.aedt` | AEDT/HFSS 工程文件，包含模型、材料、边界、端口、求解设置等 |
| `.aedtresults` | HFSS 工程结果目录，包含求解数据和中间文件 |
| `.asol` | Analysis solution 信息 |
| `.tmp` | HFSS 求解过程临时文件 |
| `.sd`, `.adp` | 求解/自适应网格相关数据 |
| `.ngmesh`, `.cmesh`, `.stats` | 网格和求解统计信息 |
| `.sf_msh`, `.sf_fld_0`, `fields.*` | 场数据、表面网格和后处理场结果 |
| `.mfsapip`, `.su`, `.dat`, `.input` | 求解器输入、中间矩阵/过程文件或内部数据 |

注意 / Note:

不要随意删除 `.aedtresults` 中的文件。它们虽然很多是中间文件，但可能被 HFSS 用于继续求解、恢复工程状态或查看已有结果。

Do not casually delete files inside `.aedtresults`. Many of them are intermediate files, but HFSS may need them to continue solving, restore project state, or inspect existing results.

## 6. 四个天线优化问题 / Four Antenna Optimization Problems

以下信息来自 `代码文件\BHO_yuan\BHO_hfss_antennas\data` 中的数据加载脚本。

The following information is based on the dataset loader scripts under `代码文件\BHO_yuan\BHO_hfss_antennas\data`.

| 问题 / Problem | 天线 / Antenna | 设计变量 / Design variables | 目标 / Objectives |
| --- | --- | --- | --- |
| P1 | Dipole | `dipole_length`, `wire_rad`, `port_gap` | 单目标：最小化中心频率处的 `|S11(f0)|`；代码中 f0 约为 0.9 GHz |
| P2 | Patch Antenna | `patchX`, `patchY`, `subH`, `feedX`, `feedLength` | 双目标：最小化 `|S11(f0)|`，同时最大化增益；在优化中写成 `min [|S11(f0)|, -Gain(f0)]`，代码中 f0 约为 12 GHz |
| P3 | Vivaldi Antenna | `Wslot`, `Wtaper`, `Ltapper`, `Wbalun`, `Wstrip`, `Lstrip_offset` | 三目标：降低平均 `|S11|`，提高增益代理值，提高带宽；在优化中写成 `min [mean(|S11|), -Gain proxy, -BW]` |
| P4 | Yagi-Uda | `Ldir`, `Ldri`, `L1`, `Sdir`, `Sref`, `Wdri` | 四目标：提高主瓣增益、降低旁瓣、控制 HPBW、降低中心频率处 `|S11|`；在优化中写成 `min [-Gmain, SLL, HPBW, |S11(f0)|]`，代码中 f0 约为 2.25 GHz |

English notes:

| Problem | Antenna | Design variables | Objectives |
| --- | --- | --- | --- |
| P1 | Dipole | `dipole_length`, `wire_rad`, `port_gap` | Single objective: minimize `|S11(f0)|`; f0 is about 0.9 GHz in the code |
| P2 | Patch Antenna | `patchX`, `patchY`, `subH`, `feedX`, `feedLength` | Bi-objective: minimize `|S11(f0)|` and maximize gain, represented as `min [|S11(f0)|, -Gain(f0)]`; f0 is about 12 GHz |
| P3 | Vivaldi Antenna | `Wslot`, `Wtaper`, `Ltapper`, `Wbalun`, `Wstrip`, `Lstrip_offset` | Tri-objective: reduce mean `|S11|`, improve gain proxy, and improve bandwidth, represented as `min [mean(|S11|), -Gain proxy, -BW]` |
| P4 | Yagi-Uda | `Ldir`, `Ldri`, `L1`, `Sdir`, `Sref`, `Wdri` | Four-objective: improve main gain, reduce side-lobe level, control HPBW, and reduce `|S11(f0)|`, represented as `min [-Gmain, SLL, HPBW, |S11(f0)|]`; f0 is about 2.25 GHz |

## 7. 推荐阅读和运行顺序 / Recommended Reading and Running Order

中文建议：

1. 如果只是想理解项目结构，先读本文档。
2. 如果想看天线模型，打开 `天线工程文件` 中对应的 `.aedt`。
3. 如果想看已有仿真数据，进入 `数据文件\<天线>\DATA\<天线> results`。
4. 如果想重新生成数据，查看 `代码文件\<天线>\DATA\main_parameter_sweep*.m`。
5. 如果想运行优化实验，查看 `代码文件\BHO_yuan\BHO_hfss_antennas\run_hfss_antenna_study.m`。
6. 如果想验证算法本身，查看 `代码文件\BHO_yuan\BHO_cec2020`。

English recommendations:

1. To understand the project structure, start with this document.
2. To inspect antenna models, open the corresponding `.aedt` files under `天线工程文件`.
3. To inspect existing simulation data, open `数据文件\<antenna>\DATA\<antenna> results`.
4. To regenerate data, check `代码文件\<antenna>\DATA\main_parameter_sweep*.m`.
5. To run antenna optimization experiments, check `代码文件\BHO_yuan\BHO_hfss_antennas\run_hfss_antenna_study.m`.
6. To validate the optimization algorithm itself, check `代码文件\BHO_yuan\BHO_cec2020`.

## 8. 使用注意事项 / Usage Notes

中文说明：

- MATLAB 脚本通常依赖当前工作目录和相对路径。运行前建议先打开脚本所在目录，或运行对应的 `startup_hfss_paths.m`。
- 重新跑 HFSS 参数扫描需要安装 Ansys Electronics Desktop / HFSS，并保证脚本中的工程路径、导出路径和变量名与实际工程一致。
- `数据文件` 中某些 CSV 路径仍保留旧路径字符串，例如 `W:\Formal\Dipole\DATA\results\...`。移动目录后读取脚本可能需要改路径或使用新的根目录映射。
- `天线工程文件` 体积较大，主要来自 `.aedtresults` 求解结果。备份时建议保留 `.aedt` 和关键汇总数据；如果要完整复现实验，则也要保留 `.aedtresults`。
- `external` 中的 PlatEMO 和 benchmark 代码属于外部依赖或基线算法，不建议直接修改，除非明确要改基线实验。
- `Yagi\DATA\main_parameter_sweep_fixed.m` 文件很小，而同目录存在 `main_parameter_sweep_fixed.asv` 自动保存文件；若要使用 fixed 版本，需要检查 `.m` 是否完整。

English notes:

- MATLAB scripts often depend on the current working directory and relative paths. Before running them, open the script directory or run the related `startup_hfss_paths.m`.
- Regenerating HFSS parameter sweeps requires Ansys Electronics Desktop / HFSS, and the project paths, export paths, and variable names in scripts must match the actual projects.
- Some CSV files in `数据文件` still contain older path strings such as `W:\Formal\Dipole\DATA\results\...`. After moving the folder, loaders may need path fixes or root-directory remapping.
- `天线工程文件` is large mainly because of `.aedtresults`. For backup, keep `.aedt` and key summary data; for full reproducibility, keep `.aedtresults` as well.
- PlatEMO and benchmark code under `external` are external dependencies or baseline algorithms. Avoid modifying them unless you are intentionally changing baseline experiments.
- `Yagi\DATA\main_parameter_sweep_fixed.m` is very small, while `main_parameter_sweep_fixed.asv` exists in the same folder. If you need the fixed version, check whether the `.m` file is complete.

## 9. 简短结论 / Short Conclusion

中文总结：

这个文件夹不是单纯的数据备份，而是一个完整的天线优化研究工程。`天线工程文件` 提供真实 HFSS 模型，`代码文件` 提供数据生成和优化算法，`数据文件` 保存仿真样本、指标和优化所需的数据集。三者需要一起理解：工程文件负责“物理真实性”，数据文件负责“可重复分析”，代码文件负责“自动化生成和优化”。

English summary:

This folder is not just a data backup; it is a complete antenna optimization research package. `天线工程文件` provides the real HFSS models, `代码文件` provides data-generation and optimization code, and `数据文件` stores simulation samples, metrics, and datasets for optimization. The three parts should be understood together: engineering files provide physical fidelity, data files provide reproducible analysis, and code files provide automation and optimization.
