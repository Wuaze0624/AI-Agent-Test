import platform
import socket
import psutil


def get_system_info():
    """Get system information."""
    return {
        'os': platform.system(),
        'python': platform.python_version(),
        'cpu': platform.processor() or platform.machine() or 'Unknown',
        'ram': _get_ram(),
        'hostname': socket.gethostname()
    }


def _get_ram():
    """Get total RAM in GB."""
    try:
        mem = psutil.virtual_memory()
        return round(mem.total / (1024 ** 3), 2)
    except (psutil.Error, OSError):
        return None


def main():
    """Print system information in formatted output."""
    info = get_system_info()
    print('\n=== System Information ===')
    print(f'OS: {info["os"]}')
    print(f'Python: {info["python"]}')
    print(f'CPU: {info["cpu"]}')
    print(f'RAM: {info["ram"]} GB')
    print(f'Hostname: {info["hostname"]}')
    print('\n========================\n')


if __name__ == '__main__':
    main()
