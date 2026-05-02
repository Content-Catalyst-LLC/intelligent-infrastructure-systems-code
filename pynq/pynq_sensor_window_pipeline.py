from __future__ import annotations

import numpy as np


def make_sensor_window(n: int = 128) -> np.ndarray:
    return np.random.normal(loc=0.0, scale=1.0, size=n).astype(np.float32)


def main() -> None:
    window = make_sensor_window()
    print({"window_size": len(window), "mean": float(window.mean())})


if __name__ == "__main__":
    main()
