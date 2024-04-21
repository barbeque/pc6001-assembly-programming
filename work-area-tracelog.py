import re

known_fields = {
    'FA06': { 'name': 'Timer interrupt setup', 'ignore': True },
    'FA07': { 'name': 'Timer interrupt setup B', 'ignore': True },
    'FA28': { 'name': 'Timer', 'ignore': True },
    'FA29': { 'name': 'Timer', 'ignore': True },
    'FA2D': { 'name': 'Click sound generation', 'ignore': True },
    'FECA': { 'name': 'Game key status', 'ignore': True }
}

with open('/Users/mike/mame0253-arm64/yewdow-rom-startup.log', 'r') as f:
    lines = f.readlines()

for line in lines:
    match = re.match('^Work Area Write ([0-9A-F]{4}) <- ([0-9A-F]{4})$', line)
    wpaddr = match.group(1).strip()
    wpdata = match.group(2).strip()
    if wpaddr in known_fields.keys():
        field = known_fields[wpaddr]
        if not field['ignore']:
            print(f"{wpaddr} <- {wpdata}")
            print(f'\t{known_fields[wpaddr]["name"]}')
    else:
            print(f"{wpaddr} <- {wpdata}")

