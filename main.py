
import serial
import requests
import os

# CAMBIAR cuando confirmemos el puerto del sensor
port = os.getenv("SERIAL_PORT", "/dev/ttyUSB0")

baud_rate = 115200

# Flask está en el mismo servidor Linux
API_URL = os.getenv("API_URL", "http://127.0.0.1:5000")
url = f"{API_URL.rstrip('/')}/api/retiro-nfc"

print("Esperando lecturas NFC...")

try:
    with serial.Serial(port, baud_rate, timeout=1) as ser:

        while True:
            line = ser.readline().decode(
                "ascii", errors="ignore"
            ).strip()

            if line:
                nfc_id = line.upper()
                print("NFC detectado:", nfc_id)

                try:
                    response = requests.post(
                        url,
                        json={"nfc_id": nfc_id},
                        timeout=5
                    )

                    resultado = response.json()

                    if response.status_code == 200:
                        print("RETIRO EXITOSO")
                        print("Empleado:", resultado["empleado"])
                        print(
                            "Pedidos retirados:",
                            resultado["pedidos_retirados"]
                        )
                    else:
                        print("RETIRO NO REALIZADO")
                        print(resultado.get("error"))

                except requests.RequestException as error:
                    print("Error al conectar con Flask:", error)

except serial.SerialException as error:
    print("Error con el sensor NFC:", error)

except KeyboardInterrupt:
    print("Lector NFC detenido.")
