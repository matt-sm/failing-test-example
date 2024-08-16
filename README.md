# failing-test-example

works:
```
bazel test //mypkg:myrules_test
```

fails:
```
bazel cquery //...             
ERROR: /home/msmith/git/failing-test-example/mypkg/BUILD.bazel:11:19: in myrule rule //mypkg:this_should_fail: 
Traceback (most recent call last):
        File "/home/msmith/git/failing-test-example/mypkg/myrules.bzl", line 9, column 13, in _myrule_impl
                fail("This rule should never work")
Error in fail: This rule should never work
ERROR: /home/msmith/git/failing-test-example/mypkg/BUILD.bazel:11:19: Analysis of target '//mypkg:this_should_fail' failed
ERROR: Analysis of target '//mypkg:this_should_fail' failed; build aborted
```