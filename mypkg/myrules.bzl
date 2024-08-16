MyInfo = provider(fields = {
    "val": "string value",
    "out": "output File",
})

def _myrule_impl(ctx):
    """Rule that just generates a file and returns a provider."""
    if ctx.label.name == "this_should_fail":
        fail("This rule should never work")
    out = ctx.actions.declare_file(ctx.label.name + ".out")
    ctx.actions.write(out, "abc")
    return [MyInfo(val="some value", out=out)]

myrule = rule(
    implementation = _myrule_impl,
)