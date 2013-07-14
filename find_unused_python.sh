#!/bin/bash
ack 'def ' | perl -pe 's/.*def (\w+)\(.*/\1/' | sort | uniq | xargs -I{} bash -c 'echo -n {} && ack "\b{}\b" | wc -l' | egrep -v '^test_' | egrep ' 1$'
