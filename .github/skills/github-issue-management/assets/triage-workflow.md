# Triage Decision Flow

Use this flow when classifying a new or unlabelled issue.

```
START: New or unlabelled issue
         │
         ▼
  Is it a large umbrella task containing multiple sub-issues?
         │
    Yes──┴──No
    │          │
    ▼          ▼
  [epic]   Is something broken / not working as expected?
                │
           Yes──┴──No
           │          │
           ▼          ▼
         [bug]      Is it a feature, improvement, or technical task?
                        │
                   Yes──┴──No
                   │          │
                   ▼          ▼
                [story]   Needs clarification
                           → add [waiting-for-details]
                           → comment asking for more info
```

---

## After applying the core label

```
Core label applied
      │
      ▼
Is it urgent?  ──Yes──▶  add [priority-high]
      │
      ▼
Is it blocked by another issue?  ──Yes──▶  add [blocked], link to blocking issue
      │
      ▼
Is it not being worked on yet?  ──Yes──▶  optionally add [not-started]
      │
      ▼
Has it been intentionally deferred?  ──Yes──▶  add [out-of-scope]
      │
      ▼
Waiting for input from someone?  ──Yes──▶  add [feedback-required] or [waiting-for-details]
      │
      ▼
DONE: Issue is labelled
```

---

## Board membership

```
Issue labelled?
      │
      ├── [story] or [bug]  ──▶  Ensure it is on the project board
      │
      └── [epic]            ──▶  Must NOT be on the project board
```
