"""Obsoleto en despliegues Docker Compose.

Docker Compose administra app.py y main.py como servicios independientes.
No ejecutes este supervisor dentro de los contenedores.
"""
raise SystemExit("Usa Docker Compose para iniciar los servicios api y lector-usb.")
