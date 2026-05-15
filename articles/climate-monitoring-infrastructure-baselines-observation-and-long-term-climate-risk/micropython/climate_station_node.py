"""
MicroPython scaffold for a low-power climate observing node.

Replace read_temperature(), read_humidity(), read_battery_voltage(), and
send_payload() with board-specific sensor and network code for ESP32, RP2040,
LoRa, Wi-Fi, LTE-M, NB-IoT, or satellite modules.
"""

import time
import json

TEMP_MIN_C = -80.0
TEMP_MAX_C = 60.0
BATTERY_MIN_V = 3.2

def read_temperature():
    return 24.8

def read_humidity():
    return 51.5

def read_battery_voltage():
    return 3.8

def quality_flag(temp_c, humidity_pct, battery_v):
    if temp_c < TEMP_MIN_C or temp_c > TEMP_MAX_C:
        return "range_fail"
    if humidity_pct < 0.0 or humidity_pct > 100.0:
        return "range_fail"
    if battery_v < BATTERY_MIN_V:
        return "low_power"
    return "good"

def send_payload(payload):
    print(json.dumps(payload))

while True:
    temp_c = read_temperature()
    humidity_pct = read_humidity()
    battery_v = read_battery_voltage()

    payload = {
        "station_id": "edge-climate-node-001",
        "temperature_c": temp_c,
        "humidity_pct": humidity_pct,
        "battery_v": battery_v,
        "quality_flag": quality_flag(temp_c, humidity_pct, battery_v),
        "timestamp_ms": time.ticks_ms()
    }

    send_payload(payload)
    time.sleep(300)
