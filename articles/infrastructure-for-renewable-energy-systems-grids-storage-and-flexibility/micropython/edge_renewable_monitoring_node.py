"""
MicroPython scaffold for a low-power renewable energy monitoring node.
Replace read_* and send_payload with board-specific ESP32, RP2040, LoRa,
Wi-Fi, LTE-M, NB-IoT, or satellite code.
"""

import time
import json

MIN_VOLTAGE_PU = 0.95
MAX_VOLTAGE_PU = 1.05
MAX_INVERTER_TEMP_C = 70.0
BATTERY_MIN_V = 3.2

def read_voltage_pu():
    return 0.96

def read_actual_generation_mw():
    return 118.0

def read_forecast_generation_mw():
    return 135.0

def read_inverter_temperature_c():
    return 58.0

def read_battery_voltage():
    return 3.8

def quality_flag(voltage_pu, actual_generation_mw, forecast_generation_mw, inverter_temp_c, battery_v):
    if voltage_pu < MIN_VOLTAGE_PU or voltage_pu > MAX_VOLTAGE_PU:
        return "voltage_review"
    if inverter_temp_c > MAX_INVERTER_TEMP_C:
        return "thermal_review"
    if actual_generation_mw < 0 or forecast_generation_mw < 0:
        return "generation_range_fail"
    if forecast_generation_mw > 0 and abs(forecast_generation_mw - actual_generation_mw) / forecast_generation_mw > 0.25:
        return "forecast_review"
    if battery_v < BATTERY_MIN_V:
        return "low_power"
    return "good"

def send_payload(payload):
    print(json.dumps(payload))

while True:
    voltage_pu = read_voltage_pu()
    actual_generation_mw = read_actual_generation_mw()
    forecast_generation_mw = read_forecast_generation_mw()
    inverter_temp_c = read_inverter_temperature_c()
    battery_v = read_battery_voltage()

    payload = {
        "node_id": "edge-renewable-monitor-001",
        "asset_id": "RE-WND-001",
        "voltage_pu": voltage_pu,
        "actual_generation_mw": actual_generation_mw,
        "forecast_generation_mw": forecast_generation_mw,
        "forecast_error_mw": abs(forecast_generation_mw - actual_generation_mw),
        "inverter_temperature_c": inverter_temp_c,
        "battery_v": battery_v,
        "quality_flag": quality_flag(voltage_pu, actual_generation_mw, forecast_generation_mw, inverter_temp_c, battery_v),
        "timestamp_ms": time.ticks_ms()
    }

    send_payload(payload)
    time.sleep(300)
