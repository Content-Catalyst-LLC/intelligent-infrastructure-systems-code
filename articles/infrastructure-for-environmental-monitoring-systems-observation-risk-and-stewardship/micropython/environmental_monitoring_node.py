"""
MicroPython scaffold for a low-power environmental monitoring node.

Replace read_pm25(), read_temperature(), read_battery_voltage(), and
send_payload() with board-specific sensor and network code for ESP32, RP2040,
LoRa, Wi-Fi, LTE-M, NB-IoT, or satellite modules.
"""

import time
import json

PM25_REVIEW_THRESHOLD = 35.0
TEMP_MIN_C = -40.0
TEMP_MAX_C = 70.0
BATTERY_MIN_V = 3.2

def read_pm25():
    return 36.2

def read_temperature():
    return 24.8

def read_battery_voltage():
    return 3.8

def quality_flag(pm25, temperature_c, battery_v):
    if pm25 < 0:
        return "range_fail"
    if temperature_c < TEMP_MIN_C or temperature_c > TEMP_MAX_C:
        return "range_fail"
    if battery_v < BATTERY_MIN_V:
        return "low_power"
    return "good"

def send_payload(payload):
    print(json.dumps(payload))

while True:
    pm25 = read_pm25()
    temperature_c = read_temperature()
    battery_v = read_battery_voltage()

    payload = {
        "node_id": "edge-environment-node-001",
        "domain": "air_quality",
        "pm25_ug_m3": pm25,
        "temperature_c": temperature_c,
        "battery_v": battery_v,
        "threshold_exceeded": pm25 >= PM25_REVIEW_THRESHOLD,
        "quality_flag": quality_flag(pm25, temperature_c, battery_v),
        "timestamp_ms": time.ticks_ms()
    }

    send_payload(payload)
    time.sleep(300)
