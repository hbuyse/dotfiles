#!/usr/bin/env python

"""
Get the battery levels and output the icons, the total percentage and a time prevision before
running out of battery
"""

import datetime
import json
import os

ICONS = {
    "charging": "",
}

POWER_SUPPLIES_PATH = "/sys/class/power_supply"


class PowerSupply:
    """Power supply object from the /sys/class/power_supply Linux folder"""

    def __init__(self, name):
        self._name = name
        self._path = os.path.join(POWER_SUPPLIES_PATH, name)

    @property
    def alarm(self):
        """Get data from the file /sys/class/power_supply/*/alarm"""
        data = 0
        with open(os.path.join(self._path, "alarm"), "r") as fld:
            data = int(fld.read().strip())
        return data

    @property
    def capacity(self):
        """Get data from the file /sys/class/power_supply/*/capacity"""
        data = 0
        with open(os.path.join(self._path, "capacity"), "r") as fld:
            data = int(fld.read().strip())
        return data

    @property
    def capacity_level(self):
        """Get data from the file /sys/class/power_supply/*/capacity_level"""
        data = 0
        with open(os.path.join(self._path, "capacity_level"), "r") as fld:
            data = int(fld.read().strip())
        return data

    @property
    def charge_start_threshold(self):
        """Get data from the file /sys/class/power_supply/*/charge_start_threshold"""
        data = 0
        with open(os.path.join(self._path, "charge_start_threshold"), "r") as fld:
            data = int(fld.read().strip())
        return data

    @property
    def charge_stop_threshold(self):
        """Get data from the file /sys/class/power_supply/*/charge_stop_threshold"""
        data = 0
        with open(os.path.join(self._path, "charge_stop_threshold"), "r") as fld:
            data = int(fld.read().strip())
        return data

    @property
    def cycle_count(self):
        """Get data from the file /sys/class/power_supply/*/cycle_count"""
        data = 0
        with open(os.path.join(self._path, "cycle_count"), "r") as fld:
            data = int(fld.read().strip())
        return data

    @property
    def energy_full(self):
        """Get data from the file /sys/class/power_supply/*/energy_full"""
        data = 0
        try:
            with open(os.path.join(self._path, "energy_full"), "r") as fld:
                data = int(fld.read().strip())
        except FileNotFoundError:
            with open(os.path.join(self._path, "charge_full"), "r") as fld:
                data = int(fld.read().strip())
        return data

    @property
    def energy_full_design(self):
        """Get data from the file /sys/class/power_supply/*/energy_full_design"""
        data = 0
        try:
            with open(os.path.join(self._path, "energy_full_design"), "r") as fld:
                data = int(fld.read().strip())
        except FileNotFoundError:
            with open(os.path.join(self._path, "charge_full_design"), "r") as fld:
                data = int(fld.read().strip())
        return data

    @property
    def energy_now(self):
        """Get data from the file /sys/class/power_supply/*/energy_now"""
        data = 0
        try:
            with open(os.path.join(self._path, "energy_now"), "r") as fld:
                data = int(fld.read().strip())
        except FileNotFoundError:
            with open(os.path.join(self._path, "charge_now"), "r") as fld:
                data = int(fld.read().strip())
        return data

    @property
    def manufacturer(self):
        """Get data from the file /sys/class/power_supply/*/manufacturer"""
        data = "Unknown"
        with open(os.path.join(self._path, "manufacturer"), "r") as fld:
            data = fld.read().strip()
        return data

    @property
    def model_name(self):
        """Get data from the file /sys/class/power_supply/*/model_name"""
        data = "Unknown"
        with open(os.path.join(self._path, "model_name"), "r") as fld:
            data = fld.read().strip()
        return data

    @property
    def power_now(self):
        """Get data from the file /sys/class/power_supply/*/power_now"""
        data = 0
        try:
            with open(os.path.join(self._path, "power_now"), "r") as fld:
                data = int(fld.read().strip())
        except FileNotFoundError:
            with open(os.path.join(self._path, "current_now"), "r") as fld:
                data = int(fld.read().strip())
        return data

    @property
    def present(self):
        """Get data from the file /sys/class/power_supply/*/present"""
        data = False
        with open(os.path.join(self._path, "present"), "r") as fld:
            data = bool(fld.read().strip())
        return data

    @property
    def serial_number(self):
        """Get data from the file /sys/class/power_supply/*/serial_number"""
        data = "Unknown"
        with open(os.path.join(self._path, "serial_number"), "r") as fld:
            data = fld.read().strip()
        return data

    @property
    def status(self):
        """Get data from the file /sys/class/power_supply/*/status"""
        data = "Unknown"
        with open(os.path.join(self._path, "status"), "r") as fld:
            data = fld.read().strip()
        return data

    @property
    def technology(self):
        """Get data from the file /sys/class/power_supply/*/technology"""
        data = "Unknown"
        with open(os.path.join(self._path, "technology"), "r") as fld:
            data = fld.read().strip()
        return data

    @property
    def type(self):
        """Get data from the file /sys/class/power_supply/*/type"""
        data = "Unknown"
        with open(os.path.join(self._path, "type"), "r") as fld:
            data = fld.read().strip()
        return data

    @property
    def uevent(self):
        """Get data from the file /sys/class/power_supply/*/uevent"""
        data = "Unknown"
        with open(os.path.join(self._path, "uevent"), "r") as fld:
            data = fld.read().strip()
        return data

    @property
    def voltage_min_design(self):
        """Get data from the file /sys/class/power_supply/*/voltage_min_design"""
        data = 0
        with open(os.path.join(self._path, "voltage_min_design"), "r") as fld:
            data = int(fld.read().strip())
        return data

    @property
    def voltage_now(self):
        """Get data from the file /sys/class/power_supply/*/voltage_now"""
        data = 0
        with open(os.path.join(self._path, "voltage_now"), "r") as fld:
            data = int(fld.read().strip())
        return data

    @property
    def percentage(self):
        """Global percentage of the batteries"""
        return round(self.energy_now / self.energy_full * 100, 2)


