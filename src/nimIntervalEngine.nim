import times, tables
import print

type
  Idx = int
  Timestamp = float
  IntervalProc[T] = proc (obj: T)
  IntervalEngine[T] = ref object
    idx: Idx = 0
    intervals: Table[Idx, IntervalProc[T]]
    lastRun: Table[Idx, Timestamp]
    everys: Table[Idx, Timestamp]
    
proc getTimestamp(): float =
  return epochTime()

proc newIntervalEngine*[T](): IntervalEngine[T] =
  result = IntervalEngine[T]()

proc mustRun[T](ie: IntervalEngine[T], idx: Idx, curTimestamp: float): bool =
    let lastRun = ie.lastRun[idx]
    let every = ie.everys[idx]
    print curTimestamp - lastRun, every < (curTimestamp - lastRun)
    return every < (curTimestamp - lastRun)

proc tick*[T](ie: IntervalEngine[T], obj: T) =
  ## can be called as often as desired
  let curTimestamp = getTimestamp()
  for idx, pr in ie.intervals:
    if ie.mustRun(idx, curTimestamp):
      pr(obj)
      ie.lastRun[idx] = getTimestamp()
      
proc addInterval*[T](ie: IntervalEngine[T], pr: IntervalProc[T], every: float) =
  ie.intervals[ie.idx] = pr
  ie.lastRun[ie.idx] = getTimestamp()
  ie.everys[ie.idx] = every
  ie.idx.inc()

proc clear*[T](ie: IntervalEngine[T]) =
  ie.idx = 0
  ie.intervals.clear()
  ie.lastRun.clear()
  ie.everys.clear()

when isMainModule:
  import os
  var obj = "MY OBJ"
  proc intervalFoo(obj: string) = 
    echo "foo"
  proc intervalBaa(obj: string) = 
    echo "baa"


  var ie = newIntervalEngine[string]()
  ie.addInterval(intervalFoo, 5)
  ie.addInterval(intervalBaa, 3)
  ie.clear()
  while true:
    ie.tick(obj)
    sleep(200)

