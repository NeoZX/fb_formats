meta:
  id: ods14
  title: Firebird 6.X and Red Database 6.X format ODS14
  application: firebird
  endian: le
  bit-endian: le
doc: | 
  Firebird Database formats
doc-ref: firebird/src/jrd/ods.h
seq:
  - id: pages
    type: page
    size: _root.page_size
    repeat: eos
instances:
  page_size:
    pos: 0x10
    type: u2
types:
  page:
    seq:
      - id: header
        type: page_header
      - id: data
        type:
          switch-on: header.type
          cases:
            'page_type::header_page': header_page
            'page_type::page_inventory_page': page_inventory_page
            'page_type::transaction_inventory_page': transaction_inventory_page
            'page_type::pointer_page': pointer_page
            'page_type::data_page': data_page
            'page_type::index_root_page': index_root_page
            'page_type::index_b_tree_page': index_b_tree_page
            'page_type::blob_page': blob_page
            'page_type::generator_page': generator_page
            'page_type::scn_page': scn_page
  page_header:
    seq:
      - id: type
        type: u1
        enum: page_type
      - id: flags
        size: 1
        type:
          switch-on: type
          cases:
            #'page_type::header_page':
            #'page_type::page_inventory_page':
            #'page_type::transaction_inventory_page':
            'page_type::pointer_page': pointer_page_flags
            'page_type::data_page': data_page_flags
            #'page_type::index_root_page':
            #'page_type::index_b_tree_page':
            'page_type::index_b_tree_page': index_b_tree_page_flags
            'page_type::blob_page': blob_page_flags
            #'page_type::generator_page':
            #'page_type::scn_page':
      - id: reserved
        type: u2
      - id: generation
        type: u4
      - id: scn
        type: u4
        doc: Used by nbackup
      - id: page_no
        type: u4
  pointer_page_flags:
    seq:
      - id: ppg_eof
        type: b1
        doc: 'Last pointer page in relation'
  data_page_flags:
    seq:
      - id: orphan
        type: b1
      - id: full
        type: b1
      - id: large
        type: b1
      - id: swept
        type: b1
      - id: secondary
        type: b1
  index_b_tree_page_flags:
    seq:
      - id: dont_gc
        type: b1
      - id: descending
        type: b1
      - id: jump_info
        type: b1
      - id: released
        type: b1
        doc: 'Page was released from b-tree'
  blob_page_flags:
    seq:
      - id: pointers
        type: b1
  header_page:
    seq:
      - id: page_size
        type: u2
      - id: ods_version
        type: u2
      - id: ods_minor
        type: u2
      - id: flags
        type: header_flags
        size: 2
      - id: backup_mode
        type: u1
        enum: backup_mode
      - id: shutdown_mode
        type: u1
        enum: shutdown_mode
      - id: replica_mode
        type: u2
        enum: replica_mode
      - id: pages
        type: u4
      - id: page_buffers
        type: u4
      - id: end
        type: u4
        doc: Offset of end in page
      - id: next_transaction
        type: u8
        doc: Next transaction id
      - id: oldest_transaction
        type: u8
        doc: Oldest interesting transaction
      - id: oldest_active
        type: u8
        doc: transaction
      - id: oldest_snapshot
        type: u8
        doc: transaction
      - id: attachment_id
        type: u8
        doc: Next attachment id
      - id: struct_cpu
        type: u1
        doc: 'CPU database was created on'
        enum: cpu_type
      - id: struct_os
        type: u1
        doc: 'OS database was created on'
        enum: os_type
      - id: struct_cc
        type: u1
        doc: 'Compiler of engine on witch database was created'
        enum: cc_type
      - id: struct_compat
        type: u1
      - id: db_guid
        size: 16
      - id: creation_date
        type: isc_timestamp
      - id: shadow_count
        type: s4
      - id: crypt_page
        type: u4
      - id: crypt_plugin
        size: 32
      - id: clumplets
        type: hdr_clumplet
        repeat: until
        repeat-until: _.type == hdr_clumplet_type::end
  page_inventory_page:
    seq:
      - id: pip_min
        type: u4
        doc: 'Lowest (posible) free page'
      - id: pip_extent
        type: u4
        doc: 'Lowest free extent'
      - id: pip_used
        type: u4
        doc: 'Number of pages allocated from this PIP page'
      - id: pip_bits
        size: _root.page_size - 16 - 4 - 4 - 4
  transaction_inventory_page:
    seq:
      - id: next
        type: s4
        doc: 'Next transaction inventory page'
      - id: transactions
        type: u1
        doc: 'Array'
  pointer_page:
    seq:
      - id: sequence
        type: u4
      - id: next
        type: u4
        doc: 'Next pointer page'
      - id: count
        type: u2
        doc: 'Number of slots active'
      - id: relation
        type: u2
        doc: 'relation id'
      - id: min_space
        type: u2
        doc: 'Lowest slot with space available'
      - id: align
        size: 2
        doc: 'Array size, but not used'
      - id: pages
        type: u4
        doc: 'Data page vector'
        repeat: expr
        repeat-expr: count
      - id: pages_flags
        type: ppg_dp_flags
        size: 1
        doc: 'Data page flags'
        repeat: expr
        repeat-expr: count
  ppg_dp_flags:
    seq:
      - id: full
        type: b1
        doc: 'Data page is FULL'
      - id: large
        type: b1
        doc: 'Large object is on data page'
      - id: swept
        type: b1
        doc: 'Sweep has nothing to do on data page'
      - id: secondary
        type: b1
        doc: 'Primary record versions not stored on data page'
      - id: empty
        type: b1
        doc: 'Data page is empty'
  data_page:
    seq:
      - id: sequence
        type: u4
      - id: relation
        type: u2
      - id: count
        type: u2
      - id: records
        type: dpr_record
        repeat: expr
        repeat-expr: count
  index_root_page:
    seq:
      - id: relation
        type: u2
        doc: 'Releation id'
      - id: count
        type: u2
        doc: 'Number of indices'
      - id: irt_rpt
        type: irt_rpt
        repeat: expr
        repeat-expr: count
  irt_rpt:
    seq:
      - id: root
        type: s4
      - id: transaction
        type: s4
      - id: desc
        type: u2
        doc: 'Offset to key descriptions'
      - id: keys
        type: u1
        doc: 'Number of keys in index'
      - id: flags
        size: 8
        type: irt_flags
  index_b_tree_page:
    seq:
      - id: sibling
        type: u4
        doc: 'right sibling page'
      - id: left_sibling
        type: u4
        doc: 'left sibling page'
      - id: prefix_total
        type: s4
        doc: 'sum of all prefixes on page'
      - id: relation
        type: u2
        doc: 'relation id for consistency'
      - id: length
        type: u2
        doc: 'length of data in bucket (offset end of data on page)'
      - id: id
        type: u1
        doc: 'index id for consistency'
      - id: level
        type: u1
        doc: '0 = leaf'
      - id: jump_interval
        type: u2
        doc: 'interval between jump nodes'
      - id: jump_size
        type: u2
        doc: 'size of the jump table'
      - id: jump_count
        type: u1
        doc: 'number of jump nodes'
      - id: btree_nodes
        size: length - 39
  blob_page:
    seq:
      - id: lead_page
        type: u4
      - id: sequence
        type: u4
      - id: length
        type: u2
      - id: pad
        type: u2
        doc: unused
      #next page if flags in header=blp_pointers
      - id: data
        size: length
  generator_page:
    seq:
      - id: sequence
        type: u4
        doc: 'Sequence number'
      - id: dummy1
        type: u4
        doc: 'Alignment enforced'
      - id: value
        type: s8
        repeat: eos
  scn_page:
    seq:
      - id: sequence
        type: u4
        doc: 'Sequence number in page space'
      - id: pages
        type: u1
        doc: 'SCNs vector'
  header_flags:
    seq:
      - id: active_shadow
        type: b1
        doc: '0x1'
      - id: no_force_write
        type: b1
        doc: '0x2'
      - id: crypt_process
        type: b1
        doc: '0x4'
      - id: no_reserve
        type: b1
        doc: '0x8'
      - id: sql_dialect_3
        type: b1
        doc: '0x10'
      - id: read_only
        type: b1
        doc: '0x20'
      - id: encrypted
        type: b1
        doc: '0x40 Database is encrypted'
  dpr_record:
    seq:
      - id: offset
        type: u2
      - id: length
        type: u2
  hdr_clumplet:
    seq:
      - id: type
        type: u1
        enum: hdr_clumplet_type
      - id: length
        type: u1
      - id: data
        size: length
  irt_flags:
    seq:
      - id: unique
        type: b1
      - id: descending
        type: b1
      - id: in_progress
        type: b1
      - id: foreign
        type: b1
      - id: primary
        type: b1
      - id: expression
        type: b1
      - id: complete_segs
        type: b1
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
    10: scn_page
  backup_mode: #need rename to avoid class confilcts
    0: not_backup
    1: backup_mode
    2: merge
    3: unknown
  shutdown_mode: #need rename to avoid class confilcts
    0: online
    1: multi_user_maintance
    2: full_shutdown
    3: single_user_maintance
  replica_mode:
    0: none
    1: read_only
    2: read_write
  hdr_clumplet_type: #need rename to avoid class confilcts
    0: end
    1: root_file_name
    2: unused_secondary_file
    3: unused_last_page
    4: sweep_interval
    5: crypt_checksum
    6: difference_file
    7: backup_guid
    8: crypt_key
    9: crypt_hash
    10: unused_db_guid
    11: repl_seq
  cpu_type:
    0: intel
    1: amd
    2: ultrasparc
    3: powerpc
    4: powerpc64
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
    16: powerpc64el
    17: m68k
  os_type:
    0: windows
    1: linux
    2: darwin
    3: solaris
    4: hpux
    5: aix
    6: mms
    7: freebsd
    8: netbsd
  cc_type:
    0: msvc
    1: gcc
    2: xlc
    3: acc
    4: sunstudio
    5: icc
