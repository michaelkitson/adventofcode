function count_child_bags(color,    children, count, child_values, i) {
    if (!children_for[color]) {
	return 0
    }
    split(children_for[color], children, ";")
    count = 0
    for (i = 1; i <= length(children); i++) {
	split(children[i], child_values, ",")
	count = count + child_values[2] * (1 + count_child_bags(child_values[1]))
    }
    return count
}

function array_contains(array, value,    key) {
    for (key in array) {
	if (array[key] == value) {
	    return 1
	}
    }
    return 0
}

{
    parent = $1 " " $2
    for (i = 5; i + 3 <= NF; i = i + 4) {
	num = $i
	child = $(i+1) " " $(i+2)
	if (parents_for[child] != "") {
	    parents_for[child] = parents_for[child] ";"
        }
	parents_for[child] = parents_for[child] parent

	if (children_for[parent] != "") {
	    children_for[parent] = children_for[parent] ";"
	}
	children_for[parent] = children_for[parent] child "," num
    }
}
END {
    parents[1] = "shiny gold"
    last_parent_count = 0
    parent_count = 1

    while (last_parent_count != parent_count) {
	for (key1 in parents) {
	    parent = parents[key1]
	    split(parents_for[parent], potentially_new_parents, ";")
	    for (key2 in potentially_new_parents) {
		potentially_new_parent = potentially_new_parents[key2]
		if (!array_contains(parents, potentially_new_parent)) {
		    parents[length(parents)+1] = potentially_new_parent
		}
	    }
	}
	last_parent_count = parent_count
	parent_count = length(parents)
    }
    print "Part 1:", parent_count - 1
    print "Part 2:", count_child_bags("shiny gold")
}
