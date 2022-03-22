import argparse
import os
import json
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

parser = argparse.ArgumentParser()
parser.add_argument('path')
parser.add_argument('-g', '--graph', action='store_true')


def plot(times, yvalues, yavg, ylabel):
    plt.clf()
    plt.figure(figsize=(15, 10))

    plt.plot(times, yvalues)
    plt.fill_between(times, 0, yvalues, alpha=0.3)
    plt.plot([times[0], times[-1]], [yavg] * 2)

    plt.xlabel('Time (s)')
    plt.ylabel(ylabel)
    plt.tight_layout()

    basename, _ = os.path.splitext(os.path.basename(args.path))
    suffix = ylabel.replace(' ', '')
    if args.graph:
        plt.savefig(basename + '-' + suffix + '.png')
    print(ylabel + ':', yavg)


def calc_ipc(hpm0, hpm1):
    cycle = hpm1[0] - hpm0[0]
    instret = hpm1[1] - hpm0[1]
    return instret / cycle


def calc_br_misp_rate(hpm0, hpm1):
    br = hpm1[2] - hpm0[2]
    br_misp = hpm1[5] - hpm0[5]
    return br_misp / br


def calc_br_mpki(hpm0, hpm1):
    instret = hpm1[1] - hpm0[1]
    br_misp = hpm1[5] - hpm0[5]
    return br_misp / instret * 1000


def parse_file(f):
    lineno = 0
    last_hpms = None
    times = []
    ipcs = []
    br_misp_rates = []
    br_mpkis = []

    while True:
        line = f.readline()
        if not line:
            break
        line = line.strip()
        if not line:
            continue

        data = json.loads(line)
        time = data['time']
        hpms = data['hpms']
        times.append(time)

        if lineno == 0:
            first_hpms = hpms

        else:
            times.append(time)
            ipcs.extend([calc_ipc(last_hpms, hpms)] * 2)
            br_misp_rates.extend([calc_br_misp_rate(last_hpms, hpms)] * 2)
            br_mpkis.extend([calc_br_mpki(last_hpms, hpms)] * 2)

        last_hpms = hpms
        lineno += 1

    times.pop()
    ipc_avg = calc_ipc(first_hpms, hpms)
    br_misp_rate_avg = calc_br_misp_rate(first_hpms, hpms)
    br_mpki_avg = calc_br_mpki(first_hpms, hpms)

    plot(times, ipcs, ipc_avg, 'IPC')
    plot(times, br_misp_rates, br_misp_rate_avg, 'Br Misp Rate')
    plot(times, br_mpkis, br_mpki_avg, 'Br MPKI')


if __name__ == '__main__':
    args = parser.parse_args()

    with open(args.path) as f:
        parse_file(f)
