from __future__ import annotations


def decode_simple_lorawan_payload(payload_hex: str) -> dict:
    """
    Decode a simple educational LoRaWAN-style payload.

    Payload format:
    - bytes 0-1: sensor value, unsigned integer, scale 0.01
    - byte 2: battery percentage
    - byte 3: signal quality percentage
    """

    payload = bytes.fromhex(payload_hex)

    if len(payload) < 4:
        raise ValueError("Payload must contain at least 4 bytes.")

    raw_value = int.from_bytes(payload[0:2], byteorder="big", signed=False)
    battery_percent = payload[2]
    signal_quality_percent = payload[3]

    return {
        "decoded_value": raw_value * 0.01,
        "battery_percent": battery_percent,
        "signal_quality_percent": signal_quality_percent,
    }


def main() -> None:
    example_payload = "039B5F58"
    decoded = decode_simple_lorawan_payload(example_payload)
    print(decoded)


if __name__ == "__main__":
    main()
