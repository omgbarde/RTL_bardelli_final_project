# VHDL Sine Function Calculator

Welcome to the **VHDL Sine Function Calculator** repository! 

🎯 This project implements a **sine function calculator** using **interpolation** in VHDL, designed for FPGA-based applications requiring efficient trigonometric computations.

## 🚀 Project Overview
This project leverages **piecewise linear interpolation** to compute sine values with high accuracy while minimizing hardware complexity. The implementation is optimized for **speed and resource efficiency**, making it suitable for real-time applications.

The module leverages the following trigonometric identities:

  $sin⁡(\theta)=sin⁡(180-\theta)$  se  $\theta \in (90;180]$

  $sin⁡(\theta)=-sin⁡(\theta-180)$  se $\theta \in (180;270]$

  $sin⁡(\theta)= -sin⁡(360-\theta)$  se $\theta \in (270;360]$

  Using the line equation given two points to interpolate:

  $y=y_0 + \frac{(x-x_0)(y_1-y_0)}{8}$

Block Diagram for the component:

![image](https://github.com/user-attachments/assets/5ea94abe-77dd-4756-b86a-7134e3a16e1a)

## 🛠️ Features
- ✅ VHDL implementation of a **sine function calculator**.
- 🔢 **Interpolation-based computation**.
- 🛠️ **Verifier** to validate correctness.

Example of interpolation:

![image](https://github.com/user-attachments/assets/22c317f5-88dc-4da3-baf4-a441793c20a3)

## 📜 Documentation
For a detailed explanation of the architecture, design choices, and implementation details, check out the full **project documentation**:
📄 [Project Documentation (PDF)](https://github.com/omgbarde/RTL_bardelli_final_project/blob/main/Relazione%20Bardelli.pdf)

## 🔍 Verification
A dedicated **verifier** is included to ensure correctness and evaluate precision. This program compares the generated sine values using the same logic implemented in VHDL against reference values, providing error analysis and performance metrics.

## 📁 Repository Structure
- **sources/** - VHDL source files.
- **sim/** - Testbenches for functional verification.
- **verifier.c/** - Test script.

---
Feel free to explore, contribute, or provide feedback! 🚀


