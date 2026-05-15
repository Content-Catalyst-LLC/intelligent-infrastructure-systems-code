"""
MicroPython scaffold for a flood early-warning edge node.

This example is intentionally hardware-agnostic. Replace read_rainfall(),
read_river_stage(), and send_payload() with board-specific sensor and network
code for ESP32, RP2040, LoRa, Wi-Fi, LTE-M, NB-IoT, or satellite modules.
"""

import time
import json

RAINFALL_THRESHOLD_MM_HR = 35.0
RIVER_STAGE_THRESHOLD_M = 3.5
SOIL_SATURATION_THRESHOLD = 0.75

def read_rainfall():
    return 42.0

def read_river_stage():
    return 3.1

def read_soil_saturation():
    return 0.82

def classify_watch(rainfall, river_stage, soil_saturation):
    rainfall_high = rainfall >= RAINFALL_THRESHOLD_MM_HR
    river_high = river_stage >= RIVER_STAGE_THRESHOLD_M
    soil_high = soil_saturation >= SOIL_SATURATION_THRESHOLD
    return (rainfall_high and soil_high) or river_high

def send_payload(payload):
    print(json.dumps(payload))

while True:
    rainfall = read_rainfall()
    river_stage = read_river_stage()
    soil = read_soil_saturation()
    local_watch = classify_watch(rainfall, river_stage, soil)

    payload = {
        "node_id": "edge-flood-node-001",
        "rainfall_mm_hr": rainfall,
        "river_stage_m": river_stage,
        "soil_saturation": soil,
        "local_watch": local_watch,
        "timestamp_ms": time.ticks_ms()
    }

    send_payload(payload)
    time.sleep(60)
