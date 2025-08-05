#!/usr/bin/python

# Counts labels in each file and checks how many of them still have their generated name,
# and how many got a semantically fitting name.
# This gives a good overview of the overall progress.

import re

total_count = 0
total_gen_count = 0


def analyze_file(file_path):
    global total_count, total_gen_count
    label_pattern = re.compile(r"^\s*[\w\.]+(::|:)")
    gen_label_pattern = re.compile(r"^(jr|Call|Jump)_\w{3}_\w{4}:")
    count = 0
    gen_count = 0
    try:
        with open(file_path, "r") as file:
            for line_number, line in enumerate(file, start=1):
                if label_pattern.match(line.strip()):
                    count += 1
                if gen_label_pattern.match(line.strip()):
                    gen_count += 1
    except FileNotFoundError:
        print(f"Error: The file '{file_path}' was not found.")
    except IOError as e:
        print(f"Error reading file '{file_path}': {e}")
    total_count += count
    total_gen_count += gen_count
    completed_percentage = round(100 * (1 - (gen_count / count)), 1)
    print(f"{file_path}: {completed_percentage}% ({count - gen_count}/{count})")


file_list = [
    "bank_000.asm",
    "bank_001.asm",
    "bank_002.asm",
    "bank_003.asm",
    "bank_004.asm",
    "bank_005.asm",
    "bank_006.asm",
    "bank_007.asm",
]

source_dir = "../src/"

if __name__ == "__main__":
    for file in file_list:
        analyze_file(source_dir + file)
        completed_percentage = round(100 * (1 - (total_gen_count / total_count)), 1)
    print("")
    print(f"Total: {completed_percentage}% ({total_count - total_gen_count}/{total_count})")
