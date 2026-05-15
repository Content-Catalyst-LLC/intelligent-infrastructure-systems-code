"""
MicroPython scaffold for a low-power infrastructure monitoring node.
Replace read_* and send_payload with board-specific ESP32, RP2040, LoRa,
Wi-Fi, LTE-M, NB-IoT, or satellite code.
"""

import time
import json

MAX_LATENCY_SECONDS = 120
BATTERY_MIN_V = 3.2
REQUIRED_METADATA_FIELDS = [
    "sensor_id",
    "asset_id",
    "location",
    "unit",
    "timestamp_source",
    "owner",
    "quality_flag",
    "valid_use"
]

def read_measurement_value():
    return 34.0

def read_battery_voltage():
    return 3.8

def metadata_completeness(payload):
    present = sum(1 for field in REQUIRED_METADATA_FIELDS if field in payload and payload[field] is not None)
    return present / len(REQUIRED_METADATA_FIELDS)

def quality_flag(payload):
    if payload["battery_v"] < BATTERY_MIN_V:
        return "low_power"
    if payload["latency_seconds"] > MAX_LATENCY_SECONDS:
        return "latency_review"
    if metadata_completeness(payload) < 1.0:
        return "metadata_review"
    return "good"

def send_payload(payload):
    print(json.dumps(payload))

while True:
    payload = {
        "telemetry_id": "EDGE-MON-001",
        "sensor_id": "SENS-WATER-001",
        "asset_id": "ASSET-WATER-001",
        "source_system_id": "SRC-WATER-001",
        "location": "SZ-WATER-CENTRAL",
        "measurement_name": "pressure_psi",
        "measurement_value": read_measurement_value(),
        "unit": "psi",
        "timestamp_source": "edge_clock",
        "owner": "water_utility",
        "valid_use": "field_inspection",
        "latency_seconds": 45,
        "battery_v": read_battery_voltage(),
        "timestamp_ms": time.ticks_ms()
    }
    payload["quality_flag"] = quality_flag(payload)
    payload["metadata_completeness"] = metadata_completeness(payload)

    send_payload(payload)
    time.sleep(300)
