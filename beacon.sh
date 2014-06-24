#!/bin/bash

#--------------------------------------------------------------------------
# Copyright (c) 2014. Regents of the University of California
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#--------------------------------------------------------------------------
DIR=$(pwd)

liftover="$DIR/liftOverfiles/liftover"
lochainPref="$DIR/liftOverfiles/liftover_chains"
lochainSuff="ToHg19.over.chain"
work="$DIR/liftOverfiles/work"
liftoverIn="$work/liftin.bed"
liftoverOut="$work/liftout.bed"
liftoverUn="$work/liftun.bed"

if [ "$#" -ne 4 ]
	then
	echo "All fields are required. Try again"
	##echo "</body></html>"
	exit 1
fi

ref=$1
chr=$2
coord=$3
allele=$4

echo 1 >> $work/log.txt

if [ $ref != "hg19" ]
then
	echo $chr:$coord-$coord > $liftoverIn
	lochain=$lochainPref/$ref$lochainSuff
	cd $work
	$liftover -positions $liftoverIn $lochain $liftoverOut $liftoverUn > /dev/null 2>&1
	cd $DIR
	testOut=`wc -l $liftoverOut | cut -d " " -f1`
	if [ $testOut -eq 0 ] 
	then
		echo "Beacon cannot convert input coordinate to hg19. Please try another one"
		exit 1
	fi
	coord=$(cut -d "-" -f2 $liftoverOut)
fi

chr_path="$DIR/files"

if echo del DEL deletion Deletion | grep $allele > /dev/null 2>&1
	then 
	result=`grep "^$coord [0-9][0-9]*[[:space:]]*$" $chr_path/$chr.frequencies | cut -f2 -d " "`
else 
	result=`grep "^$coord $allele" $chr_path/$chr.frequencies | cut -f3 -d " "`
fi
if [ -z $result ]
	then
	echo "Beacon cannot find allele $allele at coordinate $chr:$coord of hg19"
else
	echo "Beacon found allele $allele at coordinate $chr:$coord of hg19 with frequency $result"
fi


