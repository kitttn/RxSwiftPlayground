import UIKit
import RxSwift

let array = [1, 2, 3, 4, 5]

prefix operator >

prefix operator >>

prefix func > <T : Any>(arg: T) {
    print(arg)
}

prefix func >> <T : Any>(arg: T) {
    >arg
    >""
}

prefix func >> <T: Any> (arg: Observable<T>) {
    arg.subscribe(onNext: { >$0 }, onError: { >"ERROR: \($0)" })
    >""
}

enum SomeError : Error {
    case ohmygod
    case willneverbecaught
}


// Execution starts here


>"Observable.just - all items at once, as array"

>>Observable.just(array)


>"Observable.from - one by one, as ints"

>>Observable.from(array)

let obs = Observable.from(array)

>"Observable.map() - maps items in observable, in a linear and pure way."
>>obs.map({ $0 + 3 })

>"Observable.flatMap - controls Observable flow, whenever you have ((Observable1), (Observable2), ...) => makes it to be just (Observable1, Observable2). Obviously, they need to be of the same type."
>>obs.flatMap({
    $0 > 3 ? Observable.error(SomeError.ohmygod) : Observable.just($0) // example of flow switching - all numbers > 3 become errorneous cases and execution is stopped
})

>"Another example with flatMap. See how nicely observable stops execution after error happening. "

>>obs
    .flatMap({
    $0 > 2 ? Observable.error(SomeError.ohmygod) : Observable.just($0) // this will give error when num > 2
})
.do(onNext: {
    if ($0 > 3) { throw SomeError.willneverbecaught } // obviously, this will never be caught, because in this block we will never get number 3 which triggers throw
})
