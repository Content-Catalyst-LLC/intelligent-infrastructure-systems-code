"""
MicroPython scaffold for a cyber-physical edge control node.
This is illustrative only. Do not use for real control operations without
certified engineering, safety review, field testing, and operational authority.
"""

import time
import json

MAX_LATENCY_SECONDS = 120
MIN_STATE = 0.0
MAX_STATE = 5.0
MIN_COMMAND = 0.0
MAX_COMMAND = 2.0

def read_state():
    return 6.5

def proposed_command():
    return 1.0

def within_bounds(value, low, high):
    return low <= value <= high

def build_payload():
    state = read_state()
    command = proposed_command()
    measurement_valid = within_bounds(state, MIN_STATE, MAX_STATE)
    command_valid = within_bounds(command, MIN_COMMAND, MAX_COMMAND)

    payload = {
        "record_id": "EDGE-CP-001",
        "control_loop_id": "LOOP-SEC-001",
        "asset_id": "CP-SEC-001",
        "controller_id": "CTRL-SEC-001",
        "measurement_value": state,
        "requested_command": command,
        "measurement_valid": measurement_valid,
        "command_within_bounds": command_valid,
        "operator_ack_required": True,
        "manual_override_available": True,
        "fallback_available": False,
        "latency_seconds": 25,
        "timestamp_ms": time.ticks_ms()
    }

    if not measurement_valid:
        payload["quality_flag"] = "state_out_of_bounds"
    elif not command_valid:
        payload["quality_flag"] = "command_out_of_bounds"
    elif not payload["fallback_available"]:
        payload["quality_flag"] = "fallback_review"
    else:
        payload["quality_flag"] = "good"

    return payload

def send_payload(payload):
    print(json.dumps(payload))

while True:
    send_payload(build_payload())
    time.sleep(300)
