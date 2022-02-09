#! /usr/bin/env python

import psutil

if __name__ == "__main__":
    color = "fb4934"

    # Iterate over all running processes
    for proc in psutil.process_iter():
        # Get process detail as dictionary
        pInfoDict = proc.as_dict(attrs=["pid", "name", "cmdline"])

        # Append dict of process detail in list
        if pInfoDict["name"] == "openvpn" and pInfoDict["cmdline"][-2:] == [
            "--user",
            "nobody",
        ]:
            color = "b8bb26"
            break

    print(f"%{{u#{color}}}%{{+u}}TUNNEL: %{{F#{color}}}%{{F-}}%{{u-}}")
