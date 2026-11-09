A = list(map(int, input().split()))
B = list(map(int, input().split()))

i, j = 0, 0
dot_product = 0

while i < len(A) and j < len(B):
    overlap = min(A[i], B[j])

    dot_product += overlap * A[i + 1] * B[j + 1]

    A[i] -= overlap
    B[j] -= overlap

    if A[i] == 0:
        i += 2
    if B[j] == 0:
        j += 2

print(dot_product)
