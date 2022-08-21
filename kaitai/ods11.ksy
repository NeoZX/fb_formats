meta:
  id: ods11
  title: Firebird 2.X and Red Database 2.X format ODS11
  application: firebird
  endian: le
  bit-endian: le
doc: | 
  Firebird file formats
doc-ref: firebird/src/jrd/ods.h
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
            'page_type::page_inventory_page': page_inventory_page
            'page_type::transaction_inventory_page': transaction_inventory_page
            'page_type::pointer_page': pointer_page
            'page_type::data_page': data_page
            'page_type::index_root_page': index_root_page
            'page_type::index_b_tree_page': index_b_tree_page
            'page_type::blob_page': blob_page
            'page_type::generator_page': generator_page
            'page_type::write_ahead_log': write_ahead_log
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
            #'page_type::write_ahead_log':
      - id: checksum
        type: u2
        doc: Always 12345, not used
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
  index_b_tree_page_flags:
    seq:
      - id: dont_gc
        type: b1
      - id: not_propagated
        type: b1
      - id: unused3
        type: b1
      - id: descending
        type: b1
      - id: all_record_number
        type: b1
      - id: large_keys
        type: b1
      - id: jump_info
        type: b1
      - id: released
        type: b1
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
        type: s2
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
      - id: misc
        size: 12
        doc: SLONG[3]
      - id: clumplets
        type: hdr_clumplet
        repeat: until
        repeat-until: _.type == hdr_clumplet_type::end
  page_inventory_page:
    seq:
      - id: pip_min
        type: s4
      - id: pip_bits
        size: _root.page_size - 16 - 4
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
        type: s4
      - id: next
        type: s4
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
      - id: max_space
        type: u2
        doc: 'Highest slot with space available'
      - id: page
        type: s4
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
        size: 1
        type: irt_flags
  index_b_tree_page:
    seq:
      - id: sibling
        type: s4
      - id: left_sibling
        type: s4
      - id: prefix_total
        type: s4
      - id: relation
        type: u2
      - id: length
        type: u2
        doc: 'length include page header'
      - id: id
        type: u1
      - id: level
        type: u1
        doc: '0 = leaf'
      - id: first_node_offset
        type: u2
      - id: jump_area_size
        type: u2
      - id: jumpers
        type: u1
      - id: jump_nodes
        type: jump_node
        repeat: expr
        repeat-expr: jumpers
      - id: btree_nodes
        #type: btree_node
        size: length - first_node_offset
  jump_node:
    seq:
      - id: jn_node_pointer
        type: u1
      - id: jn_prefix
        type: u1
      - id: jn_length
        type: u1
      - id: jn_offset
        type: u1
      - id: jn_data
        size: jn_prefix
  btree_node:
    seq:
      - id: prefix
        type: u1
      - id: length
        type: u1
      - id: some
        size: 1
      - id: size
        type: u1
      - id: data
        size: size
  blob_page:
    seq:
      - id: lead_page
        type: s4
      - id: sequence
        type: s4
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
        type: s4
      - id: waste1
        type: s4
      - id: waste2
        type: s2
      - id: waste3
        type: s2
      - id: waste4
        type: s2
      - id: waste5
        type: s2
      - id: value
        type: s8
        repeat: eos
  write_ahead_log:
    seq:
      - id: flags
        type: s4
      - id: log_cp_1
        type: ctrl_pt
      - id: log_cp_2
        type: ctrl_pt
      - id: log_file
        type: ctrl_pt
      - id: next_page
        type: s4
        doc: 'Next log page'
      - id: mod_tip
        type: s4
        doc: 'tip of modify transaction'
      - id: mod_tid
        type: s4
        doc: 'transaction id of modify process'
      - id: creation_date
        type: isc_timestamp
      - id: free
        type: s4
        repeat: expr
        repeat-expr: 4
      - id: end
        type: u1
      - id: data
        type: u1
        repeat: eos
  ctrl_pt:
    seq:
      - id: seqno
        type: s4
      - id: offset
        type: s4
      - id: p_offset
        type: s4
      - id: fn_length
        type: s2
  header_flags:
    seq:
      - id: active_shadow
        type: b1
      - id: no_force_write
        type: b1
      - id: crypt_process
        type: b1
      - id: encrypted
        type: b1
      - id: no_checksums
        type: b1
      - id: no_reserve
        type: b1
      - id: replica
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
  hdr_clumplet_type: #need rename to avoid class confilcts
    0: end
    1: root_file_name
    3: secondary_file
    4: last_page
    6: sweep_interval
    7: log_name
    9: password_file_key
    12: difference_file
    13: backup_guid
    14: repl_guid
    15: db_guid

