import argparse
import glob
import json

import yaml


def parse_arg():
    parser = argparse.ArgumentParser(
        description='convert json to yaml or the other way around')
    parser.add_argument('outformat', help='output format: [j]son/[y]aml')
    parser.add_argument(
        '-i', '--input_directory', default='.', help='input directory')
    return parser.parse_args()


if __name__ == "__main__":

    args = parse_arg()
    if args.outformat.endswith('j'):
        from_affix = 'yaml'
        to_affix = 'json'
        fromM = yaml
        toM = json
    else:
        from_affix = 'json'
        to_affix = 'yaml'
        fromM = json
        toM = yaml

    files = glob.glob(f'{args.input_directory}/*.{from_affix}')
    target_files = [f[:-4] + to_affix for f in files]

    for fromname, toname in zip(files, target_files):
        with open(fromname) as fromf, open(toname, 'w') as tof:
            toM.dump(fromM.load(fromf), tof, indent=2)
