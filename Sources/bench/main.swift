import Benchmark
import Library

func start() {
    // How many inner calls per benchmark
    let innerLoop = 1_000_000

    // —— 1) Raw Int addition (baseline) ——
    benchmark("Raw Int + anchored loop") {
        var sum = 0
        for _ in 0..<innerLoop {
            sum &+= 42 + 1
        }
    }

    // —— 2) Any boxing & unboxing ——
    benchmark("Any boxing & unboxing Int anchored loop") {
        var sum = 0
        for _ in 0..<innerLoop {
            let anyValue: Any = 42
            sum &+= (anyValue as! Int) + 1
        }
    }

    // —— 3) Direct Box.v access ——
    benchmark("Direct Box.v anchored loop") {
        var sum = 0
        let box = Box()
        for _ in 0..<innerLoop {
            sum &+= box.v + 1
        }
    }

    // —— 4) AnyObject boxing & unboxing ——
    benchmark("AnyObject boxing & unboxing Box anchored loop") {
        var sum = 0
        for _ in 0..<innerLoop {
            let anyObj: AnyObject = getAnyObjectBox()
            sum &+= ((anyObj as! Box).v + 1)
        }
    }

    // —— 5) some P static dispatch with data access ——
    benchmark("some P value access anchored loop") {
        var sum = 0
        let s = getSomeInt()
        for _ in 0..<innerLoop {
            sum &+= s.value + 1
        }
    }

    // —— 6) any P dynamic dispatch with data access ——
    benchmark("any P value access anchored loop") {
        let anyP = getAnyInt()
        var sum = 0
        for _ in 0..<innerLoop {
            sum &+= anyP.value + 1
        }
    }

    // —— 7) some P static dispatch with method call ——
    benchmark("some P method call anchored loop") {
        let someP = getSomeInt()
        var sum = 0
        for _ in 0..<innerLoop {
            sum &+= someP.getValue() + 1
        }
    }

    // —— 8) any P dynamic dispatch with method call ——
    benchmark("any P method call anchored loop") {
        let anyP = getAnyInt()
        var sum = 0
        for _ in 0..<innerLoop {
            sum &+= anyP.getValue() + 1
        }
    }

    // —— 9) Box through any P value access (fair comparison) ——
    benchmark("any P Box value access anchored loop") {
        let anyP = getAnyBox()
        var sum = 0
        for _ in 0..<innerLoop { sum &+= anyP.value + 1 }
    }

    // —— 10) Box method through any P (fair comparison) ——
    benchmark("any P Box method call anchored loop") {
        let anyP = getAnyBox()
        var sum = 0
        for _ in 0..<innerLoop { sum &+= anyP.getValue() + 1 }
    }

    // —— 11) Mixed types through any P (real-world scenario) ——
    benchmark("any P mixed types anchored loop") {
        let objects: [any P] = [42, getAnyS(), getAnyBox()]
        var sum = 0
        for _ in 0..<innerLoop {
            for obj in objects {    
                sum &+= obj.value + 1
            }
        }
    }

    // —— 12) Protocol witness table overhead ——
    benchmark("any P Int vs direct Int comparison") {
        let direct = 42
        var sum1 = 0
        var sum2 = 0
        let anyP = getAnyInt()
        
        for _ in 0..<innerLoop/2 {
            sum1 &+= anyP.value + 1
            sum2 &+= direct + 1
        }
    }

    // —— 13.a) Box through any P value access (fair comparison) ——
    benchmark("any P Box value for a 8-byte struct access anchored loop") {
        let anyP = getAnyS()
        var sum = 0
        for _ in 0..<innerLoop { sum &+= anyP.value + 1 }
    }
    
    // —— 13.b) Box through any P value access (fair comparison) ——
    benchmark("any P Box value for a 48-byte struct access anchored loop") {
        let anyP = getAnyS2()
        var sum = 0
        for _ in 0..<innerLoop { sum &+= anyP.value + 1 }
    }

    // —— 13.c) Box through any P value access (fair comparison) ——
    benchmark("some P Box value for a 8-byte struct access anchored loop") {
        let someP = getSomeS()
        var sum = 0
        for _ in 0..<innerLoop { sum &+= someP.value + 1 }
    }
    
    // —— 13.d) Box through any P value access (fair comparison) ——
    benchmark("some P Box value for a 48-byte struct access anchored loop") {
        let someP = getSomeS2()
        var sum = 0
        for _ in 0..<innerLoop { sum &+= someP.value + 1 }
    }

    print("Running benchmarks...")
    Benchmark.main()
}

start()