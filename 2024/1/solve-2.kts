import java.io.File
import kotlin.text.Regex
import kotlin.math.abs

var list1 = mutableListOf<Int>()
var list2 = mutableListOf<Int>()

File("input").readLines().map { line ->
    Regex("[0-9]+")
        .findAll(line)
        .map { it.value.toInt() }
        .toList()
        .let { nums ->
            list1.add(nums[0])
            list2.add(nums[1])
        }
}

val frequency = list2.sorted().groupingBy { it }.eachCount();

val score = list1.map {
    it * (frequency.get(it) ?: 0)
}.sum()

println(score)
