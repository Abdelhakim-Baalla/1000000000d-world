# 1000000000D World

[![Node.js](https://img.shields.io/badge/Node.js-%E2%89%A514-339933?logo=node.js&logoColor=white)](https://nodejs.org/)
[![Python](https://img.shields.io/badge/Python-3.8%2B-3776AB?logo=python&logoColor=white)](https://python.org/)
[![PHP](https://img.shields.io/badge/PHP-8.0%2B-777BB4?logo=php&logoColor=white)](https://php.net/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

Dot product of two **one-billion-dimensional** vectors, stored as run-length
encoded (RLE) pairs — solved in `O(runs)` instead of `O(10⁹)`.

Three reference implementations: **JavaScript**, **Python 3** and **PHP**.

---

## Overview

A vector in 1000000000D World has exactly `10⁹` integers. Because consecutive
values repeat heavily, each vector is stored compressed as a flat list of
`(count, value)` pairs:

```
3 1 2 2 999999995 3   ≡   [1,1,1, 2,2, 3,3,3, …, 3]
```

Given two such vectors `A` and `B`, compute

```
A · B = Σ aᵢ · bᵢ
```

without ever expanding them. Naively materialising a vector needs 10⁹ integers
(≈ 8 GB); the RLE representation is a few dozen numbers, so the whole computation
is a linear merge over the *runs*.

---

## Approach — two-pointer run merge

Both vectors are streams of runs. Walk them in parallel, exactly like merging two
sorted ranges:

```js
while (i < A.length && j < B.length) {
    const overlap = A[i] < B[j] ? A[i] : B[j];   // shared prefix length
    dotProduct += overlap * A[i + 1] * B[j + 1]; // count × valueA × valueB
    A[i] -= overlap;                             // consume from A's run
    B[j] -= overlap;                             // consume from B's run
    if (A[i] === 0n) i += 2;                     // run exhausted → next pair
    if (B[j] === 0n) j += 2;
}
```

Why it is correct:

- `overlap = min(remainingA, remainingB)` is exactly the number of positions where
  the *current* run of `A` and the *current* run of `B` coincide. Every position in
  that window contributes `valueA · valueB`, so the product can be added once and
  multiplied by the window length.
- After the subtraction, at least one run is fully consumed, so the pointers always
  make progress — the loop cannot spin.
- One pass, no expansion, no storage beyond the two input arrays.

### Numeric safety

| Language | Strategy |
|:--------:|----------|
| JavaScript | `BigInt` (`0n`, `.map(BigInt)`), because products can exceed `2⁵³`. |
| Python | Native arbitrary-precision `int` — no special handling. |
| PHP | 64-bit integers; the statement bounds every intermediate result below `2⁴⁰`, so no overflow. |

### Complexity

| | |
|---|---|
| Time | `O(rA + rB)` — each run is consumed at most once |
| Space | `O(rA + rB)` for the inputs, `O(1)` working memory |
| Naive alternative | `O(10⁹)` time and memory |

---

## Input / Output

**Input**

```
Line 1: compressed vector A — pairs of <count> <value>
Line 2: compressed vector B — pairs of <count> <value>
```

**Output**

```
The dot product A · B
```

**Example**

Input:

```
50000001 1 49999999 -1
50000000 1 50000000 1
```

Output:

```
2
```

The first 50 000 001 positions contribute `+50 000 001`, the remaining 49 999 999
contribute `-49 999 999`, leaving `2`.

---

## Execution

### JavaScript

```bash
node runner.js solution.js < tests/01_example.txt
```

(`runner.js` supplies CodinGame's `readline()` locally; on the platform the plain
`solution.js` runs as-is.)

### Python

```bash
python3 solution.py < tests/01_example.txt
```

### PHP

```bash
php solution.php < tests/01_example.txt
```

### Run every test in every language

```bash
./run_tests.sh
```

10 cases: the sample, single-run vectors, exact cancellation, mixed runs, negative
values, a `10¹²` result, asymmetric run boundaries, zero values, 100 runs, and a
run split across vectors.

---

## Author

**Abdelhakim Baalla**

- GitHub: [https://github.com/Abdelhakim-Baalla](https://github.com/Abdelhakim-Baalla)

## License

Released under the [MIT License](./LICENSE).
