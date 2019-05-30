#!/bin/sh

# Copyright 2018 Jordan Geoghegan

# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.

# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
# OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

# Download and parse StevenBlack hosts file into unbound compatible format

mkdir /tmp/unbound-adblock
cd /tmp/unbound-adblock || exit 99
ftp https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts && \
awk 'BEGIN { OFS = "" } NF == 2 && $1 == "0.0.0.0" { print "local-zone: \"", $2, "\" static" }' hosts > adblock.conf
mv /tmp/unbound-adblock/adblock.conf /tmp/adblock.conf
doas mv /tmp/adblock.conf /var/unbound/etc/
doas rcctl reload unbound

# Clean up after ourselves
rm -r /tmp/unbound-adblock
