"""
MicroPython scaffold for a low-power grid-edge monitoring node.
Replace read_* and send_payload with board-specific ESP32, RP2040, LoRa,
Wi-Fi, LTE-M, NB-IoT, or satellite code.
"""

import time
import json

MIN_VOLTAGE_PU = 0.95
MAX_VOLTAGE_PU = 1.05
MIN_FREQUENCY_HZ = 59.95
MAX_FREQUENCY_HZ = 60.05
MAX_LOADING = 0.95
BATTERY_MIN_V = 3.2

def read_voltage_pu():
    return 0.94

def read_frequency_hz():
    return 59.97

def read_loading_percent():
    return 0.96

def read_battery_voltage():
    return 3.8

def quality_flag(voltage_pu, frequency_hz, loading_percent, battery_v):
    if voltage_pu < MIN_VOLTAGE_PU or voltage_pu > MAX_VOLTAGE_PU:
        return "voltage_review"
    if frequency_hz < MIN_FREQUENCY_HZ or frequency_hz > MAX_FREQUENCY_HZ:
        return "frequency_review"
    if loading_percent > MAX_LOADING:
        return "loading_review"
    if battery_v < BATTERY_MIN_V:
        return "low_power"
    return "good"

def send_payload(payload):
    print(json.dumps(payload))

while True:
    voltage = read_voltage_pu()
    frequency = read_frequency_hz()
    loading = read_loading_percent()
    battery_v = read_battery_voltage()

    payload = {
        "node_id": "edge-grid-quality-node-001",
        "asset_id": "SG-TRF-001",
        "voltage_pu": voltage,
        "frequency_hz": frequency,
        "loading_percent": loading,
        "battery_v": battery_v,
        "quality_flag": quality_flag(voltage, frequency, loading, battery_v),
        "timestamp_ms": time.ticks_ms()
    }

    send_payload(payload)
    time.sleep(300)
