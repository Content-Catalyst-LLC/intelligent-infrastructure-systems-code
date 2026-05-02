from __future__ import annotations

import numpy as np


def simulate_asset_degradation(n_steps: int = 50) -> np.ndarray:
    degradation = np.zeros(n_steps)

    for t in range(1, n_steps):
        degradation[t] = degradation[t - 1] + 0.02 + np.random.normal(0, 0.005)

    return degradation


def main() -> None:
    degradation = simulate_asset_degradation()
    print({"final_degradation": float(degradation[-1])})


if __name__ == "__main__":
    main()
