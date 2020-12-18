import java.io.File

data class Ticket(val fields: List<Int>)
data class Rule(val name: String, val ranges: List<IntRange>)
class TicketValidator constructor(private val rules: List<Rule>) {
    fun isValid(ticket: Ticket) : Boolean {
        return this.invalidFields(ticket).isEmpty()
    }

    fun invalidFields(ticket: Ticket) : List<Int> {
        return ticket.fields.filter { field ->
            !this.rules.any { rule -> rule.ranges.any { range -> range.contains(field) } }
        }
    }
}

class RuleSolver constructor(private val rules: List<Rule>, private val tickets: List<Ticket>) {
    fun orderedRules() : List<Rule> {
        val possibilities = this.possibilities()
        var lastSettledCount = -1
        var settledCount = 0
        while (settledCount < possibilities.size && lastSettledCount != settledCount) {
            lastSettledCount = settledCount
            for (i in possibilities.indices) {
                if (possibilities[i].count() == 1) {
                    val settledRule : Rule = possibilities[i].single()
                    for (j in possibilities.indices) {
                        if (i != j) possibilities[j].remove(settledRule)
                    }
                }
            }
            settledCount = possibilities.filter { it.count() == 1 }.count()
        }

        return possibilities.map { it.single() }
    }

    private fun possibilities() : List<MutableSet<Rule>> {
        return this.tickets[0].fields.indices.map { i ->
            this.tickets.map { it.fields[i] }
        }.map { this.validRulesForValues(it).toMutableSet() }
    }

    private fun validRulesForValues(values: List<Int>) : Set<Rule> {
        return values.fold(this.rules.toSet()) { rules, value -> rules.intersect(this.validRulesForValue(value)) }
    }

    private fun validRulesForValue(value: Int) : Set<Rule> {
        return this.rules.filter { it.ranges.any { range -> range.contains(value) } }.toSet()
    }
}

fun main() {
    val lines = File("input.txt").readLines()
    val rules = buildRules(lines.takeWhile { it != "" })
    val ticket = Ticket(lines.dropWhile { it != "" }.drop(2)[0].split(",").map { it.toInt() })
    val otherTickets = lines.takeLastWhile { it != "" }.drop(1).map { Ticket(it.split(",").map { it.toInt() }) }
    val validator = TicketValidator(rules)
    val score1 = otherTickets.map { validator.invalidFields(it) }.filter { it.isNotEmpty() }.map { it[0] }.sum()
    println("Part 1: $score1")
    val allValidTickets = otherTickets.filter { validator.isValid(it) } + ticket
    val orderedRules = RuleSolver(rules, allValidTickets).orderedRules()
    val score2 = orderedRules.mapIndexed { index, rule -> if (rule.name.startsWith("departure")) ticket.fields[index] else 1 }.fold(1L) { acc, i -> acc * i }
    println("Part 2: $score2")
}

fun buildRules(rulesLines: List<String>) : List<Rule> {
    return rulesLines.map { ruleLine ->
        val name = ruleLine.takeWhile { it != ':' }
        val ranges = ruleLine.dropWhile { it != ':' }.drop(2).split(" or ").map {
            val (start, end) = it.split("-").map { it.toInt() }
            IntRange(start, end)
        }
        Rule(name, ranges)
    }
}