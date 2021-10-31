meta:
  id: ods11
  title: Red Database 2.6 format ODS11.x
  application: rdb_inet_server
  endian: le
  bit-endian: le
doc: | 
  Red Database file formats
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
            'page_type::page_inventory_page': page_inventory_page
            'page_type::transaction_inventory_page': transaction_inventory_page
            'page_type::pointer_page': pointer_page
            'page_type::data_page': data_page
            #'page_type::index_root_page':
            #'page_type::index_b_tree_page':
            'page_type::index_b_tree_page': index_b_tree_page
            'page_type::blob_page': blob_page_flags
            'page_type::generator_page': generator_page
            #'page_type::write_ahead_log':
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
            #'page_type::blob_page': 
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
      - id: reserved
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
        type: hdr_clumplets
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
        type: dpr_records
  index_root_page:
    seq:
      - id: relation
        type: u2
      - id: count
        type: u2
        doc: 'number of indices'
        #struct irt_repeat_ods11
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
      - id: level
        type: u2
        doc: '0 = leaf'
#      - id: btree_nodes
#        type: btree_nodes
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
      - id: page
        type: s4
        doc: page number if level 1
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
      - id: values
        type: values
        doc: 'generator vector'
  #write_ahead_log:
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
  hdr_clumplets:
    seq:
      - id: clumplet
        type: hdr_clumplet
        repeat: until
        repeat-until: _.type == hdr_clumplet_type::end
  hdr_clumplet:
    seq:
      - id: type
        type: u1
        enum: hdr_clumplet_type
      - id: length
        type: u1
      - id: data
        size: length
  values:
    seq:
      - id: value
        type: value
        repeat: eos
  value:
    seq:
      - id: value
        type: s8
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

