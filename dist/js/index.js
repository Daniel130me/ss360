const arr1 = { 'age': 20, 'name': 'sola' }
const arr2 = { 'age': 20, 'name': 'sola1' }


function newme(ar1, ar2) {
    const val1 = Object.values(ar1)
    const val2 = Object.values(ar2)
    for (let i = 0; i < val1.length; i++) {
        if (val2.includes(val1[i])) {
            console.log(true)
        }
        else {
            console.log(false)
            // return false
        }
    }
}

console.log(newme(arr1, arr2))