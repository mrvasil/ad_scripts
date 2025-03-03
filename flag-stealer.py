import subprocess
import re
import requests
import time

def capture_and_extract_flags():
    flag_pattern = re.compile(r'[A-Z0-9]{31}=')
    sent_flags = set()
    tcpdump_command = ["sudo", "tcpdump", "-A", "-i", "any"]
    
    print("Starting network traffic capture. Press Ctrl+C to stop.")
    
    try:
        process = subprocess.Popen(tcpdump_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        for line in process.stdout:
            matches = flag_pattern.findall(line)

            for flag in matches:
                if flag not in sent_flags:
                    print(f"Found new flag: {flag}")
                    send_flag([flag])
                    sent_flags.add(flag)
                    print(f"Total unique flags sent: {len(sent_flags)}")
                else:
                    print(f"Flag that has already been found: {flag}")
                print("-----------------\n")    
    except KeyboardInterrupt:
        print("\nStopping flag capture.")
        process.terminate()
    except Exception as e:
        print(f"Error during capture: {e}")
        if 'process' in locals():
            process.terminate()

def send_flag(flags):
    url = 'http://10.10.10.10/flags'
    headers = {
        'Content-Type': 'application/json',
        'X-Team-Token': '5ff0ec4072a656b9'
    }
    try:
        response = requests.put(url, headers=headers, json=flags)
        print(f"Flag submission response: {response.text}")
        return response.status_code == 200
    except Exception as e:
        print(f"Error sending flag: {e}")
        return False

if __name__ == "__main__":
    capture_and_extract_flags()
