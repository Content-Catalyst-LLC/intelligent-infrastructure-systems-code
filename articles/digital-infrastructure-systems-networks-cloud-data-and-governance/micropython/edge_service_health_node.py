"""
MicroPython scaffold for an edge service-health telemetry node.
Replace read_* and send_payload with board-specific ESP32, RP2040, LoRa,
Wi-Fi, LTE-M, NB-IoT, Ethernet, or satellite code.
"""

import time
import json

MAX_LATENCY_MS = 250
MAX_PACKET_LOSS_PERCENT = 5.0
MIN_LINK_QUALITY = 0.70
MIN_BATTERY_V = 3.2

def read_latency_ms():
    return 180

def read_packet_loss_percent():
    return 4.5

def read_link_quality():
    return 0.68

def read_battery_voltage():
    return 3.7

def build_payload():
    latency_ms = read_latency_ms()
    packet_loss = read_packet_loss_percent()
    link_quality = read_link_quality()
    battery_v = read_battery_voltage()

    payload = {
        "telemetry_id": "EDGE-DIGI-001",
        "service_zone_id": "DIGI-RESILIENCE-NET",
        "edge_node_id": "EDGE-NODE-001",
        "latency_ms": latency_ms,
        "packet_loss_percent": packet_loss,
        "link_quality_score": link_quality,
        "battery_v": battery_v,
        "upstream_reachable": True,
        "local_cache_available": True,
        "fallback_route_available": False,
        "identity_service_reachable": True,
        "command_channel_secure": True,
        "timestamp_ms": time.ticks_ms()
    }

    if latency_ms > MAX_LATENCY_MS:
        payload["quality_flag"] = "latency_review"
    elif packet_loss > MAX_PACKET_LOSS_PERCENT:
        payload["quality_flag"] = "packet_loss_review"
    elif link_quality < MIN_LINK_QUALITY:
        payload["quality_flag"] = "link_quality_review"
    elif battery_v < MIN_BATTERY_V:
        payload["quality_flag"] = "power_review"
    elif not payload["fallback_route_available"]:
        payload["quality_flag"] = "fallback_route_review"
    else:
        payload["quality_flag"] = "good"

    return payload

def send_payload(payload):
    print(json.dumps(payload))

while True:
    send_payload(build_payload())
    time.sleep(300)
