import os

LOG_FILE = "/opt/omniscient/structure_log.txt"
DIGEST_FILE = "/opt/omniscient/logs/ai_structure_digest.txt"

def read_log_file():
    if not os.path.exists(LOG_FILE):
        print(f"Log file {LOG_FILE} does not exist.")
        return None
    with open(LOG_FILE, "r") as f:
        return f.readlines()

def generate_digest(lines):
    digest = []
    digest.append("Omniscient System Structure Digest\n")
    digest.append("="*40 + "\n\n")
    digest.append("This digest explains the directory structure of the Omniscient system as logged.\n\n")
    
    current_level = 0
    for line in lines:
        stripped = line.rstrip()
        if not stripped:
            continue
        # Count indentation level by number of leading spaces or characters
        indent_level = len(line) - len(line.lstrip())
        # Simplify explanation based on indent level
        if indent_level == 0:
            digest.append(f"Top-level: {stripped}\n")
        elif indent_level <= 4:
            digest.append(f"  Subdirectory or file: {stripped.strip()}\n")
        else:
            digest.append(f"    Nested item: {stripped.strip()}\n")
    
    digest.append("\nCode Explanation:\n")
    digest.append("-----------------\n")
    digest.append("The system is organized into modular directories such as ai/, control/, modules/, etc.\n")
    digest.append("Scripts like create_system_structure.sh and create_subdir_files.sh automate the creation of this structure.\n")
    digest.append("The create_and_log_structure.sh script runs these and logs the directory tree for auditing.\n")
    digest.append("This modular design facilitates maintainability, scalability, and clear separation of concerns.\n")
    
    return "".join(digest)

def save_digest(digest_text):
    os.makedirs(os.path.dirname(DIGEST_FILE), exist_ok=True)
    with open(DIGEST_FILE, "w") as f:
        f.write(digest_text)
    print(f"Digest saved to {DIGEST_FILE}")

def main():
    lines = read_log_file()
    if lines is None:
        return
    digest_text = generate_digest(lines)
    save_digest(digest_text)

if __name__ == "__main__":
    main()
