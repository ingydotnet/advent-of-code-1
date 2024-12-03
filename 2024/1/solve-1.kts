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

list1 = list1.sorted().toMutableList()
list2 = list2.sorted().toMutableList()

val sol = list1.indices.map { i -> abs(list1[i] - list2[i]) }.sum()

println(sol)
