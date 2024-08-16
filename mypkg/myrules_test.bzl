load("@bazel_skylib//lib:unittest.bzl", "asserts", "analysistest")
load(":myrules.bzl", "myrule", "MyInfo")

# ==== Check the provider contents ====

def _provider_contents_test_impl(ctx):
    env = analysistest.begin(ctx)

    target_under_test = analysistest.target_under_test(env)
    # If preferred, could pass these values as "expected" and "actual" keyword
    # arguments.
    asserts.equals(env, "some value", target_under_test[MyInfo].val)

    # If you forget to return end(), you will get an error about an analysis
    # test needing to return an instance of AnalysisTestResultInfo.
    return analysistest.end(env)

def _failure_testing_test_impl(ctx):
    env = analysistest.begin(ctx)
    asserts.expect_failure(env, "This rule should never work")
    return analysistest.end(env)

# Create the testing rule to wrap the test logic. This must be bound to a global
# variable, not called in a macro's body, since macros get evaluated at loading
# time but the rule gets evaluated later, at analysis time. Since this is a test
# rule, its name must end with "_test".
provider_contents_test = analysistest.make(_provider_contents_test_impl)

failure_testing_test = analysistest.make(
    _failure_testing_test_impl,
    expect_failure = True,
)
# Macro to setup the test.
def _test_provider_contents():
    # Rule under test. Be sure to tag 'manual', as this target should not be
    # built using `:all` except as a dependency of the test.
    myrule(name = "provider_contents_subject", tags = ["manual"])
    # Testing rule.
    provider_contents_test(name = "provider_contents_test",
                           target_under_test = ":provider_contents_subject")
    # Note the target_under_test attribute is how the test rule depends on
    # the real rule target.

def _test_failure():
    myrule(name = "this_should_fail", tags = ["manual"])

    failure_testing_test(name = "failure_testing_test",
                         target_under_test = ":this_should_fail")

# Entry point from the BUILD file; macro for running each test case's macro and
# declaring a test suite that wraps them together.
def myrules_test_suite(name):
    # Call all test functions and wrap their targets in a suite.
    _test_provider_contents()
    _test_failure()
    # ...

    native.test_suite(
        name = name,
        tests = [
            ":provider_contents_test",
            ":failure_testing_test",
            # ...
        ],
    )