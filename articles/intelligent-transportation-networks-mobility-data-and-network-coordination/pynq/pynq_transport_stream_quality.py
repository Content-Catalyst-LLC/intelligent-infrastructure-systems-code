"""
PYNQ scaffold for FPGA-assisted transportation telemetry checks.
Build the Verilog module into a bitstream and connect it through AXI.
"""

try:
    from pynq import Overlay
except ImportError:
    Overlay = None

def software_transport_check(speed_kph, min_speed_kph, latency_seconds, max_latency_seconds=120, battery_v=3.8):
    if speed_kph < 0 or battery_v < 3.2 or latency_seconds > max_latency_seconds:
        return False
    return speed_kph >= min_speed_kph

def main():
    print("software_speed_ok=", software_transport_check(24.0, 30.0, 34))

    if Overlay is None:
        print("PYNQ not available in this environment. Skipping overlay load.")
        return

    # overlay = Overlay("transportation_quality_check.bit")
    # TODO: connect AXI stream/register interface here.

if __name__ == "__main__":
    main()
