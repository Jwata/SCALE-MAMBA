#!/bin/bash

# Portably find the directory containing this script.
HERE=$(cd `dirname $0`; pwd)
# Assuming it lives in Scripts/, set ROOT to the root directory of the
# project.
ROOT=$HERE/..
# Now set the PYTHONPATH so we don't have to worry about the CWD
# whenever we invoke python scripts.
export PYTHONPATH=$ROOT:$PYTHONPATH

docker_pre=$1
docker_container=$2
docker_volumes=$3
shift 3

while getopts sCm:c:n opt; do
    case $opt in
	s) test_opts="-s"; compile_opts="$compile_opts -s" ;;
	c) compile_opts="$compile_opts -c $OPTARG" ;;
	n) compile_opts="$compile_opts -n" ;;
    esac
done

shift $[OPTIND-1]



run_test() {
    test=$1
    shift
    printf "\n\n\n\n\n\n\n\n\n\n"
    >&2 echo "$test"
    >&2 echo "compiling"
    docker run -a STDOUT -a STDERR --rm $docker_volumes $docker_container ./compile.py --dead-code-elimination $compile_opts $* Programs/$test || exit 1
    Scripts/run-online.sh $docker_pre $docker_container "$docker_volumes$" Programs/$test || exit 1
    python Scripts/test-result.py $test_opts $test || exit 1
}

if test "$1"; then
    test=$1
    shift
    run_test $test $*
else
    test_opts="-s"
    compile_opts="--stop"
    for test in test_all test_array test_branch test_branching test_comparison test_count test_empty_tape test_flex test_float test_floatingpoint test_float_sorting test_float_vector test_for_range_multithread test_function test_idle_threads test_lib test_loop test_map_reduce test_mem_order test_new_threads test_threads test_vector test_sfix test_sqrt test_math test_custom_array; do
	run_test $test
    done
fi
