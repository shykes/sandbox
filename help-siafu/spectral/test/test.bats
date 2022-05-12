setup() {
    load '../../../../bats_helpers'

    common_setup
}

@test "spectral" {
    dagger "do" -p ./ruleset.cue rulesetOutput
}
