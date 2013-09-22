#!/bin/bash

function show_help() {
  echo "$@"
  cat <<EOF
Useage: -n <name> -c <className> -r <runAs>

-n   name of the daemon to run
-c   java classname to call main on
-r   user to run the java process
-h|? this useage screen
EOF
exit 0
}

while getopts "n:c:r:h" opt; do
    case "$opt" in
    h)
        show_help "-h given"
        ;;
    n)  name=$OPTARG
        path_name=`echo $name | tr -s "[[:blank:]]" | tr "[[:blank:]]" "_"`
        export_name=`echo $path_name | tr "[:lower:]" "[:upper:]"`
        ;;
    c)  class_name=$OPTARG
        ;;
    r)  run_as=$OPTARG
        ;;
    *)
        show_help "Unknown arg $opt"
        ;;
    esac
done

if [ -z "$name" -o -z "$class_name" -o -z "$run_as" ]; then 
  show_help "Not all arguments defined"
fi

date=$(date)

function replace() {
  sed "s/{{NAME}}/$name/g" | sed "s/{{PATH_NAME}}/$path_name/g" | sed "s/{{EXPORT_NAME}}/$export_name/g" | sed "s/{{CLASS_NAME}}/$class_name/g" | sed "s/{{RUN_AS}}/$run_as/g" | sed "s/{{DATE}}/$date/g"
}

cat init-script.templete | replace > $path_name.init
cat default-include.templete | replace > $path_name.default
