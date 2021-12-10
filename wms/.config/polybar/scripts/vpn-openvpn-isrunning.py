#! /usr/bin/env bash

import psutil

if __name__ == '__main__':
    output = "%{u#fb4934}%{+u}TUNNEL: %{F#fb4934}%{F-}%{u-}"
    # Iterate over all running processes
    for proc in psutil.process_iter():
       # Get process detail as dictionary
       pInfoDict = proc.as_dict(attrs=['pid', 'name', 'cmdline'])
       # Append dict of process detail in list
       if pInfoDict['name'] == 'openvpn' and pInfoDict['cmdline'][-2:] == ['--user', 'nobody']:
            output = "%{u#b8bb26}%{+u}TUNNEL: %{F#b8bb26}%{F-}%{u-}"

    print(output)
