import re

known_fields = {
    '00B0': { 'name': 'timer/vram/cass', 'ignore': False },
    '00A0': { 'name': 'psg reg address', 'ignore': True },
    '00A1': { 'name': 'psg output data', 'ignore': True }
}

with open('/Users/mike/mame0253-arm64/iop', 'r') as f:
    lines = [l for l in f.readlines() if l.startswith('iop') ]

for line in lines:
    match = re.match('^iop ([0-9A-F]+) <- ([0-9A-F]+)', line)
    wpaddr = match.group(1).strip()
    wpdata = match.group(2).strip()
    if wpaddr in known_fields.keys():
        field = known_fields[wpaddr]
        if not field['ignore']:
            print(f"{wpaddr} <- {wpdata}")
            print(f'\t{known_fields[wpaddr]["name"]}')
    else:
            print(f"{wpaddr} <- {wpdata}")

