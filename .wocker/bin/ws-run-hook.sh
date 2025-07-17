#!/bin/bash

NAME="$1"

run_init_scripts() {
    local scripts_dir="$1"

    if [ -d "$scripts_dir" ]; then
        echo "Running $NAME scripts from $scripts_dir"

        find "$scripts_dir" -type f -name "*.sh" | sort | while read -r script; do
            if [ -x "$script" ]; then
                echo "Executing $script"
                "$script"
            else
                echo "Executing $script with sh"
                sh "$script"
            fi

            if [ $? -ne 0 ]; then
                echo "Warning: Script $script exited with non-zero status"
            fi
        done

        echo "Initialization scripts completed"
    else
        echo "No initialization scripts directory found at $scripts_dir"
    fi
}

case "$NAME" in
    "init")
        run_init_scripts "/etc/wocker-init.d"
        ;;
    "build")
        run_init_scripts "/etc/wocker-build.d"
        ;;
    *)
        echo "Error: Invalid name '$NAME'. Supported values are: init, build"
        exit 1
        ;;
esac