class PowerSupplies:
    """List of PowerSupply"""

    def __init__(self):
        self._pws = list()
        for file in os.listdir(POWER_SUPPLIES_PATH):
            if file.startswith("BAT"):
                self._pws.append(PowerSupply(file))

    @property
    def energy_full(self):
        """Sum of the different energy_full files"""
        energy_full = 0
        for power_supply in self._pws:
            energy_full += power_supply.energy_full
        return energy_full

    @property
    def energy_now(self):
        """Sum of the different energy_now files"""
        energy_now = 0
        for power_supply in self._pws:
            energy_now += power_supply.energy_now
        return energy_now

    @property
    def percentage(self):
        """Global percentage of the batteries"""
        return round(self.energy_now / self.energy_full * 100, 2)

    @property
    def time_remaining(self):
        """Time remaining to be fully-charged or fully-discharged"""
        time = datetime.timedelta(0)
        status = self.status

        if status in ["Discharging", "Not charging"]:
            time = datetime.timedelta(hours=self.energy_now / self.power_now)
        elif status == "Charging":
            time = datetime.timedelta(
                hours=(self.energy_full - self.energy_now) / self.power_now
            )

        return time

    @property
    def power_now(self):
        """Sum of the different power_now files"""
        power_now = 0
        for power_supply in self._pws:
            power_now += power_supply.power_now
        return power_now

    @property
    def status(self):
        """General status of the batteries"""
        data = "Unknown"
        for power_supply in self._pws:
            if power_supply.status != "Unknown":
                data = power_supply.status
                break
        return data


def main():
    """Main program"""
    powersupplies = PowerSupplies()

    charge_icon = "" if powersupplies.status == "Charging" else ""
    remaining_time = powersupplies.time_remaining

    remaining_time_str = ""
    if remaining_time != datetime.timedelta(0):
        remaining_time_str = "({:02d}h{:02d})".format(
            int(remaining_time.seconds / 3600), int(remaining_time.seconds % 3600 / 60)
        )

    classes = []

    if int(powersupplies.percentage) < 10:
        classes.append("critical")
    elif int(powersupplies.percentage) < 25:
        classes.append("warning")

    if powersupplies.status in ["Discharging", "Not charging"]:
        classes.append("discharging")

    tooltips = []
    for pw in powersupplies._pws:
        tooltips.append(f"<b>{pw._name}</b>: {pw.percentage}%")

    print(
        json.dumps(
            {
                "text": " ".join(
                    filter(
                        None,
                        [
                            str(powersupplies.percentage) + "%",
                            remaining_time_str,
                            charge_icon,
                        ],
                    )
                ),
                "percentage": int(powersupplies.percentage),
                "tooltip": f"<span font_desc='Hack Nerd Font Mono'>{chr(10).join(tooltips)}</span>",
                "class": "-".join(classes),
            }
        )
    )


if __name__ == "__main__":
    main()

#  vim: set ts=8 sw=4 tw=0 et ft=python :
