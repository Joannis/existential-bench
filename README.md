# Existential vs. Some Benchmark

Swift is great at optimizations. These tests should therefore not be ran with whole module optimization (enabled by default):

The following results are from `swift run -c release` (default configuration):

```
name                                                       time            std        iterations
------------------------------------------------------------------------------------------------
Raw Int + anchored loop                                           0.000 ns ±    inf %    1000000
Any boxing & unboxing Int anchored loop                    11056875.500 ns ±   1.78 %        126
Direct Box.v anchored loop                                        0.000 ns ±    inf %    1000000
AnyObject boxing & unboxing Box anchored loop                     0.000 ns ±    inf %    1000000
some P value access anchored loop                                 0.000 ns ±    inf %    1000000
any P value access anchored loop                                  0.000 ns ±    inf %    1000000
some P method call anchored loop                                  0.000 ns ±    inf %    1000000
any P method call anchored loop                                   0.000 ns ±    inf %    1000000
any P Box value access anchored loop                              0.000 ns ±    inf %    1000000
any P Box method call anchored loop                               0.000 ns ±    inf %    1000000
any P mixed types anchored loop                            10777625.000 ns ±   1.17 %        131
any P Int vs direct Int comparison                                0.000 ns ±    inf %    1000000
any P Box value for a 8-byte struct access anchored loop          0.000 ns ±    inf %    1000000
any P Box value for a 48-byte struct access anchored loop         0.000 ns ±    inf %    1000000
some P Box value for a 8-byte struct access anchored loop         0.000 ns ±    inf %    1000000
some P Box value for a 48-byte struct access anchored loop        0.000 ns ±    inf %    1000000
```

Now obviously, `0ns` CPU time is unreasonably low, meaning Swift practically pre-resolved the whole function for you at compile time. AWESOME for you, not for benchmarks.

Instead, run the following: `swift build -Xswiftc -no-whole-module-optimization -c release; .build/release/bench`

```
name                                                       time            std        iterations
------------------------------------------------------------------------------------------------
Raw Int + anchored loop                                           0.000 ns ±    inf %    1000000
Any boxing & unboxing Int anchored loop                    11301292.000 ns ±   2.10 %        126
Direct Box.v anchored loop                                       41.000 ns ± 111.31 %    1000000
AnyObject boxing & unboxing Box anchored loop              23778875.000 ns ±   2.04 %         59
some P value access anchored loop                            892708.000 ns ±  10.24 %       1534
any P value access anchored loop                            1571917.000 ns ±   7.02 %        885
some P method call anchored loop                             927625.000 ns ±  10.20 %       1551
any P method call anchored loop                             1602125.000 ns ±   7.21 %        869
any P Box value access anchored loop                        2141375.000 ns ±   6.27 %        655
any P Box method call anchored loop                         2143959.000 ns ±   7.87 %        665
any P mixed types anchored loop                            11545438.000 ns ±   2.50 %        120
any P Int vs direct Int comparison                           798375.000 ns ±   6.74 %       1760
any P Box value for a 8-byte struct access anchored loop    1600458.500 ns ±   5.99 %        892
any P Box value for a 48-byte struct access anchored loop   1419416.500 ns ±   2.61 %        980
some P Box value for a 8-byte struct access anchored loop    899417.000 ns ±   3.66 %       1538
some P Box value for a 48-byte struct access anchored loop   895854.000 ns ±   6.86 %       1544
```

The thing to look out for is `time`. The milliseconds spent in test are irrelevant, since the iterations are different per test (thanks to the benchmarking library). As you see, `some` is about 2x faster in each scenario.