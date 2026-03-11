#!/usr/bin/env python3
"""Convert answer key markdown files to spoken text for TTS."""
import re
import sys

def clean_md(text):
    """Strip markdown formatting for spoken text."""
    # Code blocks FIRST (before inline backticks eat the fences)
    text = re.sub(r'```[\s\S]*?```', '', text)
    # Then inline backticks
    text = re.sub(r'`([^`]+)`', r'\1', text)
    # Blockquote markers
    text = re.sub(r'^>\s?', '', text, flags=re.MULTILINE)
    # Bold/italic
    text = text.replace('**', '')
    # Tables
    text = re.sub(r'\|[^\n]+\|', '', text)
    text = re.sub(r'^[-|:\s]+$', '', text, flags=re.MULTILINE)
    # Horizontal rules
    text = re.sub(r'^---+$', '', text, flags=re.MULTILINE)
    # Headers (keep text)
    text = re.sub(r'^#{1,4}\s+', '', text, flags=re.MULTILINE)
    # Links
    text = re.sub(r'\[([^\]]+)\]\([^)]+\)', r'\1', text)
    # Excessive newlines
    text = re.sub(r'\n{3,}', '\n\n', text)
    return text.strip()

src = sys.argv[1]
with open(src) as f:
    text = f.read()

title_match = re.search(r'^#\s+(.+)', text, re.MULTILINE)
title = title_match.group(1) if title_match else 'Answer Key'

spoken = []
spoken.append(f'{title}.')
spoken.append('')

# Format A: ## Question N ... ### Answer (Modules 2-11 separate files)
if re.search(r'^## Question \d+', text, re.MULTILINE):
    parts = re.split(r'^## Question (\d+)\s*', text, flags=re.MULTILINE)
    for i in range(1, len(parts), 2):
        qnum = parts[i]
        content = parts[i + 1].strip() if i + 1 < len(parts) else ''
        
        # Split on ### Answer
        q_split = re.split(r'^### Answer\s*', content, maxsplit=1, flags=re.MULTILINE)
        if len(q_split) >= 2:
            question = clean_md(q_split[0])
            answer = clean_md(q_split[1])
        else:
            question = ''
            answer = clean_md(content)
        
        spoken.append(f'Question {qnum}.')
        spoken.append('')
        if question:
            spoken.append(question)
            spoken.append('')
        spoken.append('Answer.')
        spoken.append('')
        spoken.append(answer)
        spoken.append('')

# Format B: **Q1.** with > **Discussion:** (Modules 1, 12 inline)
elif re.search(r'\*\*Q\d+\.?\*\*', text):
    parts = re.split(r'\*\*Q(\d+)\.?\*\*\s*', text)
    for i in range(1, len(parts), 2):
        qnum = parts[i]
        content = parts[i + 1].strip() if i + 1 < len(parts) else ''
        
        disc_split = re.split(r'\n\s*>\s*\*\*Discussion:\*\*\s*', content, maxsplit=1)
        if len(disc_split) < 2:
            disc_split = re.split(r'\n\s*\*Discussion:\*\s*', content, maxsplit=1)
        
        question = clean_md(disc_split[0])
        answer = clean_md(disc_split[1]) if len(disc_split) > 1 else clean_md(content)
        
        spoken.append(f'Question {qnum}.')
        spoken.append('')
        if question:
            spoken.append(question)
            spoken.append('')
        spoken.append('Answer.')
        spoken.append('')
        spoken.append(answer)
        spoken.append('')
else:
    spoken.append(clean_md(text))

print('\n'.join(spoken))
