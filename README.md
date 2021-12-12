# About project
This project contains a description of the file formats used in the [Firebird]:(https://firebirdsql.org/) and [Red Database]:(https://reddatabase.ru/) projects. Formats are described in [Kaitai Struct]:(https://kaitai.io/) language. Not all formats are fully described; a more complete and accurate description can be seen in the source codes of the projects.
You can use these descriptions to develop your own utilities for working with structures used in Firebird projects.

## File Database
* ods11.ksy - on-disk-structure version 11. Used in Firebird 2.x, RedDatabase 2.x.
* ods12.ksy - on-disk-structure version 12. Used in Firebird 3.x, RedDatabase 3.x.
* ods13.ksy - on-disk-structure version 13. Used in Firebird 4.x, RedDatabase 4.x

## Replication logs
* replication_log_v1.ksy - replication log. Used in Red Database 2.6 (protocol 1), Red Database 3.0 и HQBird 3.0 (protocol 2).
* change_log_v1.ksy - change log. Improved version of the replication log. Used in RedDatabase 4.0 и Firebird 4.0.

## Status file
* rdb_replication_status_file.ksy - the status of the replication logs application file. Used in Red Database 2.6, Red Database 3.0 and HQBird 3.0.
* fb4_replication_status_file.ksy - статус файл применения репликационных журналов. Используется в Firebird 4.0 и Red Database 4.0.

# Requirements
The ksc utility is used to generate classes. 
The kaitaistruct package must be installed for Python.

# Usage example
Using the kaitai-struct-visualizer utility, you can view binaries by ksy description files.
View DB file employee.fdb RDBMS Firebird 4:

    ksv employee.fdb kaitai/ods11.fdb

Examples of use in Python: 

* view_replication_log.py - view replication log.
* view_rdb_rpl_status.py - view status replication log.
* view_change_log.py - view change log.
* view_fb4_rpl_status.py - view status change log.

# Restrictions
Data structures are loaded into RAM. If you need to view large files, you need an appropriate amount of RAM.
