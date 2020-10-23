# This script will open all the TextGrid files in a directory specified and
# output the number of tiers and the tier names for each file.

form List the TextGrid files in directory
  sentence Directory /home/exoglycerin/Dropbox/workspace/data/cayuga/
endform

clearinfo

wd$ = homeDirectory$ + "/Dropbox/workspace/data/cayuga/"

inDir$ = directory$
inDirWavs$ = inDir$ + "*.WAV"

# make sure inDir$ exists
if not fileReadable: inDir$
  exitScript: "The input folder doesn't exist"
endif

wavList = Create Strings as file list: "wavList", inDirWavs$

selectObject: wavList

numFiles = Get number of strings

for fileNum from 1 to numFiles
  selectObject: wavList
  wavFile$ = Get string: fileNum
  wav = Read from file: inDir$ + wavFile$
  objName$ = selected$: "Sound"
  endTime = Get end time
  tgPath$ = inDir$ + objName$ + ".TextGrid"
  if fileReadable: tgPath$
    appendInfoLine: wavFile$ + " is approximately " + fixed$(endTime, 2) + " seconds long."
    tg = Read from file: tgPath$
    tgName$ = selected$: "TextGrid"
    numTiers = Get number of tiers
    appendInfoLine: wavFile$ + " has " + string$(numTiers) + " tier(s)."
    for tierNum from 1 to numTiers
      selectObject: tg
      tierName$ = Get tier name: tierNum
      if tierName$ == "Word"
        selectObject: tg
        numIntervals = Get number of intervals: tierNum
        for intervalNum from 1 to numIntervals
          wordLabel$ = Get label of interval: tierNum, intervalNum
          wordStart = Get start time of interval: tierNum, intervalNum
          wordEnd = Get end time of interval: tierNum, intervalNum
          wordDur = wordEnd - wordStart
          if wordLabel$ <> ""
            appendInfoLine: wordLabel$ + tab$ + fixed$(wordDur*1000,2) + "ms"
          endif
        endfor
      endif
      #appendInfoLine: "Tier # " + string$(tierNum) + " is named " + tierName$ + "."
    endfor
  else
    appendInfoLine: fileName$ + " is missing a TextGrid file."
  endif
  appendInfoLine: ""
endfor
