#!/usr/bin/python
import pstats, sys
p = pstats.Stats(sys.argv[1])
print p.sort_stats('cumulative').print_stats(int(sys.argv[2]))
