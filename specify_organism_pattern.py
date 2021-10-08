# prints organism in a pretty fashion
def print_pattern(mat):
    for row in mat:
        print(''.join(['■' if x else '□' for x in row]))

# converts pattern matrix to processing syntax
def mat_to_syntax(m):
    return str(m).replace(")", "}").replace("(", "{").replace("[", "{").replace("]", "}").replace("0", "false").replace("1", "true")

phases = []

while True:
    x, y = list(map(int, input("Input phase dimensions (Ex. 3 3): ").split()))

    print("Input each row of the organism pattern using 0 and 1 (with no delimiters): ")

    pattern_mat = []

    for _ in range(x):
        l = [int(c) for c in input()]
        assert len(l) == y
        pattern_mat.append(l)

    print("\nInputed pattern: ")
    print_pattern(pattern_mat)

    # we want to track the organism and all rotations of it
    rotate = lambda m : tuple(zip(*reversed(m)))

    # we call set on rotations to eliminate identical ones
    rotations = [pattern_mat, rotate(pattern_mat), rotate(rotate(pattern_mat)), rotate(rotate(rotate(pattern_mat)))]

    phases += [mat_to_syntax(mat) for mat in rotations]

    if input("Do you want to input another phase? (Y/n) ").lower() == 'n': break

# finally, we convert our pattern matricies to processing syntax
with open("targets.pde", 'w') as f:
    f.write("boolean[][][] targets = {" + ', '.join(set(phases)) + "};")

print("\nSaved organism's phase patterns to 'targets.pde'")