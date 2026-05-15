"""
PYNQ scaffold for FPGA-assisted streaming threshold checks.

This is a structural placeholder. To use on a PYNQ board:
1. Build the Verilog threshold module into a bitstream.
2. Load the overlay with pynq.Overlay().
3. Stream sensor samples through AXI interfaces.
4. Compare FPGA flags with software validation outputs.
"""

try:
    from pynq import Overlay
except ImportError:
    Overlay = None

def software_threshold(rainfall_mm_hr, river_stage_m, soil_saturation):
    return (rainfall_mm_hr >= 35.0 and soil_saturation >= 0.75) or river_stage_m >= 3.5

def main():
    sample = {
        "rainfall_mm_hr": 42.0,
        "river_stage_m": 3.1,
        "soil_saturation": 0.82
    }

    print("software_threshold=", software_threshold(**sample))

    if Overlay is None:
        print("PYNQ not available in this environment. Skipping overlay load.")
        return

    # overlay = Overlay("early_warning_threshold.bit")
    # TODO: connect AXI stream/register interface here.

if __name__ == "__main__":
    main()
