all: change_log_v1.py replication_log_v1.py rdb_replication_status_file.py fb4_replication_status_file.py nbak_header.py gbak_header.py

change_log_v1.py: kaitai/change_log_v1.ksy
	ksc -t python kaitai/change_log_v1.ksy

replication_log_v1.py: kaitai/replication_log_v1.ksy
	ksc -t python kaitai/replication_log_v1.ksy

rdb_replication_status_file.py: kaitai/rdb_replication_status_file.ksy
	ksc -t python kaitai/rdb_replication_status_file.ksy

fb4_replication_status_file.py: kaitai/fb4_replication_status_file.ksy
	ksc -t python kaitai/fb4_replication_status_file.ksy

nbak_header.py: kaitai/nbak_header.ksy
	ksc -t python kaitai/nbak_header.ksy

gbak_header.py: kaitai/gbak_header.ksy
	ksc -t python kaitai/gbak_header.ksy
