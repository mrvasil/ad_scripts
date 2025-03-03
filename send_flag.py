import requests

def send_flag(flags):
    url = 'http://10.10.10.10/flags'
    headers = {
        'Content-Type': 'application/json',
        'X-Team-Token': '5ff0ec4072a656b9'
    }
    response = requests.put(url, headers=headers, json=flags)
    print(response.text)

send_flag([''])
