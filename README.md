# android-libs

Local mirror artifacts for the warehouse app.

## Included artifacts

| New JitPack coordinate | Source artifact |
| --- | --- |
| `com.github.sujiewen.android-libs:rxlife-coroutine:2.0.0` | `com.ljx.rxlife:rxlife-coroutine:2.0.0` |
| `com.github.sujiewen.android-libs:rxlife-rxjava:3.0.0` | `com.ljx.rxlife3:rxlife-rxjava:3.0.0` |
| `com.github.sujiewen.android-libs:rxandroid:3.0.0` | `io.reactivex.rxjava3:rxandroid:3.0.0` |
| `com.github.sujiewen.android-libs:rxjava:3.0.3` | `io.reactivex.rxjava3:rxjava:3.0.3` |

`rxjava:3.0.2` was not present as a complete local artifact on this Mac, so this mirror uses the available `3.0.3` artifact.

## Gradle dependency replacement

The consumer project already has `https://jitpack.io` in its repositories, so only dependency coordinates need to change:

```groovy
"rxlife-coroutine"   : "com.github.sujiewen.android-libs:rxlife-coroutine:2.0.0",
"rxlife-rxjava"      : "com.github.sujiewen.android-libs:rxlife-rxjava:3.0.0",
rxandroid            : "com.github.sujiewen.android-libs:rxandroid:3.0.0",
rxjava               : "com.github.sujiewen.android-libs:rxjava:3.0.3",
```

## Source projects

- RxLife: https://github.com/liujingxing/RxLife
- RxAndroid: https://github.com/ReactiveX/RxAndroid
- RxJava: https://github.com/ReactiveX/RxJava
