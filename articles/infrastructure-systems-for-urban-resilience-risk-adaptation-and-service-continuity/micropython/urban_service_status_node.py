"""
MicroPython scaffold for a low-power urban infrastructure service-status node.

Replace read_service_capacity(), read_battery_voltage(), read_backup_power(),
and send_payload() with board-specific sensor and network code for ESP32,
RP2040, LoRa, Wi-Fi, LTE-M, NB-IoT, or satellite modules.
"""

import time
import json

MIN_SERVICE_CONTINUITY_PCT = 75.0
BATTERY_MIN_V = 3.2

def read_service_capacity():
    return 58.0

def read_battery_voltage():
    return 3.8

def read_backup_power():
    return False

def quality_flag(service_capacity_pct, battery_v):
    if service_capacity_pct < 0.0 or service_capacity_pct > 100.0:
        return "range_fail"
    if battery_v < BATTERY_MIN_V:
        return "low_power"
    return "good"

def send_payload(payload):
    print(json.dumps(payload))

while True:
    capacity = read_service_capacity()
    battery_v = read_battery_voltage()
    backup_power = read_backup_power()

    payload = {
        "node_id": "edge-urban-service-node-001",
        "service_id": "SVC-DRN-001",
        "service_domain": "drainage",
        "service_capacity_pct": capacity,
        "continuity_review_required": capacity < MIN_SERVICE_CONTINUITY_PCT or not backup_power,
        "backup_power_available": backup_power,
        "battery_v": battery_v,
        "quality_flag": quality_flag(capacity, battery_v),
        "timestamp_ms": time.ticks_ms()
    }

    send_payload(payload)
    time.sleep(300)
