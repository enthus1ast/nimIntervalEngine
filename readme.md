A small Nim module that 
executes a given proc in an interval.

Good for executing a given job every x seconds
from a "main loop"


```nim
import os # for sleep
import intervalEngine

var obj = "MY OBJ"
proc intervalFoo(obj: string) = 
    echo "foo"
proc intervalBaa(obj: string) = 
    echo "baa"

var ie = newIntervalEngine[string]()
ie.addInterval(intervalFoo, every = 5)
ie.addinterval(intervalbaa, every = 3)
# ie.clear() ## would clear the intervals
while true:
    ie.tick(obj) ## tick can be called as often as desired
    sleep(200)
```
