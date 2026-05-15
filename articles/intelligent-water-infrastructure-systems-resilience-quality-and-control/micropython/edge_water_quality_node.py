"""
MicroPython scaffold for a low-power intelligent water monitoring node.
Replace read_* and send_payload with board-specific ESP32, RP2040, LoRa,
Wi-Fi, LTE-M, NB-IoT, or satellite code.
"""

import time
import json

MIN_PRESSURE_PSI = 35.0
MAX_TURBIDITY_NTU = 1.0
MIN_CHLORINE_MG_L = 0.6
MAX_CHLORINE_MG_L = 4.0
MIN_PH = 6.5
MAX_PH = 8.5
BATTERY_MIN_V = 3.2

def read_pressure_psi():
    return 34.0

def read_turbidity_ntu():
    return 0.9

def read_chlorine_mg_l():
    return 0.5

def read_ph():
    return 7.1

def read_battery_voltage():
    return 3.8

def quality_flag(pressure_psi, turbidity_ntu, chlorine_mg_l, ph, battery_v):
    if pressure_psi < MIN_PRESSURE_PSI:
        return "pressure_review"
    if turbidity_ntu > MAX_TURBIDITY_NTU:
        return "turbidity_review"
    if chlorine_mg_l < MIN_CHLORINE_MG_L or chlorine_mg_l > MAX_CHLORINE_MG_L:
        return "chlorine_review"
    if ph < MIN_PH or ph > MAX_PH:
        return "ph_review"
    if battery_v < BATTERY_MIN_V:
        return "low_power"
    return "good"

def send_payload(payload):
    print(json.dumps(payload))

while True:
    pressure = read_pressure_psi()
    turbidity = read_turbidity_ntu()
    chlorine = read_chlorine_mg_l()
    ph = read_ph()
    battery_v = read_battery_voltage()

    payload = {
        "node_id": "edge-water-quality-node-001",
        "asset_id": "WAT-DST-001",
        "pressure_psi": pressure,
        "turbidity_ntu": turbidity,
        "chlorine_mg_l": chlorine,
        "ph": ph,
        "battery_v": battery_v,
        "quality_flag": quality_flag(pressure, turbidity, chlorine, ph, battery_v),
        "timestamp_ms": time.ticks_ms()
    }

    send_payload(payload)
    time.sleep(300)
