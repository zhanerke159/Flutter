# NOTES

## Level 1: order of events

Predicted:
A, C, fetchStudents #1, first frame, B (after 2 s), 6 students

Actual:
(впишите после запуска)

Unhandled Exception line (third call):
(впишите точную строку из консоли)

## Level 2: setState() called after dispose()

(впишите первую строку ошибки из консоли)

## Level 4: countdown

With _sub.cancel() in dispose (version B, Back at 7):
(впишите, что показала консоль)

Without _sub.cancel() (version B, Back at 7):
(впишите: setState() called after dispose() и tick 6 ... tick 0 без экрана)

Version A (no cancel in my code, Back at 7):
(впишите: консоль остановилась, StreamBuilder отменил подписку сам)

## Level 5: save without await

The user saw a success, but the server had rejected the save: Unhandled Exception: Bad state: server rejected 6.