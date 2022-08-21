#!/usr/bin/python3

from nbak_header import NbakHeader
from sys import argv


def fb_guid2str(fb_guid):
    guid = '{{{:02X}{:02X}{:02X}{:02X}-{:02X}{:02X}-{:02X}{:02X}-{:02X}{:02X}-{:02X}{:02X}{:02X}{:02X}{:02X}{:02X}}}'.format(
        fb_guid[3], fb_guid[2], fb_guid[1], fb_guid[0],
        fb_guid[5], fb_guid[4], fb_guid[7], fb_guid[6], fb_guid[8], fb_guid[9],
        fb_guid[10], fb_guid[11], fb_guid[12], fb_guid[13], fb_guid[14], fb_guid[15])
    return guid


if __name__ == '__main__':

    if len(argv) == 1:
        print("Usage: {} <nbackup file>".format(argv[0]))
        exit(1)

    nbak_file = NbakHeader.from_file(argv[1])

    print('= HEADERS ========================================')
    print('Version       ', nbak_file.header.version)
    print('Level         ', nbak_file.header.version)
    print('Backup GUID   ', fb_guid2str(nbak_file.header.backup_guid))
    print('Previous GUID ', fb_guid2str(nbak_file.header.prev_guid))
    print('Page size     ', nbak_file.header.page_size)
    print('Backup SCN    ', nbak_file.header.backup_scn)
    print('Previous SCN  ', nbak_file.header.prev_scn)
