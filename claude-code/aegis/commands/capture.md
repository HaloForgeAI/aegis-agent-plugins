---
description: Compatibility command: capture durable work with Aegis.
argument-hint: <what to capture>
---

Prefer the plugin skill `/aegis:aegis-operator` when available.

First decide whether the request is durable team work. If it is only ordinary
Q&A, a completed one-off lookup/script/tool request, casual chat, or a simple
personal reminder, do not create a WorkItem; say that it does not belong on the
board unless the user wants it tracked.

If it is durable work, create it with `aegis_create_item`, add useful context
with `aegis_comment_item` when needed, then confirm in one short Aegis-style
sentence.

Item: $ARGUMENTS
