"""
MicroPython scaffold for a low-power transportation monitoring node.
Replace read_* and send_payload with board-specific ESP32, RP2040, LoRa,
Wi-Fi, LTE-M, NB-IoT, or satellite code.
"""

import time
import json

MIN_SPEED_KPH = 30.0
MAX_HEADWAY_MINUTES = 10.0
BATTERY_MIN_V = 3.2

def read_speed_kph():
    return 24.0

def read_headway_minutes():
    return 14.0

def read_battery_voltage():
    return 3.8

def quality_flag(speed_kph, headway_minutes, battery_v):
    if speed_kph < 0 or headway_minutes < 0:
        return "range_fail"
    if battery_v < BATTERY_MIN_V:
        return "low_power"
    return "good"

def send_payload(payload):
    print(json.dumps(payload))

while True:
    speed_kph = read_speed_kph()
    headway_minutes = read_headway_minutes()
    battery_v = read_battery_voltage()

    payload = {
        "node_id": "edge-transport-node-001",
        "network_element_id": "NET-BUS-001",
        "speed_kph": speed_kph,
        "headway_minutes": headway_minutes,
        "battery_v": battery_v,
        "speed_review_required": speed_kph < MIN_SPEED_KPH,
        "headway_review_required": headway_minutes > MAX_HEADWAY_MINUTES,
        "quality_flag": quality_flag(speed_kph, headway_minutes, battery_v),
        "timestamp_ms": time.ticks_ms()
    }

    send_payload(payload)
    time.sleep(300)
