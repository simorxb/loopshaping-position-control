# Loop Shaping - Position Control

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=simorxb/loopshaping-position-control)

## Summary
This project demonstrates the design of a position controller using loop shaping techniques. The project utilizes MATLAB to design feedback controllers that balance performance and robustness through the `loopsyn` command.

## Project Overview
Loop shaping is a technique used to achieve the desired closed-loop behavior by shaping the open-loop transfer function. This project designs a feedback controller for a mass-damper system using the `loopsyn` function in MATLAB, which blends two loop-shaping methods:

- **Mixed-sensitivity design (mixsyn)**: Optimizes performance.
- **Glover-McFarlane method (ncfsyn)**: Maximizes robustness.

### Plant
The system being controlled is an object of mass $m = 10 \, \text{kg}$ sliding on a surface with viscous friction coefficient $k = 0.5 \, \text{N}\cdot\text{s/m}$, pushed by a force $F$. The dynamic equation is:

$$ \ddot{z} m = F - k \dot{z} $$

The transfer function of the plant is:

$$ G(s) = \frac{Z(s)}{F(s)} = \frac{1}{s(ms + k)} $$

### Objective
The goal is to design a controller $K(s)$ that achieves a closed-loop response as close as possible to the desired transfer function:

$$ T_d = \frac{1}{(\tau s + 1)^2} $$

where $\tau = 0.2$ seconds. The open-loop transfer function $L_d = K(s)G(s)$ is derived from:

$$ L_d = \frac{T_d}{1 - T_d} = \frac{1}{\tau^2 s^2 + 2\tau s} $$

### Design
Using the MATLAB `loopsyn` function, the design balances the trade-off between performance and robustness. The argument $\alpha \in [0, 1]$ controls this trade-off:
- Smaller $\alpha$ values favor performance (mixsyn design).
- Larger $\alpha$ values favor robustness (ncfsyn design).

This project compares results for $\alpha = 0.1$, $\alpha = 0.5$, and $\alpha = 0.9$.

### Comparison
The project compares the results using:
- Open-loop Bode diagrams for each value of $\alpha$.
- Closed-loop step responses.
- Control effort analysis.

The comparison reveals interesting trade-offs between performance and robustness in each case.

![Screenshot 2024-09-16 163606](https://github.com/user-attachments/assets/5b3bb5a0-09ef-4b51-a2bd-a0535ec5d99a)

![Screenshot 2024-09-16 163740](https://github.com/user-attachments/assets/3787cae7-8e15-4423-a148-811186ca64ec)

## Author
This project was developed by Simone Bertoni. Learn more about my work on my personal website - [Simone Bertoni - Control Lab](https://simonebertonilab.com/).

## Contact
For further communication, connect with me on [LinkedIn](https://www.linkedin.com/in/simone-bertoni-control-eng/).
