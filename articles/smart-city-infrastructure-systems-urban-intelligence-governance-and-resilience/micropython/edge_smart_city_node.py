"""
MicroPython scaffold for a low-power smart city infrastructure monitoring node.
Replace read_* and send_payload with board-specific ESP32, RP2040, LoRa,
Wi-Fi, LTE-M, NB-IoT, or satellite code.
"""

import time
import json

MIN_SERVICE_CONTINUITY = 0.75
BATTERY_MIN_V = 3.2

def read_observed_service_capacity():
    return 0.58

def read_normal_service_capacity():
    return 1.00

def read_battery_voltage():
    return 3.8

def quality_flag(continuity, battery_v):
    if continuity < 0:
        return "range_fail"
    if battery_v < BATTERY_MIN_V:
        return "low_power"
    if continuity < MIN_SERVICE_CONTINUITY:
        return "review"
    return "good"

def send_payload(payload):
    print(json.dumps(payload))

while True:
    observed = read_observed_service_capacity()
    normal = read_normal_service_capacity()
    battery_v = read_battery_voltage()
    continuity = observed / normal if normal > 0 else 0

    payload = {
        "node_id": "edge-smart-city-node-001",
        "infrastructure_id": "SCI-STM-001",
        "service_continuity_score": continuity,
        "battery_v": battery_v,
        "review_required": continuity < MIN_SERVICE_CONTINUITY,
        "quality_flag": quality_flag(continuity, battery_v),
        "timestamp_ms": time.ticks_ms()
    }

    send_payload(payload)
    time.sleep(300)
