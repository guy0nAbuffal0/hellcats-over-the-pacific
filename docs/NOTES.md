# Evidence notes index

The former daily log is preserved unchanged in
[`research/NOTES_HISTORY.md`](research/NOTES_HISTORY.md). It is historical
evidence, not required startup context.

For routine work, retrieve a function and its local evidence directly:

```sh
python3 tools/re_query.py function FUN_0000435a
python3 tools/re_query.py callers FUN_0000435a
python3 tools/re_query.py globals FUN_0000435a
python3 tools/re_query.py status FUN_0000435a
python3 tools/re_query.py symbol FUN_0000435a
```

Add a new note only when it records unique evidence that is not represented in
the reconstructed source, symbol registry, mapping manifest, test, or checkpoint.
Do not duplicate function bodies, tracker rows, or generated counts here.
