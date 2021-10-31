meta:
  id: ods13
  title: Firebird Database 4.0 format ODS13
  application: firebird
  endian: le
  bit-endian: le
doc: | 
  Firebird Database formats
doc-ref: src/jrd/ods.h
seq:
  - id: pages
    type: pages
instances:
  page_size:
    pos: 0x10
    type: u2
types:
  pages:
    seq:
      - id: page
        type: page
        size: _root.page_size
        repeat: eos
  page:
    seq:
      - id: header
        type: page_header
      - id: data
        type: 
          switch-on: header.type
          cases:
            'page_type::header_page': header_page
            'page_type::data_page': data_page
  header_page:
    seq:
      - id: page_size
        type: u2
      - id: ods_version
        type: u2
      - id: pages
        type: s4
        doc: This is the page number of the first pointer page
      - id: next_page
        type: u4
        doc: The page number of the header page in the next file of the database
      - id: oldest_transaction
        type: s4
      - id: oldest_active
        type: s4
      - id: next_transaction
        type: s4
      - id: sequence
        type: u2
        doc: The sequence number of this file within the database
      - id: flags
        size: 2
        type: header_flags
      - id: creation_date
        type: isc_timestamp
      - id: attachment_id
        type: s4
      - id: shadow_count
        type: s4
      - id: implementation
        size: 4
        type: implementation
        doc: src/common/classes/DbImplementation.cpp
      - id: ods_minor
        type: u2
      - id: ods_minor_original
        type: u2
      - id: end
        type: u2
      - id: page_buffers
        type: u4
      - id: bumped_transaction
        type: s4
      - id: oldest_snapshot
        type: s4
      - id: backup_pages
        type: s4
      - id: crypt_page
        type: u4
      - id: crypt_plugin
        type: strz
        size: 32
        encoding: ASCII
      - id: att_high
        type: s4
      - id: tra_high
        size: 8
        doc: type ushort
      - id: data
        type: u1
  data_page:
    seq:
      - id: sequence
        type: u4
      - id: relation
        type: u2
      - id: count
        type: u2
      - id: records
        type: dpr_records
  dpr_records:
    seq:
      - id: record
        type: dpr_record
        repeat: expr
        repeat-expr: _parent.count
  dpr_record:        
    seq:
      - id: offset
        type: u2
      - id: length
        type: u2
  page_header:
    seq:
      - id: type
        type: u1
        enum: page_type
      - id: flags
        size: 1
        type: page_flags
        #Значения флагов зависит от типов страницы
      - id: reserved
        type: u2
      - id: generation
        type: u4
      - id: scn
        type: u4
        doc: Used by nbackup
      - id: pageno
        type: u4
  page_flags: #Шаблон, флаги зависят от типа страницы
    seq:
      - id: bit_1
        type: b1
      - id: bit_2
        type: b1
      - id: bit_3
        type: b1
      - id: bit_4
        type: b1
      - id: bit_5
        type: b1
      - id: bit_6
        type: b1
      - id: bit_7
        type: b1
      - id: crypted_page
        type: b1
  header_flags:
    seq:
      - id: active_shadow
        type: b1
      - id: no_force_write
        type: b1
      - id: unused_bit_2
        type: b1
      - id: unused_bit_3
        type: b1
      - id: no_checksums
        type: b1
      - id: no_reserve
        type: b1
      - id: unused_bit_6
        type: b1
      - id: shutdown_mask_sysdba
        type: b1
      - id: sql_dialect_3
        type: b1
      - id: read_only
        type: b1
      - id: backup_mask
        type: b2
        enum: backup_mask
      - id: shutdown_mask_full
        type: b1
  implementation:
    seq:
      - id: cpu
        type: u1
        enum: implementation_cpu
      - id: os
        type: u1
        enum: implementation_os
      - id: cc
        type: u1
        enum: implementation_cc
      - id: compatibility_flags
        type: u1
        enum: implementation_compatibility_flags
  isc_timestamp:
    seq:
      - id: isc_date
        type: u4
      - id: isc_time
        type: u4
    instances:
      unixtime:
        value: '(isc_date - 40617 + 30) * 86400 + isc_time / 10000'
enums:
  page_type:
    0: undefined
    1: header_page
    2: page_inventory_page
    3: transaction_inventory_page
    4: pointer_page
    5: data_page
    6: index_root_page
    7: index_b_tree_page
    8: blob_page
    9: generator_page
    10: write_ahead_log
  backup_mask: #need rename to avoid class confilcts
    0: not_backup
    1: backup_mode
    2: merge
    3: unknown
  shutdown_mask: #need rename to avoid class confilcts
    0: online
    1: multi_user_maintance
    2: full_shutdown
    3: single_user_maintance
  implementation_cpu:
    0: i386
    1: x64
    2: ultra_aparc
    3: power_pc
    4: power_pc64
    5: mipsel
    6: mips
    7: arm
    8: ia64
    9: s390
    10: s390x
    11: sh
    12: sheb
    13: hppa
    14: alpha
    15: arm64
    16: power_pc64el
    17: m68k
    18: risc_v64
  implementation_os:
    0: windows
    1: linux
    2: darwin
    3: solaris
    4: hpux
    5: aix
    6: mms
    7: free_bsd
    8: net_bsd
  implementation_cc:
    0: msvc
    1: gcc
    2: xlc
    3: acc
    4: sun_studio
    5: icc
  implementation_compatibility_flags:
    0: endian_little
    1: endian_big
