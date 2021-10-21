all: change_log_v1.py replication_log_v1.py rdb_replication_status_file.py

change_log_v1.py: kaitai/change_log_v1.ksy
	ksc -t python kaitai/change_log_v1.ksy

replication_log_v1.py: kaitai/replication_log_v1.ksy
	ksc -t python kaitai/replication_log_v1.ksy

rdb_replication_status_file.py: kaitai/rdb_replication_status_file.ksy
	ksc -t python kaitai/rdb_replication_status_file.ksy
