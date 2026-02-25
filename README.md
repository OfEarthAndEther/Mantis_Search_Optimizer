# Mantis_Search_Optimizer

## Technical Analysis Report: Mantis Search Algorithm (MSA)
__Date__: February 25, 2026
__Subject__: Algorithmic Breakdown and Strategic Implementation of the Mantis Search Algorithm
__Repository Source__: [redamohamed8/Mantis-Search-Algorithm-MSA-](https://github.com/redamohamed8/Mantis-Search-Algorithm-MSA-)

### 1. Executive Summary
The Mantis Search Algorithm (MSA) is a high-performance, bio-inspired metaheuristic designed for global optimization. It simulates the unique predatory behavior and reproductive cycle of the praying mantis. This report provides a technical audit of the official source code, differentiates its operational modes (IterMSA vs. FESMSA), and outlines a roadmap for integrating the algorithm into Machine Learning workflows and advanced optimization frameworks.

### 2. Algorithmic Foundation and Methodology
The MSA operates by mimicking three distinct biological phases to balance Exploration (searching wide areas) and Exploitation (honing in on a solution).
- Phase I: Prey Search (Exploration): The population explores the search space using a mathematical control factor. This prevents the algorithm from getting trapped in local minima during the early stages.
- Phase II: Prey Attack (Exploitation): The search step size is reduced. The "mantis" agents move towards the current best-known position (the prey) with increasing precision.
- Phase III: Sexual Cannibalism: A unique stochastic operator that replaces low-performing agents with new coordinates derived from high-performing ones. This maintains population diversity and simulates the energy transfer seen in mantis mating.

### 3. Repository Architecture and Analysis
- 3.1 Analysis of IterMSA vs. FESMSA
- 3.2 File-Level Breakdown

## Machine Learning Application: Hyperparameter Tuning
MSA is highly effective in the domain of AutoML, specifically for optimizing non-differentiable hyperparameters in complex models.
- 4.1 Use Case: Gradient Boosted Trees (XGBoost) Optimization
In this application, the MSA is used to find the optimal configuration for a model's hyperparameters (e.g., $Learning\_Rate$, $Tree\_Depth$, $Subsample\_Ratio$).

The Optimization Pipeline:
  - Search Space Mapping: Define the range for each hyperparameter as the $lb$ and $ub$ in MSA.
  - Objective Function: The "fitness" of a mantis is defined as the Cross-Validation Error (e.g., RMSE or Log-Loss) of the XGBoost model.
  - Iteration: MSA moves the "mantises" (hyperparameter sets) through the search space until the model error is minimized.
  - Result: The "Best Position" found by MSA becomes the production configuration for the ML model.

## Innovation Roadmap: Playbook for Advanced Implementation
To enhance the baseline MSA code, the following innovative modifications are recommended:
<img width="663" height="418" alt="image" src="https://github.com/user-attachments/assets/65f8ed15-3916-44af-84b8-bdcca68f973e" />

## Usage

```
% Example: Running the optimizer on a Sphere Function
[Best_score, Best_pos, Convergence_curve] = MSA(30, 500, -100, 100, 30, @fobj);
plot(Convergence_curve);
```

## Citation
Abdel-Basset, M., Mohamed, R., et al. (2023). "Mantis Search Algorithm: A novel bio-inspired algorithm for global optimization and engineering design problems." Computer Methods in Applied Mechanics and Engineering.
