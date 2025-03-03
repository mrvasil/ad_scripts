import requests

def send_flag(flags):
    print("[#] try to send:", flags)
    url = 'http://10.10.10.10/flags'
    headers = {
        'Content-Type': 'application/json',
        'X-Team-Token': '5ff0ec4072a656b9'
    }
    try:
        response = requests.put(url, headers=headers, json=flags)
        print("[#] response:", response.text)
    except:
        print("[!] some error")
    #print(response.text)

c = 0
flags = []
while True:
    flag = input()
    if (flag) and (c < 10):
        flags.append(flag)
        c += 1
    else:
        send_flag(flags)
        flags = []
        c = 0
