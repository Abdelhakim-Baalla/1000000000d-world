const A = readline().split(' ').map(BigInt);
const B = readline().split(' ').map(BigInt);

let i = 0, j = 0;
let dotProduct = 0n;

while (i < A.length && j < B.length) {
    const overlap = A[i] < B[j] ? A[i] : B[j];

    dotProduct += overlap * A[i + 1] * B[j + 1];

    A[i] -= overlap;
    B[j] -= overlap;

    if (A[i] === 0n) i += 2;
    if (B[j] === 0n) j += 2;
}

console.log(dotProduct.toString());
