#! /usr/bin/env python

import psutil

if __name__ == "__main__":
    color = "fb4934"
    icon = ""

    # Iterate over all running processes
    for proc in psutil.process_iter():
        pInfoDict: dict = {}

        # Get process detail as dictionary
        try:
            pInfoDict = proc.as_dict(attrs=["pid", "name", "cmdline"])
        except psutil.NoSuchProcess:
            continue

        # Append dict of process detail in list
        if pInfoDict["name"] == "openvpn" and pInfoDict["cmdline"][-2:] == [
            "--user",
            "nobody",
        ]:
            color = "b8bb26"
            icon = ""
            break

    print(f"%{{u#{color}}}%{{+u}}TUNNEL: %{{F#{color}}}{icon}%{{F-}}%{{u-}}")
