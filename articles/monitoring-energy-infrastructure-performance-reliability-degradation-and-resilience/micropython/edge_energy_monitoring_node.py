"""
MicroPython scaffold for a low-power energy infrastructure monitoring node.
Replace read_* and send_payload with board-specific ESP32, RP2040, LoRa,
Wi-Fi, LTE-M, NB-IoT, or satellite code.
"""

import time
import json

MIN_VOLTAGE_PU = 0.95
MAX_VOLTAGE_PU = 1.05
MAX_TEMPERATURE_C = 70.0
MAX_LOADING = 0.95
BATTERY_MIN_V = 3.2

def read_voltage_pu():
    return 0.95

def read_temperature_c():
    return 71.0

def read_loading_percent():
    return 0.96

def read_battery_voltage():
    return 3.8

def quality_flag(voltage_pu, temperature_c, loading_percent, battery_v):
    if voltage_pu < MIN_VOLTAGE_PU or voltage_pu > MAX_VOLTAGE_PU:
        return "voltage_review"
    if temperature_c > MAX_TEMPERATURE_C:
        return "thermal_review"
    if loading_percent > MAX_LOADING:
        return "loading_review"
    if battery_v < BATTERY_MIN_V:
        return "low_power"
    return "good"

def send_payload(payload):
    print(json.dumps(payload))

while True:
    voltage_pu = read_voltage_pu()
    temperature_c = read_temperature_c()
    loading_percent = read_loading_percent()
    battery_v = read_battery_voltage()

    payload = {
        "node_id": "edge-energy-monitor-001",
        "asset_id": "EN-TRF-001",
        "voltage_pu": voltage_pu,
        "temperature_c": temperature_c,
        "loading_percent": loading_percent,
        "battery_v": battery_v,
        "quality_flag": quality_flag(voltage_pu, temperature_c, loading_percent, battery_v),
        "timestamp_ms": time.ticks_ms()
    }

    send_payload(payload)
    time.sleep(300)
