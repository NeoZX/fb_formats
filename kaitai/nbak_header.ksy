meta:
  id: nbak_header
  title: NBackup file header version 1
  application: nbackup
  endian: le
  bit-endian: le
doc: | 
  Firebird nbackup file format version 1
doc-ref: src/utilites.nbackup.cpp
seq:
  - id: header
    type: header
    size: 52
types:
  header:
    seq:
      - id: magic
        contents: [ "NBAK"]
        size: 4
      - id: version
        type: s2
      - id: level
        type: s2
      - id: backup_guid
        size: 16
      - id: prev_guid
        size: 16
      - id: page_size
        type: u4
      - id: backup_scn
        type: u4
      - id: prev_scn
        type: u4
