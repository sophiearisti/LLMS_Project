| Variable Name    | Variable Label               | Value Labels    | Levels Var. Type |
| ---------------- | ---------------------------- | --------------- | ---------------- |
| session          | Session ID (date-time)       | yymmdd-hh:mm    | String           |
| country          | Country                      |                 | Binary           |
|                  |                              | Switzerland     | 0                |
|                  |                              | USA             | 1                |
| Subject          | Subject ID within session    | 1, 2, …, 34     | Integer          |
| communication    | Communication condition      |                 | Binary           |
|                  |                              | NOCOMM          | 0                |
|                  |                              | COMM            | 1                |
| delay            | Delay condition              |                 | Categorical      |
|                  |                              | IMM             | 0                |
|                  |                              | EARLY           | 1                |
|                  |                              | LATE            | 2                |
| role             | Role                         |                 | Binary           |
|                  |                              | Trustor         | 0                |
|                  |                              | Trustee         | 1                |
| numrolls         | Number ROLL choices          | 0, 1, 2, …, 10  | Integer          |
| numins           | Number IN choices            | 0, 1, 2, …, 10  | Integer          |
| firstquest       | Responded to 1st survey      |                 | Binary           |
|                  |                              | No              | 0                |
|                  |                              | Yes             | 1                |
| secondquest      | Responded to 2nd survey      |                 | Binary           |
|                  |                              | No              | 0                |
|                  |                              | Yes             | 1                |
| Belief           | Belief 1BG                   | 0, 1, 2, …, 100 | Integer          |
| Belief2          | Belief 1BM                   | 0, 1, 2, …, 10  | Integer          |
| Belief2nd        | Belief 2BM                   | 0, 1, 2, …, 10  | Integer          |
| BeliefOtherGroup | Belief 1BO                   | 0, 1, 2, …, 100 | Integer          |
| age              | Age (years)                  | 17-67           | Integer          |
| female           | Female                       |                 | Binary           |
|                  |                              | male            | 0                |
|                  |                              | female          | 1                |
| time             | Time Preference (MPL-T)      | 0, 1, 2, …, 11  | Integer          |
| risk             | Risk Preference (MPL-R)      | 0, 1, 2, …, 11  | Integer          |
| Message          | Trustee's message to trustor | Open ended      | String           |
Recalled_Message Trustee's message (recalled) Open ended String
| recall_missing | Did not collect recall |     | Binary |
| -------------- | ---------------------- | --- | ------ |
|                |                        | No  | 0      |
|                |                        | Yes | 1      |
| is_promise     | Classified as promise  |     | Binary |
|                |                        | No  | 0      |
|                |                        | Yes | 1      |
recalled_as_promise Trustee recalled message as promise Binary
|               |                                    | No    | 0      |
| ------------- | ---------------------------------- | ----- | ------ |
|               |                                    | Yes   | 1      |
| is_efficiency | Classified as appeal to efficiency |       | Binary |
|               |                                    | No    | 0      |
|               |                                    | Yes   | 1      |
| is_ethics     | Classified as appeal to fairness   |       | Binary |
|               |                                    | No    | 0      |
|               |                                    | Yes   | 1      |
| Early         | EARLY Dummy                        |       | Binary |
|               |                                    | Other | 0      |

EARLY 1
| Late | LATE Dummy | Binary |
| ---- | ---------- | ------ |
Other 0
LATE 1
| ImmNoComm | IMMXNOCOMM Dummy | Binary |
| --------- | ---------------- | ------ |
Other 0
IMM and NOCOMM 1
| EarlyNoComm | EARLYXNOCOMM Dummy | Binary |
| ----------- | ------------------ | ------ |
Other 0
EARLY and NOCOMM 1
| LateNoComm | LATEXNOCOMM Dummy | Binary |
| ---------- | ----------------- | ------ |
Other 0
LATE and NOCOMM 1
| ImmComm | IMMXCOMM Dummy | Binary |
| ------- | -------------- | ------ |
Other 0
IMM and COMM 1
| EarlyComm | EARLYXCOMM Dummy | Binary |
| --------- | ---------------- | ------ |
Other 0
EARLY and COMM 1
| LateComm | LATEXCOMM Dummy | Binary |
| -------- | --------------- | ------ |
Other 0
LATE and COMM 1