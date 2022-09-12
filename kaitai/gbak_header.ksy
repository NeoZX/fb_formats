meta:
  id: gbak_header
  title: Backup file version 11 (Firebird 4.0)
  application: gbak
  endian: le
  bit-endian: le
doc: | 
  Firebird backup format
doc-ref: src/burp/backup.epp
seq:
  - id: header
    type: header
types:
  header:
    seq:
      - id: record
        enum: record
        type: u1
      - id: attributes
        type: attribute
        repeat: until
        repeat-until: _.type == attribute_type::end
  attribute:
    seq:
      - id: type
        enum: attribute_type
        type: u1
      - id: data
        type:
          switch-on: type
          cases:
            #'attribute_type::end': terminator
            'attribute_type::backup_date': string
            'attribute_type::backup_format': integer
            #'attribute_type::backup_os': 
            'attribute_type::backup_compress': integer
            'attribute_type::backup_transportable': integer
            'attribute_type::backup_blksize': integer
            'attribute_type::backup_file': string
            'attribute_type::backup_volume': integer
            'attribute_type::backup_keyname': string
            'attribute_type::backup_zip': integer
            'attribute_type::backup_hash': string 
            'attribute_type::backup_crypt': string
  integer:
    seq:
      - id: length
        type: s1
      - id: value
        type: s4
  string:
    seq:
      - id: length
        type: s1
      - id: value
        type: str
        encoding: ASCII
        size: length
enums:
  record:
    0: burp #Restore program attributes
  attribute_type:
    0: end
    1: backup_date          # date of backup
    2: backup_format        # backup format version
    3: backup_os            # backup operating system
    4: backup_compress
    5: backup_transportable # XDR datatypes for user data
    6: backup_blksize       # backup block size
    7: backup_file          # database file name
    8: backup_volume        # backup volume number
    9: backup_keyname       # name of crypt key
    10: backup_zip          # zipped backup file
    11: backup_hash         # hash of crypt key
    12: backup_crypt        # name of crypt plugin
