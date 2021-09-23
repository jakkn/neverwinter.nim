#
#
#            Interop API
#
#
## This file defines a simple interop API for use by other languages, such as C#.
## The file should be compiled without a main function (compile flag --noMain)
## which demands that NimMain be imported and called to initialize garbage
## collection. GC is necessary to operte with strings, and since we're
## stringifying JSON it must be called by every function.

import neverwinter/gff, neverwinter/gffjson
import json, streams

proc NimMain() {.importc.}

proc writeGffFromJson*(json: cstring, gffFilename: cstring) {.cdecl, exportc, dynlib.} =
  NimMain()
  let gff = parseJson($json).gffRootFromJson()
  var stream = openFileStream($gffFilename, fmWrite)
  stream.write(gff)
  stream.close()

proc readGffAsJson*(gffFilename: cstring): cstring {.cdecl, exportc, dynlib.} =
  NimMain()
  let input = openFileStream($gffFilename)
  let json: GffRoot = readGffRoot(input, false)
  input.close()
  let res: cstring = $json.toJson()
  result = res
