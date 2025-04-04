# 动态多目标优化算法实现 <br>
# 后续会不断更新相关算法，如有问题请通过本人邮箱进行联系！
## 1. Algorithms中包含以下算法
* **Tr-DMOEA** <br>
  M. Jiang, Z. Huang, L. Qiu, W. Huang, and G. G. Yen, "Transfer Learning-Based Dynamic Multiobjective Optimization Algorithms," IEEE Transactions on Evolutionary Computation, vol. 22, no. 4, pp. 501-514, 2018, doi: 10.1109/TEVC.2017.2771451.
* **KT-DMOEA** <br>
  M. Jiang, Z. Wang, H. Hong, and G. G. Yen, "Knee Point-Based Imbalanced Transfer Learning for Dynamic Multiobjective Optimization," IEEE Transactions on Evolutionary Computation, vol. 25, no. 1, pp. 117-129, 2021, doi: 10.1109/TEVC.2020.3004027.
* **MMTL-DMOEA** <br>
  M. Jiang, Z. Wang, L. Qiu, S. Guo, X. Gao, and K. C. Tan, "A Fast Dynamic Evolutionary Multiobjective Algorithm via Manifold Transfer Learning," IEEE T. Cybern., vol. 51, no. 7, pp. 3417-3428, 2021, doi: 10.1109/TCYB.2020.2989465.
* **IGP-DMOEA** <br>
  H. Zhang, J. Ding, M. Jiang, K. C. Tan, and T. Chai, "Inverse Gaussian Process Modeling for Evolutionary Dynamic Multiobjective Optimization," IEEE T. Cybern., vol. 52, no. 10, pp. 11240-11253, 2022, doi: 10.1109/TCYB.2021.3070434.
* **KTM-DMOEA** <br>
  Q. Lin, Y. Ye, L. Ma, M. Jiang, and K. C. Tan, "Dynamic Multiobjective Evolutionary Optimization via Knowledge Transfer and Maintenance," IEEE Transactions on Systems, Man, and Cybernetics: Systems, vol. 54, no. 2, pp. 936-949, 2024, doi: 10.1109/TSMC.2023.3322718.
* **DIP-DMOEA** <br>
  Y. Ye, S. Liu, J. Zhou, Q. Lin, M. Jiang, and K. C. Tan, "Learning-Based Directional Improvement Prediction for Dynamic Multiobjective Optimization," IEEE Transactions on Evolutionary Computation, pp. 1-1, 2024, doi: 10.1109/TEVC.2024.3393151.
## 2. 文件和文件夹功能说明
### 文件夹
 **"Algorithm":** 包含所有的DMOEAs。 <br>
 **"Benchmark":** 包含CEC2018动态多目标优化问题的测试函数。 <br>
 **"Metrics":**  动态多目标优化算法的评估指标，例如IGD,HV等。 <br>
 **"public":** 执行程序所需要的公共文件。 <br>
### 文件
**"mian.m":** 执行程序的主函数 <br>
**"configure.m":** 参数配置文件 <br>
**"SelectAlgorithms.m"** 算法调用函数文件 <br>
**"computeMetrics.m":** 计算评估指标文件 <br>
**"dataOutput.m":** 数据输出处理文件 <br>
**"dataProcess.m":** 数据处理成excel格式文件 <br>
**"drawPlots.m":** 数据绘图文件 <br>
## 3. 执行之前操作（重点）
执行/Benchmark/CreatTrueDFPOF.m,获得测试函数的真实POF。
