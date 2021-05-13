meta:
  id: replication_journal_v26
  title: Red Database 2.6 asynchronously replication journal format
  application: rdb_smp_server
  endian: le
seq:
  - id: header
    type: header
  - id: segments
    type: segments
    size: header.segments_length
types:
  header:
    seq:
      - id: magic
        contents: [ "FBREPLLOG", 0x00 ]
        size: 10
      - id: version
        type: u2
      - id: state
        type: u4
        enum: journal_state
      - id: replication_guid
        size: 16
      - id: sequence
        type: u8
      - id: protocol
        type: u4
      - id: journal_length
        type: u4
    instances:
      segments_length:
        value: 'journal_length == 0 ? 0 : journal_length - 48'
  segments:
    seq:
      - id: segment
        type: segment
        repeat: eos
  segment:
    seq:
      - id: isc_date
        type: u4
      - id: isc_time
        type: u4
      - id: segment_length
        type: u4
      - id: packets
        type: packets
        size: segment_length
    instances:
      unixtime:
        value: '(isc_date - 40617 + 30) * 86400 + isc_time / 1000'
  packets:
    seq:
      - id: packet
        type: packet
        repeat: eos
  packet:
    seq:
      - id: tag
        type: u1
        enum: tag
      - id: transaction_id
        type:
          switch-on: tag
          cases:
            'tag::estarttransaction': s4
            'tag::ecommittransaction': s4
            'tag::erollbacktransaction': s4
            'tag::estartsavepoint': s4
            'tag::ecleanupsavepoint': s4
            'tag::einsertrecord': s4
            'tag::eupdaterecord': s4
            'tag::edeleterecord': s4
            'tag::echangegenerator': s4
            'tag::estoreblob': s4
            'tag::esuspendtxns': s4
            'tag::eresumetxns': s4
            'tag::esynctxns': s4
            'tag::epreparetransaction': s4
            'tag::eexecutestatement': s4
      - id: data
        type:
          switch-on: tag
          cases:
            'tag::einitialize': einitialize_16b
            'tag::estartattachment': s4
            'tag::ecleanupattachment': s4
            'tag::estarttransaction': u4
            'tag::ecleanupsavepoint': s4
            'tag::einsertrecord': table_data
            'tag::eupdaterecord': table_update_data
            'tag::edeleterecord': table_data
            'tag::echangegenerator': s8
            'tag::estoreblob': isc_blob
            'tag::eexecutestatement': isc_text
            'tag::echangegenerator2': change_generator
            'tag::ecreatedatabase': isc_text_2
  isc_text:
    seq:
      - id: text_length
        type: u4
      - id: text
        type: str
        encoding: ASCII
        size: text_length
  isc_text_2:
    seq:
      - id: text_length
        type: s2
      - id: text
        type: str
        encoding: ASCII
        size: text_length
  isc_blob:
    seq:
      - id: blob_id
        size: 8
      - id: blob_length
        type: u4
      - id: blob
        size: blob_length
  table_data:
    seq:
      - id: table_name_length
        type: u4
      - id: table_name
        type: str
        encoding: ASCII
        size: table_name_length
      - id: data_length
        type: u4
      - id: data
        size: data_length
  table_update_data:
    seq:
      - id: table_name_length
        type: u4
      - id: table_name
        type: str
        encoding: ASCII
        size: table_name_length
      - id: old_data_length
        type: u4
      - id: old_data
        size: old_data_length
      - id: new_data_length
        type: u4
      - id: new_data
        size: new_data_length
  change_generator:
    seq:
      - id: gen_name_len
        type: u4
      - id: gen_name
        type: str
        encoding: ASCII
        size: gen_name_len
      - id: value
        type: s8
  einitialize_16b:
    seq:
      - id: einitialize_16b
        size: 16
enums:
  journal_state:
    0: free
    1: used
    2: full
    3: arch
  tag:
    1: einitialize
    2: estartattachment
    3: ecleanupattachment
    4: estarttransaction
    5: ecommittransaction
    6: erollbacktransaction
    7: estartsavepoint
    8: ecleanupsavepoint
    9: einsertrecord
    10: eupdaterecord
    11: edeleterecord
    12: echangegenerator
    13: estoreblob
    14: esuspendtxns
    15: eresumetxns
    16: esynctxns
    17: epreparetransaction
    18: ecleanuptransactions
    19: eexecutestatement
    20: echangegenerator2
    21: ecreatedatabase
