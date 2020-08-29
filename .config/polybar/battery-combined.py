#!/usr/bin/env python

"""
Get the battery levels and output the icons, the total percentage and a time prevision before runnig out of battery
"""

import datetime
import os
import sys

GRUVBOX = {
    "aqua1" : "#688d6a",
    "aqua2" : "#8ec07c",
    "blue1" : "#458588",
    "blue2" : "#83a598",
    "gray1" : "#a89984",
    "gray2" : "#928374",
    "green1" : "#98971a",
    "green2" : "#b8bb26",
    "orange1" : "#d65d0e",
    "orange2" : "#fe8019",
    "purple1" : "#b16286",
    "purple2" : "#d3869b",
    "red1" : "#cc241d",
    "red2" : "#fb4934",
    "yellow1" : "#d79921",
    "yellow2" : "#fabd2f"
}

ICONS = {
    "battery" : {
        10 : "",  # 00 -> 10
        33 : "",  # 11 -> 33
        55 : "",  # 34 -> 55
        78 : "",  # 56 -> 78
        100 : ""  # 79 -> 100
    },
    "charging" : ""
}

POWER_SUPPLIES_PATH = "/sys/class/power_supply"

class PowerSupply(object):

    def __init__(self, name):
        self._name = name
        self._path = os.path.join(POWER_SUPPLIES_PATH, name)

    @property
    def alarm(self):
        data = 0
        with open(os.path.join(self._path, "alarm"), 'r') as f:
            data = int(f.read().strip())
        return data

    @property
    def capacity(self):
        data = 0
        with open(os.path.join(self._path, "capacity"), 'r') as f:
            data = int(f.read().strip())
        return data

    @property
    def capacity_level(self):
        data = 0
        with open(os.path.join(self._path, "capacity_level"), 'r') as f:
            data = int(f.read().strip())
        return data

    @property
    def charge_start_threshold(self):
        data = 0
        with open(os.path.join(self._path, "charge_start_threshold"), 'r') as f:
            data = int(f.read().strip())
        return data

    @property
    def charge_stop_threshold(self):
        data = 0
        with open(os.path.join(self._path, "charge_stop_threshold"), 'r') as f:
            data = int(f.read().strip())
        return data

    @property
    def cycle_count(self):
        data = 0
        with open(os.path.join(self._path, "cycle_count"), 'r') as f:
            data = int(f.read().strip())
        return data

    @property
    def energy_full(self):
        data = 0
        with open(os.path.join(self._path, "energy_full"), 'r') as f:
            data = int(f.read().strip())
        return data

    @property
    def energy_full_design(self):
        data = 0
        with open(os.path.join(self._path, "energy_full_design"), 'r') as f:
            data = int(f.read().strip())
        return data

    @property
    def energy_now(self):
        data = 0
        with open(os.path.join(self._path, "energy_now"), 'r') as f:
            data = int(f.read().strip())
        return data

    @property
    def manufacturer(self):
        data = "Unknown"
        with open(os.path.join(self._path, "manufacturer"), 'r') as f:
            data = f.read().strip()
        return data

    @property
    def model_name(self):
        data = "Unknown"
        with open(os.path.join(self._path, "model_name"), 'r') as f:
            data = f.read().strip()
        return data

    @property
    def power_now(self):
        data = 0
        with open(os.path.join(self._path, "power_now"), 'r') as f:
            data = int(f.read().strip())
        return data

    @property
    def present(self):
        data = False
        with open(os.path.join(self._path, "present"), 'r') as f:
            data = bool(f.read().strip())
        return data

    @property
    def serial_number(self):
        data = "Unknown"
        with open(os.path.join(self._path, "serial_number"), 'r') as f:
            data = f.read().strip()
        return data

    @property
    def status(self):
        data = "Unknown"
        with open(os.path.join(self._path, "status"), 'r') as f:
            data = f.read().strip()
        return data

    @property
    def technology(self):
        data = "Unknown"
        with open(os.path.join(self._path, "technology"), 'r') as f:
            data = f.read().strip()
        return data

    @property
    def type(self):
        data = "Unknown"
        with open(os.path.join(self._path, "type"), 'r') as f:
            data = f.read().strip()
        return data

    @property
    def uevent(self):
        data = "Unknown"
        with open(os.path.join(self._path, "uevent"), 'r') as f:
            data = f.read().strip()
        return data

    @property
    def voltage_min_design(self):
        data = 0
        with open(os.path.join(self._path, "voltage_min_design"), 'r') as f:
            data = int(f.read().strip())
        return data

    @property
    def voltage_now(self):
        data = 0
        with open(os.path.join(self._path, "voltage_now"), 'r') as f:
            data = int(f.read().strip())
        return data

class PowerSupplies(object):

    def __init__(self):
        self._pws = list()
        for file in os.listdir(POWER_SUPPLIES_PATH):
            if "BAT" in file:
                self._pws.append(PowerSupply(file))

    @property
    def energy_full(self):
        energy_full = 0
        for pw in self._pws:
            energy_full += pw.energy_full
        return energy_full

    @property
    def energy_now(self):
        energy_now = 0
        for pw in self._pws:
            energy_now += pw.energy_now
        return energy_now

    @property
    def percentage(self):
        return round(self.energy_now / self.energy_full * 100, 2)

    @property
    def time_remaining(self):
        time = datetime.timedelta(0)
        status = self.status

        if status == "Charging":
            time = datetime.timedelta(hours=(self.energy_full - self.energy_now) / self.power_now)
        elif status == "Discharging":
            time = datetime.timedelta(hours=self.energy_now / self.power_now)

        return time

    @property
    def power_now(self):
        power_now = 0
        for pw in self._pws:
            power_now += pw.power_now
        return power_now

    @property
    def status(self):
        for pw in self._pws:
            if pw.status != "Unknown":
                return pw.status


if __name__ == "__main__":
    powersupplies = PowerSupplies()

    charge_icon = ICONS['charging'] if powersupplies.status == "Charging" else ""
    percentage = powersupplies.percentage
    level_icon = ICONS['battery'][10]
    if percentage <= 10.0:
        level_icon = ICONS['battery'][10]
    elif percentage <= 33.0:
        level_icon = ICONS['battery'][33]
    elif percentage <= 55.0:
        level_icon = ICONS['battery'][55]
    elif percentage <= 78.0:
        level_icon = ICONS['battery'][78]
    else:
        level_icon = ICONS['battery'][100]

    time = powersupplies.time_remaining

    print("{charge_icon} {level_icon}  {percentage}%{time}".format(
        charge_icon=charge_icon,
        level_icon=level_icon,
        percentage=powersupplies.percentage,
        time= " ({}h{})".format(int(time.seconds/3600), int(time.seconds % 3600 / 60)) if time != datetime.timedelta(0) else ""
        ))
