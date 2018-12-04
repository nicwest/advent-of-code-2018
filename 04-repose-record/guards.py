import re
import sys
import datetime


def get_lines():
    for line in sys.stdin:
        yield line.rstrip()


def parse_lines(lines):

    for line in lines:
        timestamp = datetime.datetime.strptime(line[1:17], '%Y-%m-%d %H:%M')
        event = line[19:]
        match = re.match(r'Guard #(\d+) begins shift', event)
        if match:
            event = int(match.group(1))
        yield timestamp, event


def time_sleeping(lines):
    lines = sorted(lines, key=lambda x: x[0])
    guards = {}
    guard = None
    for timestamp, event in lines:
        if event == 'falls asleep':
            start = timestamp.minute
        elif event == 'wakes up':
            for minute in range(start, timestamp.minute):
                guards[guard][minute] += 1
        else:
            guard = event
            if guard not in guards:
                guards[guard] = [0] * 60
    return guards


def find_best_guard(guards):
    best_guard = 0
    best_sleeping = 0
    for guard, mins in guards.items():
        sleeping = sum(mins)
        if sleeping > best_sleeping:
            best_guard = guard
            best_sleeping = sleeping

    return best_guard, best_sleeping


def find_best_minute(mins):
    minute_max = max(mins)
    return mins.index(minute_max), minute_max


def find_best_guard_by_best_minute(guards):
    best_guard = 0
    best_minute = 0
    best_max = 0
    for guard, mins in guards.items():
        minute, guard_max = find_best_minute(mins)
        if guard_max > best_max:
            best_guard = guard
            best_minute = minute
            best_max = guard_max

    return best_guard, best_minute


def part1(guards):
    best_guard, best_sleeping = find_best_guard(guards)
    best_minute, _ = find_best_minute(guards[best_guard])

    print('part1')
    print('=====')
    print(best_guard, best_sleeping, best_minute)
    print("result:", best_guard * best_minute)


def part2(guards):
    best_guard, best_minute = find_best_guard_by_best_minute(guards)

    print('')
    print('part2')
    print('=====')
    print(best_guard, best_minute)
    print("result:", best_guard * best_minute)


if __name__ == '__main__':
    lines = get_lines()
    lines = parse_lines(lines)
    guards = time_sleeping(lines)

    part1(guards)
    part2(guards)
