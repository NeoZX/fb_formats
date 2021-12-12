meta:
  id: ods12
  title: Firebird 3.X and Red Database 3.X format ODS12
  application: firebird
  endian: le
  bit-endian: le
doc: | 
  Firebird file formats
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
        #exclude view data if page encrypted
        if: (flags_u1 < 0x80)
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
    instances:
      flags_u1:
        pos: 0x1
        type: u1
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
  default_page_flags:
    seq:
      - id: unused
        type: b7
      - id: encrypted
        type: b1
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
      - id: unused
        type: b2
      - id: encrypted
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
      - id: pages
        type: u4
        doc: This is the page number of the first pointer page
      - id: next_page
        type: u4
        doc: The page number of the header page in the next file of the database
      - id: oldest_transaction
        type: u4
      - id: oldest_active
        type: u4
      - id: next_transaction
        type: u4
      - id: sequence
        type: u2
        doc: The sequence number of this file within the database
      - id: flags
        size: 2
        type: header_flags
      - id: creation_date
        type: isc_timestamp
      - id: attachment_id
        type: u4
      - id: shadow_count
        type: s4
      - id: cpu
        type: u1
        doc: 'CPU database was created on'
        enum: cpu_type
      - id: os
        type: u1
        doc: 'OS database was created under'
        enum: os_type
      - id: cc
        type: u1
        doc: 'Compiler of engine on which database was created'
        enum: cc_type
      - id: compatibility_flags
        type: u1
        doc: 'Cross-platform database transfer compatibility flags'
      - id: ods_minor
        type: u2
        doc: 'Update version of ODS'
      - id: end
        type: u2
        doc: 'offset of HDR_end in page'
      - id: page_buffers
        type: u4
      - id: oldest_snapshot
        type: u4
        doc: 'Oldest snapshot of active transactions'
      - id: backup_pages
        type: s4
        doc: 'The amount of pages in files locked for backup'
      - id: crypt_page
        type: u4
        doc: 'Page at which processing is in progress'
      - id: top_crypt
        type: u4
        doc: 'Last page to crypt'
      - id: crypt_plugin
        type: str
        size: 32
        encoding: ASCII
        doc: 'Name of plugin used to crypt this DB'
      - id: att_high
        type: s4
        doc: 'High word of the next attachment counter'
      - id: tra_high
        size: 4
        doc: 'High words of the transaction counters'
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
      - id: page
        type: u4
        doc: 'Data page vector'
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
        doc: 'length of data in bucket'
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
        size: length
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
      - id: shutdown_mask_sysdba
        type: b1
        doc: '0x80'
      - id: unused
        type: b1
        doc: '0x100'
      - id: backup_mask
        type: b2
        enum: backup_mask
        doc: '0xc00'
      - id: shutdown_mask_full
        type: b1
        doc: '0x1000'
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
        value: '(isc_date - 40617 + 30) * 86400 + isc_time / 1000'
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
  hdr_clumplet_type: #need rename to avoid class confilcts
    0: end
    1: root_file_name
    2: secondary_file
    3: last_page
    4: sweep_interval
    5: crypt_checksum
    6: difference_file
    7: backup_guid
    8: crypt_key
    9: crypt_hash
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
