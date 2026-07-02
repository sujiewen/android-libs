# android-libs

Local mirror artifacts for the warehouse app.

## Included artifacts

| New JitPack coordinate | Source artifact |
| --- | --- |
| `com.github.sujiewen.android-libs:rxlife-coroutine:2.0.0` | `com.ljx.rxlife:rxlife-coroutine:2.0.0` |
| `com.github.sujiewen.android-libs:rxlife-rxjava:3.0.0` | `com.ljx.rxlife3:rxlife-rxjava:3.0.0` |
| `com.github.sujiewen.android-libs:rxandroid:3.0.0` | `io.reactivex.rxjava3:rxandroid:3.0.0` |
| `com.github.sujiewen.android-libs:rxjava:3.0.3` | `io.reactivex.rxjava3:rxjava:3.0.3` |
| `com.github.sujiewen.android-libs:rxhttp:2.3.5` | `com.ljx.rxhttp:rxhttp:2.3.5` |
| `com.github.sujiewen.android-libs:rxhttp-annotation:2.3.5` | `com.ljx.rxhttp:rxhttp-annotation:1.0.1` |
| `com.github.sujiewen.android-libs:rxhttp-compiler:2.3.5` | `com.ljx.rxhttp:rxhttp-compiler:2.3.5` |

`rxjava:3.0.2` was not present as a complete local artifact on this Mac, so this mirror uses the available `3.0.3` artifact.

`rxandroid` and `rxjava` are published as relocation POMs to the official
`io.reactivex.rxjava3` coordinates instead of republishing the same classes
under a second groupId. This prevents duplicate class failures when a consumer
or another dependency also brings in the official RxAndroid/RxJava artifacts.
Keep `mavenCentral()` enabled so Gradle can resolve the relocated official
artifacts.

## Gradle dependency replacement

The consumer project already has `https://jitpack.io` in its repositories, so only dependency coordinates need to change:

```groovy
"rxlife-coroutine"   : "com.github.sujiewen.android-libs:rxlife-coroutine:2.0.0",
"rxlife-rxjava"      : "com.github.sujiewen.android-libs:rxlife-rxjava:3.0.0",
rxandroid            : "com.github.sujiewen.android-libs:rxandroid:3.0.0",
rxjava               : "com.github.sujiewen.android-libs:rxjava:3.0.3",
rxhttp               : "com.github.sujiewen.android-libs:rxhttp:2.3.5",
annotationProcessor "com.github.sujiewen.android-libs:rxhttp-compiler:2.3.5"
```

## Source projects

- RxLife: https://github.com/liujingxing/RxLife
- RxAndroid: https://github.com/ReactiveX/RxAndroid
- RxJava: https://github.com/ReactiveX/RxJava
- RxHttp: https://github.com/liujingxing/RxHttp
