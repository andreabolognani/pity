#!/bin/sh

# stopwatch.sh - Calculate average execution time for a command
# Copyright (C) 2010  Andrea Bolognani <andrea.bolognani@roundhousecode.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# XXX Portability warning: this script should be farily portable; the %N
# format argument, however, is a GNU extension, so GNU date is required.

ITERATIONS=100

if [ "${#}" -lt 1 ]; then
	echo "Usage: ${0} COMMAND [ARGS]" >&2
	exit 1
fi

COMMAND="${1}"
shift
ARGS="${@}"

AVG=0
I=0

while [ "${I}" -lt "${ITERATIONS}" ]; do

	START_TIME=`date '+%s%N'`

	${COMMAND} ${ARGS}

	END_TIME=`date '+%s%N'`

	ELAPSED_TIME=`expr "${END_TIME}" - "${START_TIME}"`
	ELAPSED_TIME=`expr "${ELAPSED_TIME}" / 1000000`

	AVG=`expr "${AVG}" + "${ELAPSED_TIME}"`

	I=`expr "${I}" + 1`
done

echo "Iterations:   ${ITERATIONS}"
echo "Total time:   ${AVG}ms"

AVG=`expr "${AVG}" / "${ITERATIONS}"`

echo "Average time: ${AVG}ms"

exit 0
