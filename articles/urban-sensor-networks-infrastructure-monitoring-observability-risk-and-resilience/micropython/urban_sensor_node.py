"""
MicroPython scaffold for a low-power urban sensing node.
Replace read_* and send_payload with board-specific ESP32, RP2040, LoRa,
Wi-Fi, LTE-M, NB-IoT, or satellite code.
"""

import time
import json

PM25_REVIEW_THRESHOLD = 35.0
WATER_LEVEL_REVIEW_THRESHOLD_M = 1.5
BATTERY_MIN_V = 3.2

def read_pm25():
    return 36.8

def read_water_level():
    return 1.9

def read_battery_voltage():
    return 3.8

def quality_flag(pm25, water_level_m, battery_v):
    if pm25 < 0 or water_level_m < 0:
        return "range_fail"
    if battery_v < BATTERY_MIN_V:
        return "low_power"
    return "good"

def send_payload(payload):
    print(json.dumps(payload))

while True:
    pm25 = read_pm25()
    water_level_m = read_water_level()
    battery_v = read_battery_voltage()

    payload = {
        "node_id": "edge-urban-sensor-node-001",
        "pm25_ug_m3": pm25,
        "water_level_m": water_level_m,
        "battery_v": battery_v,
        "pm25_threshold_exceeded": pm25 >= PM25_REVIEW_THRESHOLD,
        "water_level_threshold_exceeded": water_level_m >= WATER_LEVEL_REVIEW_THRESHOLD_M,
        "quality_flag": quality_flag(pm25, water_level_m, battery_v),
        "timestamp_ms": time.ticks_ms()
    }

    send_payload(payload)
    time.sleep(300)
