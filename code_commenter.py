# code_commenter.py (Ollama version)
import sys
import requests
import json

OLLAMA_URL = "http://localhost:11434/api/generate"  # Default Ollama endpoint
MODEL = "codellama"  # Replace with any model you have (e.g., "codellama", "mistral", "llama3", etc.)

def generate_comments(code):
    prompt = f"Add inline comments to the following code:\n\n{code}\n\nRespond with fully commented code only."
    payload = {
        "model": MODEL,
        "prompt": prompt,
        "stream": False
    }

    response = requests.post(OLLAMA_URL, json=payload)
    if response.status_code == 200:
        return response.json()['response']
    else:
        return f"Error: {response.status_code} - {response.text}"

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 code_commenter.py <file>")
        sys.exit(1)

    filename = sys.argv[1]
    with open(filename, "r") as f:
        code = f.read()

    result = generate_comments(code)
    print("\n--- Commented Code ---\n")
    print(result)
