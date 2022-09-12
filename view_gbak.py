#!/usr/bin/python3

from gbak_header import GbakHeader
from sys import argv


if __name__ == '__main__':

    if len(argv) == 1:
        print("Usage: {} <backup file>".format(argv[0]))
        exit(1)

    gbak_file = GbakHeader.from_file(argv[1])

    print('= HEADERS ========================================')
    for attribute in gbak_file.header.attributes:
        if attribute.type != GbakHeader.AttributeType.end:
            print('{} {}'.format(attribute.type, attribute.data.value))
