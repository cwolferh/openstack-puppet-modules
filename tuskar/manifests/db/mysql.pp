#
# Copyright (C) 2014 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: tuskar::db::mysql
#
# The tuskar::db::mysql class creates a MySQL database for tuskar.
# It must be used on the MySQL server
#
# === Parameters
#
# [*password*]
#   (required) Password that will be used for the tuskar db user.
#
# [*dbname*]
#   (optional) Name of tuskar database.
#   Defaults to tuskar
#
# [*user*]
#   (optional) Name of tuskar user.
#   Defaults to tuskar
#
# [*host*]
#   (optional) Host where user should be allowed all privileges for database.
#   Defaults to 127.0.0.1
#
# [*allowed_hosts*]
#   (optional) Hosts allowed to use the database
#   Defaults to undef.
#
# [*charset*]
#   (optional) Charset of tuskar database
#   Defaults 'utf8'.
#
# [*collate*]
#   (optional) Charset collate of tuskar database
#   Defaults 'utf8_general_ci'.
#
# [*mysql_module*]
#   (optional) Deprecated. Does nothing
#
class tuskar::db::mysql(
  $password,
  $dbname        = 'tuskar',
  $user          = 'tuskar',
  $host          = '127.0.0.1',
  $allowed_hosts = undef,
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
  $mysql_module  = undef,
) {

  if $mysql_module {
    warning('The mysql_module parameter is deprecated. The latest 2.x mysql module will be used.')
  }

  validate_string($password)

  ::openstacklib::db::mysql { 'tuskar':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  ::Openstacklib::Db::Mysql['tuskar'] ~> Exec<| title == 'tuskar-dbsync' |>
}
