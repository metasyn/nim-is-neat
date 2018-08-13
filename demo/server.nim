import htmlgen
import json
import strutils
import strformat

import jester
import arraymancer

import hasher

# Routing stuff
settings:
  port = Port 3000

type 
  validHashRequest = object
    texts*: seq[string]
    hashSize*: int
    k*: int

proc msgjson(m: string): string =
  return $ %* {"msg": m}

routes:
  get "/hello":
    resp h1("Hello, 世界！")

  post "/hash":
    try:
      var hashRequest = to(request.body.parseJson, validHashRequest)
      let labels = hashAndCluster(hashRequest.texts, hashRequest.hashSize, hashRequest.k)
      resp(
        Http200, 
        $(%* {"request": hashRequest, "cluster_labels": labels.toRawSeq()}),
        contentType="application/json"
        )

    except:
      let 
        exception = getCurrentException()
        stackTrace = exception.getStackTrace()
        msg = getCurrentExceptionMsg()
        response = &"Failed: {msg}"
      echo stackTrace

      resp(Http400, msgjson(response),
        contentType="application/json")

